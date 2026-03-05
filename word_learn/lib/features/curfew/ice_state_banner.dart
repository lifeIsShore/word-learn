import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/state/curfew_status_provider.dart';

/// WL-210: Ice State banner — shown at the top of the Home screen
/// when within 60 minutes of Curfew and session not yet complete.
///
/// The banner slides in with an animation and provides a live countdown.
class IceStateBanner extends ConsumerWidget {
  const IceStateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(curfewStatusProvider);

    if (status.isNormal) return const SizedBox.shrink();

    final isIce = status.isIce;
    final bg = isIce ? AppColors.iceBackground : AppColors.error.withValues(alpha: 0.1);
    final border = isIce ? AppColors.iceTeal : AppColors.error;
    final textColor = isIce ? AppColors.iceTeal : AppColors.error;
    final icon = isIce ? Icons.ac_unit : Icons.warning_amber_rounded;

    final message = isIce
        ? 'Ice State active. ${status.countdownLabel}'
        : 'Curfew passed. Complete a session to protect your streak.';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: Border(bottom: BorderSide(color: border, width: 1.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 16),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Wraps a scaffold background color so Ice State shifts the whole screen tint.
/// Drop this around any screen that should react to ice/ash.
class IceStateScaffoldBackground extends ConsumerWidget {
  const IceStateScaffoldBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(curfewStatusProvider);

    Color bg;
    if (status.isPastCurfew) {
      bg = const Color(0xFFFFF8F8); // very faint red tint
    } else if (status.isIce) {
      bg = AppColors.iceBackground;
    } else {
      bg = AppColors.paperWhite;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      color: bg,
      child: child,
    );
  }
}
