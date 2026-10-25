import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class StatisticsFuelScreen extends StatelessWidget {
  const StatisticsFuelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.pageHorizontalPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _metric(
                'SPENT',
                '₹3,250',
                'This month',
                Icons.receipt_long_outlined,
                const Color(0xFFFFF5DC),
                const Color(0xFFB66A00),
              ),
              SizedBox(width: AppDimensions.space8.w),
              _metric(
                'USED',
                '32.5 L',
                'This month',
                Icons.local_gas_station_outlined,
                const Color(0xFFEAF2FF),
                const Color(0xFF2868DC),
              ),
              SizedBox(width: AppDimensions.space8.w),
              _metric(
                'EFFICIENCY',
                '16.8',
                'km/L avg',
                Icons.eco_outlined,
                const Color(0xFFE5FAF0),
                const Color(0xFF00875A),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space16.h),
          _panel(
            title: 'Fuel efficiency trend',
            subtitle: 'Speed Petrol · 91 Octane',
            trailing: '6 months',
            child: _lineChart(
              values: const [15.4, 15.8, 16.2, 15.9, 16.5, 16.8],
              labels: const ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
              minValue: 14,
              maxValue: 18,
              unit: 'km/L',
              color: const Color(0xFF00B884),
            ),
            footer: const ('Best: 17.4 km/L (Highway)', 'Avg: 16.8 km/L'),
          ),
          SizedBox(height: AppDimensions.space16.h),
          _panel(
            title: 'Fuel price trend',
            subtitle: 'Average price per litre',
            trailing: '6 months',
            child: _lineChart(
              values: const [96.2, 96.8, 97.1, 96.9, 97.4, 97.8],
              labels: const ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'],
              minValue: 96,
              maxValue: 98,
              unit: '₹/L',
              color: const Color(0xFFFF8500),
            ),
          ),
          SizedBox(height: AppDimensions.space24.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recent refuels',
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Open all refuel records.
                },
                child: Text(
                  'View all refuels',
                  style: AppTextStyles.body.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space12.h),
          _refuelList(),
          SizedBox(height: AppDimensions.space16.h),
          _verificationNote(),
          SizedBox(height: AppDimensions.space24.h),
        ],
      ),
    );
  }

  Widget _metric(
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color background,
    Color foreground,
  ) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(minHeight: 96.h),
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
                Icon(icon, size: 17.sp, color: foreground),
              ],
            ),
            SizedBox(height: AppDimensions.space8.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: AppTextStyles.cardTitle),
            ),
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

  Widget _panel({
    required String title,
    required String subtitle,
    required String trailing,
    required Widget child,
    (String, String)? footer,
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
          Row(
            children: [
              Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.space8.w,
                  vertical: AppDimensions.space4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  border: Border.all(color: AppColors.border),
                  borderRadius: AppRadius.largeRadius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trailing, style: AppTextStyles.caption),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space4.h),
          Text(
            subtitle,
            style: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.space16.h),
          child,
          if (footer != null) ...[
            SizedBox(height: AppDimensions.space12.h),
            Divider(color: AppColors.divider),
            SizedBox(height: AppDimensions.space8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    footer.$1,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Text(
                  footer.$2,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _lineChart({
    required List<double> values,
    required List<String> labels,
    required double minValue,
    required double maxValue,
    required String unit,
    required Color color,
  }) {
    return SizedBox(
      height: 205.h,
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: _LineChartPainter(
                values: values,
                minValue: minValue,
                maxValue: maxValue,
                color: color,
                gridColor: AppColors.divider,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          SizedBox(height: AppDimensions.space8.h),
          Row(
            children: labels.map((label) {
              return Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: label == 'Oct'
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: label == 'Oct'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _refuelList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Column(
        children: [
          _refuelRow(
            'HP Auto Care',
            'Speed Petrol',
            '12 Oct 2026 · 18.5 L · 24,500 km',
            '₹1,809',
            '₹97.8/L',
            const Color(0xFFFFF5DC),
            const Color(0xFFED8700),
          ),
          Divider(height: 1, color: AppColors.divider),
          _refuelRow(
            'Shell Express',
            'Regular 91',
            '28 Sep 2026 · 14.0 L · 24,195 km',
            '₹1,364',
            '₹97.4/L',
            const Color(0xFFFFF0E2),
            const Color(0xFFED8700),
          ),
          Divider(height: 1, color: AppColors.divider),
          _refuelRow(
            'IndianOil Retail',
            'Regular 91',
            '15 Sep 2026 · 20.0 L · 23,870 km',
            '₹1,940',
            '₹97.0/L',
            const Color(0xFFEAF2FF),
            const Color(0xFF2868DC),
          ),
        ],
      ),
    );
  }

  Widget _refuelRow(
    String station,
    String fuel,
    String details,
    String amount,
    String price,
    Color background,
    Color foreground,
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
            child: Icon(
              Icons.local_gas_station_outlined,
              color: foreground,
              size: 22.sp,
            ),
          ),
          SizedBox(width: AppDimensions.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  fuel,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  details,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.space8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                price,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
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

  Widget _verificationNote() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified, color: AppColors.success, size: 24.sp),
          SizedBox(width: AppDimensions.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3 verified full-tank refuels',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppDimensions.space4.h),
                Text(
                  'Calculated from consecutive full-tank entries with verified odometer readings. Partial fills are tracked for spending but excluded from efficiency averages.',
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final double minValue;
  final double maxValue;
  final Color color;
  final Color gridColor;

  _LineChartPainter({
    required this.values,
    required this.minValue,
    required this.maxValue,
    required this.color,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.8;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 3; i++) {
      final y = size.height * i / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[];

    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? size.width / 2
          : size.width * i / (values.length - 1);
      final ratio = ((values[i] - minValue) / (maxValue - minValue)).clamp(
        0.0,
        1.0,
      );
      final y = size.height * (1 - ratio);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final midX = (previous.dx + current.dx) / 2;

      path.cubicTo(midX, previous.dy, midX, current.dy, current.dx, current.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = color;

    for (final point in points) {
      canvas.drawCircle(point, 3.2, Paint()..color = AppColors.surface);
      canvas.drawCircle(point, 2.2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.color != color;
  }
}
