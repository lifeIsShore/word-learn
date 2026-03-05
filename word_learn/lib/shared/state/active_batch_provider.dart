import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vocabulary_repository.dart';
import '../models/batch_entry.dart';
import '../models/language_config.dart';
import '../services/local_storage_service.dart';
import 'session_state.dart';
import 'vault_provider.dart';

const int _batchCapacity = 200;

// ── Per-language batch provider (WL-610) ──────────────────────────────────────

/// Family provider: one independent [LanguageBatchNotifier] per [LanguageConfig].
///
/// Each language gets its own isolated 200-word Active Batch with independent
/// SRS state. Fully persisted to SQLite via [LocalStorageService].
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
  late LanguageConfig _config;
  final _storage = LocalStorageService.instance;
  bool _loaded = false;

  @override
  List<BatchEntry> build(LanguageConfig arg) {
    _config = arg;
    // Return empty list synchronously; init() loads from DB asynchronously.
    // This avoids blocking Riverpod's synchronous build.
    return [];
  }

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Load this language's batch from SQLite (or seed if first launch).
  /// Must be called once per language on startup / first use.
  Future<void> init() async {
    if (_loaded) return;
    _loaded = true;

    final persisted = await _storage.loadBatch(_config.key);
    if (persisted.isNotEmpty) {
      state = persisted;
    } else {
      // First launch for this language — seed initial 10-word batch.
      final seeded = _buildSeed();
      await _storage.upsertBatchEntries(seeded);
      state = seeded;
    }
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
  Future<int> injectDrip({int count = 20}) async {
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
    final newEntries = toAdd
        .map((w) => BatchEntry(
              id: w.id,
              word: w.word,
              meaning: w.meaning,
              exampleSentence: w.exampleSentence,
              exampleTranslation: w.exampleTranslation,
              addedAt: now,
              isNewToday: true,
              languageKey: _config.key,
            ))
        .toList();

    state = [...state, ...newEntries];
    await _storage.upsertBatchEntries(newEntries);
    return toAdd.length;
  }

  // ── SRS update ─────────────────────────────────────────────────────────────

  Future<void> applyRating(String cardId, DifficultyRating rating) async {
    final quality = _ratingToQuality(rating);
    BatchEntry? updated;
    state = [
      for (final entry in state)
        if (entry.id == cardId)
          updated = entry.withSm2Update(quality)
        else
          entry,
    ];
    if (updated != null) {
      await _storage.upsertBatchEntry(updated);
    }
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

  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toList();
    await _storage.deleteBatchEntry(id);
  }

  Future<void> moveToVault(String id) async {
    final match = state.where((e) => e.id == id).toList();
    if (match.isNotEmpty) {
      await ref.read(vaultProvider.notifier).add(match.first);
      state = state.where((e) => e.id != id).toList();
      await _storage.deleteBatchEntry(id);
    }
  }

  Future<void> clearNewTodayFlags() async {
    final updated = [for (final e in state) e.copyWith(isNewToday: false)];
    state = updated;
    await _storage.upsertBatchEntries(updated);
  }

  // ── Seed ───────────────────────────────────────────────────────────────────

  List<BatchEntry> _buildSeed() {
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

final activeBatchProvider =
    NotifierProvider<ActiveBatchNotifier, List<BatchEntry>>(
  ActiveBatchNotifier.new,
);

/// Thin wrapper that delegates to the German B2 language batch.
/// All pre-WL-610 code continues to work unchanged.
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
    return ref.watch(languageBatchProvider(_fallbackConfig));
  }

  LanguageBatchNotifier get _delegate =>
      ref.read(languageBatchProvider(_fallbackConfig).notifier);

  int get capacity => _delegate.capacity;
  bool get isFull => _delegate.isFull;
  int get remainingCapacity => _delegate.remainingCapacity;
  bool get isNearCapacity => _delegate.isNearCapacity;

  Future<int> injectDrip({
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

  Future<void> applyRating(String cardId, DifficultyRating rating) =>
      _delegate.applyRating(cardId, rating);

  Future<void> remove(String id) => _delegate.remove(id);

  Future<void> moveToVault(String id) => _delegate.moveToVault(id);

  Future<void> clearNewTodayFlags() => _delegate.clearNewTodayFlags();
}
