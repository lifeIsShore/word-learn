/// Describes a single available vocabulary asset: language code, CEFR level,
/// asset path, and a human-readable label.
///
/// The asset path is the key used with [rootBundle.loadString()].
/// Add new entries here when adding new CSV files to assets/data/.
class LanguageConfig {
  const LanguageConfig({
    required this.languageCode,
    required this.cefrLevel,
    required this.assetPath,
    required this.languageName,
    required this.wordColumnHeader,
  });

  /// ISO 639-1 code, e.g. 'de', 'es', 'fr', 'it', 'tr', 'en'.
  final String languageCode;

  /// CEFR level string, e.g. 'B2', 'C1'. Always uppercase.
  final String cefrLevel;

  /// Path relative to the Flutter asset bundle, e.g. 'assets/data/de_b2.csv'.
  final String assetPath;

  /// Human-readable language name, e.g. 'German'.
  final String languageName;

  /// The header of the first column in the CSV — used to skip the header row.
  final String wordColumnHeader;

  /// Unique key used as a cache key and as the vocabulary ID prefix.
  String get key => '${languageCode}_${cefrLevel.toLowerCase()}';

  @override
  String toString() => 'LanguageConfig($key)';
}

/// Master registry of all available language × CEFR combinations.
/// When a new CSV is added to assets/data/, add an entry here AND
/// register it in pubspec.yaml under flutter.assets.
const List<LanguageConfig> kAvailableLanguageConfigs = [
  // ── German ────────────────────────────────────────────────────────────────
  LanguageConfig(
    languageCode: 'de',
    cefrLevel: 'A1',
    assetPath: 'assets/data/de_a1.csv',
    languageName: 'German',
    wordColumnHeader: 'German Word',
  ),
  LanguageConfig(
    languageCode: 'de',
    cefrLevel: 'A2',
    assetPath: 'assets/data/de_a2.csv',
    languageName: 'German',
    wordColumnHeader: 'German Word',
  ),
  LanguageConfig(
    languageCode: 'de',
    cefrLevel: 'B1',
    assetPath: 'assets/data/de_b1.csv',
    languageName: 'German',
    wordColumnHeader: 'German Word',
  ),
  LanguageConfig(
    languageCode: 'de',
    cefrLevel: 'B2',
    assetPath: 'assets/data/de_b2.csv',
    languageName: 'German',
    wordColumnHeader: 'German Word',
  ),
  LanguageConfig(
    languageCode: 'de',
    cefrLevel: 'C1',
    assetPath: 'assets/data/de_c1.csv',
    languageName: 'German',
    wordColumnHeader: 'German Word',
  ),
  // ── Spanish ───────────────────────────────────────────────────────────────
  LanguageConfig(
    languageCode: 'es',
    cefrLevel: 'A1',
    assetPath: 'assets/data/es_a1.csv',
    languageName: 'Spanish',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'es',
    cefrLevel: 'A2',
    assetPath: 'assets/data/es_a2.csv',
    languageName: 'Spanish',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'es',
    cefrLevel: 'B1',
    assetPath: 'assets/data/es_b1.csv',
    languageName: 'Spanish',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'es',
    cefrLevel: 'B2',
    assetPath: 'assets/data/es_b2.csv',
    languageName: 'Spanish',
    wordColumnHeader: 'Target Word',
  ),
  // ── French ────────────────────────────────────────────────────────────────
  LanguageConfig(
    languageCode: 'fr',
    cefrLevel: 'A1',
    assetPath: 'assets/data/fr_a1.csv',
    languageName: 'French',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'fr',
    cefrLevel: 'A2',
    assetPath: 'assets/data/fr_a2.csv',
    languageName: 'French',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'fr',
    cefrLevel: 'B1',
    assetPath: 'assets/data/fr_b1.csv',
    languageName: 'French',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'fr',
    cefrLevel: 'B2',
    assetPath: 'assets/data/fr_b2.csv',
    languageName: 'French',
    wordColumnHeader: 'Target Word',
  ),
  // ── Italian ───────────────────────────────────────────────────────────────
  LanguageConfig(
    languageCode: 'it',
    cefrLevel: 'A1',
    assetPath: 'assets/data/it_a1.csv',
    languageName: 'Italian',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'it',
    cefrLevel: 'A2',
    assetPath: 'assets/data/it_a2.csv',
    languageName: 'Italian',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'it',
    cefrLevel: 'B1',
    assetPath: 'assets/data/it_b1.csv',
    languageName: 'Italian',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'it',
    cefrLevel: 'B2',
    assetPath: 'assets/data/it_b2.csv',
    languageName: 'Italian',
    wordColumnHeader: 'Target Word',
  ),
  // ── Turkish ───────────────────────────────────────────────────────────────
  LanguageConfig(
    languageCode: 'tr',
    cefrLevel: 'A1',
    assetPath: 'assets/data/tr_a1.csv',
    languageName: 'Turkish',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'tr',
    cefrLevel: 'A2',
    assetPath: 'assets/data/tr_a2.csv',
    languageName: 'Turkish',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'tr',
    cefrLevel: 'B1',
    assetPath: 'assets/data/tr_b1.csv',
    languageName: 'Turkish',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'tr',
    cefrLevel: 'B2',
    assetPath: 'assets/data/tr_b2.csv',
    languageName: 'Turkish',
    wordColumnHeader: 'Target Word',
  ),
  // ── English (as target language) ──────────────────────────────────────────
  LanguageConfig(
    languageCode: 'en',
    cefrLevel: 'A1',
    assetPath: 'assets/data/en_a1.csv',
    languageName: 'English',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'en',
    cefrLevel: 'A2',
    assetPath: 'assets/data/en_a2.csv',
    languageName: 'English',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'en',
    cefrLevel: 'B1',
    assetPath: 'assets/data/en_b1.csv',
    languageName: 'English',
    wordColumnHeader: 'Target Word',
  ),
  LanguageConfig(
    languageCode: 'en',
    cefrLevel: 'B2',
    assetPath: 'assets/data/en_b2.csv',
    languageName: 'English',
    wordColumnHeader: 'Target Word',
  ),
];

/// Looks up a [LanguageConfig] by [languageCode] and [cefrLevel].
/// Returns null if no matching config is registered.
LanguageConfig? findLanguageConfig({
  required String languageCode,
  required String cefrLevel,
}) {
  final level = cefrLevel.toUpperCase();
  try {
    return kAvailableLanguageConfigs.firstWhere(
      (c) => c.languageCode == languageCode && c.cefrLevel == level,
    );
  } catch (_) {
    return null;
  }
}
