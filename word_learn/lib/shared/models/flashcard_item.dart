/// A single flashcard for the study session.
/// Matches CSV columns: Word, English Meaning, Example, Translation.
/// [languageKey] is LanguageConfig.key — added in WL-610 for per-language SRS routing.
class FlashcardItem {
  const FlashcardItem({
    required this.id,
    required this.word,
    required this.meaning,
    required this.exampleSentence,
    required this.exampleTranslation,
    this.languageKey = '',
  });

  final String id;
  final String word;
  final String meaning;
  final String exampleSentence;
  final String exampleTranslation;

  /// The language config key this card belongs to, e.g. 'de_b2'. WL-610.
  final String languageKey;
}
