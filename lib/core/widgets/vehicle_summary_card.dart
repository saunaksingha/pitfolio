import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class VehicleSummaryCard extends StatelessWidget {
  const VehicleSummaryCard({
    super.key,
    required this.vehicleName,
    required this.make,
    required this.model,
    required this.odometer,
    this.year,
    this.onTap,
  });

  final String vehicleName;
  final String make;
  final String model;
  final String odometer;
  final String? year;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.largeRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.largeRadius,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.space16.w,
            vertical: AppDimensions.space12.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border),
            borderRadius: AppRadius.largeRadius,
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: AppRadius.mediumRadius,
                ),
                child: Icon(
                  Icons.directions_car_outlined,
                  size: AppDimensions.iconLarge.sp,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(width: AppDimensions.space16.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicleName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle,
                    ),

                    SizedBox(height: AppDimensions.space2.h),

                    Text(
                      '$make $model'
                      '${year?.isNotEmpty == true ? ' • $year' : ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 13.sp,
                      ),
                    ),

                    SizedBox(height: AppDimensions.space2.h),

                    RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: AppTextStyles.caption.copyWith(fontSize: 13.sp),
                        children: [
                          const TextSpan(text: 'Odometer: '),
                          TextSpan(
                            text: odometer.isEmpty
                                ? 'Not provided'
                                : '$odometer km',
                            style: AppTextStyles.body.copyWith(fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: AppDimensions.space8.w),

              Icon(
                Icons.unfold_more,
                size: AppDimensions.iconMedium.sp,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
