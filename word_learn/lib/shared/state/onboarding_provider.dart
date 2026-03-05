import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/local_storage_service.dart';
import 'onboarding_state.dart';

final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(OnboardingNotifier.new);

class OnboardingNotifier extends Notifier<OnboardingState> {
  final _storage = LocalStorageService.instance;

  @override
  OnboardingState build() => const OnboardingState();

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Load persisted onboarding choices from SQLite. Called once on startup.
  /// Returns true if the user has completed onboarding before.
  Future<bool> init() async {
    final data = await _storage.loadOnboarding();
    if (data == null) return false; // first launch

    state = OnboardingState(
      baseLanguageCode: data['baseLanguageCode'] as String,
      targetLanguageCodes:
          List<String>.from(data['targetLanguageCodes'] as List),
      cefrPerTarget: Map<String, String>.from(
          data['cefrPerTarget'] as Map<dynamic, dynamic>),
      curfew: TimeOfDay(
        hour: data['curfewHour'] as int,
        minute: data['curfewMinute'] as int,
      ),
      dailyDripCount: data['dailyDripCount'] as int,
    );
    return true;
  }

  // ── Mutations ─────────────────────────────────────────────────────────────

  void setBaseLanguage(String code) {
    state = state.copyWith(baseLanguageCode: code);
  }

  void setTargetLanguages(List<String> codes) {
    state = state.copyWith(targetLanguageCodes: List.from(codes));
  }

  void setCefrForTarget(String targetCode, String cefr) {
    final next = Map<String, String>.from(state.cefrPerTarget)
      ..[targetCode] = cefr;
    state = state.copyWith(cefrPerTarget: next);
  }

  void setCurfew(TimeOfDay time) {
    state = state.copyWith(curfew: time);
    _persist(); // fire-and-forget — curfew change takes effect immediately
  }

  void setDailyDrip(int count) {
    state = state.copyWith(dailyDripCount: count);
    _persist();
  }

  /// Called at the end of onboarding flow to persist all choices at once.
  Future<void> completeOnboarding() async {
    await _persist();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _persist() async {
    await _storage.saveOnboarding(
      baseLanguageCode: state.baseLanguageCode,
      targetLanguageCodes: state.targetLanguageCodes,
      cefrPerTarget: state.cefrPerTarget,
      curfew: state.curfew,
      dailyDripCount: state.dailyDripCount,
    );
  }
}
