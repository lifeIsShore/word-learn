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
class NotificationScheduler {
  NotificationScheduler._();
  static final NotificationScheduler instance = NotificationScheduler._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'wordlearn_study';
  static const _channelName = 'Study Reminders';

  static String _payload(String route) => json.encode({'route': route});

  // ── 1. Daily study reminder ───────────────────────────────────────────────

  Future<void> scheduleDailyReminder({
    TimeOfDay dailyTime = const TimeOfDay(hour: 9, minute: 0),
    int batchCount = 0,
  }) async {
    await _plugin.cancel(NotificationService.idDailyReminder);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = _nextInstanceOf(now, dailyTime.hour, dailyTime.minute);

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
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: _payload('/home'),
    );
  }

  // ── 2. Streak-at-risk warning ─────────────────────────────────────────────

  Future<void> scheduleStreakWarning({required TimeOfDay curfew}) async {
    await _plugin.cancel(NotificationService.idStreakWarning);

    final now = tz.TZDateTime.now(tz.local);

    var warningTime = _nextInstanceOf(
      now,
      curfew.hour,
      curfew.minute,
    ).subtract(const Duration(hours: 1));

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
        iOS: const DarwinNotificationDetails(
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: _payload('/session'),
    );
  }

  Future<void> cancelStreakWarning() =>
      _plugin.cancel(NotificationService.idStreakWarning);

  // ── 3. Drip nudge ─────────────────────────────────────────────────────────

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
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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
