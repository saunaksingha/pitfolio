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
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool readOnly;
  final bool enabled;

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  final String? errorText;

  const AppTextField({
    super.key,
    this.label = '',
    required this.controller,
    this.hint = '',
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.textInputAction,
    this.errorText,
  }) : assert(
         maxLines == null || minLines == null || minLines <= maxLines,
         'minLines cannot exceed maxLines.',
       );

  @override
  Widget build(BuildContext context) {
    final message = errorText?.trim();
    final showError = message != null && message.isNotEmpty;

    final Color secondaryColor = enabled
        ? AppColors.textSecondary
        : AppColors.textDisabled;

    final Color decorationColor = showError
        ? AppColors.error
        : AppColors.border;

    OutlineInputBorder outlineBorder({required Color color, double width = 1}) {
      return OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    Widget? buildPrefix() {
      if (prefix == null && prefixIcon == null) {
        return null;
      }

      return Padding(
        padding: EdgeInsets.only(
          left: AppDimensions.space12.w,
          right: AppDimensions.space8.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null)
              Icon(
                prefixIcon,
                size: AppDimensions.iconMedium.sp,
                color: secondaryColor,
              ),
            if (prefix != null)
              Text(
                prefix!,
                style: AppTextStyles.body.copyWith(color: secondaryColor),
              ),
          ],
        ),
      );
    }

    Widget? buildSuffix() {
      if (suffix == null && suffixIcon == null) {
        return null;
      }

      return Padding(
        padding: EdgeInsets.only(
          left: AppDimensions.space8.w,
          right: AppDimensions.space12.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (suffix != null)
              Text(
                suffix!,
                style: AppTextStyles.body.copyWith(
                  color: showError ? AppColors.error : secondaryColor,
                ),
              ),
            if (suffix != null && suffixIcon != null)
              SizedBox(width: AppDimensions.space8.w),
            if (suffixIcon != null)
              Icon(
                suffixIcon,
                size: AppDimensions.iconMedium.sp,
                color: showError ? AppColors.error : secondaryColor,
              ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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
          minLines: minLines,
          maxLength: maxLength,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          textInputAction: textInputAction,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body.copyWith(
              color: AppColors.textDisabled,
            ),

            prefixIcon: buildPrefix(),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),

            suffixIcon: buildSuffix(),
            suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 48.h),

            filled: true,
            fillColor: enabled ? AppColors.surface : AppColors.surfaceSecondary,

            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space12.w,
              vertical: AppDimensions.space12.h,
            ),

            border: outlineBorder(color: AppColors.border),
            enabledBorder: outlineBorder(color: decorationColor),
            focusedBorder: outlineBorder(
              color: showError ? AppColors.error : AppColors.primary,
              width: 1.4,
            ),
            disabledBorder: outlineBorder(color: decorationColor),
          ),
        ),

        if (showError) ...[
          SizedBox(height: AppDimensions.space4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline, size: 16.sp, color: AppColors.error),
              SizedBox(width: AppDimensions.space4.w),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
