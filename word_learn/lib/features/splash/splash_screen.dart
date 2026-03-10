import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/data/vocabulary_repository.dart';
import '../../shared/models/language_config.dart';
import '../../shared/services/database_service.dart';
import '../../shared/state/active_batch_provider.dart';
import '../../shared/state/auth_provider.dart';
import '../../shared/state/onboarding_provider.dart';
import '../../shared/state/settings_provider.dart';
import '../../shared/state/streak_provider.dart';
import '../../shared/state/audit_provider.dart';
import '../../shared/state/vault_provider.dart';
import '../../shared/notifications/notification_service.dart';
import '../../shared/notifications/notification_scheduler.dart';

/// Initial screen — logo/title, warms vocabulary cache, initialises DB, then redirects.
///
/// SESSION 24 — Complete rewrite of init sequence to fix device hang.
///
/// ROOT CAUSES OF HANG (diagnosed):
///
/// 1. kAvailableLanguageConfigs now has 25 entries. Splash was iterating all
///    of them SEQUENTIALLY with await warmUp + await init per language.
///    That's 50 sequential SQLite/file operations before navigation — 15-30s
///    on a real device.
///    FIX: Only warm and init the USER'S CHOSEN language(s), not every single
///    registered config. Non-chosen languages are lazy-loaded on demand.
///
/// 2. GoRouter _ProviderListenable fires notifyListeners() as soon as
///    checkStartupAuth() flips AuthStatus from unknown → authenticated.
///    The router redirect sees isAuthenticated=true + location=/splash and
///    redirects to /home BEFORE context.go() runs in the splash callback.
///    This creates a race where two navigation calls fight each other.
///    FIX: Set a _navigationComplete flag in SplashScreen. The router redirect
///    now ignores splash while _splashNavigationPending is true, letting
///    SplashScreen own navigation exactly once.
///    SIMPLER FIX APPLIED: Remove refreshListenable from the router entirely.
///    The router only needs to guard navigation; the splash screen drives the
///    actual first route. Auth changes after first boot use direct context.go()
///    calls already.
///
/// 3. FlutterSecureStorage on Android can hang on first access if the
///    Keystore is initialising.
///    FIX: Wrap loadStoredUser() in a timeout — if it takes more than 3s,
///    treat as devBypass/no-session so the app always navigates.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    try {
      debugPrint('[WordLearn] Splash: Starting init...');

      // Minimum display time runs in parallel with DB init.
      // Vocab cache warm-up is now EXCLUDED from this blocking wait.
      await Future.wait([
        Future<void>.delayed(const Duration(milliseconds: 1500)),
        _initEssentials(),
      ]);

      if (!mounted) return;

      debugPrint('[WordLearn] Splash: Checking auth...');
      final authStartup = await ref
          .read(authProvider.notifier)
          .checkStartupAuth()
          .timeout(
            const Duration(seconds: 4),
            onTimeout: () {
              // If secure storage hangs (known Android Keystore issue),
              // fall through as devBypass — never leave user stuck on splash.
              debugPrint('[WordLearn] Splash: Auth check timed out — using devBypass');
              return AuthStartupResult.devBypass;
            },
          );

      if (!mounted) return;

      final hasOnboarded = ref.read(onboardingProvider).isOnboardingComplete;

      debugPrint('[WordLearn] Splash: Navigating (auth=$authStartup, onboarded=$hasOnboarded)');

      switch (authStartup) {
        case AuthStartupResult.noSession:
          context.go(AppRoutes.auth);
        case AuthStartupResult.devBypass:
        case AuthStartupResult.sessionRestored:
          context.go(
            hasOnboarded ? AppRoutes.home : AppRoutes.onboardingWelcome,
          );
      }

      // After navigation, warm the remaining languages in the background.
      // Non-blocking — user sees Home immediately, vocab loads behind the scenes.
      _warmRemainingLanguagesInBackground();

      // Fire-and-forget notifications — must be after context.go().
      _initNotificationsFireAndForget();
    } catch (e, stack) {
      debugPrint('[WordLearn] Splash FATAL: $e\n$stack');
      if (!mounted) return;
      context.go(AppRoutes.home);
    }
  }

  /// Phase 1 — ESSENTIAL init only (must complete before navigation).
  ///
  /// Only includes:
  ///   - SQLite open
  ///   - Provider state restore (settings, streak, vault, audit, onboarding)
  ///   - Warm ONLY the user's currently active language (fast path)
  ///
  /// Everything else is deferred to background after navigation.
  Future<void> _initEssentials() async {
    // 1. Open SQLite database.
    debugPrint('[WordLearn] Splash: Opening database...');
    await DatabaseService.instance.database;

    // 2. Restore all persisted state (these are cheap key-value reads).
    await ref.read(onboardingProvider.notifier).init();
    await ref.read(settingsProvider.notifier).init();
    await ref.read(streakProvider.notifier).init();
    await ref.read(vaultProvider.notifier).init();
    await ref.read(auditProvider.notifier).init();
    debugPrint('[WordLearn] Splash: Providers restored.');

    // 3. Find the user's active language — warm ONLY that one before navigation.
    //    This is fast: 1 file read + 1 SQLite query.
    final onboarding = ref.read(onboardingProvider);
    final targets = onboarding.targetLanguageCodes;

    if (targets.isNotEmpty) {
      final firstCode = targets.first;
      final firstCefr = onboarding.cefrPerTarget[firstCode] ?? 'B1';
      final activeConfig = kAvailableLanguageConfigs
          .cast<LanguageConfig?>()
          .firstWhere(
            (c) => c?.languageCode == firstCode &&
                c?.cefrLevel == firstCefr.toUpperCase(),
            orElse: () => null,
          );

      if (activeConfig != null) {
        debugPrint('[WordLearn] Splash: Warming active language ${activeConfig.key}...');
        await VocabularyRepository.warmUp(activeConfig);
        await ref.read(languageBatchProvider(activeConfig).notifier).init();
        debugPrint('[WordLearn] Splash: Active language ready.');
      }
    } else {
      // First launch / no language chosen yet — warm German B2 as fallback
      // so the batch notifier has something to seed.
      final fallback = kAvailableLanguageConfigs.first;
      debugPrint('[WordLearn] Splash: First launch — warming fallback ${fallback.key}...');
      await VocabularyRepository.warmUp(fallback);
      await ref.read(languageBatchProvider(fallback).notifier).init();
    }

    debugPrint('[WordLearn] Splash: Essential init complete.');
  }

  /// Phase 2 — Background warm-up of ALL registered language configs.
  ///
  /// Runs AFTER context.go() so it never blocks navigation.
  /// Uses microtask-spaced awaits to avoid saturating the IO thread.
  void _warmRemainingLanguagesInBackground() {
    _doBackgroundWarmUp().catchError((Object e) {
      debugPrint('[WordLearn] Background warmup error (non-fatal): $e');
    });
  }

  Future<void> _doBackgroundWarmUp() async {
    debugPrint('[WordLearn] Background: Starting remaining language warm-up...');
    for (final cfg in kAvailableLanguageConfigs) {
      // Skip configs that are already cached.
      if (VocabularyRepository.isCached(cfg)) continue;

      // Small delay between each language to avoid IO bursting.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      try {
        await VocabularyRepository.warmUp(cfg);
        await ref.read(languageBatchProvider(cfg).notifier).init();
        debugPrint('[WordLearn] Background: Warmed ${cfg.key}');
      } catch (e) {
        debugPrint('[WordLearn] Background: Failed to warm ${cfg.key}: $e');
      }
    }
    debugPrint('[WordLearn] Background: All languages warm.');
  }

  /// Fire-and-forget notification scheduling.
  void _initNotificationsFireAndForget() {
    _initNotifications().catchError((Object e) {
      debugPrint('[WordLearn] Notification init error (non-fatal): $e');
    });
  }

  Future<void> _initNotifications() async {
    final onboarding = ref.read(onboardingProvider);
    final streak = ref.read(streakProvider);

    await NotificationService.instance.init(
      onTap: (payload) {
        if (!mounted) return;
        context.go(AppRoutes.home);
      },
    );

    final scheduler = NotificationScheduler.instance;

    await scheduler.scheduleDailyReminder(batchCount: 0);

    if (!streak.sessionCompletedToday) {
      await scheduler.scheduleStreakWarning(curfew: onboarding.curfew);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WordLearn',
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.primaryTeal,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Vocabulary mastery without fluff.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryTeal.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
