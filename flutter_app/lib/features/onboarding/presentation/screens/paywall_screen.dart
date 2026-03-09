import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/wl_buttons.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _isMonthlySelected = true;

  Future<void> _completeFreeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingComplete, true);
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Step 4 of 4'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              const Text('Unlock full\naccess.',
                  style: AppTextStyles.displayLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'One subscription. All languages. No ads.',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.mediumGray),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Tier toggle
              Row(
                children: [
                  Expanded(
                    child: _PlanToggle(
                      label: 'Monthly',
                      price: '\$9.99',
                      period: '/month',
                      isSelected: _isMonthlySelected,
                      onTap: () => setState(() => _isMonthlySelected = true),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _PlanToggle(
                      label: '6 Months',
                      price: '\$49.99',
                      period: '/6 months',
                      badge: 'SAVE 17%',
                      isSelected: !_isMonthlySelected,
                      onTap: () => setState(() => _isMonthlySelected = false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Feature comparison
              _FeatureTable(),

              const SizedBox(height: AppSpacing.xl),

              // Subscribe button
              WlPrimaryButton(
                label: _isMonthlySelected
                    ? 'Subscribe — \$9.99/month'
                    : 'Subscribe — \$49.99/6 months',
                onPressed: () {
                  // TODO: Implement IAP (Sprint 2)
                  // For now, treat as subscribed and go home
                  _completeFreeOnboarding();
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // Try free
              WlOutlinedButton(
                label: 'Try Free — 1 Language',
                onPressed: _completeFreeOnboarding,
              ),

              const SizedBox(height: AppSpacing.md),

              Center(
                child: Text(
                  'Cancel anytime. No ads. No data selling.',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.mediumGray),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanToggle extends StatelessWidget {
  const _PlanToggle({
    required this.label,
    required this.price,
    required this.period,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  final String label;
  final String price;
  final String period;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightTeal : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.borderGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  badge!,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            Text(label,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.mediumGray)),
            const SizedBox(height: 4),
            Text(price, style: AppTextStyles.displaySmall),
            Text(period,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.mediumGray)),
          ],
        ),
      ),
    );
  }
}

class _FeatureTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const features = [
      ('Languages', 'Up to 6', '1 only'),
      ('Active Batch', '200 words', '50 words'),
      ('The Vault', 'Unlimited', '25 words'),
      ('Study sessions', 'Unlimited', 'Unlimited'),
      ('Intelligence Reports', 'Included', '—'),
      ('Multi-language mode', 'Included', '—'),
    ];

    return Column(
      children: [
        // Header row
        Row(
          children: [
            Expanded(
                flex: 3,
                child: Text('FEATURE',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.mediumGray, fontSize: 10))),
            Expanded(
                flex: 2,
                child: Text('SUBSCRIBER',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.primaryTeal, fontSize: 10),
                    textAlign: TextAlign.center)),
            Expanded(
                flex: 2,
                child: Text('FREE',
                    style: AppTextStyles.labelMedium
                        .copyWith(color: AppColors.mediumGray, fontSize: 10),
                    textAlign: TextAlign.center)),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const Divider(),
        ...features.map(
          (f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text(f.$1, style: AppTextStyles.bodyMedium)),
                Expanded(
                    flex: 2,
                    child: Text(f.$2,
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center)),
                Expanded(
                    flex: 2,
                    child: Text(f.$3,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.mediumGray),
                        textAlign: TextAlign.center)),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
