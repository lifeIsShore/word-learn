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

  /// ISO 639-1 code, e.g. 'de', 'es'.
  final String languageCode;

  /// CEFR level string, e.g. 'B2', 'C1'. Always uppercase.
  final String cefrLevel;

  /// Path relative to the Flutter asset bundle, e.g. 'assets/data/de_b2.csv'.
  final String assetPath;

  /// Human-readable language name, e.g. 'German'.
  final String languageName;

  /// The header of the first column in the CSV — used to skip the header row.
  /// e.g. 'German Word' for German CSVs, 'Target Word' for Spanish.
  final String wordColumnHeader;

  /// Unique key used as a cache key and as the vocabulary ID prefix.
  String get key => '${languageCode}_${cefrLevel.toLowerCase()}';

  @override
  String toString() => 'LanguageConfig($key)';
}

/// Master registry of all available language × CEFR combinations.
/// When a new CSV is added to assets/data/, add an entry here.
const List<LanguageConfig> kAvailableLanguageConfigs = [
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
    wordColumnHeader: 'Abgelenkt sein',  // de_c1 has no header row — first word
  ),
  LanguageConfig(
    languageCode: 'es',
    cefrLevel: 'B2',
    assetPath: 'assets/data/es_b2.csv',
    languageName: 'Spanish',
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
