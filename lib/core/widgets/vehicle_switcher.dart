import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import '../../models/vehicle.dart';
import '../../repositories/vehicle_repository.dart';
import '../../repositories/odometer_repository.dart';

class VehicleSwitcher extends StatefulWidget {
  const VehicleSwitcher({
    super.key,
    this.initialVehicleId,
    this.onVehicleSelected,
  });

  final int? initialVehicleId;
  final ValueChanged<VehicleModel>? onVehicleSelected;

  @override
  State<VehicleSwitcher> createState() => _VehicleSwitcherState();
}

class _VehicleSwitcherState extends State<VehicleSwitcher>
    with SingleTickerProviderStateMixin {
  List<VehicleModel> _vehicles = [];
  VehicleModel? _selectedVehicle;

  bool _isExpanded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      final vehicles = await VehicleRepository.instance.getAllVehicles();

      final updatedVehicles = <VehicleModel>[];

      for (final vehicle in vehicles) {
        final latestRecord = await OdometerRepository.instance
            .getLatestOdometerRecord(vehicle.id!);

        if (latestRecord != null) {
          final updatedMap = vehicle.toMap()
            ..['current_odometer'] = latestRecord.odometerReading;

          updatedVehicles.add(VehicleModel.fromMap(updatedMap));
        } else {
          updatedVehicles.add(vehicle);
        }
      }

      if (!mounted) return;

      VehicleModel? selected;

      if (widget.initialVehicleId != null) {
        for (final vehicle in updatedVehicles) {
          if (vehicle.id == widget.initialVehicleId) {
            selected = vehicle;
            break;
          }
        }
      }

      selected ??= updatedVehicles.isNotEmpty ? updatedVehicles.first : null;

      setState(() {
        _vehicles = updatedVehicles;
        _selectedVehicle = selected;
        _isLoading = false;
      });

      if (selected != null) {
        widget.onVehicleSelected?.call(selected);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      debugPrint('Failed to load vehicles: $e');
    }
  }

  void _toggleExpanded() {
    if (_isLoading || _vehicles.length < 2) return;

    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _selectVehicle(VehicleModel vehicle) {
    setState(() {
      _selectedVehicle = vehicle;
      _isExpanded = false;
    });

    widget.onVehicleSelected?.call(vehicle);
  }

  String _vehicleSubtitle(VehicleModel vehicle) {
    final makeModel = '${vehicle.make} ${vehicle.model}'.trim();

    return makeModel.isEmpty ? 'Vehicle details unavailable' : makeModel;
  }

  String _formatOdometer(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  Widget _buildVehicleThumbnail(
    VehicleModel vehicle, {
    required double size,
    required bool isSelected,
  }) {
    final photoPath = vehicle.photoPath;

    final hasPhoto =
        photoPath != null &&
        photoPath.isNotEmpty &&
        File(photoPath).existsSync();

    if (hasPhoto) {
      return ClipRRect(
        borderRadius: AppRadius.mediumRadius,
        child: SizedBox(
          width: size,
          height: size,
          child: Image.file(
            File(photoPath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildVehicleIcon(size: size, isSelected: isSelected);
            },
          ),
        ),
      );
    }

    return _buildVehicleIcon(size: size, isSelected: isSelected);
  }

  Widget _buildVehicleIcon({required double size, required bool isSelected}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF2C313C),
        borderRadius: AppRadius.mediumRadius,
      ),
      child: Icon(
        Icons.directions_car_outlined,
        color: isSelected ? AppColors.primary : const Color(0xFF9BA3B4),
        size: AppDimensions.iconMedium.sp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimensions.space16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF20232B),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_selectedVehicle == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppDimensions.space16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF20232B),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          'No vehicles added yet',
          style: AppTextStyles.body.copyWith(color: Colors.white),
        ),
      );
    }

    final vehicle = _selectedVehicle!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF20232B),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Currently selected vehicle
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16.r),
            child: InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.circular(16.r),
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.space16.w),
                child: Row(
                  children: [
                    _buildVehicleThumbnail(
                      vehicle,
                      size: 40.w,
                      isSelected: true,
                    ),

                    SizedBox(width: AppDimensions.space12.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.cardTitle.copyWith(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: AppDimensions.space2.h),
                          Text(
                            _vehicleSubtitle(vehicle),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: const Color(0xFF9BA3B4),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: AppDimensions.space8.w),

                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: const Color(0xFF9BA3B4),
                        size: AppDimensions.iconMedium.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expandable list of available vehicles
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: !_isExpanded
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.space16.w,
                        ),
                        child: Container(
                          height: 1,
                          color: const Color(0xFF343944),
                        ),
                      ),

                      ..._vehicles.map((item) {
                        final isSelected = item.id == _selectedVehicle?.id;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectVehicle(item),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.space16.w,
                                vertical: AppDimensions.space12.h,
                              ),
                              child: Row(
                                children: [
                                  _buildVehicleThumbnail(
                                    item,
                                    size: 36.w,
                                    isSelected: isSelected,
                                  ),

                                  SizedBox(width: AppDimensions.space12.w),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.body.copyWith(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(
                                          height: AppDimensions.space2.h,
                                        ),
                                        Text(
                                          _vehicleSubtitle(item),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.caption.copyWith(
                                            color: const Color(0xFF9BA3B4),
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                      size: AppDimensions.iconMedium.sp,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
          ),

          // Odometer summary
          if (!_isExpanded) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space16.w,
              ),
              child: Container(height: 1, color: const Color(0xFF343944)),
            ),

            Padding(
              padding: EdgeInsets.all(AppDimensions.space16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ODOMETER',
                          style: AppTextStyles.caption.copyWith(
                            color: const Color(0xFF9BA3B4),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.7,
                          ),
                        ),
                        SizedBox(height: AppDimensions.space4.h),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _formatOdometer(vehicle.currentOdometer),
                                style: AppTextStyles.cardTitle.copyWith(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' km',
                                style: AppTextStyles.caption.copyWith(
                                  color: const Color(0xFF9BA3B4),
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.swap_vert,
                    color: const Color(0xFF9BA3B4),
                    size: AppDimensions.iconMedium.sp,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
