import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/vocabulary_repository.dart';
import '../models/batch_entry.dart';
import '../models/flashcard_item.dart';
import 'session_state.dart';
import 'active_batch_provider.dart';

final sessionProvider =
    NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionState();

  /// Start a new session: pull due/new cards from the active batch, shuffle. WL-050.
  void startSession({int maxCards = 10}) {
    final batch = ref.read(activeBatchProvider);
    final now = DateTime.now();

    // Prefer cards that are due for review, then fill with others.
    final due = batch
        .where((e) => e.nextReviewDate == null || !e.nextReviewDate!.isAfter(now))
        .toList();
    final notDue = batch
        .where((e) => e.nextReviewDate != null && e.nextReviewDate!.isAfter(now))
        .toList();

    due.shuffle(Random());
    notDue.shuffle(Random());

    final combined = [...due, ...notDue].take(maxCards).toList();

    // Fall back to sample vocabulary if batch is empty (dev/demo mode).
    final cards = combined.isNotEmpty
        ? combined.map((e) => FlashcardItem(
              id: e.id,
              word: e.word,
              meaning: e.meaning,
              exampleSentence: e.exampleSentence,
              exampleTranslation: e.exampleTranslation,
            )).toList()
        : _fallbackSample(maxCards);

    state = SessionState(
      cards: cards,
      currentIndex: 0,
      results: [],
      startTime: DateTime.now(),
    );
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
            ))
        .toList();
  }

  /// Submit rating for current card, update SRS in batch, advance. WL-070.
  void submitRating(DifficultyRating rating) {
    final card = state.currentCard;
    if (card == null) return;

    final newResults = List<SessionCardResult>.from(state.results)
      ..add(SessionCardResult(cardId: card.id, rating: rating));
    state = state.copyWith(
      results: newResults,
      currentIndex: state.currentIndex + 1,
    );

    // Update SRS for this card in the active batch.
    ref.read(activeBatchProvider.notifier).applyRating(card.id, rating);
  }

  /// Clear session (e.g. after viewing completion screen).
  void clearSession() {
    state = const SessionState();
  }
}
