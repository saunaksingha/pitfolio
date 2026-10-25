import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_action.dart';
import '../../core/widgets/app_text_field.dart';

class OdometerUpdateScreen extends StatefulWidget {
  const OdometerUpdateScreen({
    super.key,
    required this.currentOdometer,
    required this.vehicleName,
    required this.make,
    required this.model,
    required this.year,
  });

  final int currentOdometer;
  final String vehicleName;
  final String make;
  final String model;
  final String year;

  @override
  State<OdometerUpdateScreen> createState() => _OdometerUpdateScreenState();
}

class _OdometerUpdateScreenState extends State<OdometerUpdateScreen> {
  late final TextEditingController _odometerController;
  late final TextEditingController _dateController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;
  bool _isSaving = false;
  String? _odometerError;

  int? get _newOdometer {
    final value = int.tryParse(
      _odometerController.text.replaceAll(',', '').trim(),
    );
    return value;
  }

  int get _distanceDifference =>
      (_newOdometer ?? widget.currentOdometer) - widget.currentOdometer;

  @override
  void initState() {
    super.initState();

    _selectedDate = DateTime.now();
    _odometerController = TextEditingController(
      text: _formatNumber(widget.currentOdometer),
    );
    _dateController = TextEditingController(text: _formatDate(_selectedDate));
    _notesController = TextEditingController();

    _odometerController.addListener(_validateOdometer);
  }

  @override
  void dispose() {
    _odometerController.removeListener(_validateOdometer);
    _odometerController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _validateOdometer() {
    final value = _newOdometer;
    String? error;

    if (_odometerController.text.trim().isEmpty) {
      error = 'Enter the new odometer reading.';
    } else if (value == null) {
      error = 'Enter a valid whole-number reading.';
    } else if (value < widget.currentOdometer) {
      error =
          'Reading must be at least ${_formatNumber(widget.currentOdometer)} km.';
    }

    if (error != _odometerError && mounted) {
      setState(() => _odometerError = error);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    setState(() {
      _selectedDate = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  Future<void> _saveReading() async {
    _validateOdometer();

    if (_odometerError != null || _newOdometer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_odometerError ?? 'Enter a valid reading.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Return the new reading to the dashboard.
      // Persistent storage will be connected later.
      if (!mounted) return;
      Navigator.of(context).pop<int>(_newOdometer);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _formatNumber(int value) {
    final digits = value.toString();
    return digits.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final today = DateTime.now();
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    return '${isToday ? 'Today, ' : ''}${date.day} ${months[date.month - 1]}';
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
                    _buildVehicleCard(),
                    SizedBox(height: AppDimensions.space24.h),

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
                      hint: 'Enter odometer reading',
                      suffix: 'km',
                      keyboardType: TextInputType.number,
                    ),

                    if (_odometerError != null) ...[
                      SizedBox(height: AppDimensions.space8.h),
                      Text(
                        _odometerError!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ] else ...[
                      SizedBox(height: AppDimensions.space8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 15.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: AppDimensions.space8.w),
                          Expanded(
                            child: Text(
                              'Must be equal to or higher than your '
                              'previous reading '
                              '(${_formatNumber(widget.currentOdometer)} km).',
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (_distanceDifference >= 0) ...[
                      SizedBox(height: AppDimensions.space8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space12.w,
                          vertical: AppDimensions.space8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 14.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: AppDimensions.space4.w),
                            Text(
                              '+${_formatNumber(_distanceDifference)} km since last update',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.warning,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    SizedBox(height: AppDimensions.space20.h),

                    AppTextField(
                      label: 'Date recorded',
                      hint: "",
                      controller: _dateController,
                      readOnly: true,
                      suffixIcon: Icons.calendar_today_outlined,
                      onTap: _selectDate,
                    ),

                    SizedBox(height: AppDimensions.space16.h),

                    Row(
                      children: [
                        Text(
                          'Notes (Optional)',
                          style: AppTextStyles.fieldLabel,
                        ),
                        const Spacer(),
                        Text(
                          'Optional',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.space8.h),

                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      minLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText:
                            'Add a note about this reading (e.g. after road trip)...',
                        hintStyle: AppTextStyles.bodySecondary.copyWith(
                          fontSize: 14.sp,
                          height: 1.5,
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: EdgeInsets.all(AppDimensions.space16.w),
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.largeRadius,
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppRadius.largeRadius,
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: AppRadius.largeRadius,
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
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
                    isLoading: _isSaving,
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

  Widget _buildVehicleCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16.w),
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
              Icons.directions_car_filled_outlined,
              color: AppColors.primary,
              size: AppDimensions.iconLarge.sp,
            ),
          ),
          SizedBox(width: AppDimensions.space16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehicleName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 15.sp),
                ),
                SizedBox(height: AppDimensions.space4.h),
                Text(
                  '${widget.make} ${widget.model} · ${widget.year}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(fontSize: 12.sp),
                ),
                SizedBox(height: AppDimensions.space4.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space8.w,
                    vertical: AppDimensions.space2.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    'Current: ${_formatNumber(widget.currentOdometer)} km',
                    style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.unfold_more,
            color: AppColors.textSecondary,
            size: AppDimensions.iconMedium.sp,
          ),
        ],
      ),
    );
  }
}
