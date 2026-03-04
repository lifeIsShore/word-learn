import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/constants/app_languages.dart';
import '../../shared/state/onboarding_provider.dart';

/// WL-011: Base Language Selection — single select from 6 languages, default English.
class BaseLanguageScreen extends ConsumerWidget {
  const BaseLanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProvider).baseLanguageCode;

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.onboardingWelcome),
        ),
        title: Text('Select base language', style: AppTypography.labelLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What language do you speak natively?',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.mediumGray),
              ),
              SizedBox(height: AppSpacing.lg),
              ...kAppLanguages.map((lang) {
                final isSelected = selected == lang.code;
                return Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Material(
                    color: isSelected ? AppColors.lightTeal : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(
                        color: isSelected ? AppColors.primaryTeal : AppColors.lightGray,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () =>
                          ref.read(onboardingProvider.notifier).setBaseLanguage(lang.code),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md, vertical: AppSpacing.lg),
                        child: Row(
                          children: [
                            Text(lang.flagEmoji, style: const TextStyle(fontSize: 24)),
                            SizedBox(width: AppSpacing.md),
                            Text(
                              lang.name,
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.darkGray,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.onboardingTargetLanguages),
                child: const Text('NEXT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
