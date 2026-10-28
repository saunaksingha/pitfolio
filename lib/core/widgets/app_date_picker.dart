import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppDatePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  /// Earliest selectable date.
  final DateTime firstDate;

  /// Latest selectable date.
  final DateTime lastDate;

  final String? hint;
  final String? errorText;
  final bool enabled;
  final DateTime? initialDate;
  final DateTime? currentDate;

  /// Optional custom display formatter.
  final String Function(DateTime date)? dateFormatter;

  const AppDatePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.hint = 'Select date',
    this.errorText,
    this.enabled = true,
    this.initialDate,
    this.currentDate,
    this.dateFormatter,
  });

  /// Displays dates like 20th Oct, 2026.
  String _defaultDateFormatter(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = date.day;

    final suffix = (day >= 11 && day <= 13)
        ? 'th'
        : switch (day % 10) {
            1 => 'st',
            2 => 'nd',
            3 => 'rd',
            _ => 'th',
          };

    return '$day$suffix ${months[date.month - 1]}, ${date.year}';
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime _getInitialDate() {
    final preferredDate = value ?? initialDate ?? currentDate ?? DateTime.now();
    final normalizedDate = _dateOnly(preferredDate);
    final first = _dateOnly(firstDate);
    final last = _dateOnly(lastDate);

    if (normalizedDate.isBefore(first)) {
      return first;
    }

    if (normalizedDate.isAfter(last)) {
      return last;
    }

    return normalizedDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!enabled) return;

    final first = _dateOnly(firstDate);
    final last = _dateOnly(lastDate);

    if (first.isAfter(last)) {
      throw ArgumentError('firstDate must be on or before lastDate.');
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _getInitialDate(),
      firstDate: first,
      lastDate: last,
      currentDate: currentDate == null ? null : _dateOnly(currentDate!),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      onChanged(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.trim().isNotEmpty;

    final displayText = value == null
        ? null
        : (dateFormatter ?? _defaultDateFormatter)(value!);

    OutlineInputBorder outlineBorder({required Color color, double width = 1}) {
      return OutlineInputBorder(
        borderRadius: AppRadius.mediumRadius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        InkWell(
          onTap: enabled ? () => _selectDate(context) : null,
          borderRadius: AppRadius.mediumRadius,
          child: InputDecorator(
            isEmpty: displayText == null,
            decoration: InputDecoration(
              filled: true,
              fillColor: enabled
                  ? AppColors.surface
                  : AppColors.surfaceSecondary,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space16.w,
                vertical: AppDimensions.space16.h,
              ),
              errorText: hasError ? errorText!.trim() : null,
              errorMaxLines: 2,
              border: outlineBorder(color: AppColors.border),
              enabledBorder: outlineBorder(
                color: hasError ? AppColors.error : AppColors.border,
                width: hasError ? 1.5 : 1,
              ),
              focusedBorder: outlineBorder(
                color: hasError ? AppColors.error : AppColors.primary,
                width: 1.5,
              ),
              errorBorder: outlineBorder(color: AppColors.error, width: 1.5),
              focusedErrorBorder: outlineBorder(
                color: AppColors.error,
                width: 1.5,
              ),
              disabledBorder: outlineBorder(
                color: hasError ? AppColors.error : AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayText ?? hint ?? 'Select date',
                    style: AppTextStyles.body.copyWith(
                      color: displayText == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppDimensions.iconLarge.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
