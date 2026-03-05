import 'package:go_router/go_router.dart';

import '../../features/auth/auth_screen.dart';
import '../../features/batch/batch_screen.dart';
import '../../features/curfew/ash_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/base_language_screen.dart';
import '../../features/session/session_complete_screen.dart';
import '../../features/session/session_screen.dart';
import '../../features/onboarding/cefr_screen.dart';
import '../../features/onboarding/curfew_screen.dart';
import '../../features/onboarding/drip_screen.dart';
import '../../features/onboarding/paywall_screen.dart';
import '../../features/onboarding/target_languages_screen.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/vault/audit_complete_screen.dart';
import '../../features/vault/audit_session_screen.dart';
import '../../features/vault/vault_screen.dart';

/// Route names — align with docs/BLUEPRINT.md.
class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String onboardingWelcome = '/onboarding/welcome';
  static const String onboardingBaseLanguage = '/onboarding/base-language';
  static const String onboardingTargetLanguages = '/onboarding/target-languages';
  static const String onboardingCefr = '/onboarding/cefr';
  static const String onboardingCurfew = '/onboarding/curfew';
  static const String onboardingDrip = '/onboarding/drip';
  static const String onboardingPaywall = '/onboarding/paywall';
  static const String home = '/home';
  static const String batch = '/batch';
  static const String vault = '/vault';
  static const String session = '/session';
  static const String sessionComplete = '/session/complete';
  static const String settings = '/settings';
  static const String ash = '/ash';
  static const String auditSession = '/vault/audit';
  static const String auditComplete = '/vault/audit/complete';
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingWelcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingBaseLanguage,
        builder: (context, state) => const BaseLanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingTargetLanguages,
        builder: (context, state) => const TargetLanguagesScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingCefr,
        builder: (context, state) => const CefrScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingCurfew,
        builder: (context, state) => const CurfewScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingDrip,
        builder: (context, state) => const DripScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboardingPaywall,
        builder: (context, state) => const PaywallScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.batch,
        builder: (context, state) => const BatchScreen(),
      ),
      GoRoute(
        path: AppRoutes.vault,
        builder: (context, state) => const VaultScreen(),
      ),
      GoRoute(
        path: AppRoutes.session,
        builder: (context, state) => const SessionScreen(),
      ),
      GoRoute(
        path: AppRoutes.sessionComplete,
        builder: (context, state) => const SessionCompleteScreen(),
      ),
      GoRoute(
        path: AppRoutes.ash,
        builder: (context, state) => const AshScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.auditSession,
        builder: (context, state) => const AuditSessionScreen(),
      ),
      GoRoute(
        path: AppRoutes.auditComplete,
        builder: (context, state) => const AuditCompleteScreen(),
      ),
    ],
  );
}
