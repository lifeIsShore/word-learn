import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/wl_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),

              // Logo mark
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    'W',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Text(
                'Scholar,\nwelcome to\nWordLearn.',
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 40,
                  height: 1.15,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                'A precision tool for vocabulary mastery.\nNo fluff. Just results.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.mediumGray,
                  height: 1.6,
                ),
              ),

              const Spacer(flex: 3),

              // Feature summary — minimal, 3 lines
              ..._features.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryTeal,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        f,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.darkGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              WlPrimaryButton(
                label: 'Get Started',
                onPressed: () => context.go(AppRoutes.languageSelection),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  static const _features = [
    'Spaced repetition — science-backed retention',
    'Multi-language simultaneous learning',
    'Accountability without gamification',
  ];
}
