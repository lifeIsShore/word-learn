import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '../../shared/state/auth_provider.dart';
import '../../shared/state/onboarding_provider.dart';

/// Route name constants — align with docs/BLUEPRINT.md.
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

  // ── Route groups used by the redirect guard ──────────────────────────────

  /// Routes that are always accessible — no auth or onboarding required.
  static const _publicRoutes = {splash, auth};

  /// Onboarding routes — accessible only when authenticated but not onboarded.
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

/// Creates the app router with Riverpod-aware redirect guards.
///
/// Guard logic (evaluated on every navigation):
///
///   1. AuthStatus.unknown   → still initialising, stay on splash.
///   2. Unauthenticated      → redirect to /auth unless already on a public route.
///   3. Authenticated + not onboarded → redirect to /onboarding/welcome
///      unless already in an onboarding route.
///   4. Authenticated + onboarded + trying to reach /auth or onboarding
///      → redirect to /home (user is already set up).
///   5. Otherwise            → allow navigation as requested.
GoRouter createAppRouter(WidgetRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    // Refresh the router whenever auth or onboarding state changes.
    refreshListenable: _ProviderListenable(ref),
    redirect: (context, state) {
      final location = state.matchedLocation;

      final authState = ref.read(authProvider);
      final onboarding = ref.read(onboardingProvider);

      // 1. Still initialising — stay on splash.
      if (authState.status == AuthStatus.unknown) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isAuthenticated = authState.isAuthenticated;
      final hasOnboarded = onboarding.isOnboardingComplete;
      final isPublic = AppRoutes.isPublic(location);
      final isOnboardingRoute = AppRoutes.isOnboarding(location);

      // 2. Not authenticated → send to auth (unless already on a public route).
      if (!isAuthenticated && !isPublic) {
        return AppRoutes.auth;
      }

      // 3. Authenticated but onboarding not complete → send to onboarding.
      if (isAuthenticated && !hasOnboarded && !isOnboardingRoute && !isPublic) {
        return AppRoutes.onboardingWelcome;
      }

      // 4. Authenticated + onboarded → don't allow going back to auth/onboarding.
      if (isAuthenticated && hasOnboarded && (isPublic || isOnboardingRoute)) {
        // Allow splash to run its own init logic.
        if (location == AppRoutes.splash) return null;
        return AppRoutes.home;
      }

      // 5. All good — allow.
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

// ── Listenable bridge ─────────────────────────────────────────────────────────
// GoRouter's refreshListenable needs a ChangeNotifier.
// This bridges Riverpod providers into that interface so the router
// re-evaluates its redirect whenever auth or onboarding state changes.

class _ProviderListenable extends ChangeNotifier {
  _ProviderListenable(WidgetRef ref) {
    ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
    ref.listen<OnboardingState>(onboardingProvider, (_, __) => notifyListeners());
  }
}
