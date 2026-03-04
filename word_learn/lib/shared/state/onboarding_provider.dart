import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'onboarding_state.dart';

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(OnboardingNotifier.new);

class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void setBaseLanguage(String code) {
    state = state.copyWith(baseLanguageCode: code);
  }

  void setTargetLanguages(List<String> codes) {
    state = state.copyWith(targetLanguageCodes: List.from(codes));
  }

  void setCefrForTarget(String targetCode, String cefr) {
    final next = Map<String, String>.from(state.cefrPerTarget)..[targetCode] = cefr;
    state = state.copyWith(cefrPerTarget: next);
  }

  void setCurfew(TimeOfDay time) {
    state = state.copyWith(curfew: time);
  }

  void setDailyDrip(int count) {
    state = state.copyWith(dailyDripCount: count);
  }
}
