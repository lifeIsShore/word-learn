import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Session 17 — Push Notification Service.
///
/// Responsibilities:
///   1. Request notification permissions (iOS prompt, Android 13+ prompt).
///   2. Initialise flutter_local_notifications with the WordLearn channel.
///   3. Register FCM token and expose it for backend storage (when auth lands).
///   4. Handle incoming messages in all three states:
///        - Foreground  → show local notification banner
///        - Background  → handled by [firebaseMessagingBackgroundHandler]
///        - Terminated  → handled on app open via getInitialMessage()
///   5. Route notification taps to the correct app screen via [onNotificationTap].
///
/// Notification channel IDs:
///   wordlearn_general   — general marketing / updates
///   wordlearn_study     — study reminders, streak warnings, drip nudges
///
/// Usage:
///   await NotificationService.instance.init(onTap: (payload) { ... });
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _fcm = FirebaseMessaging.instance;
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

  /// Must be called once during app startup (after Firebase.initializeApp).
  ///
  /// [onTap] receives the JSON payload string when a notification is tapped.
  /// Parse it with `json.decode(payload)` to get a Map with a 'route' key.
  Future<void> init({void Function(String? payload)? onTap}) async {
    _onTap = onTap;

    // 1. Request permissions.
    await _requestPermissions();

    // 2. Init local notifications plugin.
    await _initLocalNotifications();

    // 3. Wire FCM listeners.
    _wireFcmListeners();

    // 4. Handle notification that launched the app from terminated state.
    await _handleTerminatedMessage();
  }

  // ── Permissions ───────────────────────────────────────────────────────────

  Future<void> _requestPermissions() async {
    // FCM permission (covers iOS + Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Android: request exact alarm permission for scheduled local notifications.
    // On Android < 13 this is granted automatically.
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.requestExactAlarmsPermission();
  }

  // ── Local notifications init ──────────────────────────────────────────────

  Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false, // We handle this via FCM requestPermission
      requestBadgePermission: false,
      requestSoundPermission: false,
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
            AndroidFlutterLocalNotificationsPlugin>();

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

  // ── FCM listeners ─────────────────────────────────────────────────────────

  void _wireFcmListeners() {
    // Foreground message → show local notification banner.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalFromFcm(message);
    });

    // User tapped a notification while app was in background (not terminated).
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final payload = json.encode(message.data);
      _onTap?.call(payload);
    });
  }

  Future<void> _handleTerminatedMessage() async {
    final message = await _fcm.getInitialMessage();
    if (message != null) {
      // Slight delay so the app has finished building before navigating.
      await Future<void>.delayed(const Duration(milliseconds: 500));
      final payload = json.encode(message.data);
      _onTap?.call(payload);
    }
  }

  void _showLocalFromFcm(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      _studyChannelId,
      _studyChannelName,
      channelDescription: _studyChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      ),
      payload: json.encode(message.data),
    );
  }

  // ── Show helpers (called by NotificationScheduler) ────────────────────────

  /// Show an immediate local notification. Used for testing and streak warnings
  /// that fire programmatically rather than on a schedule.
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

  // ── FCM token ─────────────────────────────────────────────────────────────

  /// Returns the FCM registration token. May return null if permissions denied
  /// or on simulator without APNs.
  Future<String?> getToken() => _fcm.getToken();

  /// Stream that fires whenever the FCM token is refreshed.
  Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;
}

// ── Background message handler ─────────────────────────────────────────────
// MUST be a top-level function — FCM requirement.
// Registered in main.dart via FirebaseMessaging.onBackgroundMessage().
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialised in this isolate by the plugin.
  // We don't show a local notification here because FCM data-only messages
  // can be handled silently; notification messages are shown by the OS.
  debugPrint('[FCM Background] ${message.messageId}: ${message.data}');
}
