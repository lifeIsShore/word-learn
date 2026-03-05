import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/active_batch_provider.dart';
import '../../shared/state/onboarding_provider.dart';
import '../../shared/state/session_provider.dart';
import '../../shared/state/vault_provider.dart';

/// Home tab — Daily briefing, START SESSION, streak, Curfew. WL-050.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    final batch = ref.watch(activeBatchProvider);
    final batchNotifier = ref.read(activeBatchProvider.notifier);
    final vaultCount = ref.watch(vaultProvider).length;

    final now = DateTime.now();
    final dueCount = batch
        .where((e) => e.nextReviewDate == null || !e.nextReviewDate!.isAfter(now))
        .length;
    final newTodayCount = batch.where((e) => e.isNewToday).length;

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Scholar.',
              style: AppTypography.displayMedium.copyWith(color: AppColors.darkGray),
            ),
            SizedBox(height: AppSpacing.xl),

            // ── Daily Stats Card ──────────────────────────────────────────
            _StatsCard(
              batchTotal: batch.length,
              capacity: batchNotifier.capacity,
              dueCount: dueCount,
              newTodayCount: newTodayCount,
              vaultCount: vaultCount,
              curfewStr: curfewStr,
              isNearCapacity: batchNotifier.isNearCapacity,
            ),

            SizedBox(height: AppSpacing.xl),

            // ── Capacity warning (WL-160) ─────────────────────────────────
            if (batchNotifier.isNearCapacity)
              _CapacityWarning(
                current: batch.length,
                capacity: batchNotifier.capacity,
              ),
            if (batchNotifier.isNearCapacity) SizedBox(height: AppSpacing.md),

            // ── Primary CTA ───────────────────────────────────────────────
            FilledButton(
              onPressed: () {
                ref.read(sessionProvider.notifier).startSession(maxCards: 10);
                context.go(AppRoutes.session);
              },
              child: const Text('START SESSION'),
            ),

            SizedBox(height: AppSpacing.md),

            // ── Daily Drip button (WL-150) ────────────────────────────────
            OutlinedButton.icon(
              onPressed: () {
                final added = ref.read(activeBatchProvider.notifier).injectDrip(
                      count: onboarding.dailyDripCount,
                    );
                _showDripSnackbar(context, added);
              },
              icon: const Icon(Icons.water_drop, size: 18),
              label: Text('DAILY DRIP (+${onboarding.dailyDripCount} words)'),
            ),

            SizedBox(height: AppSpacing.sm),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go(AppRoutes.batch),
                    child: const Text('VIEW BATCH'),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go(AppRoutes.vault),
                    child: const Text('VIEW VAULT'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDripSnackbar(BuildContext context, int added) {
    final msg = added > 0
        ? '$added new words added to your batch.'
        : 'Batch is full or no new words available.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 3),
        backgroundColor: added > 0 ? AppColors.primaryTeal : AppColors.mediumGray,
      ),
    );
  }
}

// ── Stats Card ────────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.batchTotal,
    required this.capacity,
    required this.dueCount,
    required this.newTodayCount,
    required this.vaultCount,
    required this.curfewStr,
    required this.isNearCapacity,
  });

  final int batchTotal;
  final int capacity;
  final int dueCount;
  final int newTodayCount;
  final int vaultCount;
  final String curfewStr;
  final bool isNearCapacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNearCapacity ? AppColors.warning : AppColors.lightGray,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _StatRow(label: 'Batch', value: '$batchTotal / $capacity words'),
          _StatRow(label: 'Due for review', value: '$dueCount'),
          _StatRow(label: 'New today', value: '$newTodayCount'),
          _StatRow(label: 'Vault (mastered)', value: '$vaultCount'),
          _StatRow(label: 'Streak', value: '0 days'),
          _StatRow(label: 'Curfew', value: curfewStr, isLast: true),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.mediumGray,
                  )),
              Text(value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: AppColors.lightGray),
      ],
    );
  }
}

// ── Capacity Warning ──────────────────────────────────────────────────────────

class _CapacityWarning extends StatelessWidget {
  const _CapacityWarning({required this.current, required this.capacity});
  final int current;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.warning),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Batch nearly full ($current/$capacity). Graduate words to Vault to make room.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
