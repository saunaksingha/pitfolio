import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class StatisticsCostsScreen extends StatelessWidget {
  const StatisticsCostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.pageHorizontalPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _totalExpenses(),
          SizedBox(height: AppDimensions.space16.h),
          _breakdownCard(),
          SizedBox(height: AppDimensions.space16.h),
          _monthlyExpenses(),
          SizedBox(height: AppDimensions.space16.h),
          _insightsCard(),
          SizedBox(height: AppDimensions.space20.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent expenses',
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Open all expenses.
                },
                child: Text(
                  'View all expenses',
                  style: AppTextStyles.body.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space8.h),
          _recentExpenses(),
          SizedBox(height: AppDimensions.space24.h),
        ],
      ),
    );
  }

  Widget _totalExpenses() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'TOTAL EXPENSES',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              _periodSelector('This month'),
            ],
          ),
          SizedBox(height: AppDimensions.space8.h),
          Text(
            '₹7,250',
            style: AppTextStyles.pageTitle.copyWith(
              color: AppColors.primary,
              fontSize: 30.sp,
            ),
          ),
          SizedBox(height: AppDimensions.space8.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space8.w,
              vertical: AppDimensions.space4.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F8EF),
              borderRadius: AppRadius.largeRadius,
            ),
            child: Text(
              '↓ -8.5% vs last month (₹7,920)',
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFF148454),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownCard() {
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expense breakdown',
                      style: AppTextStyles.sectionTitle,
                    ),
                    Text(
                      'Total spend ₹7,250',
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.pie_chart_outline,
                color: AppColors.textSecondary,
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space16.h),
          SizedBox(
            height: 220.h,
            child: Center(
              child: SizedBox(
                width: 164.w,
                height: 164.w,
                child: CustomPaint(
                  painter: _DonutPainter(),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('₹7,250', style: AppTextStyles.sectionTitle),
                        Text(
                          'Total',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.space8.h),
          _legendRow('Fuel', '₹3,250', '44.8%', const Color(0xFFEF8200)),
          _legendRow(
            'Maintenance & repairs',
            '₹2,500',
            '34.5%',
            const Color(0xFF4385F5),
          ),
          _legendRow('Insurance', '₹1,000', '13.8%', const Color(0xFF10B981)),
          _legendRow('Other', '₹500', '6.9%', const Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  Widget _legendRow(
    String label,
    String amount,
    String percentage,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.space8.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: AppDimensions.space8.w),
          Expanded(child: Text(label, style: AppTextStyles.body)),
          SizedBox(width: AppDimensions.space4.w),
          Text(
            amount,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(width: AppDimensions.space12.w),
          SizedBox(
            width: 42.w,
            child: Text(
              percentage,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthlyExpenses() {
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Monthly expenses', style: AppTextStyles.sectionTitle),
                    Text(
                      'Total: ₹7,250 (Oct)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _periodSelector('6 months'),
            ],
          ),
          SizedBox(height: AppDimensions.space16.h),
          SizedBox(height: 180.h, child: _barChart()),
        ],
      ),
    );
  }

  Widget _barChart() {
    const values = [4300.0, 3500.0, 5400.0, 4800.0, 6100.0, 7250.0];
    const labels = ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(values.length, (index) {
        final isCurrent = index == values.length - 1;
        final ratio = values[index] / 8000;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
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
                          color: isCurrent
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
                  labels[index],
                  style: AppTextStyles.caption.copyWith(
                    color: isCurrent
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _insightsCard() {
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
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E4),
                  borderRadius: AppRadius.smallRadius,
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.primary,
                  size: 21.sp,
                ),
              ),
              SizedBox(width: AppDimensions.space8.w),
              Text('Spending insights', style: AppTextStyles.sectionTitle),
            ],
          ),
          SizedBox(height: AppDimensions.space12.h),
          Container(
            padding: EdgeInsets.all(AppDimensions.space12.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Column(
              children: [
                _insight(
                  const Color(0xFFEF8200),
                  'Highest category:',
                  ' Fuel represents 44.8% of total spending this month.',
                ),
                SizedBox(height: AppDimensions.space12.h),
                _insight(
                  AppColors.success,
                  'Month-over-month:',
                  ' Total expenses decreased by ₹670 (-8.5%) compared to September.',
                ),
                SizedBox(height: AppDimensions.space12.h),
                _insight(
                  const Color(0xFF4385F5),
                  'Largest single cost:',
                  ' Engine oil & filter service (₹2,500 on 12 Oct).',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _insight(Color color, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        SizedBox(width: AppDimensions.space8.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: description),
              ],
            ),
            style: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _recentExpenses() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Column(
        children: [
          _expenseRow(
            Icons.local_gas_station_outlined,
            const Color(0xFFFFF3E4),
            const Color(0xFFEF8200),
            'Fuel refill',
            '12 Oct 2026 · Speed Petrol',
            '₹1,809',
          ),
          Divider(height: 1, color: AppColors.divider),
          _expenseRow(
            Icons.build_outlined,
            const Color(0xFFEAF2FF),
            const Color(0xFF2868DC),
            'Engine oil & filter',
            '12 Oct 2026 · Maintenance',
            '₹2,500',
          ),
          Divider(height: 1, color: AppColors.divider),
          _expenseRow(
            Icons.toll_outlined,
            const Color(0xFFF0F3F8),
            const Color(0xFF657087),
            'Parking & Tolls',
            '04 Oct 2026 · Other',
            '₹250',
          ),
        ],
      ),
    );
  }

  Widget _expenseRow(
    IconData icon,
    Color background,
    Color foreground,
    String title,
    String subtitle,
    String amount,
  ) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.space12.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: background,
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Icon(icon, color: foreground, size: 22.sp),
          ),
          SizedBox(width: AppDimensions.space12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: 20.sp,
          ),
        ],
      ),
    );
  }

  Widget _periodSelector(String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space8.w,
        vertical: AppDimensions.space4.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: AppRadius.largeRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16.sp,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.16;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    const segments = [
      (0.448, Color(0xFFEF8200)),
      (0.345, Color(0xFF4385F5)),
      (0.138, Color(0xFF10B981)),
      (0.069, Color(0xFF94A3B8)),
    ];

    var start = -math.pi / 2;

    for (final segment in segments) {
      final sweep = 2 * math.pi * segment.$1;
      final paint = Paint()
        ..color = segment.$2
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => false;
}
