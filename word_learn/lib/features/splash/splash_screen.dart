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
    final results = await Future.wait([
      Future<void>.delayed(const Duration(milliseconds: 1500)),
      _initApp(),
    ]);

    // _initApp returns whether the user has completed onboarding.
    final hasOnboarded = results[1] as bool;

    if (!mounted) return;
    if (hasOnboarded) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboardingWelcome);
    }
  }

  /// Opens DB, loads all persisted state, warms vocabulary cache.
  /// Returns true if the user has previously completed onboarding.
  Future<bool> _initApp() async {
    // 1. Open the SQLite database (creates tables on first launch).
    await DatabaseService.instance.database;

    // 2. Restore all persisted provider state from SQLite.
    //    Order matters: onboarding → settings → streak → vault → batch
    final hasOnboarded =
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

    return hasOnboarded;
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
