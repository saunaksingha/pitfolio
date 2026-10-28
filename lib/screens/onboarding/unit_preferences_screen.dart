import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:pitfolio/screens/onboarding/add_vehicle_screen.dart';

import '../../core/constants/app_options.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_action.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_page_header.dart';

/// The preferences selected by the user during onboarding.
class UnitPreferencesScreen extends StatefulWidget {
  const UnitPreferencesScreen({super.key});

  @override
  State<UnitPreferencesScreen> createState() => _UnitPreferencesScreenState();
}

class _UnitPreferencesScreenState extends State<UnitPreferencesScreen> {
  // Store option keys, not their display labels.
  String _currency = 'INR';
  String _distanceUnit = 'km';
  String _fuelCapacityUnit = 'L';

  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _handleContinue() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final preferences = UnitPreferencesData(
        currency: _currency,
        distanceUnit: _distanceUnit,
        fuelCapacityUnit: _fuelCapacityUnit,
      );

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AddVehicleScreen(preferences: preferences),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Unable to continue onboarding: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _errorMessage = 'Could not continue. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 1 of 2',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13.sp,
              ),
            ),
            Text(
              'Vehicle Setup',
              style: AppTextStyles.caption.copyWith(fontSize: 13.sp),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.space8.h),
        Row(
          children: [
            const Expanded(child: _ProgressSegment(color: AppColors.primary)),
            SizedBox(width: AppDimensions.progressGap.w),
            const Expanded(
              child: _ProgressSegment(color: AppColors.progressTrack),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.surface,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Same reusable header as Vehicle Profile Setup.
              const AppPageHeader(
                title: 'Your preferences',
                showBackButton: false,
                //  showBackButton: false,
              ),

              // Keep the header fixed while the content scrolls.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.pageHorizontalPadding.w,
                        vertical: AppDimensions.space24.h,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              (constraints.maxHeight - AppDimensions.space48.h)
                                  .clamp(0.0, double.infinity)
                                  .toDouble(),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Onboarding progress labels.
                            _buildProgress(),

                            SizedBox(height: AppDimensions.space24.h),

                            Text(
                              'Your preferences',
                              style: AppTextStyles.pageTitle,
                            ),

                            SizedBox(height: AppDimensions.space4.h),

                            Text(
                              'Set your preferred units for tracking costs, '
                              'fuel, and mileage. You can change these '
                              'anytime in Settings.',
                              style: AppTextStyles.bodySecondary,
                            ),

                            SizedBox(height: AppDimensions.space24.h),

                            // Currency dropdown starts here.
                            // Currency dropdown.
                            AppDropdown(
                              label: 'Currency',
                              value: _currency,
                              options: currencies,
                              onChanged: (value) {
                                if (value == null) return;

                                setState(() => _currency = value);
                              },
                            ),

                            SizedBox(height: AppDimensions.space20.h),

                            // Distance unit dropdown.
                            AppDropdown(
                              label: 'Distance unit',
                              value: _distanceUnit,
                              options: distanceUnits,
                              onChanged: (value) {
                                if (value == null) return;

                                setState(() => _distanceUnit = value);
                              },
                            ),

                            SizedBox(height: AppDimensions.space20.h),

                            // Fuel capacity dropdown.
                            AppDropdown(
                              label: 'Fuel capacity',
                              value: _fuelCapacityUnit,
                              options: fuelCapacityUnits,
                              onChanged: (value) {
                                if (value == null) return;

                                setState(() => _fuelCapacityUnit = value);
                              },
                            ),

                            // Display errors if Continue fails.
                            if (_errorMessage != null) ...[
                              SizedBox(height: AppDimensions.space16.h),
                              Text(
                                _errorMessage!,
                                style: AppTextStyles.helperText.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ],

                            SizedBox(height: AppDimensions.space48.h),

                            // Continue button.
                            AppBottomAction(
                              label: 'Continue',
                              onPressed: _isSubmitting ? null : _handleContinue,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One segment of the onboarding progress indicator.
class _ProgressSegment extends StatelessWidget {
  const _ProgressSegment({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.progressHeight.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}

/// The preferences selected by the user.
class UnitPreferencesData {
  final String currency;
  final String distanceUnit;
  final String fuelCapacityUnit;

  const UnitPreferencesData({
    required this.currency,
    required this.distanceUnit,
    required this.fuelCapacityUnit,
  });
}
