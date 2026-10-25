import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../../models/logbook_entry.dart';
import 'logbook_item.dart';

class LogbookDateGroup extends StatelessWidget {
  const LogbookDateGroup({
    super.key,
    required this.group,
    this.showBottomSpacing = true,
  });

  final LogbookDateGroupData group;
  final bool showBottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: showBottomSpacing ? AppDimensions.space20.h : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.date,
            style: AppTextStyles.caption.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
          SizedBox(height: AppDimensions.space12.h),
          for (int i = 0; i < group.entries.length; i++) ...[
            LogbookItem(entry: group.entries[i]),
            if (i < group.entries.length - 1) ...[
              SizedBox(height: AppDimensions.space16.h),
              Divider(height: 1, thickness: 1, color: AppColors.divider),
              SizedBox(height: AppDimensions.space16.h),
            ],
          ],
        ],
      ),
    );
  }
}
