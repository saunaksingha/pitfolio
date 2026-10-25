import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.version = 'v1.0'});

  final String version;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Show the splash screen briefly, then move to onboarding.
    // The timer is cancelled if the screen is disposed early.
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed('/preferences');
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              // Center the logo, title and tagline as one group.
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space24.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/pitfolio_logo.png',
                        width: 88.w,
                        height: 88.w,
                        fit: BoxFit.contain,
                        semanticLabel: 'Pitfolio logo',
                      ),
                      SizedBox(height: AppDimensions.space24.h),
                      Text(
                        'Pitfolio',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.pageTitle.copyWith(
                          fontSize: 30.sp,
                        ),
                      ),
                      SizedBox(height: AppDimensions.space8.h),
                      Text(
                        'Manage Maintenance, Expenses &\nDocuments.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySecondary.copyWith(
                          fontSize: 16.sp,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Keep the loader and version near the bottom.
              Positioned(
                left: 0,
                right: 0,
                bottom: AppDimensions.space32.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: AppDimensions.iconMedium.w,
                      height: AppDimensions.iconMedium.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                        backgroundColor: AppColors.border,
                      ),
                    ),
                    SizedBox(height: AppDimensions.space16.h),
                    Text(
                      widget.version,
                      style: AppTextStyles.caption.copyWith(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
