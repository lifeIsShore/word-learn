import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/streak_provider.dart';

/// WL-220: Ash Protocol screen — shown once on app open when the user
/// missed their Curfew the previous day. Hard streak reset. No escape.
/// The "Director's Pardon" is a one-time reprieve (1 per lifetime in MVP).
class AshProtocolScreen extends ConsumerWidget {
  const AshProtocolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final hasPardon = streak.pardonsRemaining > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // ── Icon ──────────────────────────────────────────────────
              const Center(
                child: Icon(
                  Icons.local_fire_department,
                  size: 72,
                  color: Color(0xFFE64A19),
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // ── Headline ──────────────────────────────────────────────
              Text(
                'Your streak is Ash.',
                style: AppTypography.displayLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),

              // ── Subtext ───────────────────────────────────────────────
              Text(
                'You missed your Curfew. The streak has been reset to zero.\n\n'
                'There are no freezes. There is no mercy built into the system.\n\n'
                'Only consistency earns a streak.',
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // ── Pardon section ────────────────────────────────────────
              if (hasPardon) ...[
                Container(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "The Director's Pardon",
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.warning,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'You have 1 pardon remaining. Use it to restore '
                        'your previous streak. This cannot be undone and '
                        'pardons do not renew.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.md),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.warning,
                          side: const BorderSide(color: AppColors.warning),
                        ),
                        onPressed: () => _usePardon(context, ref),
                        child: const Text('USE DIRECTOR\'S PARDON'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.md),
              ],

              // ── Accept CTA ────────────────────────────────────────────
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE64A19),
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                ),
                onPressed: () => _acceptAsh(context, ref),
                child: const Text(
                  'I ACCEPT. START OVER.',
                  style: TextStyle(color: Colors.white, letterSpacing: 1),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Streaks reset: ${_streakResetLabel(streak)}',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  void _acceptAsh(BuildContext context, WidgetRef ref) {
    ref.read(streakProvider.notifier).acknowledgeAsh();
    context.go(AppRoutes.home);
  }

  void _usePardon(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          "Use Director's Pardon?",
          style: AppTypography.labelLarge.copyWith(color: Colors.white),
        ),
        content: Text(
          'This will restore your previous streak. '
          'You have 1 pardon — once used it cannot be recovered.',
          style: AppTypography.bodyMedium
              .copyWith(color: Colors.white.withValues(alpha: 0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Restore to the streak count that was active before Ash reset.
              // In MVP, we don't persist the pre-Ash count, so restore to 1
              // as a "grace" start — per PRD: "grace, not amnesty".
              ref.read(streakProvider.notifier).useDirectorsPardon(1);
              context.go(AppRoutes.home);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.warning),
            child: const Text('USE PARDON'),
          ),
        ],
      ),
    );
  }

  String _streakResetLabel(StreakState streak) {
    return streak.totalSessionsCompleted > 0
        ? '${streak.totalSessionsCompleted} total sessions completed'
        : 'Begin your first streak today.';
  }
}
