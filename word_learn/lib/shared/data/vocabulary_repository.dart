import '../models/flashcard_item.dart';
import '../models/language_config.dart';
import 'vocabulary_loader.dart';

/// Legacy synchronous vocabulary access — kept for backward compatibility.
///
/// POST-WL-600: Vocabulary is now loaded from bundled asset CSVs via
/// [VocabularyLoader]. This class provides a thin synchronous facade that
/// returns cached data (populated after the first async load), so that
/// existing call sites (seed batch, drip injection) continue to work without
/// refactoring.
///
/// SESSION 24: Added [isCached] so the background warm-up loop in
/// SplashScreen can skip configs that are already in memory.
class VocabularyRepository {
  VocabularyRepository._();

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Asynchronously warms the cache for [config].
  static Future<List<FlashcardItem>> warmUp(LanguageConfig config) =>
      VocabularyLoader.load(config);

  /// Returns true if [config] is already in the in-memory cache.
  /// Used by the background warm-up loop to skip already-loaded languages.
  static bool isCached(LanguageConfig config) =>
      VocabularyLoader.cachedWords(config.key) != null;

  /// Synchronous access — returns cached words for [languageCode] / [cefrLevel].
  /// Returns an empty list if [warmUp] has not been called yet.
  static List<FlashcardItem> getWords({
    String languageCode = 'de',
    String cefrLevel = 'b2',
  }) {
    final key = '${languageCode}_${cefrLevel.toLowerCase()}';
    final cached = VocabularyLoader.cachedWords(key);
    if (cached != null) return cached;

    assert(
      false,
      '[VocabularyRepository] Cache miss for key "$key". '
      'Call VocabularyRepository.warmUp() during app init.',
    );
    return const [];
  }

  /// Quick fallback — returns up to 10 German B2 words.
  static List<FlashcardItem> getSampleWords() =>
      getWords(languageCode: 'de', cefrLevel: 'b2').take(10).toList();
}
