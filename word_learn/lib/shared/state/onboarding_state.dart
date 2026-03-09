import 'package:flutter/material.dart';

/// Onboarding choices — base language, target languages, CEFR per language, curfew, drip.
/// Used by onboarding flow; later can be persisted to backend after auth.
class OnboardingState {
  const OnboardingState({
    this.baseLanguageCode = 'en',
    this.targetLanguageCodes = const [],
    this.cefrPerTarget = const {},
    this.curfew = const TimeOfDay(hour: 22, minute: 0),
    this.dailyDripCount = 20,
    bool onboardingComplete = false,
  }) : _onboardingComplete = onboardingComplete;

  final String baseLanguageCode;
  final List<String> targetLanguageCodes;
  final Map<String, String> cefrPerTarget; // targetCode -> A1..C2
  final TimeOfDay curfew;
  final int dailyDripCount;
  final bool _onboardingComplete;

  /// True once the user has completed the full onboarding flow.
  bool get isOnboardingComplete => _onboardingComplete;

  OnboardingState copyWith({
    String? baseLanguageCode,
    List<String>? targetLanguageCodes,
    Map<String, String>? cefrPerTarget,
    TimeOfDay? curfew,
    int? dailyDripCount,
    bool? onboardingComplete,
  }) {
    return OnboardingState(
      baseLanguageCode: baseLanguageCode ?? this.baseLanguageCode,
      targetLanguageCodes: targetLanguageCodes ?? this.targetLanguageCodes,
      cefrPerTarget: cefrPerTarget ?? this.cefrPerTarget,
      curfew: curfew ?? this.curfew,
      dailyDripCount: dailyDripCount ?? this.dailyDripCount,
      onboardingComplete: onboardingComplete ?? _onboardingComplete,
    );
  }
}
