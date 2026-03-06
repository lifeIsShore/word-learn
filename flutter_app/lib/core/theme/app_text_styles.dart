import 'package:flutter/material.dart';
import 'app_colors.dart';

/// WordLearn Design System — Typography
/// Futura for display, system sans-serif for body
abstract class AppTextStyles {
  // ─── Display (Headlines) ─────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Futura',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.darkGray,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'Futura',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: AppColors.darkGray,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'Futura',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: AppColors.darkGray,
  );

  // ─── Body ─────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.darkGray,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
    color: AppColors.darkGray,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
    color: AppColors.mediumGray,
  );

  // ─── Labels (Buttons, Tags, Caps) ────────────────────────────
  static const TextStyle labelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.3,
    color: AppColors.white,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.3,
    color: AppColors.darkGray,
  );

  // ─── Word Card (Flashcard) ────────────────────────────────────
  static const TextStyle wordDisplay = TextStyle(
    fontFamily: 'Futura',
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
    color: AppColors.darkGray,
  );

  static const TextStyle wordTranslation = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.mediumGray,
  );

  static const TextStyle wordExample = TextStyle(
    fontSize: 14,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.mediumGray,
  );

  // ─── Dark Mode Overrides ─────────────────────────────────────
  static TextStyle get displayLargeDark =>
      displayLarge.copyWith(color: AppColors.navyText);

  static TextStyle get bodyLargeDark =>
      bodyLarge.copyWith(color: AppColors.navyText);

  static TextStyle get bodyMediumDark =>
      bodyMedium.copyWith(color: AppColors.navyText);
}
