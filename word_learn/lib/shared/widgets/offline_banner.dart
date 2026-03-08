import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/state/connectivity_provider.dart';

/// Session 19 — Slim offline banner.
///
/// Slides down from the top of any screen when connectivity is lost.
/// Auto-hides when connectivity is restored.
///
/// Usage: wrap the body of any Scaffold with [OfflineAwareBody], or drop
/// [OfflineBanner] directly at the top of a Column.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(connectivityProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1,
        child: child,
      ),
      child: isOnline
          ? const SizedBox.shrink(key: ValueKey('online'))
          : _OfflineBannerContent(key: const ValueKey('offline')),
    );
  }
}

class _OfflineBannerContent extends StatelessWidget {
  const _OfflineBannerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.mediumGray,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, size: 14, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            'No internet connection — studying locally',
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Convenience wrapper — stacks [OfflineBanner] above [child].
///
/// Example:
///   body: OfflineAwareBody(child: myScrollView),
class OfflineAwareBody extends StatelessWidget {
  const OfflineAwareBody({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OfflineBanner(),
        Expanded(child: child),
      ],
    );
  }
}
