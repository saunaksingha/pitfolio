import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? prefix;
  final String? suffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  /// Optional inline error message.
  final String? errorText;

  /// Shows a red outline without displaying error text.
  final bool hasError;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.hint,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.errorText,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final showError = hasError || errorText != null;

    OutlineInputBorder outlineBorder({required Color color, double width = 1}) {
      return OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Only render the label and its spacing when a label exists.
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: AppTextStyles.fieldLabel.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.space8.h),
        ],

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.textDisabled,
            ),
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 0, height: 0),
            prefixText: prefix == null ? null : '$prefix ',
            suffixText: suffix,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(
                    prefixIcon,
                    size: AppDimensions.iconMedium.sp,
                    color: AppColors.textSecondary,
                  ),
            suffixIcon: suffixIcon == null
                ? null
                : Icon(
                    suffixIcon,
                    size: AppDimensions.iconMedium.sp,
                    color: AppColors.textSecondary,
                  ),
            filled: true,
            fillColor: enabled ? AppColors.surface : AppColors.surfaceSecondary,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space12.w,
              vertical: AppDimensions.space12.h,
            ),
            border: outlineBorder(color: AppColors.border),
            enabledBorder: outlineBorder(
              color: showError ? AppColors.error : AppColors.border,
            ),
            focusedBorder: outlineBorder(
              color: showError ? AppColors.error : AppColors.primary,
              width: 1.4,
            ),
            errorBorder: outlineBorder(color: AppColors.error),
            focusedErrorBorder: outlineBorder(
              color: AppColors.error,
              width: 1.4,
            ),
            disabledBorder: outlineBorder(color: AppColors.border),
          ),
        ),
      ],
    );
  }
}
