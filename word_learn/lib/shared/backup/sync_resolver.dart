import '../models/batch_entry.dart';

/// A mastered word snapshot used for vault merge.
/// Mirrors the vault_entries SQLite row fields needed for LWW comparison.
class VaultEntrySnapshot {
  const VaultEntrySnapshot({
    required this.id,
    required this.languageKey,
    required this.word,
    required this.meaning,
    required this.exampleSentence,
    required this.exampleTranslation,
    required this.easeFactor,
    required this.intervalDays,
    required this.repetitions,
    required this.addedAt,
    required this.vaultedAt,
  });

  final String id;
  final String languageKey;
  final String word;
  final String meaning;
  final String exampleSentence;
  final String exampleTranslation;
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final DateTime addedAt;
  final DateTime vaultedAt; // used as the LWW timestamp for vault entries

  VaultEntrySnapshot copyWith({DateTime? vaultedAt}) => VaultEntrySnapshot(
        id: id,
        languageKey: languageKey,
        word: word,
        meaning: meaning,
        exampleSentence: exampleSentence,
        exampleTranslation: exampleTranslation,
        easeFactor: easeFactor,
        intervalDays: intervalDays,
        repetitions: repetitions,
        addedAt: addedAt,
        vaultedAt: vaultedAt ?? this.vaultedAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'language_key': languageKey,
        'word': word,
        'meaning': meaning,
        'example_sentence': exampleSentence,
        'example_translation': exampleTranslation,
        'ease_factor': easeFactor,
        'interval_days': intervalDays,
        'repetitions': repetitions,
        'added_at': addedAt.toIso8601String(),
        'vaulted_at': vaultedAt.toIso8601String(),
      };

  factory VaultEntrySnapshot.fromMap(Map<String, dynamic> map) =>
      VaultEntrySnapshot(
        id: map['id'] as String,
        languageKey: map['language_key'] as String,
        word: map['word'] as String,
        meaning: map['meaning'] as String,
        exampleSentence: map['example_sentence'] as String? ?? '',
        exampleTranslation: map['example_translation'] as String? ?? '',
        easeFactor: (map['ease_factor'] as num).toDouble(),
        intervalDays: map['interval_days'] as int,
        repetitions: map['repetitions'] as int,
        addedAt: DateTime.parse(map['added_at'] as String),
        vaultedAt: DateTime.parse(map['vaulted_at'] as String),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// SyncResolver — pure, stateless functions. No I/O, no Riverpod. Easy to test.
// ─────────────────────────────────────────────────────────────────────────────

/// Conflict resolution for multi-device sync (WL-510).
///
/// Strategy: **Last-Write-Wins (LWW)** per word, keyed by [BatchEntry.id].
/// The word whose [nextReviewDate] was updated most recently wins.
/// Words present in only one side are kept unconditionally.
/// No data is silently deleted; the merge is always additive except where
/// a more-recent state supersedes an older one.
class SyncResolver {
  SyncResolver._(); // static-only; never instantiate.

  // ── Batch entries ──────────────────────────────────────────────────────────

  /// Resolves a conflict between the same word on two devices.
  ///
  /// Returns the entry with the more recent [nextReviewDate].
  /// If one side has no review date yet (brand-new word), the other wins.
  /// If both have no review date, [remote] is preferred (conservative).
  static BatchEntry resolveWordConflict({
    required BatchEntry local,
    required BatchEntry remote,
  }) {
    assert(local.id == remote.id,
        'resolveWordConflict: IDs must match (${local.id} vs ${remote.id})');

    final localDate = local.nextReviewDate;
    final remoteDate = remote.nextReviewDate;

    if (localDate == null && remoteDate == null) return remote;
    if (localDate == null) return remote;
    if (remoteDate == null) return local;

    // Most-recent review date = more progress = winner.
    return localDate.isAfter(remoteDate) ? local : remote;
  }

  /// Merges two Active Batch word lists into one.
  ///
  /// - Words in both lists → resolved by [resolveWordConflict].
  /// - Words only in [local]  → kept as-is (remote hasn't seen them yet).
  /// - Words only in [remote] → kept as-is (local hasn't received them yet).
  ///
  /// The result respects language isolation: the caller should pass lists
  /// already filtered to the same [languageKey].
  static List<BatchEntry> mergeBatches({
    required List<BatchEntry> local,
    required List<BatchEntry> remote,
  }) {
    final Map<String, BatchEntry> merged = {};

    // Start with all local entries.
    for (final entry in local) {
      merged[entry.id] = entry;
    }

    // Merge remote entries — resolve conflicts where IDs collide.
    for (final entry in remote) {
      final existing = merged[entry.id];
      if (existing == null) {
        // Remote-only word: add it.
        merged[entry.id] = entry;
      } else {
        // Conflict: pick the winner.
        merged[entry.id] =
            resolveWordConflict(local: existing, remote: entry);
      }
    }

    return merged.values.toList();
  }

  // ── Vault entries ──────────────────────────────────────────────────────────

  /// Resolves a vault conflict between two devices.
  ///
  /// Uses [VaultEntrySnapshot.vaultedAt] as the LWW timestamp.
  /// The more recently vaulted entry wins (it carries more review history).
  static VaultEntrySnapshot resolveVaultConflict({
    required VaultEntrySnapshot local,
    required VaultEntrySnapshot remote,
  }) {
    assert(local.id == remote.id,
        'resolveVaultConflict: IDs must match (${local.id} vs ${remote.id})');
    return local.vaultedAt.isAfter(remote.vaultedAt) ? local : remote;
  }

  /// Merges two Vault word lists into one.
  ///
  /// Same additive-union semantics as [mergeBatches].
  static List<VaultEntrySnapshot> mergeVaults({
    required List<VaultEntrySnapshot> local,
    required List<VaultEntrySnapshot> remote,
  }) {
    final Map<String, VaultEntrySnapshot> merged = {};

    for (final entry in local) {
      merged[entry.id] = entry;
    }

    for (final entry in remote) {
      final existing = merged[entry.id];
      if (existing == null) {
        merged[entry.id] = entry;
      } else {
        merged[entry.id] =
            resolveVaultConflict(local: existing, remote: entry);
      }
    }

    return merged.values.toList();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Groups a batch list by languageKey for per-language merging.
  static Map<String, List<BatchEntry>> groupByLanguage(
          List<BatchEntry> entries) =>
      entries.fold({}, (map, e) {
        (map[e.languageKey] ??= []).add(e);
        return map;
      });

  /// Runs [mergeBatches] across all language groups from two full batch lists.
  ///
  /// Handles the case where one device has a language the other doesn't
  /// (e.g. user added German on iPhone, Spanish on iPad).
  static List<BatchEntry> mergeAllLanguageBatches({
    required List<BatchEntry> local,
    required List<BatchEntry> remote,
  }) {
    final localByLang = groupByLanguage(local);
    final remoteByLang = groupByLanguage(remote);

    final allLangKeys = {
      ...localByLang.keys,
      ...remoteByLang.keys,
    };

    final result = <BatchEntry>[];
    for (final langKey in allLangKeys) {
      result.addAll(mergeBatches(
        local: localByLang[langKey] ?? [],
        remote: remoteByLang[langKey] ?? [],
      ));
    }
    return result;
  }
}
