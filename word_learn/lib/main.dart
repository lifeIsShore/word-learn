import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'core/config/app_config.dart';
import 'firebase_options.dart';
import 'shared/notifications/notification_service.dart';

/// Session 17: Firebase must be initialised before runApp.
/// The background handler must be registered before runApp too.
///
/// [AppConfig.devModeSkipFirebase] guards Firebase init so the app can
/// still run in dev mode before google-services.json / GoogleService-Info.plist
/// are configured. Set it to false once `flutterfire configure` has been run.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise timezone database (required by flutter_local_notifications
  // for zonedSchedule calls).
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.local);

  if (!AppConfig.devModeSkipFirebase) {
    // Initialise Firebase.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Register background message handler BEFORE runApp.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  runApp(
    const ProviderScope(
      child: WordLearnApp(),
    ),
  );
}
