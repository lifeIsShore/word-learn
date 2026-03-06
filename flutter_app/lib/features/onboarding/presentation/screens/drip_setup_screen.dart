import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/wl_buttons.dart';
import '../../../onboarding/providers/onboarding_provider.dart';
import 'language_selection_screen.dart';

class DripSetupScreen extends ConsumerStatefulWidget {
  const DripSetupScreen({super.key});

  @override
  ConsumerState<DripSetupScreen> createState() => _DripSetupScreenState();
}

class _DripSetupScreenState extends ConsumerState<DripSetupScreen> {
  double _sliderValue = 20;

  int get _drip => _sliderValue.round();

  String get _dripLabel {
    if (_drip <= 10) return 'Steady';
    if (_drip <= 20) return 'Balanced';
    if (_drip <= 30) return 'Intensive';
    return 'Maximum';
  }

  String get _dripDescription {
    if (_drip <= 10) return '~${_drip * 2}–${_drip * 3} min/day';
    if (_drip <= 20) return '~${_drip}–${_drip + 10} min/day';
    if (_drip <= 30) return '~${_drip + 5}–${_drip + 20} min/day';
    return '~${_drip + 10}–${_drip + 30} min/day';
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.curfewSetup),
        ),
        title: const Text('Step 3 of 4'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OnboardingProgressBar(step: 3),
              const SizedBox(height: AppSpacing.xl),

              Text('Set your\ndaily drip.', style: AppTextStyles.displayLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'New words added to your study set each day.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
              ),

              const Spacer(flex: 2),

              // Count display
              Center(
                child: Column(
                  children: [
                    Text(
                      '$_drip',
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 72,
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'words / day',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.mediumGray,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightTeal,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '$_dripLabel — $_dripDescription',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.primaryTeal,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primaryTeal,
                  inactiveTrackColor: AppColors.lightGray,
                  thumbColor: AppColors.primaryTeal,
                  overlayColor: AppColors.primaryTeal.withOpacity(0.15),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _sliderValue,
                  min: AppConstants.minDailyDrip.toDouble(),
                  max: AppConstants.maxDailyDrip.toDouble(),
                  divisions: (AppConstants.maxDailyDrip - AppConstants.minDailyDrip),
                  onChanged: (val) => setState(() => _sliderValue = val),
                ),
              ),

              // Min / Max labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppConstants.minDailyDrip}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                  ),
                  Text(
                    '${AppConstants.maxDailyDrip}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Info note
              Text(
                'You can change this anytime in Settings.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
              ),

              const SizedBox(height: AppSpacing.lg),

              WlPrimaryButton(
                label: 'Start Learning',
                onPressed: () {
                  notifier.setDailyDrip(_drip);
                  context.go(AppRoutes.paywall);
                },
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
