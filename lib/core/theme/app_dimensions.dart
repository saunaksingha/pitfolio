/// Shared dimensions for Pitfolio.
///
/// Values are expressed in logical pixels before optional
/// ScreenUtil scaling. Keep them consistent across screens.
abstract final class AppDimensions {
  // Spacing scale
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;

  // Common screen layout
  static const double pageHorizontalPadding = 20;
  static const double pageVerticalPadding = 24;
  static const double contentMaxWidth = 560;

  // Interactive elements
  static const double buttonHeight = 50;
  static const double inputHeight = 52;
  static const double minimumTapTarget = 48;

  // Icons
  static const double iconSmall = 16;
  static const double iconMedium = 20;
  static const double iconLarge = 24;
  static const double iconExtraLarge = 32;

  // Onboarding progress indicator
  static const double progressHeight = 4;
  static const double progressGap = 4;
  static const double bottomGestureWidth = 128;
  static const double bottomGestureHeight = 4;

  // Common card dimensions
  static const double cardPadding = 16;
  static const double cardGap = 12;
}
