// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:word_learn/shared/backup/sync_resolver.dart';
import 'package:word_learn/shared/models/batch_entry.dart';

void main() {
  // ── Helpers ────────────────────────────────────────────────────────────────

  BatchEntry entry({
    required String id,
    required String langKey,
    DateTime? nextReview,
    double ef = 2.5,
    int reps = 0,
  }) =>
      BatchEntry(
        id: id,
        word: 'word_$id',
        meaning: 'meaning_$id',
        exampleSentence: '',
        exampleTranslation: '',
        nextReviewDate: nextReview,
        easeFactor: ef,
        repetitions: reps,
        addedAt: DateTime(2026, 1, 1),
        languageKey: langKey,
      );

  VaultEntrySnapshot vault({
    required String id,
    required String langKey,
    required DateTime vaultedAt,
  }) =>
      VaultEntrySnapshot(
        id: id,
        languageKey: langKey,
        word: 'word_$id',
        meaning: 'meaning_$id',
        exampleSentence: '',
        exampleTranslation: '',
        easeFactor: 2.5,
        intervalDays: 30,
        repetitions: 5,
        addedAt: DateTime(2026, 1, 1),
        vaultedAt: vaultedAt,
      );

  // ── resolveWordConflict ────────────────────────────────────────────────────

  group('resolveWordConflict', () {
    test('returns the entry with the more-recent nextReviewDate', () {
      final local = entry(
        id: '1',
        langKey: 'de_b2',
        nextReview: DateTime(2026, 3, 10),
      );
      final remote = entry(
        id: '1',
        langKey: 'de_b2',
        nextReview: DateTime(2026, 3, 15), // more recent
      );

      final winner = SyncResolver.resolveWordConflict(
          local: local, remote: remote);
      expect(winner.id, '1');
      expect(winner.nextReviewDate, DateTime(2026, 3, 15));
    });

    test('local wins when local nextReviewDate is more recent', () {
      final local = entry(
        id: '2',
        langKey: 'de_b2',
        nextReview: DateTime(2026, 3, 20),
      );
      final remote = entry(
        id: '2',
        langKey: 'de_b2',
        nextReview: DateTime(2026, 3, 5),
      );

      final winner = SyncResolver.resolveWordConflict(
          local: local, remote: remote);
      expect(winner.nextReviewDate, DateTime(2026, 3, 20));
    });

    test('remote wins when local has no nextReviewDate', () {
      final local = entry(id: '3', langKey: 'de_b2', nextReview: null);
      final remote = entry(
        id: '3',
        langKey: 'de_b2',
        nextReview: DateTime(2026, 3, 10),
      );

      final winner = SyncResolver.resolveWordConflict(
          local: local, remote: remote);
      expect(winner.nextReviewDate, DateTime(2026, 3, 10));
    });

    test('local wins when remote has no nextReviewDate', () {
      final local = entry(
        id: '4',
        langKey: 'de_b2',
        nextReview: DateTime(2026, 3, 10),
      );
      final remote = entry(id: '4', langKey: 'de_b2', nextReview: null);

      final winner = SyncResolver.resolveWordConflict(
          local: local, remote: remote);
      expect(winner.nextReviewDate, DateTime(2026, 3, 10));
    });

    test('remote is preferred when both have no nextReviewDate', () {
      final local = entry(id: '5', langKey: 'de_b2', nextReview: null);
      final remote = entry(id: '5', langKey: 'de_b2', nextReview: null, ef: 2.8);

      final winner = SyncResolver.resolveWordConflict(
          local: local, remote: remote);
      expect(winner.easeFactor, 2.8); // remote's ef
    });
  });

  // ── mergeBatches ──────────────────────────────────────────────────────────

  group('mergeBatches', () {
    test('keeps words only in local', () {
      final local = [entry(id: 'a', langKey: 'de_b2')];
      final remote = <BatchEntry>[];

      final merged = SyncResolver.mergeBatches(
          local: local, remote: remote);
      expect(merged.length, 1);
      expect(merged.first.id, 'a');
    });

    test('keeps words only in remote', () {
      final local = <BatchEntry>[];
      final remote = [entry(id: 'b', langKey: 'de_b2')];

      final merged = SyncResolver.mergeBatches(
          local: local, remote: remote);
      expect(merged.length, 1);
      expect(merged.first.id, 'b');
    });

    test('resolves conflict when same word on both sides', () {
      final local = [
        entry(id: 'c', langKey: 'de_b2',
            nextReview: DateTime(2026, 3, 1)),
      ];
      final remote = [
        entry(id: 'c', langKey: 'de_b2',
            nextReview: DateTime(2026, 3, 20)), // newer
      ];

      final merged = SyncResolver.mergeBatches(
          local: local, remote: remote);
      expect(merged.length, 1);
      expect(merged.first.nextReviewDate, DateTime(2026, 3, 20));
    });

    test('unions when no conflicts', () {
      final local = [
        entry(id: 'd', langKey: 'de_b2'),
        entry(id: 'e', langKey: 'de_b2'),
      ];
      final remote = [
        entry(id: 'f', langKey: 'de_b2'),
        entry(id: 'g', langKey: 'de_b2'),
      ];

      final merged = SyncResolver.mergeBatches(
          local: local, remote: remote);
      expect(merged.length, 4);
      expect(merged.map((e) => e.id).toSet(),
          containsAll(['d', 'e', 'f', 'g']));
    });

    test('empty remote returns local unchanged', () {
      final local = [
        entry(id: 'h', langKey: 'de_b2', nextReview: DateTime(2026, 2, 1)),
      ];
      final merged = SyncResolver.mergeBatches(local: local, remote: []);
      expect(merged.length, 1);
      expect(merged.first.nextReviewDate, DateTime(2026, 2, 1));
    });

    test('empty local returns remote unchanged', () {
      final remote = [
        entry(id: 'i', langKey: 'de_b2', nextReview: DateTime(2026, 3, 1)),
      ];
      final merged = SyncResolver.mergeBatches(local: [], remote: remote);
      expect(merged.length, 1);
      expect(merged.first.nextReviewDate, DateTime(2026, 3, 1));
    });
  });

  // ── mergeAllLanguageBatches ───────────────────────────────────────────────

  group('mergeAllLanguageBatches', () {
    test('handles languages only on one device', () {
      // iPhone has de_b2, iPad has es_b2
      final local = [entry(id: 'de1', langKey: 'de_b2')];
      final remote = [entry(id: 'es1', langKey: 'es_b2')];

      final merged = SyncResolver.mergeAllLanguageBatches(
          local: local, remote: remote);
      expect(merged.length, 2);
      expect(merged.map((e) => e.languageKey).toSet(),
          containsAll(['de_b2', 'es_b2']));
    });

    test('no cross-language data leaks', () {
      final local = [
        entry(id: 'x1', langKey: 'de_b2',
            nextReview: DateTime(2026, 3, 10)),
        entry(id: 'x1', langKey: 'es_b2', // same word id, different language
            nextReview: DateTime(2026, 3, 5)),
      ];
      final remote = <BatchEntry>[];

      // Both words survive; merge is per-language.
      final merged = SyncResolver.mergeAllLanguageBatches(
          local: local, remote: remote);
      // Each language group has its own 'x1'.
      expect(merged.where((e) => e.languageKey == 'de_b2').length, 1);
      expect(merged.where((e) => e.languageKey == 'es_b2').length, 1);
    });
  });

  // ── mergeVaults ──────────────────────────────────────────────────────────

  group('mergeVaults', () {
    test('returns the more-recently vaulted entry on conflict', () {
      final local = [
        vault(id: 'v1', langKey: 'de_b2',
            vaultedAt: DateTime(2026, 2, 1)),
      ];
      final remote = [
        vault(id: 'v1', langKey: 'de_b2',
            vaultedAt: DateTime(2026, 3, 1)), // newer
      ];

      final merged = SyncResolver.mergeVaults(
          local: local, remote: remote);
      expect(merged.length, 1);
      expect(merged.first.vaultedAt, DateTime(2026, 3, 1));
    });

    test('unions vaults with no conflicts', () {
      final local = [
        vault(id: 'v2', langKey: 'de_b2',
            vaultedAt: DateTime(2026, 1, 1)),
      ];
      final remote = [
        vault(id: 'v3', langKey: 'de_b2',
            vaultedAt: DateTime(2026, 2, 1)),
      ];

      final merged = SyncResolver.mergeVaults(
          local: local, remote: remote);
      expect(merged.length, 2);
    });

    test('empty remote returns local vault', () {
      final local = [
        vault(id: 'v4', langKey: 'de_b2',
            vaultedAt: DateTime(2026, 1, 15)),
      ];
      final merged = SyncResolver.mergeVaults(local: local, remote: []);
      expect(merged.length, 1);
    });

    test('empty local returns remote vault', () {
      final remote = [
        vault(id: 'v5', langKey: 'de_b2',
            vaultedAt: DateTime(2026, 2, 1)),
      ];
      final merged = SyncResolver.mergeVaults(local: [], remote: remote);
      expect(merged.length, 1);
    });
  });
}
