import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class StatisticsOdometerScreen extends StatelessWidget {
  const StatisticsOdometerScreen({super.key});

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
                'DRIVEN',
                '420 km',
                'This month',
                Icons.alt_route,
                const Color(0xFFEAF2FF),
                const Color(0xFF2868DC),
              ),
              SizedBox(width: AppDimensions.space8.w),
              _metric(
                'CURRENT',
                '24,500',
                'km reading',
                Icons.speed_outlined,
                AppColors.surfaceSecondary,
                AppColors.textSecondary,
              ),
              SizedBox(width: AppDimensions.space8.w),
              _metric(
                'DAILY',
                '14 km',
                'per day',
                Icons.calendar_today_outlined,
                const Color(0xFFFFF3E4),
                const Color(0xFFEF8200),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space20.h),
          _distanceChart(),
          SizedBox(height: AppDimensions.space16.h),
          _drivingPatterns(),
          SizedBox(height: AppDimensions.space16.h),
          _smartInsights(),
          SizedBox(height: AppDimensions.space24.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Odometer history',
                  style: AppTextStyles.sectionTitle,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Open all odometer logs.
                },
                child: Text(
                  'View all logs ›',
                  style: AppTextStyles.body.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space12.h),
          _historyCard(),
          SizedBox(height: AppDimensions.space12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Open the add odometer reading screen.
              },
              icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
              label: const Text('Log New Odometer Reading'),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.surfaceSecondary,
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(color: AppColors.border),
                textStyle: AppTextStyles.button,
                padding: EdgeInsets.symmetric(
                  vertical: AppDimensions.space12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.mediumRadius,
                ),
              ),
            ),
          ),
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
        constraints: BoxConstraints(minHeight: 92.h),
        padding: EdgeInsets.all(AppDimensions.space12.w),
        decoration: BoxDecoration(
          color: background,
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

  Widget _distanceChart() {
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
                    Text('Distance driven', style: AppTextStyles.sectionTitle),
                    Text(
                      'Total: 420 km this month',
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _selector('6 months'),
            ],
          ),
          SizedBox(height: AppDimensions.space16.h),
          SizedBox(height: 190.h, child: _distancePlot()),
        ],
      ),
    );
  }

  Widget _distancePlot() {
    const values = [380.0, 410.0, 460.0, 395.0, 440.0, 420.0];
    const labels = ['May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct'];

    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _DistanceChartPainter(
              values: values,
              minValue: 0,
              maxValue: 500,
              lineColor: const Color(0xFF3478F6),
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
    );
  }

  Widget _drivingPatterns() {
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
              Icon(Icons.auto_graph, color: AppColors.primary, size: 22.sp),
              SizedBox(width: AppDimensions.space8.w),
              Text('Driving patterns', style: AppTextStyles.sectionTitle),
            ],
          ),
          SizedBox(height: AppDimensions.space12.h),
          _patternRow(
            Icons.calendar_view_week_outlined,
            'Average per week',
            '98 km/week',
          ),
          SizedBox(height: AppDimensions.space8.h),
          _patternRow(
            Icons.calendar_month_outlined,
            'Average per month',
            '416 km/month',
          ),
          SizedBox(height: AppDimensions.space8.h),
          _patternRow(
            Icons.trending_up,
            'Peak distance month',
            'July (460 km)',
            subtitle: 'Road trip to Pune',
          ),
        ],
      ),
    );
  }

  Widget _patternRow(
    IconData icon,
    String label,
    String value, {
    String? subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: AppRadius.mediumRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 21.sp),
          SizedBox(width: AppDimensions.space12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.space8.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smartInsights() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: AppRadius.largeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: 21.sp,
              ),
              SizedBox(width: AppDimensions.space8.w),
              Text(
                'Smart Estimates & Insights',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.space12.h),
          _insightRow(
            Icons.trending_down,
            AppColors.success,
            'Current month is ',
            '4.5% below',
            ' your 6-month average (440 km).',
          ),
          SizedBox(height: AppDimensions.space12.h),
          _insightRow(
            Icons.build_circle_outlined,
            AppColors.primary,
            'Estimated next service due at ',
            '25,000 km',
            ' (~35 days at current 14 km/day rate).',
          ),
        ],
      ),
    );
  }

  Widget _insightRow(
    IconData icon,
    Color color,
    String prefix,
    String emphasis,
    String suffix,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: color),
        SizedBox(width: AppDimensions.space8.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: prefix),
                TextSpan(
                  text: emphasis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: suffix),
              ],
            ),
            style: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _historyCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Column(
        children: [
          _historyRow(
            Icons.local_gas_station_outlined,
            const Color(0xFFFFF3E4),
            const Color(0xFFEF8200),
            '24,500 km',
            '+45 km',
            '12 Oct 2026 · Recorded during refill',
          ),
          Divider(height: 1, color: AppColors.divider),
          _historyRow(
            Icons.directions_car_outlined,
            const Color(0xFFEAF2FF),
            const Color(0xFF2868DC),
            '24,455 km',
            '+120 km',
            '04 Oct 2026 · Weekend city drive',
          ),
          Divider(height: 1, color: AppColors.divider),
          _historyRow(
            Icons.edit_note_outlined,
            AppColors.surfaceSecondary,
            AppColors.textSecondary,
            '24,335 km',
            '+85 km',
            '28 Sep 2026 · Routine odometer log',
          ),
        ],
      ),
    );
  }

  Widget _historyRow(
    IconData icon,
    Color background,
    Color foreground,
    String reading,
    String difference,
    String details,
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
            child: Icon(icon, color: foreground, size: 21.sp),
          ),
          SizedBox(width: AppDimensions.space12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppDimensions.space8.w,
                  runSpacing: 4.h,
                  children: [
                    Text(
                      reading,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.space8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: AppRadius.largeRadius,
                      ),
                      child: Text(
                        difference,
                        style: AppTextStyles.caption.copyWith(
                          color: foreground,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.space4.h),
                Text(
                  details,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert, color: AppColors.textSecondary, size: 21.sp),
        ],
      ),
    );
  }

  Widget _selector(String label) {
    return Container(
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
          Text(label, style: AppTextStyles.caption),
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

class _DistanceChartPainter extends CustomPainter {
  final List<double> values;
  final double minValue;
  final double maxValue;
  final Color lineColor;
  final Color gridColor;

  _DistanceChartPainter({
    required this.values,
    required this.minValue,
    required this.maxValue,
    required this.lineColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.8;

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
      points.add(Offset(x, size.height * (1 - ratio)));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..color = lineColor.withValues(alpha: 0.10)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    for (final point in points) {
      canvas.drawCircle(point, 3.5, Paint()..color = AppColors.surface);
      canvas.drawCircle(point, 2.4, Paint()..color = lineColor);
    }
  }

  @override
  bool shouldRepaint(covariant _DistanceChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.lineColor != lineColor;
  }
}
