import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/wl_buttons.dart';
import '../../../onboarding/providers/onboarding_provider.dart';
import 'language_selection_screen.dart';

class CurfewSetupScreen extends ConsumerStatefulWidget {
  const CurfewSetupScreen({super.key});

  @override
  ConsumerState<CurfewSetupScreen> createState() => _CurfewSetupScreenState();
}

class _CurfewSetupScreenState extends ConsumerState<CurfewSetupScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 22, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: AppColors.white,
              hourMinuteColor: AppColors.lightTeal,
              hourMinuteTextColor: AppColors.primaryTeal,
              dialHandColor: AppColors.primaryTeal,
              dialBackgroundColor: AppColors.lightTeal,
              entryModeIconColor: AppColors.primaryTeal,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hour.toString().padLeft(2, '0');
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
          onPressed: () => context.go(AppRoutes.languageSelection),
        ),
        title: const Text('Step 2 of 4'),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingProgressBar(step: 2),
              const SizedBox(height: AppSpacing.xl),

              const Text('Set your\nCurfew.',
                  style: AppTextStyles.displayLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your daily deadline for completing a study session.',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.mediumGray),
              ),

              const Spacer(flex: 2),

              // Time display — large, tappable
              Center(
                child: GestureDetector(
                  onTap: _pickTime,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xxl,
                          vertical: AppSpacing.xl,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightTeal,
                          borderRadius: BorderRadius.circular(
                              AppSpacing.cardBorderRadius),
                          border: Border.all(
                              color: AppColors.primaryTeal, width: 2),
                        ),
                        child: Text(
                          _formatTime(_selectedTime),
                          style: AppTextStyles.displayLarge.copyWith(
                            fontSize: 56,
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'TAP TO CHANGE',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.mediumGray,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Warning box
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                  border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: AppColors.warning, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'The Ash Protocol',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Missing your Curfew burns your streak to ash. No streak freezes. Consistency is the only path.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.darkGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              WlPrimaryButton(
                label: 'I Accept',
                onPressed: () {
                  notifier.setCurfew(_formatTime(_selectedTime));
                  context.go(AppRoutes.dripSetup);
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
