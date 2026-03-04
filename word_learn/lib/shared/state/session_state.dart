import '../../shared/models/flashcard_item.dart';

/// Difficulty rating per PRD: HARD (1), FAMILIAR (2), OK (3), EASY (4).
enum DifficultyRating { hard, familiar, ok, easy }

/// Result of rating one card in a session.
class SessionCardResult {
  const SessionCardResult({
    required this.cardId,
    required this.rating,
  });
  final String cardId;
  final DifficultyRating rating;
}

/// State for an active or completed study session.
class SessionState {
  const SessionState({
    this.cards = const [],
    this.currentIndex = 0,
    this.results = const [],
    this.startTime,
  });

  final List<FlashcardItem> cards;
  final int currentIndex;
  final List<SessionCardResult> results;
  final DateTime? startTime;

  int get totalCount => cards.length;
  int get reviewedCount => results.length;
  bool get isComplete => cards.isNotEmpty && currentIndex >= cards.length;
  FlashcardItem? get currentCard =>
      (currentIndex >= 0 && currentIndex < cards.length) ? cards[currentIndex] : null;

  /// Words "mastered" this session: EASY count (simplified; full SRS later).
  int get masteredCount =>
      results.where((r) => r.rating == DifficultyRating.easy).length;

  SessionState copyWith({
    List<FlashcardItem>? cards,
    int? currentIndex,
    List<SessionCardResult>? results,
    DateTime? startTime,
  }) {
    return SessionState(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      results: results ?? this.results,
      startTime: startTime ?? this.startTime,
    );
  }
}
