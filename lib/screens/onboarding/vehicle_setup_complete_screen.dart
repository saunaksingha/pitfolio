import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_action.dart';

class VehicleSetupCompleteScreen extends StatelessWidget {
  const VehicleSetupCompleteScreen({
    super.key,
    required this.vehicleName,
    required this.make,
    required this.model,
    required this.year,
    required this.odometer,
    this.onEditDetails,
  });

  final String vehicleName;
  final String make;
  final String model;
  final String year;
  final String odometer;

  final VoidCallback? onEditDetails;

  @override
  Widget build(BuildContext context) {
    final dimensions = AppDimensions.pageHorizontalPadding;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Main content.
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: dimensions.w,
                      vertical: AppDimensions.space16.h,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight - AppDimensions.space32.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Success icon.
                          Container(
                            width: 64.w,
                            height: 64.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF3E5),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 29.w,
                              height: 29.w,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 21.sp,
                              ),
                            ),
                          ),

                          SizedBox(height: AppDimensions.space24.h),

                          // Heading.
                          Text(
                            'Your vehicle is ready!',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.pageTitle.copyWith(
                              fontSize: 27.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.7,
                            ),
                          ),

                          SizedBox(height: AppDimensions.space8.h),

                          // Description.
                          Text(
                            'Your vehicle has been added to Pitfolio. '
                            'You can now keep track of its maintenance, '
                            'expenses and documents in one place.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontSize: 15.sp,
                              height: 1.6,
                            ),
                          ),

                          SizedBox(height: AppDimensions.space24.h),

                          // Vehicle summary card.
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppDimensions.space16.w),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              border: Border.all(color: AppColors.divider),
                              borderRadius: AppRadius.largeRadius,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48.w,
                                  height: 48.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F7F8),
                                    border: Border.all(
                                      color: AppColors.divider,
                                    ),
                                    borderRadius: AppRadius.mediumRadius,
                                  ),
                                  child: Icon(
                                    Icons.directions_car_outlined,
                                    size: AppDimensions.iconLarge.sp,
                                    color: AppColors.textPrimary,
                                  ),
                                ),

                                SizedBox(width: AppDimensions.space16.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicleName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.cardTitle,
                                      ),

                                      SizedBox(height: AppDimensions.space4.h),

                                      Text(
                                        '$make $model • $year',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles.bodySecondary
                                            .copyWith(fontSize: 13.sp),
                                      ),

                                      SizedBox(height: AppDimensions.space4.h),

                                      RichText(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          style: AppTextStyles.caption.copyWith(
                                            fontSize: 13.sp,
                                          ),
                                          children: [
                                            const TextSpan(text: 'Odometer: '),
                                            TextSpan(
                                              text: odometer.isEmpty
                                                  ? 'Not provided'
                                                  : '$odometer km',
                                              style: AppTextStyles.body
                                                  .copyWith(fontSize: 13.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom actions.
            Padding(
              padding: EdgeInsets.fromLTRB(
                dimensions.w,
                AppDimensions.space8.h,
                dimensions.w,
                0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed:
                        onEditDetails ?? () => Navigator.of(context).maybePop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      minimumSize: Size(double.infinity, 44.h),
                    ),
                    child: Text(
                      'Edit vehicle details',
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: AppDimensions.space8.h),

                  // Reuse the existing shared button.
                  AppBottomAction(
                    label: 'Continue to Pitfolio',
                    onPressed: () {
                      // TODO: Replace '/home' with your registered
                      // home route when it is available.
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/home', (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
