import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/batch_entry.dart';
import 'database_service.dart';

/// High-level persistence API.
///
/// All providers call this class — they never touch [DatabaseService] directly.
/// Every method is async and returns clean Dart objects (no raw maps).
///
/// Sections
/// ────────
///   Settings / onboarding – key/value pairs
///   Streak                – single-row streak state
///   Batch entries         – per-language active batch
///   Vault entries         – mastered words
class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  Future<Database> get _db async => DatabaseService.instance.database;

  // ══════════════════════════════════════════════════════════════════════════
  // Settings / onboarding (key-value)
  // ══════════════════════════════════════════════════════════════════════════

  Future<void> saveSetting(String key, String value) async {
    final db = await _db;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await _db;
    final rows =
        await db.query('settings', where: 'key = ?', whereArgs: [key]);
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }

  Future<Map<String, String>> getAllSettings() async {
    final db = await _db;
    final rows = await db.query('settings');
    return {for (final r in rows) r['key'] as String: r['value'] as String};
  }

  // ── Convenience typed helpers ──────────────────────────────────────────────

  Future<void> saveInt(String key, int value) =>
      saveSetting(key, value.toString());

  Future<void> saveBool(String key, bool value) =>
      saveSetting(key, value ? '1' : '0');

  Future<int?> getInt(String key) async {
    final v = await getSetting(key);
    return v == null ? null : int.tryParse(v);
  }

  Future<bool?> getBool(String key) async {
    final v = await getSetting(key);
    return v == null ? null : v == '1';
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Streak
  // ══════════════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> loadStreak() async {
    final db = await _db;
    final rows = await db.query('streak', where: 'id = 1');
    return rows.isEmpty ? {} : rows.first;
  }

  Future<void> saveStreak({
    required int currentStreak,
    required int longestStreak,
    required bool sessionCompletedToday,
    required DateTime? lastSessionDate,
    required bool ashPending,
  }) async {
    final db = await _db;
    await db.update(
      'streak',
      {
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'session_completed_today': sessionCompletedToday ? 1 : 0,
        'last_session_date': lastSessionDate?.toIso8601String(),
        'ash_pending': ashPending ? 1 : 0,
      },
      where: 'id = 1',
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Batch entries
  // ══════════════════════════════════════════════════════════════════════════

  Future<List<BatchEntry>> loadBatch(String languageKey) async {
    final db = await _db;
    final rows = await db.query(
      'batch_entries',
      where: 'language_key = ?',
      whereArgs: [languageKey],
      orderBy: 'added_at ASC',
    );
    return rows.map(_rowToBatchEntry).toList();
  }

  Future<void> upsertBatchEntry(BatchEntry entry) async {
    final db = await _db;
    await db.insert(
      'batch_entries',
      _batchEntryToRow(entry),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertBatchEntries(List<BatchEntry> entries) async {
    if (entries.isEmpty) return;
    final db = await _db;
    final batch = db.batch();
    for (final e in entries) {
      batch.insert('batch_entries', _batchEntryToRow(e),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> deleteBatchEntry(String id) async {
    final db = await _db;
    await db.delete('batch_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearBatch(String languageKey) async {
    final db = await _db;
    await db.delete('batch_entries',
        where: 'language_key = ?', whereArgs: [languageKey]);
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Vault entries
  // ══════════════════════════════════════════════════════════════════════════

  Future<List<BatchEntry>> loadVault() async {
    final db = await _db;
    final rows =
        await db.query('vault_entries', orderBy: 'vaulted_at DESC');
    return rows.map(_rowToVaultEntry).toList();
  }

  Future<void> upsertVaultEntry(BatchEntry entry) async {
    final db = await _db;
    await db.insert(
      'vault_entries',
      _vaultEntryToRow(entry),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteVaultEntry(String id) async {
    final db = await _db;
    await db.delete('vault_entries', where: 'id = ?', whereArgs: [id]);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // Backup helpers (raw row access for BackupPayload)
  // ════════════════════════════════════════════════════════════════════════════

  /// Returns ALL batch entries across all languages as raw maps.
  /// Used by BackupPayload to serialise without re-parsing.
  Future<List<Map<String, dynamic>>> loadAllBatchEntriesRaw() async {
    final db = await _db;
    return db.query('batch_entries', orderBy: 'added_at ASC');
  }

  /// Returns ALL vault entries as raw maps.
  Future<List<Map<String, dynamic>>> loadAllVaultEntriesRaw() async {
    final db = await _db;
    return db.query('vault_entries', orderBy: 'vaulted_at ASC');
  }

  /// Upsert a list of raw batch-entry maps (from restore).
  Future<void> upsertBatchEntriesRaw(
      List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    final db = await _db;
    final batch = db.batch();
    for (final row in rows) {
      batch.insert('batch_entries', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  /// Upsert a list of raw vault-entry maps (from restore).
  Future<void> upsertVaultEntriesRaw(
      List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    final db = await _db;
    final batch = db.batch();
    for (final row in rows) {
      batch.insert('vault_entries', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  /// Save a raw streak map (from restore).
  Future<void> saveStreakRaw(Map<String, dynamic> row) async {
    final db = await _db;
    await db.update(
      'streak',
      {
        'current_streak': row['current_streak'] ?? 0,
        'longest_streak': row['longest_streak'] ?? 0,
        'session_completed_today': row['session_completed_today'] ?? 0,
        'last_session_date': row['last_session_date'],
        'ash_pending': row['ash_pending'] ?? 0,
      },
      where: 'id = 1',
    );
  }

  /// Wipe all user-generated data — used before restoring a backup.
  /// Preserves the streak row (single-row table) but resets its values.
  Future<void> clearAllForRestore() async {
    final db = await _db;
    await db.delete('batch_entries');
    await db.delete('vault_entries');
    await db.delete('settings');
    await db.execute(
      'UPDATE streak SET current_streak=0, longest_streak=0, '
      'session_completed_today=0, last_session_date=NULL, ash_pending=0 '
      'WHERE id=1',
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Serialisation helpers
  // ══════════════════════════════════════════════════════════════════════════

  Map<String, dynamic> _batchEntryToRow(BatchEntry e) => {
        'id': e.id,
        'language_key': e.languageKey,
        'word': e.word,
        'meaning': e.meaning,
        'example_sentence': e.exampleSentence,
        'example_translation': e.exampleTranslation,
        'next_review_date': e.nextReviewDate?.toIso8601String(),
        'ease_factor': e.easeFactor,
        'interval_days': e.intervalDays,
        'repetitions': e.repetitions,
        'added_at': e.addedAt.toIso8601String(),
        'is_new_today': e.isNewToday ? 1 : 0,
      };

  BatchEntry _rowToBatchEntry(Map<String, dynamic> row) => BatchEntry(
        id: row['id'] as String,
        languageKey: row['language_key'] as String,
        word: row['word'] as String,
        meaning: row['meaning'] as String,
        exampleSentence: row['example_sentence'] as String,
        exampleTranslation: row['example_translation'] as String,
        nextReviewDate: row['next_review_date'] != null
            ? DateTime.tryParse(row['next_review_date'] as String)
            : null,
        easeFactor: (row['ease_factor'] as num).toDouble(),
        intervalDays: row['interval_days'] as int,
        repetitions: row['repetitions'] as int,
        addedAt: DateTime.parse(row['added_at'] as String),
        isNewToday: (row['is_new_today'] as int) == 1,
      );

  Map<String, dynamic> _vaultEntryToRow(BatchEntry e) => {
        'id': e.id,
        'language_key': e.languageKey,
        'word': e.word,
        'meaning': e.meaning,
        'example_sentence': e.exampleSentence,
        'example_translation': e.exampleTranslation,
        'ease_factor': e.easeFactor,
        'interval_days': e.intervalDays,
        'repetitions': e.repetitions,
        'added_at': e.addedAt.toIso8601String(),
        'vaulted_at': DateTime.now().toIso8601String(),
      };

  BatchEntry _rowToVaultEntry(Map<String, dynamic> row) => BatchEntry(
        id: row['id'] as String,
        languageKey: row['language_key'] as String,
        word: row['word'] as String,
        meaning: row['meaning'] as String,
        exampleSentence: row['example_sentence'] as String,
        exampleTranslation: row['example_translation'] as String,
        easeFactor: (row['ease_factor'] as num).toDouble(),
        intervalDays: row['interval_days'] as int,
        repetitions: row['repetitions'] as int,
        addedAt: DateTime.parse(row['added_at'] as String),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // Onboarding helpers (stored as settings keys)
  // ══════════════════════════════════════════════════════════════════════════

  static const _kBaseLanguage = 'onboarding.base_language';
  static const _kTargetLanguages = 'onboarding.target_languages';
  static const _kCefrMap = 'onboarding.cefr_map';
  static const _kCurfewHour = 'onboarding.curfew_hour';
  static const _kCurfewMinute = 'onboarding.curfew_minute';
  static const _kDailyDrip = 'onboarding.daily_drip';

  Future<void> saveOnboarding({
    required String baseLanguageCode,
    required List<String> targetLanguageCodes,
    required Map<String, String> cefrPerTarget,
    required TimeOfDay curfew,
    required int dailyDripCount,
  }) async {
    await saveSetting(_kBaseLanguage, baseLanguageCode);
    await saveSetting(_kTargetLanguages, targetLanguageCodes.join(','));
    // Encode cefr map as "de:B2|es:B2"
    final cefrStr =
        cefrPerTarget.entries.map((e) => '${e.key}:${e.value}').join('|');
    await saveSetting(_kCefrMap, cefrStr);
    await saveInt(_kCurfewHour, curfew.hour);
    await saveInt(_kCurfewMinute, curfew.minute);
    await saveInt(_kDailyDrip, dailyDripCount);
  }

  Future<Map<String, dynamic>?> loadOnboarding() async {
    final all = await getAllSettings();
    final base = all[_kBaseLanguage];
    if (base == null) return null; // Never onboarded yet.

    final targets = (all[_kTargetLanguages] ?? '')
        .split(',')
        .where((s) => s.isNotEmpty)
        .toList();

    final cefrRaw = all[_kCefrMap] ?? '';
    final cefrMap = <String, String>{};
    for (final pair in cefrRaw.split('|')) {
      final parts = pair.split(':');
      if (parts.length == 2) cefrMap[parts[0]] = parts[1];
    }

    return {
      'baseLanguageCode': base,
      'targetLanguageCodes': targets,
      'cefrPerTarget': cefrMap,
      'curfewHour': int.tryParse(all[_kCurfewHour] ?? '') ?? 22,
      'curfewMinute': int.tryParse(all[_kCurfewMinute] ?? '') ?? 0,
      'dailyDripCount': int.tryParse(all[_kDailyDrip] ?? '') ?? 20,
    };
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Settings helpers
  // ══════════════════════════════════════════════════════════════════════════

  static const _kDisplayName = 'settings.display_name';
  static const _kThemeMode = 'settings.theme_mode'; // 0=light,1=dark,2=system
  static const _kShareData = 'settings.share_learning_data';
  static const _kCrashReports = 'settings.allow_crash_reports';

  Future<void> saveUserSettings({
    required String displayName,
    required int themeMode,
    required bool shareLearningData,
    required bool allowCrashReports,
  }) async {
    await saveSetting(_kDisplayName, displayName);
    await saveInt(_kThemeMode, themeMode);
    await saveBool(_kShareData, shareLearningData);
    await saveBool(_kCrashReports, allowCrashReports);
  }

  Future<Map<String, dynamic>> loadUserSettings() async {
    final all = await getAllSettings();
    return {
      'displayName': all[_kDisplayName] ?? 'Scholar',
      'themeMode': int.tryParse(all[_kThemeMode] ?? '') ?? 0,
      'shareLearningData': all[_kShareData] == '1',
      'allowCrashReports': all[_kCrashReports] != '0', // default true
    };
  }
}
