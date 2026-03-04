import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_vocabulary.dart';
import '../models/flashcard_item.dart';
import 'session_state.dart';

final sessionProvider =
    NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => const SessionState();

  /// Start a new session: load cards, shuffle, reset index and results. WL-050.
  void startSession({int maxCards = 10}) {
    final all = getSampleVocabulary();
    final list = List<FlashcardItem>.from(all);
    list.shuffle(Random());
    final cards = list.take(maxCards).toList();
    state = SessionState(
      cards: cards,
      currentIndex: 0,
      results: [],
      startTime: DateTime.now(),
    );
  }

  /// Submit rating for current card and advance. WL-070.
  void submitRating(DifficultyRating rating) {
    final card = state.currentCard;
    if (card == null) return;
    final newResults = List<SessionCardResult>.from(state.results)
      ..add(SessionCardResult(cardId: card.id, rating: rating));
    state = state.copyWith(
      results: newResults,
      currentIndex: state.currentIndex + 1,
    );
  }

  /// Clear session (e.g. after viewing completion screen).
  void clearSession() {
    state = const SessionState();
  }
}
