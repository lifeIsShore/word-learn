import Flutter
import UIKit
import UserNotifications

// Session 17: AppDelegate registers for APNs remote notifications.
// FirebaseMessaging is wired automatically via the firebase_messaging plugin
// once GoogleService-Info.plist is present. Until then (devModeSkipFirebase=true)
// the app runs without Firebase and only local notifications work.
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Request APNs authorisation — the Firebase plugin handles the delegate
    // callbacks (didRegisterForRemoteNotificationsWithDeviceToken etc.)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
