import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppDropdown extends StatelessWidget {
  final String label;

  /// The selected key, e.g. 'INR', 'km', or 'L'.
  final String value;

  /// Raw options map: key = stored value, value = displayed label.
  /// Example: {'INR': 'Indian Rupee (₹)', 'USD': 'US Dollar (\$)'}
  final Map<String, String> options;

  final ValueChanged<String?> onChanged;
  final String? hint;
  final bool enabled;

  const AppDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Avoid a dropdown assertion if the selected key isn't in options.
    final selectedValue = options.containsKey(value) ? value : null;

    OutlineInputBorder outlineBorder({required Color color, double width = 1}) {
      return OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Don't create an empty label or its vertical gap.
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
          hint: hint == null ? null : Text(hint!),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: AppDimensions.iconLarge.sp,
            color: AppColors.textSecondary,
          ),
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: enabled ? AppColors.surface : AppColors.surfaceSecondary,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space16.w,
              vertical: AppDimensions.space16.h,
            ),
            border: outlineBorder(color: AppColors.border),
            enabledBorder: outlineBorder(color: AppColors.border),
            focusedBorder: outlineBorder(color: AppColors.primary, width: 1.5),
            disabledBorder: outlineBorder(color: AppColors.border),
          ),
          items: options.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
