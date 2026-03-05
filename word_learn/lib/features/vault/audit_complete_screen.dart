import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/audit_provider.dart';
import '../../shared/state/audit_state.dart';

/// WL-190: Vault Audit complete — shows retained vs demoted counts, then
/// dismisses back to vault.
class AuditCompleteScreen extends ConsumerWidget {
  const AuditCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audit = ref.watch(auditProvider);

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // ── Headline ──────────────────────────────────────────────
              Text(
                'Vault audit\ncomplete.',
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.darkGray,
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // ── Stats ─────────────────────────────────────────────────
              _AuditStatRow(
                label: 'Words reviewed',
                value: '${audit.results.length}',
              ),
              SizedBox(height: AppSpacing.sm),
              _AuditStatRow(
                label: 'Retained in vault',
                value: '${audit.retainedCount}',
                color: AppColors.success,
              ),
              SizedBox(height: AppSpacing.sm),
              _AuditStatRow(
                label: 'Returned to batch',
                value: '${audit.demotedCount}',
                color: audit.demotedCount > 0
                    ? AppColors.warning
                    : AppColors.mediumGray,
              ),

              SizedBox(height: AppSpacing.xl),

              // ── Demoted word list (if any) ────────────────────────────
              if (audit.demotedCount > 0) ...[
                Text(
                  'RETURNED TO BATCH',
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.warning,
                    fontSize: 11,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: audit.demotedEntries
                        .map(
                          (e) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.arrow_back,
                                color: AppColors.warning, size: 16),
                            title: Text(e.word,
                                style: AppTypography.bodyMedium
                                    .copyWith(color: AppColors.darkGray)),
                            subtitle: Text(e.meaning,
                                style: AppTypography.bodyMedium.copyWith(
                                    color: AppColors.mediumGray,
                                    fontSize: 11)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
              ],

              // ── Explanation ───────────────────────────────────────────
              Text(
                audit.demotedCount > 0
                    ? 'Words marked Hard or Familiar need more practice. They\'ve been added back to your batch for review.'
                    : 'Outstanding. All reviewed words remain mastered.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.mediumGray),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // ── CTA ───────────────────────────────────────────────────
              FilledButton(
                onPressed: () {
                  ref.read(auditProvider.notifier).dismiss();
                  context.go(AppRoutes.vault);
                },
                child: const Text('BACK TO VAULT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuditStatRow extends StatelessWidget {
  const _AuditStatRow({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              AppTypography.bodyLarge.copyWith(color: AppColors.mediumGray),
        ),
        Text(
          value,
          style: AppTypography.bodyLarge.copyWith(
            color: color ?? AppColors.darkGray,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
