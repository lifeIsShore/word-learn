import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../features/curfew/ice_state_banner.dart';
import '../../shared/models/language_config.dart';
import '../../shared/state/active_batch_provider.dart';
import '../../shared/state/active_language_provider.dart';
import '../../shared/state/curfew_status_provider.dart';
import '../../shared/state/onboarding_provider.dart';
import '../../shared/state/session_provider.dart';
import '../../shared/state/settings_provider.dart';
import '../../shared/state/streak_provider.dart';
import '../../shared/state/vault_provider.dart';

/// Home screen — WL-050, WL-200 (Curfew), WL-210 (Ice State), WL-600 (Language switcher).
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAsh();
    }
  }

  void _checkAsh() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final curfew = ref.read(onboardingProvider).curfew;
      await ref.read(streakProvider.notifier).checkAshOnStartup(
            now: DateTime.now(),
            curfew: curfew,
          );
      if (!mounted) return;
      if (ref.read(streakProvider).ashPending) {
        context.go(AppRoutes.ash);
      }
    });
  }

  void _startCurfewTimer() {
    _curfewTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) ref.invalidate(curfewStatusProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(onboardingProvider);
    final settings = ref.watch(settingsProvider);
    final vaultCount = ref.watch(vaultProvider).length;
    final streak = ref.watch(streakProvider);
    final curfewStatus = ref.watch(curfewStatusProvider);
    final activeLang = ref.watch(activeLanguageProvider);

    // WL-610: read stats from the active language batch, not the global one.
    final batch = activeLang != null
        ? ref.watch(languageBatchProvider(activeLang))
        : ref.watch(activeBatchProvider);
    final batchNotifier = activeLang != null
        ? ref.read(languageBatchProvider(activeLang).notifier)
        : ref.read(activeBatchProvider.notifier);

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
            const IceStateBanner(),
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

                    // ── WL-600: Language Switcher ─────────────────────
                    _LanguageSwitcher(activeLang: activeLang),
                    SizedBox(height: AppSpacing.md),

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
                      activeLang: activeLang,
                    ),

                    SizedBox(height: AppSpacing.xl),

                    if (batchNotifier.isNearCapacity)
                      _CapacityWarning(
                        current: batch.length,
                        capacity: batchNotifier.capacity,
                      ),
                    if (batchNotifier.isNearCapacity)
                      SizedBox(height: AppSpacing.md),

                    if (streak.sessionCompletedToday)
                      _SessionDoneBadge(streak: streak.currentStreak),
                    if (streak.sessionCompletedToday)
                      SizedBox(height: AppSpacing.md),

                    // ── Primary CTA (WL-610: language-aware session) ──
                    FilledButton(
                      onPressed: () {
                        ref
                            .read(sessionProvider.notifier)
                            .startSession(
                              maxCards: 10,
                              config: activeLang,
                            );
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

                    // ── Daily Drip (WL-600 wired) ─────────────────────
                    OutlinedButton.icon(
                      onPressed: () {
                        final added = ref
                            .read(activeBatchProvider.notifier)
                            .injectDrip(
                              count: onboarding.dailyDripCount,
                              config: activeLang, // WL-600: pass active lang
                            );
                        _showDripSnackbar(context, added, activeLang);
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

  void _showDripSnackbar(
      BuildContext context, int added, LanguageConfig? config) {
    final langLabel =
        config != null ? '${config.languageName} ${config.cefrLevel}' : '';
    final msg = added > 0
        ? '$added new $langLabel words added to your batch.'
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

// ── Language Switcher (WL-600) ────────────────────────────────────────────────

class _LanguageSwitcher extends ConsumerWidget {
  const _LanguageSwitcher({required this.activeLang});
  final LanguageConfig? activeLang;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langNotifier = ref.read(activeLanguageProvider.notifier);
    final available = langNotifier.availableForUser();

    // If the user has only one language (or none), show a compact label only.
    if (available.length <= 1) {
      return _LangPill(
        config: activeLang,
        onTap: null,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: available.map((config) {
          final isActive = activeLang?.key == config.key;
          return Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: _LangChip(
              config: config,
              isActive: isActive,
              onTap: () => langNotifier.switchTo(config),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.config,
    required this.isActive,
    required this.onTap,
  });
  final LanguageConfig config;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primaryTeal : AppColors.lightGray,
            width: 1.5,
          ),
        ),
        child: Text(
          '${config.languageName} ${config.cefrLevel}',
          style: AppTypography.labelLarge.copyWith(
            fontSize: 12,
            color: isActive ? Colors.white : AppColors.mediumGray,
          ),
        ),
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  const _LangPill({required this.config, required this.onTap});
  final LanguageConfig? config;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (config == null) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryTeal.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryTeal.withValues(alpha: 0.3)),
      ),
      child: Text(
        '${config!.languageName} ${config!.cefrLevel}',
        style: AppTypography.labelLarge.copyWith(
          fontSize: 12,
          color: AppColors.primaryTeal,
        ),
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
    required this.activeLang,
  });

  final int batchTotal;
  final int capacity;
  final int dueCount;
  final int newTodayCount;
  final int vaultCount;
  final int streak;
  final CurfewStatus curfewStatus;
  final bool isNearCapacity;
  final LanguageConfig? activeLang;

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
          if (activeLang != null)
            _StatRow(
              label: 'Studying',
              value: '${activeLang!.languageName} ${activeLang!.cefrLevel}',
              valueColor: AppColors.primaryTeal,
            ),
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
