import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/theme/app_text_styles.dart';
import '../screens/home/home_dashboard_screen.dart';
import '../screens/garage/garage_screen.dart';
import 'statistics/statistics_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const HomeDashboardScreen(),
    const StatisticsScreen(),
    const GarageScreen(),
  ];

  static const List<_NavigationDestination> _destinations = [
    _NavigationDestination(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    _NavigationDestination(
      label: 'Statistics',
      icon: Icons.query_stats_outlined,
      selectedIcon: Icons.query_stats,
    ),
    _NavigationDestination(
      label: 'Garage',
      icon: Icons.directions_car_filled_outlined,
      selectedIcon: Icons.directions_car_filled,
    ),
  ];

  void _onDestinationSelected(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: List.generate(_destinations.length, (index) {
              final destination = _destinations[index];
              final isSelected = index == _selectedIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => _onDestinationSelected(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected
                            ? destination.selectedIcon
                            : destination.icon,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 23.sp,
                      ),
                      SizedBox(height: AppDimensions.space2.h),
                      Text(
                        destination.label,
                        style: AppTextStyles.navigationLabel.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontSize: 11.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavigationDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const _NavigationDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}
