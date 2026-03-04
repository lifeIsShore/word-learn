import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/constants/app_languages.dart';
import '../../shared/state/onboarding_provider.dart';

/// WL-012: Target Languages — multi-select 1–6, exclude base language.
class TargetLanguagesScreen extends ConsumerWidget {
  const TargetLanguagesScreen({super.key});

  static const int _maxTargets = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    final baseCode = onboarding.baseLanguageCode;
    final selected = List<String>.from(onboarding.targetLanguageCodes);
    final atMax = selected.length >= _maxTargets;

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.onboardingBaseLanguage),
        ),
        title: Text('Target languages', style: AppTypography.labelLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What languages do you want to learn? (1–$_maxTargets)',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.mediumGray),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Selected: ${selected.length}/$_maxTargets',
                style: AppTypography.labelLarge.copyWith(color: AppColors.primaryTeal),
              ),
              SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView(
                  children: kAppLanguages.map((lang) {
                    final isBase = lang.code == baseCode;
                    final isSelected = selected.contains(lang.code);
                    final canTap = isBase ? false : (isSelected || !atMax);

                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Material(
                        color: isBase
                            ? AppColors.lightGray.withValues(alpha: 0.3)
                            : (isSelected ? AppColors.lightTeal : Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                            color: isSelected ? AppColors.primaryTeal : AppColors.lightGray,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: canTap
                              ? () {
                                  final notifier = ref.read(onboardingProvider.notifier);
                                  if (isSelected) {
                                    notifier.setTargetLanguages(
                                        selected.where((c) => c != lang.code).toList());
                                  } else {
                                    notifier.setTargetLanguages([...selected, lang.code]);
                                  }
                                }
                              : null,
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.md, vertical: AppSpacing.lg),
                            child: Row(
                              children: [
                                Text(lang.flagEmoji, style: const TextStyle(fontSize: 24)),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    lang.name,
                                    style: AppTypography.bodyLarge.copyWith(
                                      color: isBase ? AppColors.mediumGray : AppColors.darkGray,
                                      fontWeight:
                                          isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isBase)
                                  Text(
                                    'Base',
                                    style: AppTypography.labelLarge.copyWith(
                                        color: AppColors.mediumGray),
                                  )
                                else if (isSelected)
                                  Icon(Icons.check, color: AppColors.primaryTeal),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              FilledButton(
                onPressed: selected.isEmpty
                    ? null
                    : () => context.go(AppRoutes.onboardingCefr),
                child: const Text('NEXT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
