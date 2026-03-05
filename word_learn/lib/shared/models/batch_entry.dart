/// A word in the Active Batch with SRS state. PRD: 200-word limit per language.
/// [languageKey] is the LanguageConfig.key, e.g. 'de_b2'. Added in WL-610.
class BatchEntry {
  const BatchEntry({
    required this.id,
    required this.word,
    required this.meaning,
    required this.exampleSentence,
    required this.exampleTranslation,
    this.nextReviewDate,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    this.repetitions = 0,
    required this.addedAt,
    this.isNewToday = false,
    this.languageKey = 'de_b2',
  });

  final String id;
  final String word;
  final String meaning;
  final String exampleSentence;
  final String exampleTranslation;
  final DateTime? nextReviewDate;
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final DateTime addedAt;

  /// True if this word was added during today's drip — shown as "NEW" badge.
  final bool isNewToday;

  /// Language config key this word belongs to, e.g. 'de_b2'. WL-610.
  final String languageKey;

  /// Difficulty colour: green (easy) ≥2.2, orange (medium) 1.8–2.2, red (hard) <1.8.
  String get difficultyLevel {
    if (easeFactor >= 2.2) return 'easy';
    if (easeFactor >= 1.8) return 'medium';
    return 'hard';
  }

  /// SM-2 algorithm update.
  ///   quality: 0 = hard, 1 = familiar, 2 = ok, 3 = easy
  BatchEntry withSm2Update(int quality) {
    double newEF = easeFactor + (0.1 - (3 - quality) * (0.08 + (3 - quality) * 0.02));
    if (newEF < 1.3) newEF = 1.3;

    int newReps;
    int newInterval;
    if (quality < 1) {
      // Hard: reset
      newReps = 0;
      newInterval = 1;
    } else {
      newReps = repetitions + 1;
      if (newReps == 1) {
        newInterval = 1;
      } else if (newReps == 2) {
        newInterval = 6;
      } else {
        newInterval = (intervalDays * newEF).round();
      }
    }

    return copyWith(
      easeFactor: newEF,
      intervalDays: newInterval,
      repetitions: newReps,
      nextReviewDate: DateTime.now().add(Duration(days: newInterval)),
    );
  }

  BatchEntry copyWith({
    String? id,
    String? word,
    String? meaning,
    String? exampleSentence,
    String? exampleTranslation,
    DateTime? nextReviewDate,
    double? easeFactor,
    int? intervalDays,
    int? repetitions,
    DateTime? addedAt,
    bool? isNewToday,
    String? languageKey,
  }) {
    return BatchEntry(
      id: id ?? this.id,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      exampleSentence: exampleSentence ?? this.exampleSentence,
      exampleTranslation: exampleTranslation ?? this.exampleTranslation,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      addedAt: addedAt ?? this.addedAt,
      isNewToday: isNewToday ?? this.isNewToday,
      languageKey: languageKey ?? this.languageKey,
    );
  }
}
