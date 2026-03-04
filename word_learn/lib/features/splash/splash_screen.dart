import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Initial screen — logo/title, then redirect to Auth or Home.
/// TODO: Check auth state and onboarding completion; for now goes to onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    // For MVP: always go to onboarding welcome. Later: check auth → home or auth; check onboarding → welcome or home.
    context.go(AppRoutes.onboardingWelcome);
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
          ],
        ),
      ),
    );
  }
}
