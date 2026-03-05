import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../features/curfew/ice_state_banner.dart';
import '../../shared/state/active_batch_provider.dart';
import '../../shared/state/curfew_status_provider.dart';
import '../../shared/state/onboarding_provider.dart';
import '../../shared/state/session_provider.dart';
import '../../shared/state/settings_provider.dart';
import '../../shared/state/streak_provider.dart';
import '../../shared/state/vault_provider.dart';

/// Home screen — WL-050 + WL-200 (Curfew enforcement) + WL-210 (Ice State).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  Timer? _curfewTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAsh();
    _startCurfewTimer();
  }

  @override
  void dispose() {
    _curfewTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// On app resume, re-run ash check in case the user left the app overnight.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAsh();
    }
  }

  /// Check whether Ash should fire and redirect if so. WL-220.
  void _checkAsh() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final curfew = ref.read(onboardingProvider).curfew;
      ref.read(streakProvider.notifier).checkAshOnStartup(
            now: DateTime.now(),
            curfew: curfew,
          );
      if (ref.read(streakProvider).ashPending) {
        context.go(AppRoutes.ash);
      }
    });
  }

  /// Refresh curfew status every 60 seconds for live countdown. WL-210.
  void _startCurfewTimer() {
    _curfewTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        // Invalidate by triggering a rebuild — curfewStatusProvider recomputes.
        ref.invalidate(curfewStatusProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(onboardingProvider);
    final settings = ref.watch(settingsProvider);
    final batch = ref.watch(activeBatchProvider);
    final batchNotifier = ref.read(activeBatchProvider.notifier);
    final vaultCount = ref.watch(vaultProvider).length;
    final streak = ref.watch(streakProvider);
    final curfewStatus = ref.watch(curfewStatusProvider);

    final now = DateTime.now();
    final dueCount = batch
        .where((e) =>
            e.nextReviewDate == null || !e.nextReviewDate!.isAfter(now))
        .length;
    final newTodayCount = batch.where((e) => e.isNewToday).length;

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        backgroundColor: curfewStatus.isIce
            ? AppColors.iceBackground
            : curfewStatus.isPastCurfew
                ? const Color(0xFFFFF8F8)
                : AppColors.paperWhite,
        title: Text(
          'WordLearn',
          style: AppTypography.labelLarge.copyWith(
            color: curfewStatus.isIce
                ? AppColors.iceTeal
                : AppColors.primaryTeal,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: IceStateScaffoldBackground(
        child: Column(
          children: [
            // ── Ice State / Past-Curfew banner (WL-210) ──────────────
            const IceStateBanner(),

            // ── Main content ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${settings.displayName}.',
                      style: AppTypography.displayMedium
                          .copyWith(color: AppColors.darkGray),
                    ),
                    SizedBox(height: AppSpacing.xl),

                    // ── Daily Stats Card ──────────────────────────────
                    _StatsCard(
                      batchTotal: batch.length,
                      capacity: batchNotifier.capacity,
                      dueCount: dueCount,
                      newTodayCount: newTodayCount,
                      vaultCount: vaultCount,
                      streak: streak.currentStreak,
                      curfewStatus: curfewStatus,
                      isNearCapacity: batchNotifier.isNearCapacity,
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // ── Capacity warning ──────────────────────────────
                    if (batchNotifier.isNearCapacity)
                      _CapacityWarning(
                        current: batch.length,
                        capacity: batchNotifier.capacity,
                      ),
                    if (batchNotifier.isNearCapacity)
                      SizedBox(height: AppSpacing.md),

                    // ── Session done badge ────────────────────────────
                    if (streak.sessionCompletedToday)
                      _SessionDoneBadge(streak: streak.currentStreak),
                    if (streak.sessionCompletedToday)
                      SizedBox(height: AppSpacing.md),

                    // ── Primary CTA ───────────────────────────────────
                    FilledButton(
                      onPressed: () {
                        ref
                            .read(sessionProvider.notifier)
                            .startSession(maxCards: 10);
                        context.go(AppRoutes.session);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: curfewStatus.isIce
                            ? AppColors.iceTeal
                            : curfewStatus.isPastCurfew
                                ? AppColors.error
                                : AppColors.primaryTeal,
                      ),
                      child: Text(
                        curfewStatus.isPastCurfew
                            ? 'START SESSION — SAVE YOUR STREAK'
                            : 'START SESSION',
                      ),
                    ),

                    SizedBox(height: AppSpacing.md),

                    // ── Daily Drip ────────────────────────────────────
                    OutlinedButton.icon(
                      onPressed: () {
                        final added = ref
                            .read(activeBatchProvider.notifier)
                            .injectDrip(
                              count: onboarding.dailyDripCount,
                            );
                        _showDripSnackbar(context, added);
                      },
                      icon: const Icon(Icons.water_drop, size: 18),
                      label: Text(
                          'DAILY DRIP (+${onboarding.dailyDripCount} words)'),
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
        backgroundColor:
            added > 0 ? AppColors.primaryTeal : AppColors.mediumGray,
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
    required this.streak,
    required this.curfewStatus,
    required this.isNearCapacity,
  });

  final int batchTotal;
  final int capacity;
  final int dueCount;
  final int newTodayCount;
  final int vaultCount;
  final int streak;
  final CurfewStatus curfewStatus;
  final bool isNearCapacity;

  @override
  Widget build(BuildContext context) {
    final borderColor = curfewStatus.isPastCurfew
        ? AppColors.error
        : curfewStatus.isIce
            ? AppColors.iceTeal
            : isNearCapacity
                ? AppColors.warning
                : AppColors.lightGray;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
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
          _StatRow(
            label: 'Streak',
            value: '$streak days',
            valueColor: streak > 0 ? AppColors.success : AppColors.mediumGray,
          ),
          _StatRow(
            label: 'Curfew',
            value: curfewStatus.curfewTimeLabel,
            valueColor: curfewStatus.isPastCurfew
                ? AppColors.error
                : curfewStatus.isIce
                    ? AppColors.iceTeal
                    : AppColors.darkGray,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
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
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.mediumGray)),
              Text(value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: valueColor ?? AppColors.darkGray,
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

// ── Session done badge ────────────────────────────────────────────────────────

class _SessionDoneBadge extends StatelessWidget {
  const _SessionDoneBadge({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
            color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Session complete. Streak: $streak days. Curfew is safe.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Capacity warning ──────────────────────────────────────────────────────────

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
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.warning, size: 20),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Batch nearly full ($current/$capacity). Graduate words to Vault to make room.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
