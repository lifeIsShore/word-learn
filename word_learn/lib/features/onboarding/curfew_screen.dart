import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/onboarding_provider.dart';

/// WL-014: Daily Curfew — time picker, default 22:00, warning about Ash.
class CurfewScreen extends ConsumerWidget {
  const CurfewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curfew = ref.watch(onboardingProvider).curfew;
    final timeStr =
        '${curfew.hour.toString().padLeft(2, '0')}:${curfew.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.onboardingCefr),
        ),
        title: Text('Daily deadline', style: AppTypography.labelLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "When's your daily deadline?",
                style: AppTypography.displayMedium.copyWith(color: AppColors.darkGray),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Choose wisely. This is when the Ice State begins.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.mediumGray),
              ),
              SizedBox(height: AppSpacing.xl),
              Center(
                child: Text(
                  timeStr,
                  style: AppTypography.displayLarge.copyWith(color: AppColors.primaryTeal),
                ),
              ),
              SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: curfew,
                  );
                  if (picked != null && context.mounted) {
                    ref.read(onboardingProvider.notifier).setCurfew(picked);
                  }
                },
                icon: const Icon(Icons.schedule),
                label: const Text('Change time'),
              ),
              SizedBox(height: AppSpacing.lg),
              Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
                ),
                child: Text(
                  'Missing your Curfew burns your streak to Ash. There are no freezes. Only consistency.',
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.warning),
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.onboardingDrip),
                child: const Text('I ACCEPT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
