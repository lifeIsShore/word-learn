import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/onboarding_provider.dart';
import '../../shared/state/session_provider.dart';

/// Home tab — Daily briefing, START SESSION, streak, Curfew. WL-050.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    final curfewStr =
        '${onboarding.curfew.hour.toString().padLeft(2, '0')}:${onboarding.curfew.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        title: Text(
          'WordLearn',
          style: AppTypography.labelLarge.copyWith(color: AppColors.primaryTeal),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Scholar.',
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.darkGray,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              '0 words due for review',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              '${onboarding.dailyDripCount} new words today',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Streak: 0 days · Curfew: $curfewStr',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
            FilledButton(
              onPressed: () {
                ref.read(sessionProvider.notifier).startSession(maxCards: 10);
                context.go(AppRoutes.session);
              },
              child: const Text('START SESSION'),
            ),
          ],
        ),
      ),
    );
  }
}
