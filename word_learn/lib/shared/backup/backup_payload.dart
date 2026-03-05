import 'dart:convert';

import '../services/local_storage_service.dart';

/// Version of the backup JSON schema.
/// Increment when the structure changes so the restore logic can migrate.
const int kBackupVersion = 1;

/// Pure data class — all user progress serialised to/from JSON.
///
/// Nothing in here touches the network or encryption. That is
/// [BackupService]'s job. This class only knows about data shape.
class BackupPayload {
  const BackupPayload({
    required this.version,
    required this.createdAt,
    required this.settings,
    required this.streak,
    required this.batchEntries,
    required this.vaultEntries,
  });

  final int version;
  final String createdAt; // ISO-8601 UTC
  final Map<String, String> settings; // all key-value settings rows
  final Map<String, dynamic> streak; // streak row
  final List<Map<String, dynamic>> batchEntries;
  final List<Map<String, dynamic>> vaultEntries;

  // ── Convenience counts for upload metadata ──────────────────────────────
  int get batchWordCount => batchEntries.length;
  int get vaultWordCount => vaultEntries.length;
  int get currentStreak =>
      (streak['current_streak'] as int?) ?? 0;

  // ── Serialise ────────────────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'version': version,
        'created_at': createdAt,
        'settings': settings,
        'streak': streak,
        'batch_entries': batchEntries,
        'vault_entries': vaultEntries,
      };

  String toJsonString() => jsonEncode(toJson());

  // ── Deserialise ──────────────────────────────────────────────────────────

  factory BackupPayload.fromJson(Map<String, dynamic> json) => BackupPayload(
        version: (json['version'] as int?) ?? 1,
        createdAt: json['created_at'] as String? ??
            DateTime.now().toUtc().toIso8601String(),
        settings:
            Map<String, String>.from(json['settings'] as Map? ?? {}),
        streak: Map<String, dynamic>.from(
            json['streak'] as Map? ?? {}),
        batchEntries: (json['batch_entries'] as List? ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList(),
        vaultEntries: (json['vault_entries'] as List? ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList(),
      );

  factory BackupPayload.fromJsonString(String s) =>
      BackupPayload.fromJson(jsonDecode(s) as Map<String, dynamic>);

  // ── Build from local SQLite ───────────────────────────────────────────────

  static Future<BackupPayload> buildFromLocalDb() async {
    final storage = LocalStorageService.instance;

    final allSettings = await storage.getAllSettings();
    final streakRow = await storage.loadStreak();

    // Load all language batches — we don't filter by language here;
    // loadAllBatchEntries returns everything in the table.
    final batchRows = await storage.loadAllBatchEntriesRaw();
    final vaultRows = await storage.loadAllVaultEntriesRaw();

    return BackupPayload(
      version: kBackupVersion,
      createdAt: DateTime.now().toUtc().toIso8601String(),
      settings: allSettings,
      streak: streakRow,
      batchEntries: batchRows,
      vaultEntries: vaultRows,
    );
  }

  // ── Restore into local SQLite ─────────────────────────────────────────────

  /// Wipes local data and writes everything from the backup.
  /// Called on new-device restore after the user explicitly confirms.
  Future<void> restoreToLocalDb() async {
    final storage = LocalStorageService.instance;

    // 1. Wipe existing data.
    await storage.clearAllForRestore();

    // 2. Restore settings.
    for (final entry in settings.entries) {
      await storage.saveSetting(entry.key, entry.value);
    }

    // 3. Restore streak.
    if (streak.isNotEmpty) {
      await storage.saveStreakRaw(streak);
    }

    // 4. Restore batch entries.
    if (batchEntries.isNotEmpty) {
      await storage.upsertBatchEntriesRaw(batchEntries);
    }

    // 5. Restore vault entries.
    if (vaultEntries.isNotEmpty) {
      await storage.upsertVaultEntriesRaw(vaultEntries);
    }
  }
}
