import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Session 17 — Local Notification Service.
///
/// Firebase Cloud Messaging (FCM) is stubbed out until google-services.json
/// is configured. This class handles LOCAL notifications only:
///   - Foreground banner display
///   - Android channel creation
///   - Notification tap routing
///
/// FCM (push from server) will be wired in when firebase packages are
/// uncommented in pubspec.yaml and devModeSkipFirebase = false.
///
/// Notification channel IDs:
///   wordlearn_general   — general marketing / updates
///   wordlearn_study     — study reminders, streak warnings, drip nudges
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _localNotifications = FlutterLocalNotificationsPlugin();

  // Channel constants
  static const _studyChannelId = 'wordlearn_study';
  static const _studyChannelName = 'Study Reminders';
  static const _studyChannelDesc =
      'Daily study reminders, streak warnings, and drip nudges.';

  static const _generalChannelId = 'wordlearn_general';
  static const _generalChannelName = 'General';
  static const _generalChannelDesc = 'General WordLearn notifications.';

  // Notification IDs (stable per notification type)
  static const int idDailyReminder = 1001;
  static const int idStreakWarning = 1002;
  static const int idDripNudge = 1003;

  void Function(String? payload)? _onTap;

  // ── init ──────────────────────────────────────────────────────────────────

  /// Must be called once during app startup.
  ///
  /// [onTap] receives the JSON payload string when a notification is tapped.
  Future<void> init({void Function(String? payload)? onTap}) async {
    _onTap = onTap;

    // Init local notifications plugin.
    await _initLocalNotifications();
  }

  // ── Local notifications init ──────────────────────────────────────────────

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: (response) {
        _onTap?.call(response.payload);
      },
    );

    // Create Android notification channels.
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _studyChannelId,
        _studyChannelName,
        description: _studyChannelDesc,
        importance: Importance.high,
        enableVibration: true,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _generalChannelId,
        _generalChannelName,
        description: _generalChannelDesc,
        importance: Importance.defaultImportance,
      ),
    );
  }

  // ── Show helpers (called by NotificationScheduler) ────────────────────────

  /// Show an immediate local notification.
  Future<void> showImmediate({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isStudy = true,
  }) async {
    final channelId = isStudy ? _studyChannelId : _generalChannelId;
    final channelName = isStudy ? _studyChannelName : _generalChannelName;

    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  /// Cancel a specific notification by ID.
  Future<void> cancel(int id) => _localNotifications.cancel(id);

  /// Cancel all pending and shown notifications.
  Future<void> cancelAll() => _localNotifications.cancelAll();
}

/// Stub — kept so files that import this compile.
/// Will be replaced with real FCM handler when firebase packages are enabled.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(dynamic message) async {
  debugPrint('[FCM Background] stub — Firebase not yet configured');
}
