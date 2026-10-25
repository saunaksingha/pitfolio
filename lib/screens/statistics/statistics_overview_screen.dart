import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class StatisticsOverviewScreen extends StatelessWidget {
  const StatisticsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.pageHorizontalPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _summaryCard(
                'SPENT',
                '₹7,250',
                'This month',
                Icons.payments_outlined,
                const Color(0xFFFFF0D9),
                const Color(0xFF9A5A12),
              ),
              SizedBox(width: AppDimensions.space8.w),
              _summaryCard(
                'DISTANCE',
                '420 km',
                'This month',
                Icons.route_outlined,
                const Color(0xFFE6F0FF),
                const Color(0xFF356FB6),
              ),
              SizedBox(width: AppDimensions.space8.w),
              _summaryCard(
                'EFFICIENCY',
                '16.8',
                'km/L avg',
                Icons.eco_outlined,
                const Color(0xFFDDF4EA),
                const Color(0xFF16845D),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space20.h),
          _chartCard(
            title: 'Monthly expenses',
            subtitle: 'Total: ₹7,250',
            child: _barChart(
              values: const [4200, 3500, 5400, 4800, 6100, 7250],
              labels: const ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
              maxValue: 8000,
              suffix: '₹',
              highlightIndex: 5,
            ),
          ),
          SizedBox(height: AppDimensions.space16.h),
          _chartCard(
            title: 'Distance driven',
            subtitle: 'Total: 420 km',
            child: _barChart(
              values: const [310, 365, 460, 350, 405, 420],
              labels: const ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
              maxValue: 500,
              suffix: '',
              highlightIndex: 3,
              visibleValues: const [310, 365, 460, 420],
            ),
          ),
          SizedBox(height: AppDimensions.space16.h),
          _chartCard(
            title: 'Fuel efficiency trend',
            subtitle: 'Speed Petrol · 91 Octane',
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(AppDimensions.space12.w),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: AppRadius.mediumRadius,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_gas_station_outlined,
                        color: AppColors.success,
                        size: 24.sp,
                      ),
                      SizedBox(width: AppDimensions.space8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('16.8 km/L', style: AppTextStyles.cardTitle),
                            Text(
                              'Best: 18.2 km/L · Highway',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Optimal',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimensions.space12.h),
                Divider(color: AppColors.divider),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      color: AppColors.textSecondary,
                      size: 17.sp,
                    ),
                    SizedBox(width: AppDimensions.space8.w),
                    Expanded(
                      child: Text(
                        'Calculated from 3 full-tank refuels with verified odometer readings. Unverified partial logs are excluded from average.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.space24.h),
        ],
      ),
    );
  }

  Widget _summaryCard(
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color background,
    Color foreground,
  ) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(minHeight: 100.h),
        padding: EdgeInsets.all(AppDimensions.space12.w),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: foreground.withValues(alpha: 0.15)),
          borderRadius: AppRadius.mediumRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(icon, color: foreground, size: 17.sp),
              ],
            ),
            SizedBox(height: AppDimensions.space8.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: AppTextStyles.cardTitle),
            ),
            SizedBox(height: AppDimensions.space4.h),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          SizedBox(height: AppDimensions.space4.h),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.space16.h),
          child,
        ],
      ),
    );
  }

  Widget _barChart({
    required List<double> values,
    required List<String> labels,
    required double maxValue,
    required String suffix,
    required int highlightIndex,
    List<double>? visibleValues,
  }) {
    final data = visibleValues ?? values;

    return SizedBox(
      height: 190.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(data.length, (index) {
          final selected =
              index == highlightIndex ||
              (visibleValues != null && index == data.length - 1);
          final ratio = (data[index] / maxValue).clamp(0.0, 1.0);

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: ratio,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : const Color(0xFFD1D9E4),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(6.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.space8.h),
                  Text(
                    labels[index < labels.length ? index : labels.length - 1],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
