import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/constants/app_languages.dart';
import '../../shared/state/onboarding_provider.dart';

/// WL-013: CEFR Level per target language — dropdown A1–C2, default B1.
class CefrScreen extends ConsumerWidget {
  const CefrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(onboardingProvider);
    final targets = onboarding.targetLanguageCodes;
    final cefrPerTarget = Map<String, String>.from(onboarding.cefrPerTarget);

    // Ensure every target has a CEFR (default B1)
    for (final code in targets) {
      cefrPerTarget.putIfAbsent(code, () => kDefaultCefr);
    }

    final allSet = targets.every((t) => cefrPerTarget[t] != null && cefrPerTarget[t]!.isNotEmpty);

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.onboardingTargetLanguages),
        ),
        title: Text('Proficiency level', style: AppTypography.labelLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'For each language, where are you?',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.mediumGray),
              ),
              SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView(
                  children: targets.map((code) {
                    final lang = kAppLanguages.firstWhere((l) => l.code == code);
                    final current = cefrPerTarget[code] ?? kDefaultCefr;

                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: Row(
                        children: [
                          Text(lang.flagEmoji, style: const TextStyle(fontSize: 22)),
                          SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              lang.name,
                              style: AppTypography.bodyLarge.copyWith(color: AppColors.darkGray),
                            ),
                          ),
                          DropdownButton<String>(
                            value: current,
                            items: kCefrLevels
                                .map((level) => DropdownMenuItem(
                                      value: level,
                                      child: Text(level),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                ref
                                    .read(onboardingProvider.notifier)
                                    .setCefrForTarget(code, value);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              FilledButton(
                onPressed: allSet ? () => context.go(AppRoutes.onboardingCurfew) : null,
                child: const Text('NEXT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
