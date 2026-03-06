/// Supabase configuration
/// Replace with your actual project values before running
/// Store secrets in .env — never commit real keys to git
abstract class SupabaseConfig {
  /// TODO: Replace with your Supabase project URL
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';

  /// TODO: Replace with your Supabase anon key
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}

/// App-wide constants
abstract class AppConstants {
  // Active Batch
  static const int maxBatchSize = 200;
  static const int freeTierBatchSize = 50;
  static const int defaultDailyDrip = 20;
  static const int minDailyDrip = 5;
  static const int maxDailyDrip = 40;

  // Subscription
  static const double priceMonthly = 9.99;
  static const double priceSixMonth = 49.99;
  static const int freeLanguageLimit = 1;
  static const int paidLanguageLimit = 6;

  // Curfew & Streak
  static const int curfewWarningMinutes = 60;
  static const int pardonCooldownDays = 180;

  // Vault entry criteria
  static const int vaultMinEasyCount = 2;
  static const int vaultMinDaysSinceReview = 7;
  static const double vaultMinEaseFactor = 2.0;

  // SRS SM-2
  static const double srsInitialEaseFactor = 2.5;
  static const double srsMinEaseFactor = 1.3;
  static const double srsMaxEaseFactor = 3.0;
  static const int srsInitialInterval = 1;

  // Sync
  static const Duration syncInterval = Duration(hours: 6);

  // Storage keys (flutter_secure_storage)
  static const String keyAccessToken = 'wl_access_token';
  static const String keyRefreshToken = 'wl_refresh_token';
  static const String keyDbEncryptionKey = 'wl_db_key';
  static const String keyOnboardingComplete = 'wl_onboarding_done';
  static const String keyOfflineSessionSignature = 'wl_offline_sig';
}
