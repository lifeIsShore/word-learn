import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// WL-010: Welcome & Introduction — "Scholar, welcome to WordLearn."
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Scholar, welcome to WordLearn.',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.darkGray,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                'A precision tool for vocabulary mastery.',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Study smarter with spaced repetition and clear goals. '
                'Set your daily Curfew and build lasting discipline—no streak freezes, no fluff.',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.darkGray,
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.onboardingBaseLanguage),
                child: const Text('GET STARTED'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
