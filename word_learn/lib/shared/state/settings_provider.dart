import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_state.dart';

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void setDisplayName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(displayName: trimmed);
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void setShareLearningData(bool value) {
    state = state.copyWith(shareLearningData: value);
  }

  void setAllowCrashReports(bool value) {
    state = state.copyWith(allowCrashReports: value);
  }
}
