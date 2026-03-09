import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/notifications/notification_scheduler.dart';
import '../../shared/state/backup_provider.dart';
import '../../shared/state/curfew_status_provider.dart';
import '../../shared/state/session_provider.dart';
import '../../shared/state/session_state.dart';
import '../../shared/state/streak_provider.dart';

/// WL-075 / WL-610: Session complete — overall summary + per-language breakdown.
class SessionCompleteScreen extends ConsumerWidget {
  const SessionCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final curfewStatus = ref.watch(curfewStatusProvider);
    final streak = ref.watch(streakProvider);
    final langStats = session.perLanguageStats;

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

              // ── Headline ──────────────────────────────────────────────
              Text(
                'Session complete.',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.darkGray,
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // ── Overall stats ──────────────────────────────────────────
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
                value:
                    '${streak.currentStreak + (streak.sessionCompletedToday ? 0 : 1)} days',
                highlight: true,
              ),

              // ── Per-language breakdown (WL-610) ───────────────────────
              if (session.isMultiLanguage && langStats.isNotEmpty) ...[
                SizedBox(height: AppSpacing.lg),
                _LanguageBreakdown(stats: langStats.values.toList()),
              ] else if (langStats.length == 1) ...[
                SizedBox(height: AppSpacing.sm),
                _SingleLanguageNote(stat: langStats.values.first),
              ],

              SizedBox(height: AppSpacing.lg),

              // ── Curfew reminder ────────────────────────────────────────
              _CurfewBanner(curfewStatus: curfewStatus),

              const Spacer(),

              // ── CTA ────────────────────────────────────────────────────
              FilledButton(
                onPressed: () async {
                  await ref.read(sessionProvider.notifier).completeAndClear();
                  // WL-500 Phase 2: Silent background backup after every session.
                  ref.read(backupProvider.notifier).sync(silent: true);
                  // Session 17: Cancel streak-at-risk warning — session is done.
                  await NotificationScheduler.instance.cancelStreakWarning();
                  if (context.mounted) context.go(AppRoutes.home);
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

// ── Widgets ───────────────────────────────────────────────────────────────────

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

/// Shown when session mixed multiple languages. WL-610.
class _LanguageBreakdown extends StatelessWidget {
  const _LanguageBreakdown({required this.stats});
  final List<LanguageSessionStats> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Language Breakdown',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primaryTeal,
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          ...stats.map(
            (s) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    s.languageName,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.darkGray,
                    ),
                  ),
                  Text(
                    '${s.reviewed} reviewed · ${s.mastered} mastered',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.mediumGray,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown for a single-language session — compact language label. WL-610.
class _SingleLanguageNote extends StatelessWidget {
  const _SingleLanguageNote({required this.stat});
  final LanguageSessionStats stat;

  @override
  Widget build(BuildContext context) {
    if (stat.languageKey.isEmpty || stat.languageKey == 'unknown') {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppColors.primaryTeal.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            stat.languageName,
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.primaryTeal,
              fontSize: 10,
            ),
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
        ? 'Ice State. ${curfewStatus.countdownLabel} Complete before Curfew.'
        : 'Curfew passed. Your streak is at risk.';

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
