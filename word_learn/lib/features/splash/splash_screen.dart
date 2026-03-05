import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/data/vocabulary_repository.dart';
import '../../shared/models/language_config.dart';

/// Initial screen — logo/title, warms vocabulary cache, then redirects.
///
/// WL-600: During the splash delay, we warm the VocabularyLoader cache for all
/// registered language configs. This ensures that by the time the user reaches
/// the Home screen, [VocabularyRepository.getWords()] returns data synchronously.
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
    // Warm vocabulary cache for all available language configs in parallel.
    // 1.5 s splash gives plenty of time; assets load in ~50-200 ms.
    await Future.wait([
      Future<void>.delayed(const Duration(milliseconds: 1500)),
      _warmVocabularyCache(),
    ]);

    if (!mounted) return;
    context.go(AppRoutes.onboardingWelcome);
  }

  /// Pre-loads all registered language configs into [VocabularyLoader] cache.
  Future<void> _warmVocabularyCache() async {
    await Future.wait(
      kAvailableLanguageConfigs.map(VocabularyRepository.warmUp),
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
            // Subtle loading indicator while cache warms.
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
