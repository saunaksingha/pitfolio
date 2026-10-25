import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import 'statistics_overview_screen.dart';
import 'statistics_fuel_screen.dart';
import 'statistics_costs_screen.dart';
import 'statistics_odometer_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedTab = 0;

  static const List<String> _tabs = ['Overview', 'Fuel', 'Costs', 'Odometer'];

  static const List<Widget> _screens = [
    StatisticsOverviewScreen(),
    StatisticsFuelScreen(),
    StatisticsCostsScreen(),
    StatisticsOdometerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: IndexedStack(index: _selectedTab, children: _screens),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.pageHorizontalPadding.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              border: Border.all(color: AppColors.border),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_car_outlined,
              color: AppColors.textPrimary,
              size: 19.sp,
            ),
          ),
          SizedBox(width: AppDimensions.space8.w),
          Expanded(
            child: Text(
              'Pitfolio',
              style: AppTextStyles.screenTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Open the reminders screen.
            },
            tooltip: 'Reminders',
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_none_outlined,
                  color: AppColors.textSecondary,
                  size: 25.sp,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space12.w,
        vertical: AppDimensions.space12.h,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final selected = _selectedTab == index;

            return Padding(
              padding: EdgeInsets.only(right: AppDimensions.space8.w),
              child: Material(
                color: selected
                    ? AppColors.primary
                    : AppColors.surfaceSecondary,
                borderRadius: AppRadius.largeRadius,
                child: InkWell(
                  borderRadius: AppRadius.largeRadius,
                  onTap: () => setState(() => _selectedTab = index),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.space16.w,
                      vertical: AppDimensions.space8.h,
                    ),
                    child: Text(
                      _tabs[index],
                      style: AppTextStyles.body.copyWith(
                        color: selected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
