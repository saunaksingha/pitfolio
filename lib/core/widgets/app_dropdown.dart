import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppDropdown extends StatelessWidget {
  final String label;

  /// The selected key, e.g. 'INR', 'km', or 'L'.
  /// Use an empty string when nothing is selected.
  final String value;

  /// Raw options map: key = stored value, value = displayed label.
  final Map<String, String> options;

  final ValueChanged<String?> onChanged;
  final String? hint;
  final bool enabled;

  /// Error message displayed below the dropdown.
  final String? errorText;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hint,
    this.enabled = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final selectedValue = value.isNotEmpty && options.containsKey(value)
        ? value
        : null;

    final message = errorText?.trim();
    final showError = message != null && message.isNotEmpty;

    final Color secondaryColor = enabled
        ? AppColors.textSecondary
        : AppColors.textDisabled;

    final Color borderColor = showError ? AppColors.error : AppColors.border;

    OutlineInputBorder outlineBorder({required Color color, double width = 1}) {
      return OutlineInputBorder(
        borderRadius: AppRadius.largeRadius,
        borderSide: BorderSide(color: color, width: width),
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

        DropdownButtonFormField<String>(
          initialValue: selectedValue,
          isExpanded: true,

          hint: hint == null
              ? null
              : Text(
                  hint!,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),

          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: AppDimensions.iconLarge.sp,
            color: secondaryColor,
          ),

          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),

          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? AppColors.surface : AppColors.surfaceSecondary,

            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space12.w,
              vertical: AppDimensions.space12.h,
            ),

            border: outlineBorder(color: AppColors.border),

            enabledBorder: outlineBorder(color: borderColor),

            focusedBorder: outlineBorder(
              color: showError ? AppColors.error : AppColors.primary,
              width: 1.4,
            ),

            errorBorder: outlineBorder(color: AppColors.error),

            focusedErrorBorder: outlineBorder(
              color: AppColors.error,
              width: 1.4,
            ),

            disabledBorder: outlineBorder(color: borderColor),
          ),

          items: options.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value, overflow: TextOverflow.ellipsis),
            );
          }).toList(),

          onChanged: enabled ? onChanged : null,
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
