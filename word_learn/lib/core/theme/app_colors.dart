import 'package:flutter/material.dart';

/// WordLearn color palette — Swiss Modernist, from PRD Design System.
abstract final class AppColors {
  // Primary brand
  static const Color primaryTeal = Color(0xFF008B8B);
  static const Color lightTeal = Color(0xFFE0F2F1);

  // Neutral
  static const Color paperWhite = Color(0xFFFAFAFA);
  static const Color darkGray = Color(0xFF212121);
  static const Color mediumGray = Color(0xFF757575);
  static const Color lightGray = Color(0xFFEBEBEB);

  // Functional
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF0288D1);

  // Ice State (Curfew approaching)
  static const Color iceTeal = Color(0xFF00BCD4);
  static const Color iceBackground = Color(0xFFE0F7FA);

  // Deep Navy (dark mode)
  static const Color deepNavy = Color(0xFF0D1B2A);
  static const Color navyText = Color(0xFFF0F0F0);
}
