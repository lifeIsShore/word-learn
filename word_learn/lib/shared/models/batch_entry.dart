/// A word in the Active Batch with SRS state. PRD: 200-word limit per language.
class BatchEntry {
  const BatchEntry({
    required this.id,
    required this.word,
    required this.meaning,
    required this.exampleSentence,
    required this.exampleTranslation,
    this.nextReviewDate,
    this.easeFactor = 2.5,
    required this.addedAt,
  });

  final String id;
  final String word;
  final String meaning;
  final String exampleSentence;
  final String exampleTranslation;
  final DateTime? nextReviewDate;
  final double easeFactor;
  final DateTime addedAt;

  /// Difficulty color: green (easy) ≥2.0, orange (medium) 1.5–2.0, red (hard) <1.5.
  String get difficultyLevel {
    if (easeFactor >= 2.0) return 'easy';
    if (easeFactor >= 1.5) return 'medium';
    return 'hard';
  }
}
