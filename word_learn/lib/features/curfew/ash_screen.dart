import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/streak_provider.dart';

/// WL-220: The Ash Protocol screen.
/// Shown when the user opens the app and a curfew was missed.
/// Streak has already been reset to 0 by StreakNotifier.checkAshOnStartup().
class AshScreen extends ConsumerWidget {
  const AshScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.darkGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // ── Ash symbol ────────────────────────────────────────────
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.mediumGray,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_outlined,
                    color: AppColors.mediumGray,
                    size: 40,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // ── Headline ──────────────────────────────────────────────
              Text(
                'Your streak\nis Ash.',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.navyText,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.lg),

              // ── Body ──────────────────────────────────────────────────
              Text(
                'You missed your Curfew.\nThere are no freezes. Only consistency.',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.md),

              Text(
                'Streak reset to 0.\nRebuild from today.',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.mediumGray,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // ── CTA ───────────────────────────────────────────────────
              FilledButton(
                onPressed: () async {
                  await ref
                      .read(streakProvider.notifier)
                      .acknowledgeAsh();
                  if (context.mounted) context.go(AppRoutes.home);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navyText,
                  foregroundColor: AppColors.darkGray,
                ),
                child: const Text('I UNDERSTAND. BEGIN AGAIN.'),
              ),

              SizedBox(height: AppSpacing.md),

              Text(
                'The Curfew does not negotiate.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
