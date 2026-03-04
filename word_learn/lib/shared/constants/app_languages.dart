/// Supported languages (PRD: en, de, fr, es, it, tr).
class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.name,
    required this.flagEmoji,
  });
  final String code;
  final String name;
  final String flagEmoji;
}

const List<AppLanguage> kAppLanguages = [
  AppLanguage(code: 'en', name: 'English', flagEmoji: '🇬🇧'),
  AppLanguage(code: 'de', name: 'German', flagEmoji: '🇩🇪'),
  AppLanguage(code: 'fr', name: 'French', flagEmoji: '🇫🇷'),
  AppLanguage(code: 'es', name: 'Spanish', flagEmoji: '🇪🇸'),
  AppLanguage(code: 'it', name: 'Italian', flagEmoji: '🇮🇹'),
  AppLanguage(code: 'tr', name: 'Turkish', flagEmoji: '🇹🇷'),
];

const List<String> kCefrLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

const String kDefaultCefr = 'B1';
