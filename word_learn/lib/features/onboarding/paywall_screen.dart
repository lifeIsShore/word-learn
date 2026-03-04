import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// WL-016: Paywall — disabled for testing. Shows tiers; only "Continue (Free)" goes to Home.
/// Auth & IAP to be implemented last; this screen is a placeholder.
class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.onboardingDrip),
        ),
        title: Text('Subscription', style: AppTypography.labelLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Unlock unlimited languages',
                style: AppTypography.displayMedium.copyWith(color: AppColors.darkGray),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Free: 1 language. Paid: up to 6.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.mediumGray),
              ),
              SizedBox(height: AppSpacing.lg),
              _TierCard(
                title: 'FREE',
                price: '\$0',
                features: const ['1 language', '50-word batch', 'Basic features'],
                isRecommended: false,
                buttonLabel: 'Continue with Free',
                onTap: () => context.go(AppRoutes.home),
              ),
              SizedBox(height: AppSpacing.md),
              _TierCard(
                title: 'MONTHLY',
                price: '\$9.99/mo',
                features: const ['6 languages', '200-word batch', 'Full features'],
                isRecommended: false,
                buttonLabel: 'Subscribe (disabled)',
                onTap: null,
              ),
              SizedBox(height: AppSpacing.md),
              _TierCard(
                title: '6-MONTH',
                price: '\$49.99',
                features: const ['6 languages', '200-word batch', '17% discount'],
                isRecommended: true,
                buttonLabel: 'Subscribe (disabled)',
                onTap: null,
              ),
              const Spacer(),
              Text(
                'Auth & payments disabled for testing. Use "Continue with Free" to go to Home.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.warning,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.title,
    required this.price,
    required this.features,
    required this.isRecommended,
    required this.buttonLabel,
    required this.onTap,
  });

  final String title;
  final String price;
  final List<String> features;
  final bool isRecommended;
  final String buttonLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isRecommended ? AppColors.primaryTeal : AppColors.lightGray,
          width: isRecommended ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.labelLarge),
              if (isRecommended)
                Text('Recommended', style: AppTypography.labelLarge.copyWith(color: AppColors.primaryTeal)),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Text(price, style: AppTypography.displayMedium.copyWith(color: AppColors.darkGray)),
          ...features.map((f) => Padding(
                padding: EdgeInsets.only(top: AppSpacing.xs),
                child: Text('• $f', style: AppTypography.bodyMedium),
              )),
          SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: onTap != null ? AppColors.primaryTeal : AppColors.mediumGray,
            ),
            child: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
