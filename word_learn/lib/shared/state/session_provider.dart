import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vocabulary_repository.dart';
import '../models/flashcard_item.dart';
import '../models/language_config.dart';
import 'session_state.dart';
import 'active_batch_provider.dart';
import 'streak_provider.dart';

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionState();

  /// Start a session for a single [config] language, or all [configs] for
  /// multi-language mode (WL-610).
  ///
  /// Cards are drawn due-first, then shuffled. Each card is tagged with the
  /// language key so per-language stats can be computed in the summary.
  void startSession({
    int maxCards = 10,
    LanguageConfig? config,
    List<LanguageConfig> configs = const [],
  }) {
    final now = DateTime.now();
    final allCards = <FlashcardItem>[];

    // Determine which language pools to draw from.
    final targets = _resolveTargets(config, configs);

    if (targets.isEmpty) {
      // Fallback: draw from the legacy activeBatchProvider (de_b2).
      _startFromLegacyBatch(maxCards, now);
      return;
    }

    // Per-language: draw due cards first, then fill with not-due.
    for (final cfg in targets) {
      final batch = ref.read(languageBatchProvider(cfg));
      final due = batch
          .where((e) =>
              e.nextReviewDate == null || !e.nextReviewDate!.isAfter(now))
          .toList();
      final notDue = batch
          .where((e) =>
              e.nextReviewDate != null && e.nextReviewDate!.isAfter(now))
          .toList();
      due.shuffle(Random());
      notDue.shuffle(Random());

      final perLang = [...due, ...notDue]
          .take((maxCards / targets.length).ceil())
          .map((e) => FlashcardItem(
                id: e.id,
                word: e.word,
                meaning: e.meaning,
                exampleSentence: e.exampleSentence,
                exampleTranslation: e.exampleTranslation,
                languageKey: cfg.key, // WL-610: tag with language
              ))
          .toList();
      allCards.addAll(perLang);
    }

    // Interleave all language cards and cap at maxCards.
    allCards.shuffle(Random());
    final cards = allCards.take(maxCards).toList();

    // Fallback to sample if no batch data yet.
    final finalCards = cards.isNotEmpty ? cards : _fallbackSample(maxCards);

    state = SessionState(
      cards: finalCards,
      currentIndex: 0,
      results: [],
      startTime: DateTime.now(),
    );
  }

  void _startFromLegacyBatch(int maxCards, DateTime now) {
    final batch = ref.read(activeBatchProvider);
    final due = batch
        .where((e) =>
            e.nextReviewDate == null || !e.nextReviewDate!.isAfter(now))
        .toList();
    final notDue = batch
        .where((e) =>
            e.nextReviewDate != null && e.nextReviewDate!.isAfter(now))
        .toList();
    due.shuffle(Random());
    notDue.shuffle(Random());

    final combined = [...due, ...notDue].take(maxCards).toList();
    final cards = combined.isNotEmpty
        ? combined
            .map((e) => FlashcardItem(
                  id: e.id,
                  word: e.word,
                  meaning: e.meaning,
                  exampleSentence: e.exampleSentence,
                  exampleTranslation: e.exampleTranslation,
                  languageKey: e.languageKey,
                ))
            .toList()
        : _fallbackSample(maxCards);

    state = SessionState(
      cards: cards,
      currentIndex: 0,
      results: [],
      startTime: DateTime.now(),
    );
  }

  List<LanguageConfig> _resolveTargets(
      LanguageConfig? config, List<LanguageConfig> configs) {
    if (config != null) return [config];
    if (configs.isNotEmpty) return configs;
    return const [];
  }

  List<FlashcardItem> _fallbackSample(int max) {
    return VocabularyRepository.getSampleWords()
        .take(max)
        .map((r) => FlashcardItem(
              id: r.id,
              word: r.word,
              meaning: r.meaning,
              exampleSentence: r.exampleSentence,
              exampleTranslation: r.exampleTranslation,
              languageKey: 'de_b2',
            ))
        .toList();
  }

  /// Submit rating for current card.
  /// Routes the SRS update to the correct language batch. WL-610.
  void submitRating(DifficultyRating rating) {
    final card = state.currentCard;
    if (card == null) return;

    final newResults = List<SessionCardResult>.from(state.results)
      ..add(SessionCardResult(
        cardId: card.id,
        rating: rating,
        languageKey: card.languageKey,
      ));
    state = state.copyWith(
      results: newResults,
      currentIndex: state.currentIndex + 1,
    );

    // Apply SRS to the correct language batch.
    _applyRatingToCorrectBatch(card.id, card.languageKey, rating);
  }

  void _applyRatingToCorrectBatch(
      String cardId, String languageKey, DifficultyRating rating) {
    // Try to find a matching LanguageConfig for this card's language key.
    final config = kAvailableLanguageConfigs
        .cast<LanguageConfig?>()
        .firstWhere((c) => c?.key == languageKey, orElse: () => null);

    if (config != null) {
      ref
          .read(languageBatchProvider(config).notifier)
          .applyRating(cardId, rating);
    } else {
      // Fallback: update legacy activeBatchProvider for unknown language keys.
      ref.read(activeBatchProvider.notifier).applyRating(cardId, rating);
    }
  }

  /// Mark session complete: record streak, then clear.
  Future<void> completeAndClear() async {
    await ref
        .read(streakProvider.notifier)
        .recordSessionComplete(DateTime.now());
    state = const SessionState();
  }

  /// Clear session without recording streak (abandoned mid-session).
  void clearSession() {
    state = const SessionState();
  }
}
