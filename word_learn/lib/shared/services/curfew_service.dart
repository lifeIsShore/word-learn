import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/onboarding_provider.dart';

/// Pure curfew logic — no Flutter dependencies, fully testable.
class CurfewService {
  const CurfewService._();

  // ── State queries ─────────────────────────────────────────────────────────

  /// True if within 60 minutes of curfew AND session not yet done today.
  static bool isIceActive({
    required DateTime now,
    required TimeOfDay curfew,
    required bool sessionCompletedToday,
  }) {
    if (sessionCompletedToday) return false;
    final todayCurfew = _todayCurfew(now, curfew);
    final iceStart = todayCurfew.subtract(const Duration(hours: 1));
    return now.isAfter(iceStart) && now.isBefore(todayCurfew);
  }

  /// True if now is past today's curfew time AND session not done.
  static bool isPastCurfew({
    required DateTime now,
    required TimeOfDay curfew,
    required bool sessionCompletedToday,
  }) {
    if (sessionCompletedToday) return false;
    return now.isAfter(_todayCurfew(now, curfew));
  }

  /// Minutes remaining until curfew (negative if past).
  static int minutesUntilCurfew({
    required DateTime now,
    required TimeOfDay curfew,
  }) {
    return _todayCurfew(now, curfew).difference(now).inMinutes;
  }

  /// True if yesterday's curfew was missed — Ash fires on today's app open.
  static bool shouldTriggerAsh({
    required DateTime now,
    required DateTime? lastSessionDate,
    required int currentStreak,
  }) {
    if (currentStreak == 0) return false;
    if (lastSessionDate == null) return false;
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(
      lastSessionDate.year,
      lastSessionDate.month,
      lastSessionDate.day,
    );
    return lastDay.isBefore(today.subtract(const Duration(days: 1)));
  }

  // ── Formatting ────────────────────────────────────────────────────────────

  static String formatTimeOfDay(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String countdownLabel(int minutesRemaining) {
    if (minutesRemaining <= 0) return 'Curfew passed.';
    if (minutesRemaining < 60) return '${minutesRemaining}m until Curfew.';
    final h = minutesRemaining ~/ 60;
    final m = minutesRemaining % 60;
    return m > 0 ? '${h}h ${m}m until Curfew.' : '${h}h until Curfew.';
  }

  // ── Private ───────────────────────────────────────────────────────────────

  static DateTime _todayCurfew(DateTime now, TimeOfDay curfew) =>
      DateTime(now.year, now.month, now.day, curfew.hour, curfew.minute);
}

/// Provider that exposes the curfew TimeOfDay from onboarding state.
final curfewTimeProvider = Provider<TimeOfDay>((ref) {
  return ref.watch(onboardingProvider).curfew;
});
