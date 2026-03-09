import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/audit_provider.dart';
import '../../shared/state/session_state.dart';

/// WL-190: Vault Audit session screen.
///
/// Reuses the flashcard reveal pattern from SessionScreen but routes verdicts
/// to AuditNotifier instead of SessionNotifier. No streak / curfew logic —
/// this is a maintenance activity, not a daily session.
class AuditSessionScreen extends ConsumerStatefulWidget {
  const AuditSessionScreen({super.key});

  @override
  ConsumerState<AuditSessionScreen> createState() => _AuditSessionScreenState();
}

class _AuditSessionScreenState extends ConsumerState<AuditSessionScreen> {
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final audit = ref.watch(auditProvider);
    final notifier = ref.read(auditProvider.notifier);

    // Redirect to complete screen when all cards rated.
    if (audit.isComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) return;
        await notifier.completeAudit();
        if (!context.mounted) return;
        GoRouter.of(context).go(AppRoutes.auditComplete);
      });
      return const Scaffold(
        backgroundColor: AppColors.paperWhite,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final card = audit.currentCard!;
    final progress = audit.cards.isEmpty
        ? 0.0
        : audit.currentIndex / audit.cards.length;

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Exit audit',
          onPressed: () {
            notifier.dismiss();
            context.go(AppRoutes.vault);
          },
        ),
        title: Text('Vault Audit', style: AppTypography.labelLarge),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: Center(
              child: Text(
                '${audit.currentIndex + 1} / ${audit.cards.length}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Progress bar ──────────────────────────────────────────────
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.lightGray,
            color: AppColors.primaryTeal,
            minHeight: 3,
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // ── Vault label ───────────────────────────────────────
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightTeal,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'VAULT AUDIT',
                        style: AppTypography.labelLarge.copyWith(
                          color: AppColors.primaryTeal,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  // ── Word ──────────────────────────────────────────────
                  Text(
                    card.word,
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.darkGray,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // ── Reveal toggle ─────────────────────────────────────
                  if (!_revealed) ...[
                    Center(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _revealed = true),
                        child: const Text('REVEAL'),
                      ),
                    ),
                  ] else ...[
                    // ── Back of card ──────────────────────────────────
                    Text(
                      card.meaning,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.primaryTeal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      card.exampleSentence,
                      style: AppTypography.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.darkGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      card.exampleTranslation,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.mediumGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.xl),

                    // ── Verdict buttons ────────────────────────────────
                    _VerdictButtons(
                      onTap: (rating) {
                        ref.read(auditProvider.notifier).submitVerdict(rating);
                        setState(() => _revealed = false);
                      },
                    ),
                  ],

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerdictButtons extends StatelessWidget {
  const _VerdictButtons({required this.onTap});
  final ValueChanged<DifficultyRating> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Still mastered?',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.mediumGray,
            fontSize: 11,
            letterSpacing: 0.6,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            // ── Demote side ────────────────────────────────────────────
            Expanded(
              child: _VerdictBtn(
                label: 'HARD',
                sublabel: 'Back to batch',
                color: AppColors.error,
                onTap: () => onTap(DifficultyRating.hard),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _VerdictBtn(
                label: 'FAMILIAR',
                sublabel: 'Back to batch',
                color: AppColors.warning,
                onTap: () => onTap(DifficultyRating.familiar),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            // ── Retain side ────────────────────────────────────────────
            Expanded(
              child: _VerdictBtn(
                label: 'OK',
                sublabel: 'Keep in vault',
                color: AppColors.primaryTeal,
                onTap: () => onTap(DifficultyRating.ok),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _VerdictBtn(
                label: 'EASY',
                sublabel: 'Keep in vault',
                color: AppColors.success,
                onTap: () => onTap(DifficultyRating.easy),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VerdictBtn extends StatelessWidget {
  const _VerdictBtn({
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                color: color.withValues(alpha: 0.7),
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
