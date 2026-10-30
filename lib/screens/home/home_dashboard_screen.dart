import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:pitfolio/core/widgets/vehicle_switcher.dart';
import 'package:pitfolio/models/vehicle.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/logbook/logbook_date_group.dart';
import '../../features/logbook/models/logbook_entry.dart';
import '../../core/widgets/quick_actions_menu.dart';
import 'odometer_update_screen.dart';
import 'fuel_refill_screen.dart';
import 'add_expense_screen.dart';
import 'service_repair_screen.dart';
import 'add_documents_screen.dart';
import 'add_note_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  // Temporary vehicle data. Replace with saved data later.

  // Logbook data: each date can contain any number of entries.
  final List<LogbookDateGroupData> _logbookGroups = const [
    LogbookDateGroupData(
      date: '12 OCT · MONDAY',
      entries: [
        LogbookEntry(
          title: 'Oil change',
          subtitle: 'Routine maintenance · Synthetic oil',
          amount: '₹450',
          icon: Icons.car_repair_outlined,
          accentColor: Color(0xFFF28C00),
          backgroundColor: Color(0xFFFFF0D9),
        ),
      ],
    ),
    LogbookDateGroupData(
      date: '10 OCT · SATURDAY',
      entries: [
        LogbookEntry(
          title: 'Odometer updated',
          subtitle: '24,455 km → 24,500 km',
          amount: '+45 km',
          icon: Icons.speed_outlined,
          accentColor: Color(0xFF2878D0),
          backgroundColor: Color(0xFFE7F0FC),
        ),
      ],
    ),
    LogbookDateGroupData(
      date: '06 OCT · TUESDAY',
      entries: [
        LogbookEntry(
          title: 'Fuel refill',
          subtitle: 'Speed Petrol · 12.4 L',
          amount: '₹1,850',
          icon: Icons.local_gas_station_outlined,
          accentColor: Color(0xFF37699E),
          backgroundColor: Color(0xFFE7F0FC),
        ),
      ],
    ),
    LogbookDateGroupData(
      date: '01 OCT · THURSDAY',
      entries: [
        LogbookEntry(
          title: 'Insurance renewal',
          subtitle: 'Comprehensive cover · 1 year',
          amount: '₹5,400',
          icon: Icons.verified_user_outlined,
          accentColor: Color(0xFF21845D),
          backgroundColor: Color(0xFFDDF3E9),
        ),
      ],
    ),
  ];

  VehicleModel? _selectedVehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppDimensions.pageHorizontalPadding.w,
                      AppDimensions.space8.h,
                      AppDimensions.pageHorizontalPadding.w,
                      100.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //   _buildVehicleCard(),
                        VehicleSwitcher(
                          onVehicleSelected: (VehicleModel vehicle) {
                            setState(() {
                              _selectedVehicle = vehicle;
                            });
                          },
                        ),
                        SizedBox(height: AppDimensions.space20.h),
                        _buildMonthlySummary(),
                        SizedBox(height: AppDimensions.space24.h),
                        _buildLogbookHeader(),
                        SizedBox(height: AppDimensions.space16.h),
                        _buildLogbook(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            QuickActionsMenu(onActionSelected: _handleQuickAction),
          ],
        ),
      ),
    );
  }

  Future<void> _handleQuickAction(QuickAction action) async {
    switch (action) {
      case QuickAction.updateOdometer:
        final VehicleModel? updatedVehicleModel = await Navigator.of(context)
            .push<VehicleModel>(
              MaterialPageRoute(
                builder: (_) => OdometerUpdateScreen(
                  selectedVehicleModel: _selectedVehicle!,
                ),
              ),
            );

        if (updatedVehicleModel != null) {
          setState(() {
            _selectedVehicle = updatedVehicleModel;
          });
        }
        break;

      case QuickAction.addFuel:
        break;
      case QuickAction.addReminder:
        _showComingSoon('Add reminder');
        break;
      case QuickAction.addExpense:
        Navigator.of(context).push<AddExpenseScreen>(
          MaterialPageRoute(
            builder: (_) => AddExpenseScreen(
              vehicleName: '',
              make: '',
              model: '',
              year: '',
            ),
          ),
        );
        break;
      case QuickAction.addMaintenance:
        break;
      case QuickAction.uploadDocument:
        // Navigator.of(context)
        //     .push<VehicleDocumentResult>(
        //       MaterialPageRoute(
        //         builder: (_) => AddDocumentsScreen(
        //           vehicleName: _vehicleName,
        //           make: 'Maruti Suzuki',
        //           model: 'Swift',
        //           year: _vehicleYear,
        //         ),
        //       ),
        //     )
        //     .then((result) {
        //       if (result == null || !mounted) return;

        //       // TODO: Save the document through your vehicle document repository.
        //       // The document data and selected file paths are available in result.
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(
        //           content: Text(
        //             'Document "${result.documentName}" added successfully.',
        //           ),
        //         ),
        //       );
        //     });
        break;
      case QuickAction.addNote:
        break;
    }
  }

  // ---------------------------------------------------------------------------
  // Top bar
  // ---------------------------------------------------------------------------

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding.w,
        AppDimensions.space8.h,
        AppDimensions.pageHorizontalPadding.w,
        AppDimensions.space12.h,
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: AppRadius.smallRadius,
            ),
            child: Icon(
              Icons.directions_car_filled_outlined,
              color: AppColors.primary,
              size: AppDimensions.iconMedium.sp,
            ),
          ),
          SizedBox(width: AppDimensions.space8.w),
          Text(
            'Pitfolio',
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          _HeaderIconButton(
            icon: Icons.search,
            tooltip: 'Search',
            onTap: () => _showComingSoon('Search'),
          ),
          SizedBox(width: AppDimensions.space8.w),
          _HeaderIconButton(
            icon: Icons.notifications_none_outlined,
            tooltip: 'Reminders',
            showDot: true,
            onTap: () => _showComingSoon('Reminders'),
          ),
          SizedBox(width: AppDimensions.space8.w),
          InkWell(
            onTap: () => _showComingSoon('Profile'),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Container(
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
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Vehicle summary card
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // Monthly summary cards
  // ---------------------------------------------------------------------------

  Widget _buildMonthlySummary() {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'EXPENSES THIS\nMONTH',
            value: '₹2,850',
            icon: Icons.payments_outlined,
            background: const Color(0xFFFFF0D9),
            iconColor: const Color(0xFF995500),
          ),
        ),
        SizedBox(width: AppDimensions.space12.w),
        Expanded(
          child: _SummaryCard(
            title: 'DISTANCE THIS\nMONTH',
            value: '420 km',
            icon: Icons.route_outlined,
            background: const Color(0xFFE6EFFC),
            iconColor: const Color(0xFF315F9A),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Logbook
  // ---------------------------------------------------------------------------

  Widget _buildLogbookHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Your logbook',
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          'October 2023',
          style: AppTextStyles.caption.copyWith(fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildLogbook() {
    return Column(
      children: [
        for (int index = 0; index < _logbookGroups.length; index++)
          LogbookDateGroup(
            group: _logbookGroups[index],
            showBottomSpacing: index < _logbookGroups.length - 1,
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom navigation
  // ---------------------------------------------------------------------------

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature will be implemented next.')),
    );
  }
}

// =============================================================================
// Reusable dashboard components
// =============================================================================

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      constraints: BoxConstraints(
        minWidth: AppDimensions.minimumTapTarget.w,
        minHeight: AppDimensions.minimumTapTarget.h,
      ),
      padding: EdgeInsets.all(AppDimensions.space8.w),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconLarge.sp,
            color: AppColors.textSecondary,
          ),
          if (showDot)
            Positioned(
              top: -2.h,
              right: -1.w,
              child: Container(
                width: 7.w,
                height: 7.w,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.background,
    required this.iconColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color background;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 94.h),
      padding: EdgeInsets.all(AppDimensions.space12.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.mediumRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFF805522),
                    fontSize: 10.sp,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Icon(icon, size: 16.sp, color: iconColor),
            ],
          ),
          SizedBox(height: AppDimensions.space8.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
