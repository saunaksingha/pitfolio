import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/constants/app_options.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_action.dart';
import '../../core/widgets/app_dropdown.dart';

/// The preferences selected by the user during onboarding.
///
/// The selected keys are passed to the caller, which can later
/// validate and persist them using a controller or repository.
class UnitPreferencesData {
  const UnitPreferencesData({
    required this.currency,
    required this.distanceUnit,
    required this.fuelCapacityUnit,
  });

  final String currency;
  final String distanceUnit;
  final String fuelCapacityUnit;
}

class UnitPreferencesScreen extends StatefulWidget {
  const UnitPreferencesScreen({super.key, required this.onContinue});

  /// The caller decides what happens with these preferences.
  final Future<void> Function(UnitPreferencesData preferences) onContinue;

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

    final preferences = UnitPreferencesData(
      currency: _currency,
      distanceUnit: _distanceUnit,
      fuelCapacityUnit: _fuelCapacityUnit,
    );

    try {
      // Pass the selected preferences to the caller.
      // This screen does not handle persistence itself.
      await widget.onContinue(preferences);
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.pageHorizontalPadding.w,
                  vertical: AppDimensions.space24.h,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (constraints.maxHeight - AppDimensions.space48.h)
                        .clamp(0.0, double.infinity)
                        .toDouble(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Onboarding progress labels.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Step 1 of 3',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 13.sp,
                            ),
                          ),
                          Text(
                            'Vehicle Setup',
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppDimensions.space8.h),

                      // Three-part onboarding progress indicator.
                      Row(
                        children: [
                          const Expanded(
                            child: _ProgressSegment(color: AppColors.primary),
                          ),
                          SizedBox(width: AppDimensions.progressGap.w),
                          const Expanded(
                            child: _ProgressSegment(
                              color: AppColors.progressTrack,
                            ),
                          ),
                          SizedBox(width: AppDimensions.progressGap.w),
                          const Expanded(
                            child: _ProgressSegment(
                              color: AppColors.progressTrack,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppDimensions.space32.h),

                      Text('Your preferences', style: AppTextStyles.pageTitle),

                      SizedBox(height: AppDimensions.space8.h),

                      Text(
                        'Set your preferred units for tracking costs, '
                        'fuel, and mileage. You can change these '
                        'anytime in Settings.',
                        style: AppTextStyles.bodySecondary,
                      ),

                      SizedBox(height: AppDimensions.space32.h),

                      // Reusable dropdown: options come from app_options.dart.
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

                      AppDropdown(
                        label: 'Fuel capacity',
                        value: _fuelCapacityUnit,
                        options: fuelCapacityUnits,
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() => _fuelCapacityUnit = value);
                        },
                      ),

                      // Show an error if the Continue action fails.
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

                      // Shared button, loading state, and gesture indicator.
                      AppBottomAction(
                        label: 'Continue',
                        isLoading: _isSubmitting,
                        onPressed: _isSubmitting ? null : _handleContinue,
                      ),
                    ],
                  ),
                ),
              );
            },
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
