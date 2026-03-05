import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../services/curfew_service.dart';
import '../state/streak_provider.dart';

/// WL-210: Ice State overlay — a non-intrusive banner that appears on
/// every screen when within 60 minutes of Curfew and the session is
/// not yet complete. Cool-cyan palette shift as psychological priming.
/// No notification, no alert — just ambient pressure.
class IceStateBanner extends ConsumerStatefulWidget {
  const IceStateBanner({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<IceStateBanner> createState() => _IceStateBannerState();
}

class _IceStateBannerState extends ConsumerState<IceStateBanner> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curfew = ref.watch(curfewTimeProvider);
    final sessionDone = ref.watch(streakProvider).sessionCompletedToday;

    final iceActive = CurfewService.isIceActive(
      now: _now,
      curfew: curfew,
      sessionCompletedToday: sessionDone,
    );
    final pastCurfew = CurfewService.isPastCurfew(
      now: _now,
      curfew: curfew,
      sessionCompletedToday: sessionDone,
    );
    final minutes = CurfewService.minutesUntilCurfew(now: _now, curfew: curfew);

    return Stack(
      children: [
        widget.child,
        if (iceActive || pastCurfew)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _IceBanner(minutesRemaining: minutes, isPast: pastCurfew),
          ),
      ],
    );
  }
}

class _IceBanner extends StatelessWidget {
  const _IceBanner({required this.minutesRemaining, required this.isPast});

  final int minutesRemaining;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    final label = isPast
        ? 'Curfew passed. Complete your session to preserve your streak.'
        : CurfewService.countdownLabel(minutesRemaining);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isPast
              ? AppColors.error.withValues(alpha: 0.92)
              : AppColors.iceTeal.withValues(alpha: 0.92),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              isPast ? Icons.local_fire_department : Icons.ac_unit,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
