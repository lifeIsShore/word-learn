import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/curfew_service.dart';
import 'onboarding_provider.dart';
import 'streak_provider.dart';

/// The four possible curfew phases.
enum CurfewPhase {
  /// Session done today OR more than 60 min until curfew. Normal UI.
  normal,

  /// Within 60 minutes of curfew, session not yet done. Ice palette active.
  ice,

  /// Past curfew time, session not yet done. Visual urgency — streak at risk.
  pastCurfew,
}

class CurfewStatus {
  const CurfewStatus({
    required this.phase,
    required this.minutesUntilCurfew,
    required this.curfewTimeLabel,
    required this.countdownLabel,
  });

  final CurfewPhase phase;
  final int minutesUntilCurfew;
  final String curfewTimeLabel;
  final String countdownLabel;

  bool get isIce => phase == CurfewPhase.ice;
  bool get isPastCurfew => phase == CurfewPhase.pastCurfew;
  bool get isNormal => phase == CurfewPhase.normal;
}

/// Reactive curfew status — re-computes whenever streak or onboarding changes.
/// Screens should call [curfewStatusProvider] rather than CurfewService directly.
///
/// NOTE: For live countdown updates the Home screen uses a local Timer to
/// invalidate this provider every minute. See HomeScreen._startCurfewTimer().
final curfewStatusProvider = Provider<CurfewStatus>((ref) {
  final curfew = ref.watch(onboardingProvider).curfew;
  final sessionDone = ref.watch(streakProvider).sessionCompletedToday;
  final now = DateTime.now();

  final minutes = CurfewService.minutesUntilCurfew(now: now, curfew: curfew);
  final isIce = CurfewService.isIceActive(
    now: now,
    curfew: curfew,
    sessionCompletedToday: sessionDone,
  );
  final isPast = CurfewService.isPastCurfew(
    now: now,
    curfew: curfew,
    sessionCompletedToday: sessionDone,
  );

  final phase = isPast
      ? CurfewPhase.pastCurfew
      : isIce
          ? CurfewPhase.ice
          : CurfewPhase.normal;

  return CurfewStatus(
    phase: phase,
    minutesUntilCurfew: minutes,
    curfewTimeLabel: CurfewService.formatTimeOfDay(curfew),
    countdownLabel: CurfewService.countdownLabel(minutes),
  );
});
