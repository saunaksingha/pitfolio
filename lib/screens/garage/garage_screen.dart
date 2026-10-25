import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import 'vehicle_details_screen.dart';

class GarageScreen extends StatelessWidget {
  final String vehicleName;
  final String make;
  final String model;
  final String year;
  final String odometer;
  final String fuelType;
  final String variant;
  final VoidCallback? onAddVehicle;

  const GarageScreen({
    super.key,
    this.vehicleName = 'My daily car',
    this.make = 'Maruti Suzuki',
    this.model = 'Swift',
    this.year = '2023',
    this.odometer = '24,500 km',
    this.fuelType = 'Petrol',
    this.variant = 'ZXi Manual',
    this.onAddVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: AppDimensions.pageHorizontalPadding.w,
        title: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: AppRadius.smallRadius,
              ),
              child: Icon(
                Icons.directions_car_filled_outlined,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: AppDimensions.space8.w),
            Text(
              'Pitfolio',
              style: AppTextStyles.screenTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Open reminders/notifications.
            },
            tooltip: 'Reminders',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_none_outlined,
                  color: AppColors.textSecondary,
                  size: 25.sp,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.space8.w),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.pageHorizontalPadding.w,
            vertical: AppDimensions.space12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Garage',
                style: AppTextStyles.pageTitle.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppDimensions.space4.h),
              Text(
                'Your vehicles, all in one place.',
                style: AppTextStyles.bodySecondary.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppDimensions.space24.h),

              Material(
                color: AppColors.surface,
                borderRadius: AppRadius.largeRadius,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VehicleDetailsScreen(
                          vehicleName: vehicleName,
                          make: make,
                          model: model,
                          year: year,
                          odometer: odometer,
                          fuelType: fuelType,
                          variant: variant,
                        ),
                      ),
                    );
                  },
                  borderRadius: AppRadius.largeRadius,
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.space16.w),
                    decoration: BoxDecoration(
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
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.15),
                            ),
                            borderRadius: AppRadius.mediumRadius,
                          ),
                          child: Icon(
                            Icons.directions_car_filled,
                            color: AppColors.primary,
                            size: 25.sp,
                          ),
                        ),
                        SizedBox(width: AppDimensions.space12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicleName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: AppDimensions.space4.h),
                              Text(
                                '$make $model · $year',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: AppDimensions.space8.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.speed_outlined,
                                    size: 15.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                  SizedBox(width: AppDimensions.space4.w),
                                  Text(
                                    'Odometer · ',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      odometer,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppDimensions.space8.w),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                          size: 24.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.space20.h),

              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight.h,
                child: ElevatedButton.icon(
                  onPressed: onAddVehicle,
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add vehicle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mediumRadius,
                    ),
                    textStyle: AppTextStyles.button,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
