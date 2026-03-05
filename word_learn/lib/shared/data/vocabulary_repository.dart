import '../models/flashcard_item.dart';
import '../models/language_config.dart';
import 'vocabulary_loader.dart';

/// Legacy synchronous vocabulary access — kept for backward compatibility.
///
/// PRE-WL-600: This class embedded all vocabulary as inline Dart string
/// constants. That was a temporary measure documented as a TODO in Session 4.
///
/// POST-WL-600: Vocabulary is now loaded from bundled asset CSVs via
/// [VocabularyLoader]. This class provides a thin synchronous facade that
/// returns cached data (populated after the first async load), so that
/// existing call sites (seed batch, drip injection) continue to work without
/// refactoring. New code should prefer [VocabularyLoader] / the Riverpod
/// [vocabularyLoaderProvider] directly.
///
/// Warm-up: [VocabularyRepository.warmUp] should be called once during
/// app initialisation (e.g. in [SplashScreen]) so that the cache is
/// populated before the Home screen requests a drip injection.
class VocabularyRepository {
  VocabularyRepository._();

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Asynchronously warms the cache for [config].
  /// Call this during the splash screen for each user-chosen language.
  static Future<List<FlashcardItem>> warmUp(LanguageConfig config) =>
      VocabularyLoader.load(config);

  /// Synchronous access — returns cached words for [languageCode] / [cefrLevel].
  /// Returns an empty list if [warmUp] has not been called yet.
  ///
  /// Existing callers (ActiveBatchNotifier, SessionNotifier) use this path.
  static List<FlashcardItem> getWords({
    String languageCode = 'de',
    String cefrLevel = 'b2',
  }) {
    final key = '${languageCode}_${cefrLevel.toLowerCase()}';
    // Return from loader cache if available.
    final cached = VocabularyLoader.cachedWords(key);
    if (cached != null) return cached;

    // Fallback: return empty list and log a warning.
    // This only happens if warmUp was not called before first use.
    assert(
      false,
      '[VocabularyRepository] Cache miss for key "$key". '
      'Call VocabularyRepository.warmUp() during app init.',
    );
    return const [];
  }

  /// Quick fallback for dev/demo mode — returns a stable short list.
  static List<FlashcardItem> getSampleWords() =>
      getWords(languageCode: 'de', cefrLevel: 'b2').take(10).toList();
}
