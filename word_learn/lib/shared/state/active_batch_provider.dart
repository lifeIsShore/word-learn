import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vocabulary_repository.dart';
import '../models/batch_entry.dart';
import '../models/language_config.dart';
import 'session_state.dart';
import 'vault_provider.dart';

const int _batchCapacity = 200;

// ── Per-language batch provider (WL-610) ──────────────────────────────────────

/// Family provider: one independent [LanguageBatchNotifier] per [LanguageConfig].
///
/// Each language gets its own isolated 200-word Active Batch with independent
/// SRS state. Language configs are compared by [LanguageConfig.key] so the
/// family lookup is stable.
///
/// Usage:
///   ref.watch(languageBatchProvider(config))
///   ref.read(languageBatchProvider(config).notifier)
final languageBatchProvider = NotifierProviderFamily<
    LanguageBatchNotifier, List<BatchEntry>, LanguageConfig>(
  LanguageBatchNotifier.new,
);

class LanguageBatchNotifier
    extends FamilyNotifier<List<BatchEntry>, LanguageConfig> {
  /// The LanguageConfig this batch belongs to — set by Riverpod family arg.
  late LanguageConfig _config;

  @override
  List<BatchEntry> build(LanguageConfig arg) {
    _config = arg;
    return _seedInitialBatch();
  }

  // ── Capacity ───────────────────────────────────────────────────────────────

  int get capacity => _batchCapacity;
  bool get isFull => state.length >= _batchCapacity;
  int get remainingCapacity => _batchCapacity - state.length;
  bool get isNearCapacity => state.length >= (_batchCapacity * 0.9).round();

  // ── Daily Drip ─────────────────────────────────────────────────────────────

  /// Inject [count] new words from this batch's language config.
  /// Skips duplicates and respects 200-word cap.
  /// Returns the number of words actually added.
  int injectDrip({int count = 20}) {
    if (isFull) return 0;

    final available = VocabularyRepository.getWords(
      languageCode: _config.languageCode,
      cefrLevel: _config.cefrLevel.toLowerCase(),
    );

    final existingIds = state.map((e) => e.id).toSet();
    final candidates =
        available.where((w) => !existingIds.contains(w.id)).toList();

    final toAdd =
        candidates.take(remainingCapacity.clamp(0, count)).toList();
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
          languageKey: _config.key,
        ));

    state = [...state, ...newEntries];
    return toAdd.length;
  }

  // ── SRS update ─────────────────────────────────────────────────────────────

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

  // ── Mutations ──────────────────────────────────────────────────────────────

  void remove(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void moveToVault(String id) {
    final match = state.where((e) => e.id == id).toList();
    if (match.isNotEmpty) {
      ref.read(vaultProvider.notifier).add(match.first);
      state = state.where((e) => e.id != id).toList();
    }
  }

  void clearNewTodayFlags() {
    state = [for (final e in state) e.copyWith(isNewToday: false)];
  }

  // ── Seed ───────────────────────────────────────────────────────────────────

  List<BatchEntry> _seedInitialBatch() {
    final now = DateTime.now();
    final words = VocabularyRepository.getWords(
      languageCode: _config.languageCode,
      cefrLevel: _config.cefrLevel.toLowerCase(),
    ).take(10).toList();

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
        languageKey: _config.key,
      );
    }).toList();
  }
}

// ── Legacy single-language provider (kept for backward compat) ────────────────
//
// Pre-WL-610 code reads activeBatchProvider directly. We keep it pointing
// to the German B2 batch so existing call-sites continue working while the
// rest of the app is migrated to languageBatchProvider.

final activeBatchProvider =
    NotifierProvider<ActiveBatchNotifier, List<BatchEntry>>(
  ActiveBatchNotifier.new,
);

/// Thin wrapper that delegates to the German B2 language batch.
/// All pre-WL-610 code that reads activeBatchProvider continues to work.
/// New code should use [languageBatchProvider] with an explicit config.
class ActiveBatchNotifier extends Notifier<List<BatchEntry>> {
  static final _fallbackConfig = LanguageConfig(
    languageCode: 'de',
    cefrLevel: 'B2',
    assetPath: 'assets/data/de_b2.csv',
    languageName: 'German',
    wordColumnHeader: 'German Word',
  );

  @override
  List<BatchEntry> build() {
    // Mirror the de_b2 language batch so activeBatchProvider stays in sync.
    return ref.watch(languageBatchProvider(_fallbackConfig));
  }

  LanguageBatchNotifier get _delegate =>
      ref.read(languageBatchProvider(_fallbackConfig).notifier);

  int get capacity => _delegate.capacity;
  bool get isFull => _delegate.isFull;
  int get remainingCapacity => _delegate.remainingCapacity;
  bool get isNearCapacity => _delegate.isNearCapacity;

  int injectDrip({
    int count = 20,
    LanguageConfig? config,
    String targetLanguage = 'de',
    String cefrLevel = 'b2',
  }) {
    if (config != null) {
      return ref
          .read(languageBatchProvider(config).notifier)
          .injectDrip(count: count);
    }
    return _delegate.injectDrip(count: count);
  }

  void applyRating(String cardId, DifficultyRating rating) =>
      _delegate.applyRating(cardId, rating);

  void remove(String id) => _delegate.remove(id);

  void moveToVault(String id) => _delegate.moveToVault(id);

  void clearNewTodayFlags() => _delegate.clearNewTodayFlags();
}
