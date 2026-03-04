import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// WordLearn light theme — Paper White, Teal accent.
class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryTeal,
        onPrimary: Colors.white,
        surface: AppColors.paperWhite,
        onSurface: AppColors.darkGray,
        onSurfaceVariant: AppColors.mediumGray,
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.paperWhite,
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.darkGray),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.darkGray),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.darkGray),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.darkGray),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paperWhite,
        foregroundColor: AppColors.darkGray,
        elevation: 0,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.iceTeal,
        onPrimary: AppColors.deepNavy,
        surface: AppColors.deepNavy,
        onSurface: AppColors.navyText,
        onSurfaceVariant: AppColors.mediumGray,
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.deepNavy,
      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(color: AppColors.navyText),
        displayMedium: AppTypography.displayMedium.copyWith(color: AppColors.navyText),
        bodyLarge: AppTypography.bodyLarge.copyWith(color: AppColors.navyText),
        bodyMedium: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
        labelLarge: AppTypography.labelLarge.copyWith(color: AppColors.navyText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.iceTeal,
          foregroundColor: AppColors.deepNavy,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepNavy,
        foregroundColor: AppColors.navyText,
        elevation: 0,
      ),
    );
  }
}
