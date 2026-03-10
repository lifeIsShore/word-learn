import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_screen.dart';
import '../../features/batch/batch_screen.dart';
import '../../features/ash/ash_protocol_screen.dart';
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
import '../../shared/state/auth_provider.dart';
import '../../shared/state/onboarding_provider.dart';

/// Route name constants — align with docs/BLUEPRINT.md.
class AppRoutes {
  static const String splash = '/';
  static const String auth = '/auth';
  static const String onboardingWelcome = '/onboarding/welcome';
  static const String onboardingBaseLanguage = '/onboarding/base-language';
  static const String onboardingTargetLanguages =
      '/onboarding/target-languages';
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

  static const _publicRoutes = {splash, auth};
  static const _onboardingRoutes = {
    onboardingWelcome,
    onboardingBaseLanguage,
    onboardingTargetLanguages,
    onboardingCefr,
    onboardingCurfew,
    onboardingDrip,
    onboardingPaywall,
  };

  static bool isPublic(String location) =>
      _publicRoutes.any((r) => location.startsWith(r));

  static bool isOnboarding(String location) =>
      _onboardingRoutes.any((r) => location.startsWith(r));
}

/// Creates the app router.
///
/// SESSION 24 FIX — Removed `refreshListenable: _ProviderListenable(ref)`.
///
/// The _ProviderListenable was calling notifyListeners() every time
/// AuthStatus changed. This caused a race condition on device:
///
///   1. SplashScreen._initApp() runs  (async, ~1-2s)
///   2. checkStartupAuth() completes — sets AuthStatus.authenticated
///   3. _ProviderListenable fires notifyListeners() immediately
///   4. GoRouter re-evaluates redirect: isAuthenticated=true, location=/
///      Redirect rule 4 fires: "authenticated + splash → allow null" ✓
///      BUT: redirect rule 4 also has the condition that splash returns null
///      only when location == AppRoutes.splash. If the timing is slightly off
///      and the location string already changed, it could redirect to /home
///      prematurely, while SplashScreen also calls context.go('/home') —
///      two navigation calls on the same frame → router stack corruption.
///
/// The redirect guard is still present for DEEP LINKS and programmatic
/// navigation (e.g. back-button press trying to reach /auth after login).
/// But it no longer auto-fires on provider changes, so SplashScreen is the
/// sole owner of the first navigation.
///
/// Auth changes after first boot (sign-in, sign-out) are handled by
/// direct context.go() calls from the auth screen and home screen.
GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    // NOTE: No refreshListenable — see doc comment above.
    redirect: (context, state) {
      final location = state.matchedLocation;
      final authState = ref.read(authProvider);
      final onboarding = ref.read(onboardingProvider);

      // 1. Still initialising (unknown) — always stay on splash.
      //    SplashScreen will navigate once init is done.
      if (authState.status == AuthStatus.unknown) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isAuthenticated = authState.isAuthenticated;
      final hasOnboarded = onboarding.isOnboardingComplete;
      final isPublic = AppRoutes.isPublic(location);
      final isOnboardingRoute = AppRoutes.isOnboarding(location);

      // 2. Not authenticated → send to auth (guard for deep links / back nav).
      if (!isAuthenticated && !isPublic) {
        return AppRoutes.auth;
      }

      // 3. Authenticated but not onboarded → send to onboarding.
      if (isAuthenticated && !hasOnboarded && !isOnboardingRoute && !isPublic) {
        return AppRoutes.onboardingWelcome;
      }

      // 4. Authenticated + onboarded → block going back to auth/onboarding.
      if (isAuthenticated && hasOnboarded && (isPublic || isOnboardingRoute)) {
        if (location == AppRoutes.splash) return null; // Let splash own init.
        return AppRoutes.home;
      }

      return null;
    },
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
        builder: (context, state) => const AshProtocolScreen(),
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
