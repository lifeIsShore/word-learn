import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/curfew_service.dart';
import '../services/local_storage_service.dart';
import 'streak_state.dart';

final streakProvider =
    NotifierProvider<StreakNotifier, StreakState>(StreakNotifier.new);

class StreakNotifier extends Notifier<StreakState> {
  final _storage = LocalStorageService.instance;

  @override
  StreakState build() => const StreakState();

  // ── Initialisation (called from SplashScreen) ─────────────────────────────

  /// Load persisted streak from SQLite. Must be called once on startup.
  Future<void> init() async {
    final row = await _storage.loadStreak();
    if (row.isEmpty) return; // first launch — defaults are fine

    state = StreakState(
      currentStreak: row['current_streak'] as int? ?? 0,
      longestStreak: row['longest_streak'] as int? ?? 0,
      sessionCompletedToday: (row['session_completed_today'] as int? ?? 0) == 1,
      lastSessionDate: row['last_session_date'] != null
          ? DateTime.tryParse(row['last_session_date'] as String)
          : null,
      ashPending: (row['ash_pending'] as int? ?? 0) == 1,
    );
  }

  // ── Business logic ────────────────────────────────────────────────────────

  /// Called on app startup / resume — checks whether yesterday's curfew was
  /// missed and sets ashPending if so (WL-220: Ash Protocol).
  Future<void> checkAshOnStartup({
    required DateTime now,
    required TimeOfDay curfew,
  }) async {
    final shouldAsh = CurfewService.shouldTriggerAsh(
      now: now,
      lastSessionDate: state.lastSessionDate,
      currentStreak: state.currentStreak,
    );

    if (shouldAsh) {
      state = state.copyWith(
        currentStreak: 0,
        ashPending: true,
      );
      await _persist();
    }
  }

  /// Called when the user completes a session (from SessionNotifier). WL-200.
  Future<void> recordSessionComplete(DateTime now) async {
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = state.lastSessionDate != null
        ? DateTime(
            state.lastSessionDate!.year,
            state.lastSessionDate!.month,
            state.lastSessionDate!.day,
          )
        : null;

    // Don't double-count a second session on the same day.
    if (lastDay != null && lastDay == today) {
      state = state.copyWith(sessionCompletedToday: true);
      await _persist();
      return;
    }

    // Check if this continues a streak (session yesterday or first ever).
    final isConsecutive = lastDay == null ||
        lastDay == today.subtract(const Duration(days: 1));

    final newStreak = isConsecutive ? state.currentStreak + 1 : 1;
    final newLongest =
        newStreak > state.longestStreak ? newStreak : state.longestStreak;

    state = state.copyWith(
      currentStreak: newStreak,
      longestStreak: newLongest,
      sessionCompletedToday: true,
      lastSessionDate: now,
    );
    await _persist();
  }

  /// Dismiss the Ash modal — clears the pending flag. WL-220.
  Future<void> acknowledgeAsh() async {
    state = state.copyWith(ashPending: false, sessionCompletedToday: false);
    await _persist();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  Future<void> _persist() async {
    await _storage.saveStreak(
      currentStreak: state.currentStreak,
      longestStreak: state.longestStreak,
      sessionCompletedToday: state.sessionCompletedToday,
      lastSessionDate: state.lastSessionDate,
      ashPending: state.ashPending,
    );
  }
}
