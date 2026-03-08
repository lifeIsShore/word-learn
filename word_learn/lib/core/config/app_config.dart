/// ─────────────────────────────────────────────────────────────────────────────
///  WordLearn — App Configuration
///
///  DEV_MODE_SKIP_AUTH = true  → splash goes straight to Home/Onboarding.
///                               No login required. Tokens are mocked.
///
///  DEV_MODE_SKIP_AUTH = false → real auth flow. Set this before release.
/// ─────────────────────────────────────────────────────────────────────────────

class AppConfig {
  AppConfig._();

  // ── Toggle this to enable/disable auth during development ──────────────────
  static const bool devModeSkipAuth = true;

  // ── Toggle this once `flutterfire configure` has been run ──────────────────
  // Set to false after adding google-services.json (Android) and
  // GoogleService-Info.plist (iOS) to the project.
  static const bool devModeSkipFirebase = true;

  // ── Backend base URL ────────────────────────────────────────────────────────
  // Change to your VPS IP/domain before release.
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api/v1';
  //  ↑ 10.0.2.2 = Android emulator loopback to host machine
  //    For iOS simulator use: http://localhost:8000/api/v1
  //    For real device on same WiFi: http://192.168.x.x:8000/api/v1

  // ── Token storage keys ───────────────────────────────────────────────────
  static const String kAccessTokenKey  = 'auth.access_token';
  static const String kRefreshTokenKey = 'auth.refresh_token';
  static const String kUserIdKey       = 'auth.user_id';
  static const String kUserEmailKey    = 'auth.user_email';
  static const String kDisplayNameKey  = 'auth.display_name';
}
