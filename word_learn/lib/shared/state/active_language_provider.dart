import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/language_config.dart';
import 'onboarding_provider.dart';

/// The currently-active study language configuration.
///
/// Derives its initial value from [onboardingProvider]:
///   - active language = first target language (or 'de' as fallback)
///   - active CEFR    = the level set for that language during onboarding
///
/// Users can switch language via [ActiveLanguageNotifier.switchTo].
/// The switch is session-scoped (in-memory); persistence comes with WL-500.
class ActiveLanguageNotifier extends Notifier<LanguageConfig?> {
  @override
  LanguageConfig? build() {
    // Derive initial active language from onboarding choices.
    final onboarding = ref.watch(onboardingProvider);

    final targetCodes = onboarding.targetLanguageCodes;
    if (targetCodes.isEmpty) return null;

    final langCode = targetCodes.first;
    final cefrLevel =
        onboarding.cefrPerTarget[langCode] ?? 'B2';

    return findLanguageConfig(
      languageCode: langCode,
      cefrLevel: cefrLevel,
    );
  }

  /// Switch the active language to [config].
  /// No-op if config is null.
  void switchTo(LanguageConfig config) {
    state = config;
  }

  /// Switch by language code + CEFR level.
  /// If the combination is not registered in [kAvailableLanguageConfigs],
  /// state remains unchanged and [false] is returned.
  bool switchToByKey({
    required String languageCode,
    required String cefrLevel,
  }) {
    final config = findLanguageConfig(
      languageCode: languageCode,
      cefrLevel: cefrLevel,
    );
    if (config == null) return false;
    state = config;
    return true;
  }

  /// Returns all [LanguageConfig]s that match the user's chosen target
  /// languages (from onboarding), filtered to what is actually available as
  /// an asset.
  List<LanguageConfig> availableForUser() {
    final onboarding = ref.read(onboardingProvider);
    final targetCodes = onboarding.targetLanguageCodes.toSet();

    return kAvailableLanguageConfigs
        .where((c) => targetCodes.contains(c.languageCode))
        .toList();
  }
}

final activeLanguageProvider =
    NotifierProvider<ActiveLanguageNotifier, LanguageConfig?>(
  ActiveLanguageNotifier.new,
);
