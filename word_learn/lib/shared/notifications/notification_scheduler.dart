import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';

/// Session 17 — WordLearn-specific notification scheduling.
///
/// Three notification types:
///
///   1. DAILY STUDY REMINDER
///      Fires every day at [dailyReminderTime] (default 09:00).
///      "Time to study! Your batch has N words waiting."
///      Suppressed if [sessionCompletedToday] == true at fire time
///      (handled by checking state on app resume — we cancel and reschedule).
///
///   2. STREAK-AT-RISK WARNING
///      Fires 60 minutes before curfew if no session completed today.
///      "Your streak is at risk! Complete today's session before [curfew]."
///      Cancelled when session is completed.
///
///   3. DRIP NUDGE
///      Fires 3 days after last drip injection if batch count < 20.
///      "Your batch is getting thin — tap to add new words."
///
/// All times use the device's local timezone via the `timezone` package.
///
/// Scheduling is idempotent: calling schedule* methods cancels the existing
/// notification for that type before creating a new one.
class NotificationScheduler {
  NotificationScheduler._();
  static final NotificationScheduler instance = NotificationScheduler._();

  final _plugin = FlutterLocalNotificationsPlugin();

  // ── Notification channel (reuse from NotificationService) ────────────────
  static const _channelId = 'wordlearn_study';
  static const _channelName = 'Study Reminders';

  // ── Route payloads ────────────────────────────────────────────────────────
  static String _payload(String route) => json.encode({'route': route});

  // ── 1. Daily study reminder ───────────────────────────────────────────────

  /// Schedule (or reschedule) the daily study reminder.
  ///
  /// [dailyTime] — time of day to fire (default 09:00).
  /// [batchCount] — shown in the notification body.
  ///
  /// Call this:
  ///   • On app startup (splash screen).
  ///   • When the user changes curfew / drip settings.
  Future<void> scheduleDailyReminder({
    TimeOfDay dailyTime = const TimeOfDay(hour: 9, minute: 0),
    int batchCount = 0,
  }) async {
    await _plugin.cancel(NotificationService.idDailyReminder);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = _nextInstanceOf(now, dailyTime.hour, dailyTime.minute);

    // If the time has already passed today, schedule for tomorrow.
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    final body = batchCount > 0
        ? 'You have $batchCount words waiting for review.'
        : 'Time to keep your streak alive.';

    await _plugin.zonedSchedule(
      NotificationService.idDailyReminder,
      '📖 Time to study!',
      body,
      scheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: const BigTextStyleInformation(''),
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // repeat daily
      payload: _payload('/home'),
    );
  }

  // ── 2. Streak-at-risk warning ─────────────────────────────────────────────

  /// Schedule a streak-at-risk warning 60 minutes before [curfew].
  ///
  /// Call this:
  ///   • On app startup if session NOT completed today.
  ///   • When curfew time is changed.
  ///
  /// Cancel this (via [cancelStreakWarning]) when session IS completed.
  Future<void> scheduleStreakWarning({
    required TimeOfDay curfew,
  }) async {
    await _plugin.cancel(NotificationService.idStreakWarning);

    final now = tz.TZDateTime.now(tz.local);

    // Fire 60 min before curfew.
    final warningHour = curfew.hour;
    final warningMinute = curfew.minute;
    var warningTime = _nextInstanceOf(now, warningHour, warningMinute)
        .subtract(const Duration(hours: 1));

    // If already past this time today, skip — no point showing a warning
    // after the curfew has passed for today.
    if (warningTime.isBefore(now)) return;

    final curfewLabel =
        '${curfew.hour.toString().padLeft(2, '0')}:${curfew.minute.toString().padLeft(2, '0')}';

    await _plugin.zonedSchedule(
      NotificationService.idStreakWarning,
      '⚠️ Streak at risk!',
      'Complete today\'s session before $curfewLabel to keep your streak.',
      warningTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: const BigTextStyleInformation(''),
        ),
        iOS: const DarwinNotificationDetails(interruptionLevel: InterruptionLevel.timeSensitive),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: _payload('/session'),
    );
  }

  Future<void> cancelStreakWarning() =>
      _plugin.cancel(NotificationService.idStreakWarning);

  // ── 3. Drip nudge ─────────────────────────────────────────────────────────

  /// Schedule a one-off drip nudge [daysFromNow] days from now at 10:00.
  ///
  /// Call this after a drip injection if batchCount < threshold.
  /// Pass daysFromNow = 3 for the default "batch getting thin" nudge.
  Future<void> scheduleDripNudge({int daysFromNow = 3}) async {
    await _plugin.cancel(NotificationService.idDripNudge);

    final now = tz.TZDateTime.now(tz.local);
    final scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + daysFromNow,
      10,
      0,
    );

    await _plugin.zonedSchedule(
      NotificationService.idDripNudge,
      '💧 Your batch is getting thin',
      'Tap to add new words and keep the momentum going.',
      scheduled,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: _payload('/home'),
    );
  }

  // ── Cancel all ────────────────────────────────────────────────────────────

  Future<void> cancelAll() => _plugin.cancelAll();

  // ── Helper ────────────────────────────────────────────────────────────────

  tz.TZDateTime _nextInstanceOf(tz.TZDateTime from, int hour, int minute) {
    var scheduled = tz.TZDateTime(
      tz.local,
      from.year,
      from.month,
      from.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(from)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
