import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

class AppBottomAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppBottomAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              textStyle: AppTextStyles.button,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.largeRadius,
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: AppDimensions.iconMedium.w,
                    height: AppDimensions.iconMedium.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(label),
          ),
        ),
        SizedBox(height: AppDimensions.space16.h),
        Center(
          child: Container(
            width: AppDimensions.bottomGestureWidth.w,
            height: AppDimensions.bottomGestureHeight.h,
            decoration: BoxDecoration(
              color: AppColors.progressTrack,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ),
      ],
    );
  }
}
