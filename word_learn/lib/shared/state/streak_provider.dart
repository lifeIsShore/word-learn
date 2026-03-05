import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/curfew_service.dart';
import 'streak_state.dart';

final streakProvider =
    NotifierProvider<StreakNotifier, StreakState>(StreakNotifier.new);

class StreakNotifier extends Notifier<StreakState> {
  @override
  StreakState build() => const StreakState();

  /// Called on app startup / resume — checks whether yesterday's curfew was
  /// missed and sets ashPending if so (WL-220: Ash Protocol).
  void checkAshOnStartup({
    required DateTime now,
    required TimeOfDay curfew,
  }) {
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
    }
  }

  /// Called when the user completes a session (from SessionNotifier). WL-200.
  void recordSessionComplete(DateTime now) {
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
  }

  /// Dismiss the Ash modal — clears the pending flag. WL-220.
  void acknowledgeAsh() {
    state = state.copyWith(ashPending: false, sessionCompletedToday: false);
  }
}
