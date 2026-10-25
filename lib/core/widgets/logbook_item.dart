import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../../models/logbook_entry.dart';

class LogbookItem extends StatelessWidget {
  const LogbookItem({super.key, required this.entry});

  final LogbookEntry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: entry.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            entry.icon,
            size: AppDimensions.iconMedium.sp,
            color: entry.accentColor,
          ),
        ),
        SizedBox(width: AppDimensions.space12.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14.sp),
              ),
              SizedBox(height: AppDimensions.space2.h),
              Text(
                entry.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 12.sp,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: AppDimensions.space8.w),

        Flexible(
          flex: 0,
          child: Container(
            constraints: BoxConstraints(maxWidth: 100.w),
            child: Text(
              entry.amount,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: _isPositiveDistance(entry.amount)
                    ? entry.accentColor
                    : AppColors.textPrimary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _isPositiveDistance(String amount) {
    return amount.startsWith('+');
  }
}
