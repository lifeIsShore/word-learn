import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';

/// WordLearn ThemeData — Light & Dark
abstract class AppTheme {
  static ThemeData get light => _buildLightTheme();
  static ThemeData get dark => _buildDarkTheme();

  static ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paperWhite,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryTeal,
        secondary: AppColors.primaryTeal,
        surface: AppColors.white,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSurface: AppColors.darkGray,
        onError: AppColors.white,
      ),

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paperWhite,
        foregroundColor: AppColors.darkGray,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: 'Futura',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkGray,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(color: AppColors.darkGray, size: 24),
      ),

      // Elevated Button (Primary CTA)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.lightGray,
          disabledForegroundColor: AppColors.mediumGray,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSpacing.borderRadius)),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // Outlined Button (Secondary)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryTeal,
          side: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSpacing.borderRadius)),
          ),
          textStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryTeal),
        ),
      ),

      // Text Button (Tertiary)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryTeal,
          textStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primaryTeal,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.lightGray, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.borderGray, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.mediumGray),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),

      // Card
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          side: const BorderSide(color: AppColors.lightGray, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.lightGray,
        thickness: 1,
        space: 1,
      ),

      // Text
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.deepNavy,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryTeal,
        secondary: AppColors.iceTeal,
        surface: AppColors.navySecondary,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSurface: AppColors.navyText,
        onError: AppColors.white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.deepNavy,
        foregroundColor: AppColors.navyText,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontFamily: 'Futura',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.navyText,
        ),
        iconTheme: IconThemeData(color: AppColors.navyText, size: 24),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSpacing.borderRadius)),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      cardTheme: CardTheme(
        color: AppColors.navySecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          side: const BorderSide(color: AppColors.navyBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.navySecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.navyBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.navyBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.navyTextSecondary),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.navyTextSecondary),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.navyBorder,
        thickness: 1,
        space: 1,
      ),

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLargeDark,
        displayMedium: AppTextStyles.displayMedium.copyWith(color: AppColors.navyText),
        bodyLarge: AppTextStyles.bodyLargeDark,
        bodyMedium: AppTextStyles.bodyMediumDark,
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.navyTextSecondary),
      ),
    );
  }
}
