import 'package:flutter/material.dart';

/// User-controlled app settings (distinct from onboarding choices).
/// In-memory for now; persisted to SQLite/shared_prefs in WL-500.
class SettingsState {
  const SettingsState({
    this.displayName = 'Scholar',
    this.themeMode = ThemeMode.light,
    this.shareLearningData = false,
    this.allowCrashReports = true,
  });

  /// Display name shown in greetings.
  final String displayName;

  /// Light / dark / system theme selection.
  final ThemeMode themeMode;

  /// Privacy: share anonymised learning data (Phase 2 — mnemonics).
  final bool shareLearningData;

  /// Privacy: allow anonymous crash/error telemetry.
  final bool allowCrashReports;

  SettingsState copyWith({
    String? displayName,
    ThemeMode? themeMode,
    bool? shareLearningData,
    bool? allowCrashReports,
  }) {
    return SettingsState(
      displayName: displayName ?? this.displayName,
      themeMode: themeMode ?? this.themeMode,
      shareLearningData: shareLearningData ?? this.shareLearningData,
      allowCrashReports: allowCrashReports ?? this.allowCrashReports,
    );
  }
}
