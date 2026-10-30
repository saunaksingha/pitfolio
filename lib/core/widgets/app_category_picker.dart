import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:pitfolio/features/config/category_styles.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppCategoryPicker<T> extends StatelessWidget {
  const AppCategoryPicker({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.subtitle = 'Tap to change category',
    this.sheetTitle = 'Choose a category',
    this.sheetSubtitle = 'Select the category that best describes it.',
  });

  final String label;
  final T value;
  final Map<T, CategoryStyle> options;
  final ValueChanged<T> onChanged;

  final String subtitle;
  final String sheetTitle;
  final String sheetSubtitle;

  Future<void> _showPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimensions.pageHorizontalPadding.w,
              AppDimensions.space8.h,
              AppDimensions.pageHorizontalPadding.w,
              AppDimensions.space24.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sheetTitle,
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppDimensions.space4.h),
                Text(sheetSubtitle, style: AppTextStyles.bodySecondary),
                SizedBox(height: AppDimensions.space16.h),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: AppDimensions.space8.w,
                    mainAxisSpacing: AppDimensions.space8.h,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final entry = options.entries.elementAt(index);

                    final optionValue = entry.key;
                    final style = entry.value;
                    final isSelected = optionValue == value;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: AppRadius.cardRadius,
                        onTap: () {
                          Navigator.of(sheetContext).pop(optionValue);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primarySoft
                                : AppColors.surface,
                            borderRadius: AppRadius.cardRadius,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  color: style.backgroundColor,
                                  borderRadius: AppRadius.mediumRadius,
                                ),
                                child: Icon(
                                  style.icon,
                                  color: style.accentColor,
                                  size: AppDimensions.iconSmall.sp,
                                ),
                              ),
                              SizedBox(height: AppDimensions.space8.h),
                              Text(
                                style.label,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null && selected != value) {
      onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = options[value];

    if (style == null) {
      throw ArgumentError(
        'The selected value "$value" must exist in '
        'AppCategoryPicker options.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.space8.h),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showPicker(context),
            borderRadius: AppRadius.cardRadius,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimensions.space12.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: AppRadius.cardRadius,
              ),
              child: Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: style.backgroundColor,
                      borderRadius: AppRadius.mediumRadius,
                    ),
                    child: Icon(
                      style.icon,
                      color: style.accentColor,
                      size: AppDimensions.iconMedium.sp,
                    ),
                  ),
                  SizedBox(width: AppDimensions.space12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          style.label,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppDimensions.space2.h),
                        Text(subtitle, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconLarge.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
