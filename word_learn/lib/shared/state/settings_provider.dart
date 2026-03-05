import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/local_storage_service.dart';
import 'settings_state.dart';

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<SettingsState> {
  final _storage = LocalStorageService.instance;

  @override
  SettingsState build() => const SettingsState();

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Load persisted settings from SQLite. Called once on startup.
  Future<void> init() async {
    final data = await _storage.loadUserSettings();
    state = SettingsState(
      displayName: data['displayName'] as String,
      themeMode: _themeModeFromInt(data['themeMode'] as int),
      shareLearningData: data['shareLearningData'] as bool,
      allowCrashReports: data['allowCrashReports'] as bool,
    );
  }

  // ── Mutations (each persists immediately) ──────────────────────────────────

  Future<void> setDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = state.copyWith(displayName: trimmed);
    await _persist();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _persist();
  }

  Future<void> setShareLearningData(bool value) async {
    state = state.copyWith(shareLearningData: value);
    await _persist();
  }

  Future<void> setAllowCrashReports(bool value) async {
    state = state.copyWith(allowCrashReports: value);
    await _persist();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _persist() async {
    await _storage.saveUserSettings(
      displayName: state.displayName,
      themeMode: _themeModeToInt(state.themeMode),
      shareLearningData: state.shareLearningData,
      allowCrashReports: state.allowCrashReports,
    );
  }

  int _themeModeToInt(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 0;
      case ThemeMode.dark:
        return 1;
      case ThemeMode.system:
        return 2;
    }
  }

  ThemeMode _themeModeFromInt(int i) {
    switch (i) {
      case 1:
        return ThemeMode.dark;
      case 2:
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
