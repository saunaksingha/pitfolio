import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/constants/app_options.dart' as app_options;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_action.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';

class FuelRefillResult {
  const FuelRefillResult({
    required this.fuelType,
    required this.date,
    required this.odometer,
    required this.quantity,
    required this.totalCost,
    required this.fuelStation,
    required this.isFullTank,
    required this.notes,
  });

  /// Stores the key from app_options.fuelTypes, e.g. 'petrol'.
  final String fuelType;
  final DateTime date;
  final int odometer;
  final double quantity;
  final double totalCost;
  final String fuelStation;
  final bool isFullTank;
  final String notes;

  double get pricePerLitre => quantity > 0 ? totalCost / quantity : 0;

  String get fuelTypeLabel => app_options.fuelTypes[fuelType] ?? fuelType;
}

class FuelRefillScreen extends StatefulWidget {
  const FuelRefillScreen({
    super.key,
    required this.vehicleName,
    required this.make,
    required this.model,
    required this.year,
    required this.currentOdometer,
    this.initialFuelType = 'petrol',
  });

  final String vehicleName;
  final String make;
  final String model;
  final String year;
  final int currentOdometer;
  final String initialFuelType;

  @override
  State<FuelRefillScreen> createState() => _FuelRefillScreenState();
}

class _FuelRefillScreenState extends State<FuelRefillScreen> {
  late final TextEditingController _odometerController;
  late final TextEditingController _quantityController;
  late final TextEditingController _costController;
  late final TextEditingController _stationController;
  late final TextEditingController _notesController;

  late DateTime _refillDate;
  late String _fuelType;

  bool _isFullTank = false;
  bool _isSaving = false;

  bool _odometerHasError = false;
  bool _quantityHasError = false;
  bool _costHasError = false;

  double get _quantity => double.tryParse(_quantityController.text.trim()) ?? 0;

  double get _totalCost =>
      double.tryParse(_costController.text.replaceAll(',', '').trim()) ?? 0;

  double get _pricePerLitre =>
      _quantity > 0 && _totalCost > 0 ? _totalCost / _quantity : 0;

  @override
  void initState() {
    super.initState();

    _refillDate = DateTime.now();
    _fuelType = app_options.fuelTypes.containsKey(widget.initialFuelType)
        ? widget.initialFuelType
        : app_options.fuelTypes.keys.first;

    _odometerController = TextEditingController(
      text: _formatNumber(widget.currentOdometer),
    );
    _quantityController = TextEditingController();
    _costController = TextEditingController();
    _stationController = TextEditingController();
    _notesController = TextEditingController();

    _quantityController.addListener(_refreshPrice);
    _costController.addListener(_refreshPrice);
  }

  @override
  void dispose() {
    _quantityController.removeListener(_refreshPrice);
    _costController.removeListener(_refreshPrice);

    _odometerController.dispose();
    _quantityController.dispose();
    _costController.dispose();
    _stationController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  void _refreshPrice() {
    if (mounted) setState(() {});
  }

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
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

    final formattedDate = '${date.day} ${months[date.month - 1]}, ${date.year}';

    return isToday ? 'Today, $formattedDate' : formattedDate;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _refillDate,
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

    if (selected == null || !mounted) return;

    setState(() => _refillDate = selected);
  }

  Future<void> _saveFuelRecord() async {
    if (_isSaving) return;

    final odometer = int.tryParse(
      _odometerController.text.replaceAll(',', '').trim(),
    );

    final quantity = _quantity;
    final totalCost = _totalCost;

    final odometerInvalid =
        odometer == null || odometer < widget.currentOdometer;
    final quantityInvalid = quantity <= 0;
    final costInvalid = totalCost <= 0;

    setState(() {
      _odometerHasError = odometerInvalid;
      _quantityHasError = quantityInvalid;
      _costHasError = costInvalid;
    });

    if (odometerInvalid) {
      _showSnackBar(
        'Enter an odometer reading of at least '
        '${_formatNumber(widget.currentOdometer)} km.',
      );
      return;
    }

    if (quantityInvalid || costInvalid) {
      if (quantityInvalid && costInvalid) {
        _showSnackBar(
          'Enter a fuel quantity and total cost greater than zero.',
        );
      } else if (quantityInvalid) {
        _showSnackBar('Enter a fuel quantity greater than zero.');
      } else {
        _showSnackBar('Enter a total cost greater than zero.');
      }
      return;
    }

    setState(() => _isSaving = true);

    try {
      final result = FuelRefillResult(
        fuelType: _fuelType,
        date: _refillDate,
        odometer: odometer,
        quantity: quantity,
        totalCost: totalCost,
        fuelStation: _stationController.text.trim(),
        isFullTank: _isFullTank,
        notes: _notesController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pop<FuelRefillResult>(result);
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
                  AppDimensions.space8.h,
                  AppDimensions.pageHorizontalPadding.w,
                  AppDimensions.space24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVehicleCard(),
                    SizedBox(height: AppDimensions.space24.h),
                    Text(
                      'Log a fuel refill',
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 27.sp),
                    ),
                    SizedBox(height: AppDimensions.space4.h),
                    Text(
                      'Track fuel spending, quantities and efficiency.',
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: AppDimensions.space24.h),
                    _buildFuelTypeDropdown(),
                    SizedBox(height: AppDimensions.space16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDateField()),
                        SizedBox(width: AppDimensions.space12.w),
                        Expanded(child: _buildOdometerField()),
                      ],
                    ),
                    SizedBox(height: AppDimensions.space16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildQuantityField()),
                        SizedBox(width: AppDimensions.space12.w),
                        Expanded(child: _buildCostField()),
                      ],
                    ),
                    SizedBox(height: AppDimensions.space16.h),
                    _buildPriceSummary(),
                    SizedBox(height: AppDimensions.space16.h),
                    _buildStationField(),
                    SizedBox(height: AppDimensions.space16.h),
                    _buildFullTankOption(),
                    SizedBox(height: AppDimensions.space16.h),
                    _buildNotesField(),
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
                    label: 'Save fuel record',
                    isLoading: _isSaving,
                    onPressed: _isSaving ? null : _saveFuelRecord,
                  ),
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).maybePop(),
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
              'Fuel Refill',
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
      padding: EdgeInsets.all(AppDimensions.space12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
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
          SizedBox(width: AppDimensions.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehicleName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14.sp),
                ),
                Text(
                  '${widget.make} ${widget.model}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(fontSize: 12.sp),
                ),
                Text(
                  widget.year,
                  style: AppTextStyles.caption.copyWith(fontSize: 12.sp),
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

  Widget _buildFuelTypeDropdown() {
    return AppDropdown(
      label: 'Fuel type',
      value: _fuelType,
      options: app_options.fuelTypes,
      onChanged: (value) {
        if (value != null) {
          setState(() => _fuelType = value);
        }
      },
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Refill date',
          style: AppTextStyles.fieldLabel.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.space8.h),
        InkWell(
          onTap: _selectDate,
          borderRadius: AppRadius.largeRadius,
          child: Container(
            height: AppDimensions.inputHeight.h,
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.space12.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.largeRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(_refillDate),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(fontSize: 13.sp),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.textSecondary,
                  size: AppDimensions.iconMedium.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOdometerField() {
    return AppTextField(
      label: 'Odometer reading',
      controller: _odometerController,
      hint: 'Enter reading',
      suffix: 'km',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      hasError: _odometerHasError,
      onChanged: (_) {
        if (_odometerHasError) {
          setState(() => _odometerHasError = false);
        }
      },
    );
  }

  Widget _buildQuantityField() {
    return AppTextField(
      label: 'Fuel quantity',
      controller: _quantityController,
      hint: 'Enter quantity',
      suffix: 'L',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
      ],
      hasError: _quantityHasError,
      onChanged: (_) {
        if (_quantityHasError) {
          setState(() => _quantityHasError = false);
        }
      },
    );
  }

  Widget _buildCostField() {
    return AppTextField(
      label: 'Total cost',
      controller: _costController,
      hint: 'Enter amount',
      prefix: '₹',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      hasError: _costHasError,
      onChanged: (_) {
        if (_costHasError) {
          setState(() => _costHasError = false);
        }
      },
    );
  }

  Widget _buildPriceSummary() {
    final hasPrice = _quantity > 0 && _totalCost > 0;

    return Container(
      padding: EdgeInsets.all(AppDimensions.space12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        border: Border.all(color: AppColors.divider),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: const BoxDecoration(
              color: Color(0xFFE1F3FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_gas_station_outlined,
              color: Color(0xFF1686C9),
              size: AppDimensions.iconMedium.sp,
            ),
          ),
          SizedBox(width: AppDimensions.space8.w),
          Expanded(
            child: Text(
              'Calculated price per unit',
              style: AppTextStyles.bodySecondary.copyWith(fontSize: 12.sp),
            ),
          ),
          Text(
            hasPrice ? '₹${_pricePerLitre.toStringAsFixed(2)} / L' : '— / L',
            style: AppTextStyles.body.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationField() {
    return AppTextField(
      label: 'Fuel station (Optional)',
      controller: _stationController,
      hint: 'Enter fuel station',
      prefixIcon: Icons.storefront_outlined,
    );
  }

  Widget _buildFullTankOption() {
    return InkWell(
      onTap: () => setState(() => _isFullTank = !_isFullTank),
      borderRadius: AppRadius.largeRadius,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.space12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.largeRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24.w,
              height: 24.w,
              child: Checkbox(
                value: _isFullTank,
                onChanged: (value) {
                  setState(() => _isFullTank = value ?? false);
                },
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                side: const BorderSide(color: AppColors.border),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: AppDimensions.space12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full tank refill',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: AppDimensions.space4.h),
                  Text(
                    'Used to accurately calculate fuel efficiency '
                    '(km/L) between full fill-ups.',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 12.sp,
                      height: 1.4,
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

  Widget _buildNotesField() {
    return AppTextField(
      label: 'Notes (Optional)',
      controller: _notesController,
      hint:
          'Add details about this refill (e.g. highway trip, premium fuel)...',
      maxLines: 3,
    );
  }
}
