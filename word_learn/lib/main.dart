import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';

/// WordLearn app entry point.
///
/// Session 17 note: Firebase (firebase_core, firebase_messaging) is commented
/// out in pubspec.yaml until google-services.json is configured via
/// `flutterfire configure`. Set AppConfig.devModeSkipFirebase = false and
/// uncomment those packages when you're ready to enable push notifications.
///
/// Local notifications (flutter_local_notifications + timezone) are still
/// initialised here — they work without Firebase for scheduled reminders.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise timezone database (required by flutter_local_notifications
  // for zonedSchedule calls).
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.local);

  runApp(
    const ProviderScope(
      child: WordLearnApp(),
    ),
  );
}
