import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_provider.g.dart';
part 'onboarding_provider.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default('en') String baseLanguage,
    @Default([]) List<String> targetLanguages,
    @Default({}) Map<String, String> cefrLevels, // lang code → CEFR level
    @Default(TimeOfDay_22_00) String dailyCurfewUtc,
    @Default(20) int dailyDripCount,
  }) = _OnboardingState;
}

// Represents 22:00 as default curfew
const String TimeOfDay_22_00 = '22:00';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingState build() => const OnboardingState();

  void setBaseLanguage(String code) {
    state = state.copyWith(baseLanguage: code);
  }

  void toggleTargetLanguage(String code) {
    final current = List<String>.from(state.targetLanguages);
    if (current.contains(code)) {
      current.remove(code);
      // Also remove its CEFR level
      final levels = Map<String, String>.from(state.cefrLevels)..remove(code);
      state = state.copyWith(targetLanguages: current, cefrLevels: levels);
    } else {
      current.add(code);
      // Default CEFR to A1
      final levels = Map<String, String>.from(state.cefrLevels)..[code] = 'A1';
      state = state.copyWith(targetLanguages: current, cefrLevels: levels);
    }
  }

  void setCefrLevel(String languageCode, String level) {
    final levels = Map<String, String>.from(state.cefrLevels)
      ..[languageCode] = level;
    state = state.copyWith(cefrLevels: levels);
  }

  void setCurfew(String time) {
    state = state.copyWith(dailyCurfewUtc: time);
  }

  void setDailyDrip(int count) {
    state = state.copyWith(dailyDripCount: count.clamp(5, 40));
  }
}
