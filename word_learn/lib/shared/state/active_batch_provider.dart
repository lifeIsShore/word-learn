import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vocabulary_repository.dart';
import '../models/batch_entry.dart';
import 'session_state.dart';
import 'vault_provider.dart';

const int _batchCapacity = 200;

final activeBatchProvider =
    NotifierProvider<ActiveBatchNotifier, List<BatchEntry>>(ActiveBatchNotifier.new);

class ActiveBatchNotifier extends Notifier<List<BatchEntry>> {
  @override
  List<BatchEntry> build() {
    return _seedInitialBatch();
  }

  // ── Capacity ──────────────────────────────────────────────────────────────

  int get capacity => _batchCapacity;

  bool get isFull => state.length >= _batchCapacity;

  int get remainingCapacity => _batchCapacity - state.length;

  /// True when batch is at or above 90 % capacity — used for Home warning.
  bool get isNearCapacity => state.length >= (_batchCapacity * 0.9).round();

  // ── Daily Drip (WL-150) ───────────────────────────────────────────────────

  /// Inject [count] new words into the batch from the vocabulary for
  /// [targetLanguage] / [cefrLevel], skipping words already present.
  /// Respects the 200-word capacity cap (WL-160).
  /// Returns how many words were actually added.
  int injectDrip({
    int count = 20,
    String targetLanguage = 'de',
    String cefrLevel = 'b2',
  }) {
    if (isFull) return 0;

    final available = VocabularyRepository.getWords(
      targetLanguage: targetLanguage,
      cefrLevel: cefrLevel,
    );

    final existingIds = state.map((e) => e.id).toSet();
    final candidates = available
        .where((w) => !existingIds.contains(w.id))
        .toList();

    final toAdd = candidates.take(remainingCapacity.clamp(0, count)).toList();
    if (toAdd.isEmpty) return 0;

    final now = DateTime.now();
    final newEntries = toAdd.map((w) => BatchEntry(
          id: w.id,
          word: w.word,
          meaning: w.meaning,
          exampleSentence: w.exampleSentence,
          exampleTranslation: w.exampleTranslation,
          addedAt: now,
          isNewToday: true,
        ));

    state = [...state, ...newEntries];
    return toAdd.length;
  }

  // ── SRS update (WL-140) ───────────────────────────────────────────────────

  /// Apply SM-2 rating from a session to the matching batch entry.
  void applyRating(String cardId, DifficultyRating rating) {
    final quality = _ratingToQuality(rating);
    state = [
      for (final entry in state)
        if (entry.id == cardId) entry.withSm2Update(quality) else entry,
    ];
  }

  int _ratingToQuality(DifficultyRating r) {
    switch (r) {
      case DifficultyRating.hard:
        return 0;
      case DifficultyRating.familiar:
        return 1;
      case DifficultyRating.ok:
        return 2;
      case DifficultyRating.easy:
        return 3;
    }
  }

  // ── Batch mutations ───────────────────────────────────────────────────────

  void remove(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  /// Move a word to the Vault (manual graduation or EASY auto-graduate). WL-170.
  void moveToVault(String id) {
    final match = state.where((e) => e.id == id).toList();
    if (match.isNotEmpty) {
      ref.read(vaultProvider.notifier).add(match.first);
      state = state.where((e) => e.id != id).toList();
    }
  }

  /// Clear the "isNewToday" flag at end of day / on next session start.
  void clearNewTodayFlags() {
    state = [for (final e in state) e.copyWith(isNewToday: false)];
  }

  // ── Seed ─────────────────────────────────────────────────────────────────

  List<BatchEntry> _seedInitialBatch() {
    final now = DateTime.now();
    final words = VocabularyRepository.getSampleWords();
    return words.asMap().entries.map((entry) {
      final i = entry.key;
      final w = entry.value;
      return BatchEntry(
        id: w.id,
        word: w.word,
        meaning: w.meaning,
        exampleSentence: w.exampleSentence,
        exampleTranslation: w.exampleTranslation,
        nextReviewDate: now.add(Duration(days: i % 3)),
        easeFactor: 2.5,
        addedAt: now.subtract(Duration(days: words.length - i)),
        isNewToday: false,
      );
    }).toList();
  }
}
