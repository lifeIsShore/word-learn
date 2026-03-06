/// WordLearn Design System — Spacing
/// 8px grid system
abstract class AppSpacing {
  static const double xs = 4.0;   // 0.5x
  static const double sm = 8.0;   // 1x (base unit)
  static const double md = 16.0;  // 2x
  static const double lg = 24.0;  // 3x
  static const double xl = 32.0;  // 4x
  static const double xxl = 48.0; // 6x
  static const double xxxl = 64.0; // 8x

  // Common layout values
  static const double screenPadding = 24.0;
  static const double cardPadding = 20.0;
  static const double buttonHeight = 52.0;
  static const double inputHeight = 56.0;
  static const double borderRadius = 4.0;   // Sharp corners (Swiss style)
  static const double cardBorderRadius = 6.0;
  static const double iconSize = 24.0;
  static const double iconSizeSm = 18.0;
  static const double iconSizeLg = 32.0;

  // Touch targets (min 44px per accessibility guidelines)
  static const double minTouchTarget = 44.0;
}
