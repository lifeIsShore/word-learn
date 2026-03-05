import '../../shared/models/flashcard_item.dart';

/// Difficulty rating per PRD: HARD (1), FAMILIAR (2), OK (3), EASY (4).
enum DifficultyRating { hard, familiar, ok, easy }

/// Result of rating one card in a session.
/// [languageKey] is LanguageConfig.key — added in WL-610 for per-language stats.
class SessionCardResult {
  const SessionCardResult({
    required this.cardId,
    required this.rating,
    this.languageKey = '',
  });
  final String cardId;
  final DifficultyRating rating;
  final String languageKey;
}

/// Per-language breakdown used in the session summary (WL-610).
class LanguageSessionStats {
  const LanguageSessionStats({
    required this.languageKey,
    required this.languageName,
    required this.reviewed,
    required this.mastered,
  });

  final String languageKey;
  final String languageName;
  final int reviewed;
  final int mastered;
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
      (currentIndex >= 0 && currentIndex < cards.length)
          ? cards[currentIndex]
          : null;

  /// Words "mastered" this session: EASY count (simplified; full SRS later).
  int get masteredCount =>
      results.where((r) => r.rating == DifficultyRating.easy).length;

  /// Per-language breakdown for the session summary. WL-610.
  Map<String, LanguageSessionStats> get perLanguageStats {
    final map = <String, _MutableStats>{};
    for (final r in results) {
      final key = r.languageKey.isEmpty ? 'unknown' : r.languageKey;
      map.putIfAbsent(key, () => _MutableStats(key));
      map[key]!.reviewed++;
      if (r.rating == DifficultyRating.easy) map[key]!.mastered++;
    }
    return {
      for (final e in map.entries)
        e.key: LanguageSessionStats(
          languageKey: e.key,
          languageName: _labelFromKey(e.key),
          reviewed: e.value.reviewed,
          mastered: e.value.mastered,
        ),
    };
  }

  /// Whether this session contains cards from more than one language. WL-610.
  bool get isMultiLanguage {
    final keys = results.map((r) => r.languageKey).toSet();
    return keys.length > 1;
  }

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

// ── Helpers ───────────────────────────────────────────────────────────────────

class _MutableStats {
  _MutableStats(this.key);
  final String key;
  int reviewed = 0;
  int mastered = 0;
}

/// Derives a display label from a language key like 'de_b2' → 'German B2'.
String _labelFromKey(String key) {
  final parts = key.split('_');
  if (parts.length < 2) return key.toUpperCase();
  final lang = _langNames[parts[0]] ?? parts[0].toUpperCase();
  final cefr = parts[1].toUpperCase();
  return '$lang $cefr';
}

const _langNames = {
  'de': 'German',
  'es': 'Spanish',
  'fr': 'French',
  'it': 'Italian',
  'tr': 'Turkish',
  'en': 'English',
};
