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
import '../../shared/state/vault_provider.dart';

/// Initial screen — logo/title, warms vocabulary cache, initialises DB, then redirects.
///
/// WL-500: Opens SQLite database and loads all persisted state before any
/// screen is shown. Ensures zero-flash state restoration.
///
/// WL-600: Warms vocabulary cache for all registered language configs.
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
    // Run DB init + vocab cache warm-up in parallel with the minimum splash.
    await Future.wait([
      Future<void>.delayed(const Duration(milliseconds: 1500)),
      _initApp(),
    ]);

    if (!mounted) return;

    // Auth check determines the destination.
    // In dev mode (devModeSkipAuth=true) this instantly returns and routes to
    // Home (or onboarding if first launch) without any login screen.
    final authStartup =
        await ref.read(authProvider.notifier).checkStartupAuth();
    final hasOnboarded =
        ref.read(onboardingProvider).isOnboardingComplete;

    if (!mounted) return;

    // Routing logic:
    //   devBypass / sessionRestored → go straight to app (home or onboarding)
    //   noSession                   → go to auth screen
    switch (authStartup) {
      case AuthStartupResult.noSession:
        context.go(AppRoutes.auth);
      case AuthStartupResult.devBypass:
      case AuthStartupResult.sessionRestored:
        context.go(hasOnboarded ? AppRoutes.home : AppRoutes.onboardingWelcome);
    }
  }

  /// Opens DB, loads all persisted state, warms vocabulary cache.
  Future<void> _initApp() async {
    // 1. Open the SQLite database (creates tables on first launch).
    await DatabaseService.instance.database;

    // 2. Restore all persisted provider state from SQLite.
    //    Order matters: onboarding → settings → streak → vault → batch
    await ref.read(onboardingProvider.notifier).init();
    await ref.read(settingsProvider.notifier).init();
    await ref.read(streakProvider.notifier).init();
    await ref.read(vaultProvider.notifier).init();

    // 3. Warm vocabulary cache for all language configs.
    await Future.wait(
      kAvailableLanguageConfigs.map(VocabularyRepository.warmUp),
    );

    // 4. Init batch for each available language config.
    //    This loads from DB (or seeds if first launch).
    await Future.wait(
      kAvailableLanguageConfigs.map(
        (cfg) => ref.read(languageBatchProvider(cfg).notifier).init(),
      ),
    );
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
                  AppColors.primaryTeal.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
