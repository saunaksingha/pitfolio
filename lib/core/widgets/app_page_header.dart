import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

class AppPageHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AppPageHeader({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space16.w,
        vertical: AppDimensions.space8.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        height: 48.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Centered independently of the side elements.
            Positioned.fill(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 56.w),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle,
                  ),
                ),
              ),
            ),

            // Back button on the left.
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                  tooltip: 'Go back',
                ),
              ),

            // Profile icon on the right.
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: AppDimensions.iconExtraLarge.w,
                height: AppDimensions.iconExtraLarge.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: AppDimensions.iconMedium.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
