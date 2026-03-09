import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/wl_buttons.dart';
import '../../../onboarding/providers/onboarding_provider.dart';

// Language model for the picker
class LanguageOption {
  const LanguageOption({
    required this.code,
    required this.name,
    required this.nameNative,
    required this.flagEmoji,
  });
  final String code;
  final String name;
  final String nameNative;
  final String flagEmoji;
}

const _allLanguages = [
  LanguageOption(
      code: 'de', name: 'German', nameNative: 'Deutsch', flagEmoji: '🇩🇪'),
  LanguageOption(
      code: 'fr', name: 'French', nameNative: 'Français', flagEmoji: '🇫🇷'),
  LanguageOption(
      code: 'es', name: 'Spanish', nameNative: 'Español', flagEmoji: '🇪🇸'),
  LanguageOption(
      code: 'it', name: 'Italian', nameNative: 'Italiano', flagEmoji: '🇮🇹'),
  LanguageOption(
      code: 'tr', name: 'Turkish', nameNative: 'Türkçe', flagEmoji: '🇹🇷'),
];

const _cefrLevels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    final canProceed = state.targetLanguages.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        title: const Text('Step 1 of 4'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar
                  const _OnboardingProgressBar(step: 1),
                  const SizedBox(height: AppSpacing.xl),

                  const Text(
                    'What are you\nlearning?',
                    style: AppTextStyles.displayLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Select one or more target languages.\nYour base language is English.',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.mediumGray),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),

            // Language list
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.xs,
                ),
                itemCount: _allLanguages.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final lang = _allLanguages[index];
                  final isSelected = state.targetLanguages.contains(lang.code);
                  final cefrLevel = state.cefrLevels[lang.code] ?? 'A1';

                  return _LanguageTile(
                    language: lang,
                    isSelected: isSelected,
                    cefrLevel: cefrLevel,
                    onTap: () => notifier.toggleTargetLanguage(lang.code),
                    onCefrChanged: (level) =>
                        notifier.setCefrLevel(lang.code, level),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: WlPrimaryButton(
                label: 'Continue',
                onPressed:
                    canProceed ? () => context.go(AppRoutes.curfewSetup) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.cefrLevel,
    required this.onTap,
    required this.onCefrChanged,
  });

  final LanguageOption language;
  final bool isSelected;
  final String cefrLevel;
  final VoidCallback onTap;
  final ValueChanged<String> onCefrChanged;

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
          children: [
            Row(
              children: [
                Text(language.flagEmoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language.name, style: AppTextStyles.displaySmall),
                      Text(
                        language.nameNative,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.mediumGray,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle,
                      color: AppColors.primaryTeal, size: 22)
                else
                  const Icon(Icons.radio_button_unchecked,
                      color: AppColors.borderGray, size: 22),
              ],
            ),

            // CEFR selector — only shown when selected
            if (isSelected) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Text(
                    'Starting level:',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.mediumGray),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ..._cefrLevels.map((level) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: GestureDetector(
                          onTap: () => onCefrChanged(level),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            width: 36,
                            height: 28,
                            decoration: BoxDecoration(
                              color: cefrLevel == level
                                  ? AppColors.primaryTeal
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: cefrLevel == level
                                    ? AppColors.primaryTeal
                                    : AppColors.borderGray,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                level,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: cefrLevel == level
                                      ? AppColors.white
                                      : AppColors.darkGray,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OnboardingProgressBar extends StatelessWidget {
  const _OnboardingProgressBar({required this.step});
  final int step; // 1–4

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        final filled = index < step;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
            height: 3,
            decoration: BoxDecoration(
              color: filled ? AppColors.primaryTeal : AppColors.lightGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
