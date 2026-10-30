import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:pitfolio/core/widgets/app_date_picker.dart';
import 'package:pitfolio/models/odometer.dart';
import 'package:pitfolio/models/vehicle.dart';
import 'package:pitfolio/repositories/odometer_repository.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_action.dart';
import '../../core/widgets/app_text_field.dart';

class OdometerUpdateScreen extends StatefulWidget {
  const OdometerUpdateScreen({super.key, required this._selectedVehicleModel});

  final VehicleModel _selectedVehicleModel;
  @override
  State<OdometerUpdateScreen> createState() => _OdometerUpdateScreenState();
}

class _OdometerUpdateScreenState extends State<OdometerUpdateScreen> {
  late VehicleModel _selectedVehicleModel;

  late final TextEditingController _odometerController;
  late final TextEditingController _notesController;

  String? _odometerInputErrorText;
  String? _odometerRecordDateErrorText;

  bool _isSaving = false;

  DateTime? _recordDate;

  int? get _newOdometer {
    final value = int.tryParse(
      _odometerController.text.replaceAll(',', '').trim(),
    );
    return value;
  }

  @override
  void initState() {
    super.initState();
    _selectedVehicleModel = widget._selectedVehicleModel;
    _odometerController = TextEditingController();

    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _validateOdometer() {
    final value = _newOdometer;
    String? error;

    if (_odometerController.text.trim().isEmpty) {
      error = 'Enter the new odometer reading.';
    } else if (value == null) {
      error = 'Enter a valid whole-number reading.';
    }

    if (error != null && error.isNotEmpty) {
      setState(() {
        _odometerInputErrorText = error;
      });
      return false;
    }

    if (_recordDate == null) {
      setState(() {
        _odometerRecordDateErrorText = "Select a record date";
      });
    }

    return true;
  }

  Future<void> _saveReading() async {
    if (_isSaving) {
      return;
    }

    if (_validateOdometer()) {
      _isSaving = true;
      OdometerModel record = OdometerModel(
        vehicleId: _selectedVehicleModel.id!,
        odometerReading: _newOdometer!,
        notes: _notesController.text,
        recordedAt: _recordDate!.toIso8601String(),
      );
      final result = await OdometerRepository.instance.addOdometerRecord(
        _selectedVehicleModel.id!,
        record,
      );

      if (!result.isSuccess) {
        setState(() {
          _isSaving = false;
          _odometerInputErrorText = result.errorMessage;
        });
      } else {
        if (result.isLatestRecord) {
          // Update your selected vehicle's currentOdometer
          // and return the updated VehicleModel if needed.
          widget._selectedVehicleModel.currentOdometer = _newOdometer!;
          Navigator.of(context).pop<VehicleModel>(widget._selectedVehicleModel);
        } else {
          Navigator.of(context).pop<VehicleModel>(widget._selectedVehicleModel);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.pageHorizontalPadding.w,
                  AppDimensions.space16.h,
                  AppDimensions.pageHorizontalPadding.w,
                  AppDimensions.space24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update your odometer',
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 27.sp),
                    ),
                    SizedBox(height: AppDimensions.space4.h),
                    Text(
                      "Keep your vehicle's mileage accurate.",
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),

                    SizedBox(height: AppDimensions.space24.h),

                    AppTextField(
                      label: 'New odometer reading',
                      controller: _odometerController,
                      errorText: _odometerInputErrorText,
                      hint: 'Enter odometer reading',
                      suffix: 'km',
                      keyboardType: TextInputType.number,
                      onChanged: (_) {
                        if (_odometerInputErrorText != null &&
                            _odometerInputErrorText!.isNotEmpty) {
                          setState(() {
                            _odometerInputErrorText = null;
                          });
                        }
                      },
                    ),

                    SizedBox(height: AppDimensions.space16.h),

                    AppDatePicker(
                      label: 'Update date',
                      value: _recordDate,
                      hint: 'e.g. 15 Oct 2023',
                      errorText: _odometerRecordDateErrorText,
                      firstDate: DateTime(1980),
                      lastDate: DateTime.now(),
                      onChanged: (date) {
                        _odometerRecordDateErrorText = null;
                        setState(() {
                          _recordDate = date;
                        });
                      },
                    ),

                    SizedBox(height: AppDimensions.space16.h),
                    AppTextField(
                      label: 'Notes (Optional)',
                      controller: _notesController,
                      hint:
                          'Add a note about this reading (e.g. after road trip)...',
                      maxLines: 5,
                      minLines: 5,
                      textInputAction: TextInputAction.newline,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.pageHorizontalPadding.w,
                AppDimensions.space8.h,
                AppDimensions.pageHorizontalPadding.w,
                AppDimensions.space8.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBottomAction(
                    label: 'Save odometer reading',

                    onPressed: _isSaving ? null : _saveReading,
                  ),
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space16.w,
        vertical: AppDimensions.space4.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
            tooltip: 'Back',
          ),
          SizedBox(width: AppDimensions.space4.w),
          Expanded(
            child: Text(
              'Odometer Update',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: const BoxDecoration(
              color: Color(0xFF995500),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: AppDimensions.iconMedium.sp,
            ),
          ),
        ],
      ),
    );
  }
}
