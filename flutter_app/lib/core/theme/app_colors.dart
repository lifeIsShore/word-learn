import 'package:flutter/material.dart';

/// WordLearn Design System — Color Palette
/// Based on Swiss Modernist aesthetic from PRD
abstract class AppColors {
  // ─── Primary Brand ───────────────────────────────────────────
  static const Color primaryTeal = Color(0xFF008B8B);
  static const Color primaryTealDark = Color(0xFF006666);
  static const Color lightTeal = Color(0xFFE0F2F1);

  // ─── Neutral Palette ─────────────────────────────────────────
  static const Color paperWhite = Color(0xFFFAFAFA);
  static const Color darkGray = Color(0xFF212121);
  static const Color mediumGray = Color(0xFF757575);
  static const Color lightGray = Color(0xFFEBEBEB);
  static const Color borderGray = Color(0xFFD0D0D0);

  // ─── Functional / Semantic ───────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFC62828);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF0288D1);
  static const Color infoLight = Color(0xFFE1F5FE);

  // ─── Ice State (Curfew approaching) ──────────────────────────
  static const Color iceTeal = Color(0xFF00BCD4);
  static const Color iceBackground = Color(0xFFE0F7FA);
  static const Color iceBorder = Color(0xFF80DEEA);

  // ─── Deep Navy (Dark Mode) ────────────────────────────────────
  static const Color deepNavy = Color(0xFF0D1B2A);
  static const Color navySecondary = Color(0xFF1A2E42);
  static const Color navyText = Color(0xFFF0F0F0);
  static const Color navyTextSecondary = Color(0xFFB0BEC5);
  static const Color navyBorder = Color(0xFF2A3F54);

  // ─── Difficulty Rating Colors ─────────────────────────────────
  static const Color difficultyHard = Color(0xFFC62828);
  static const Color difficultyFamiliar = Color(0xFFF57C00);
  static const Color difficultyOk = Color(0xFF0288D1);
  static const Color difficultyEasy = Color(0xFF2E7D32);

  // ─── White / Overlay ─────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color overlay = Color(0x80000000);
}
