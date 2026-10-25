import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.fontFamily,

      // Default text styles for standard Material widgets.
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.pageTitle,
        headlineMedium: AppTextStyles.screenTitle,
        titleLarge: AppTextStyles.sectionTitle,
        titleMedium: AppTextStyles.cardTitle,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
        labelLarge: AppTextStyles.button,
        labelMedium: AppTextStyles.fieldLabel,
        labelSmall: AppTextStyles.helperText,
      ),

      // App-wide background and foreground defaults.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.sectionTitle,
      ),

      // Default filled button appearance.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.45),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.largeRadius,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Secondary outlined actions.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size(0, AppDimensions.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          side: const BorderSide(color: AppColors.border),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.largeRadius,
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Text fields and form inputs.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        labelStyle: AppTextStyles.fieldLabel,
        errorStyle: AppTextStyles.helperText.copyWith(color: AppColors.error),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space16,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.largeRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.largeRadius,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.largeRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.largeRadius,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.largeRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),

      // Dropdown menus.
      dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: AppTextStyles.body,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
        ),
      ),

      // Dividers.
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Checkboxes and selection controls.
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
      ),

      // Floating action buttons.
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
      ),

      // Snackbars.
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.body.copyWith(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.mediumRadius,
        ),
      ),

      // Bottom navigation defaults.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primarySoft,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(AppTextStyles.navigationLabel),
      ),

      // Progress indicators.
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.progressTrack,
        circularTrackColor: AppColors.progressTrack,
      ),

      // Selection handles and text cursor.
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primarySoft,
        selectionHandleColor: AppColors.primary,
      ),
    );
  }
}
