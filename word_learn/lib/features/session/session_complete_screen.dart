import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/onboarding_provider.dart';
import '../../shared/state/session_provider.dart';

/// WL-075: Session complete — summary (reviewed, mastered, streak), CONTINUE → Home.
class SessionCompleteScreen extends ConsumerWidget {
  const SessionCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final onboarding = ref.watch(onboardingProvider);
    final curfewStr =
        '${onboarding.curfew.hour.toString().padLeft(2, '0')}:${onboarding.curfew.minute.toString().padLeft(2, '0')}';

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
                'Session complete',
                style: AppTypography.displayLarge.copyWith(color: AppColors.darkGray),
              ),
              SizedBox(height: AppSpacing.xl),
              _StatRow(
                label: 'Words reviewed',
                value: '${session.reviewedCount}',
              ),
              SizedBox(height: AppSpacing.sm),
              _StatRow(
                label: 'Words mastered',
                value: '${session.masteredCount}',
                highlight: true,
              ),
              SizedBox(height: AppSpacing.sm),
              _StatRow(
                label: 'Streak',
                value: '0 days',
              ),
              SizedBox(height: AppSpacing.lg),
              Text(
                'Complete by $curfewStr to preserve your streak.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  ref.read(sessionProvider.notifier).clearSession();
                  context.go(AppRoutes.home);
                },
                child: const Text('CONTINUE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.mediumGray),
        ),
        Text(
          value,
          style: AppTypography.bodyLarge.copyWith(
            color: highlight ? AppColors.success : AppColors.darkGray,
            fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
