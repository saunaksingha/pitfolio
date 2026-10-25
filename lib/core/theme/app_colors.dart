import 'package:flutter/material.dart';

/// The single source of truth for Pitfolio's color palette.
///
/// Avoid defining brand colors directly inside individual
/// screens. Change them here to update the whole application.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFFF28C00);
  static const Color primaryPressed = Color(0xFFD97700);
  static const Color primarySoft = Color(0xFFFFF1DF);

  // Text
  static const Color textPrimary = Color(0xFF20212A);
  static const Color textSecondary = Color(0xFF777F91);
  static const Color textDisabled = Color(0xFFA5AAB5);

  // Surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF8F9FB);

  // Borders and dividers
  static const Color border = Color(0xFFE0E4EC);
  static const Color divider = Color(0xFFEBEDF2);
  static const Color progressTrack = Color(0xFFE9E8F5);

  // Feedback
  static const Color success = Color(0xFF27845B);
  static const Color successSoft = Color(0xFFE7F5ED);
  static const Color error = Color(0xFFB42318);
  static const Color errorSoft = Color(0xFFFDECEC);
  static const Color warning = Color(0xFFB76E00);
  static const Color warningSoft = Color(0xFFFFF4D9);

  // Charts and category accents
  static const Color chartBlue = Color(0xFF7898D4);
  static const Color chartBlueSoft = Color(0xFFEDF3FF);
  static const Color chartPeach = Color(0xFFFFD8B8);
  static const Color chartPurple = Color(0xFFDCD4F7);

  // Overlay
  static const Color scrim = Color(0x52000000);
}
