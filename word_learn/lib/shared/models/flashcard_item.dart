/// A single flashcard for the study session.
/// Matches CSV columns: German Word, English Meaning, German Example, English Translation.
class FlashcardItem {
  const FlashcardItem({
    required this.id,
    required this.word,
    required this.meaning,
    required this.exampleSentence,
    required this.exampleTranslation,
  });

  final String id;
  final String word;
  final String meaning;
  final String exampleSentence;
  final String exampleTranslation;
}
