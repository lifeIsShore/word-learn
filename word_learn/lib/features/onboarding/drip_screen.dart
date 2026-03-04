import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/onboarding_provider.dart';

/// WL-015: Daily Drip — slider 5–40 words/day, default 20.
class DripScreen extends ConsumerWidget {
  const DripScreen({super.key});

  static const int minDrip = 5;
  static const int maxDrip = 40;
  static const int defaultDrip = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drip = ref.watch(onboardingProvider).dailyDripCount;

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.onboardingCurfew),
        ),
        title: Text('Words per day', style: AppTypography.labelLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'How many words per day?',
                style: AppTypography.displayMedium.copyWith(color: AppColors.darkGray),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'New words to learn. (You\'ll also review existing words.)',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.mediumGray),
              ),
              SizedBox(height: AppSpacing.xl),
              Center(
                child: Text(
                  '$drip words/day',
                  style: AppTypography.displayLarge.copyWith(color: AppColors.primaryTeal),
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              Slider(
                value: drip.toDouble(),
                min: minDrip.toDouble(),
                max: maxDrip.toDouble(),
                divisions: maxDrip - minDrip,
                label: '$drip',
                onChanged: (v) =>
                    ref.read(onboardingProvider.notifier).setDailyDrip(v.round()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$minDrip', style: AppTypography.bodyMedium),
                  Text('$maxDrip', style: AppTypography.bodyMedium),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Recommendation: 20 words/day. Adjust anytime in Settings.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.onboardingPaywall),
                child: const Text('START LEARNING'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
