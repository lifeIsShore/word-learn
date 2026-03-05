import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/curfew_status_provider.dart';
import '../../shared/state/session_provider.dart';
import '../../shared/state/streak_provider.dart';

/// WL-075: Session complete — summary (reviewed, mastered, streak), CONTINUE → Home.
class SessionCompleteScreen extends ConsumerWidget {
  const SessionCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final curfewStatus = ref.watch(curfewStatusProvider);
    // Peek at streak BEFORE completeAndClear() — we'll record on CONTINUE.
    final streak = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: curfewStatus.isIce
          ? AppColors.iceBackground
          : AppColors.paperWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // ── Headline ─────────────────────────────────────────────
              Text(
                'Session complete.',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.darkGray,
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // ── Stats ─────────────────────────────────────────────────
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
                label: 'Current streak',
                // Add 1 to preview what streak will be after this session
                value: '${streak.currentStreak + (streak.sessionCompletedToday ? 0 : 1)} days',
                highlight: true,
              ),

              SizedBox(height: AppSpacing.lg),

              // ── Curfew reminder / urgency ─────────────────────────────
              _CurfewBanner(curfewStatus: curfewStatus),

              const Spacer(),

              // ── CTA ───────────────────────────────────────────────────
              FilledButton(
                onPressed: () {
                  ref.read(sessionProvider.notifier).completeAndClear();
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

class _CurfewBanner extends StatelessWidget {
  const _CurfewBanner({required this.curfewStatus});
  final CurfewStatus curfewStatus;

  @override
  Widget build(BuildContext context) {
    if (curfewStatus.isNormal) {
      return Text(
        'Curfew: ${curfewStatus.curfewTimeLabel}. ${curfewStatus.countdownLabel}',
        style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
        textAlign: TextAlign.center,
      );
    }

    final color = curfewStatus.isIce ? AppColors.iceTeal : AppColors.error;
    final bg = curfewStatus.isIce
        ? AppColors.iceBackground
        : AppColors.error.withValues(alpha: 0.08);
    final message = curfewStatus.isIce
        ? 'Ice State. ${curfewStatus.countdownLabel} Complete more sessions before Curfew.'
        : 'Curfew passed. Your streak is at risk. Complete a session now.';

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(color: color),
        textAlign: TextAlign.center,
      ),
    );
  }
}
