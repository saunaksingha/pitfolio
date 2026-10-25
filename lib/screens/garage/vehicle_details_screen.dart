import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final String vehicleName;
  final String make;
  final String model;
  final String year;
  final String odometer;
  final String fuelType;
  final String variant;

  final VoidCallback? onEditVehicle;
  final VoidCallback? onEditDetails;
  final VoidCallback? onAddPurchaseDocument;
  final VoidCallback? onAddAttachment;
  final VoidCallback? onMaintenanceTap;

  const VehicleDetailsScreen({
    super.key,
    this.vehicleName = 'My daily car',
    this.make = 'Maruti Suzuki',
    this.model = 'Swift',
    this.year = '2023',
    this.odometer = '24,500 km',
    this.fuelType = 'Petrol',
    this.variant = 'ZXi Manual',
    this.onEditVehicle,
    this.onEditDetails,
    this.onAddPurchaseDocument,
    this.onAddAttachment,
    this.onMaintenanceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.pageHorizontalPadding.w,
                  AppDimensions.space16.h,
                  AppDimensions.pageHorizontalPadding.w,
                  AppDimensions.space32.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVehicleCard(),
                    SizedBox(height: AppDimensions.space24.h),
                    _buildSectionHeading(
                      'Vehicle information',
                      action: 'Edit details',
                      onAction: onEditDetails,
                    ),
                    SizedBox(height: AppDimensions.space8.h),
                    _buildVehicleInformation(),
                    SizedBox(height: AppDimensions.space24.h),
                    _buildSectionHeading('Purchase details'),
                    SizedBox(height: AppDimensions.space8.h),
                    _buildPurchaseDetails(),
                    SizedBox(height: AppDimensions.space24.h),
                    _buildSectionHeading('More details'),
                    SizedBox(height: AppDimensions.space8.h),
                    _buildNotes(),
                    SizedBox(height: AppDimensions.space16.h),
                    _buildSectionHeading(
                      'Attached documents',
                      action: '+ Add file',
                      onAction: onAddAttachment,
                    ),
                    SizedBox(height: AppDimensions.space4.h),
                    Text(
                      'General vehicle papers, compliance and registration.',
                      style: AppTextStyles.bodySecondary,
                    ),
                    SizedBox(height: AppDimensions.space8.h),
                    _buildAttachedDocuments(),
                    SizedBox(height: AppDimensions.space24.h),
                    _buildMaintenanceCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 56.h,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.space12.w),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
            tooltip: 'Go back',
          ),
          Expanded(
            child: Text(
              'Vehicle Details',
              textAlign: TextAlign.center,
              style: AppTextStyles.screenTitle,
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.textPrimary,
              size: 22.sp,
            ),
            onSelected: (value) {
              if (value == 'edit') onEditVehicle?.call();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit vehicle')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _iconTile(
            Icons.directions_car_outlined,
            background: const Color(0xFFFFF3E4),
            foreground: const Color(0xFFEF8200),
            size: 48,
          ),
          SizedBox(width: AppDimensions.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(vehicleName, style: AppTextStyles.cardTitle),
                    ),
                    GestureDetector(
                      onTap: onEditVehicle,
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: AppColors.primary,
                            size: 14.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Edit',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  '$make $model · $year',
                  style: AppTextStyles.bodySecondary,
                ),
                SizedBox(height: AppDimensions.space8.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: [
                    _pill(Icons.speed, odometer),
                    _pill(null, fuelType),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeading(
    String title, {
    String? action,
    VoidCallback? onAction,
  }) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.sectionTitle)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action,
              style: AppTextStyles.body.copyWith(color: AppColors.primary),
            ),
          ),
      ],
    );
  }

  Widget _buildVehicleInformation() {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _informationRow(('MAKE', make), ('MODEL', model)),
          _informationRow(('YEAR', year), ('FUEL TYPE', fuelType)),
          _informationRow(
            ('ODOMETER', odometer),
            ('VARIANT', variant),
            showBottomBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _informationRow(
    (String, String) left,
    (String, String) right, {
    bool showBottomBorder = true,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space16.w,
        vertical: AppDimensions.space16.h,
      ),
      decoration: BoxDecoration(
        border: showBottomBorder
            ? Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(child: _informationCell(left.$1, left.$2)),
          Container(
            width: 1,
            height: 40.h,
            color: AppColors.divider,
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.space4.w),
          ),
          Expanded(child: _informationCell(right.$1, right.$2)),
        ],
      ),
    );
  }

  Widget _informationCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.4,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildPurchaseDetails() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _purchaseValue('Date', '15 Mar 2025'),
              _purchaseValue('Price', '₹6,50,000'),
              _purchaseValue('At Purchase', '12,000 km'),
            ],
          ),
          SizedBox(height: AppDimensions.space16.h),
          Divider(height: 1, color: AppColors.divider),
          SizedBox(height: AppDimensions.space16.h),
          Text(
            'PURCHASE DOCUMENTS (2)',
            style: AppTextStyles.fieldLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.space8.h),
          _documentRow(
            icon: Icons.picture_as_pdf_outlined,
            name: 'Purchase Invoice.pdf',
            details: '1.8 MB · 15 Mar 2025',
            background: const Color(0xFFFCE8E6),
            foreground: const Color(0xFFC94C45),
          ),
          SizedBox(height: AppDimensions.space4.h),
          _documentRow(
            icon: Icons.receipt_long_outlined,
            name: 'Payment Receipt.pdf',
            details: '420 KB · 15 Mar 2025',
            background: const Color(0xFFFFF3E4),
            foreground: const Color(0xFFEF8200),
          ),
          SizedBox(height: AppDimensions.space12.h),
          GestureDetector(
            onTap: onAddPurchaseDocument,
            child: Text(
              '+ Add purchase document',
              style: AppTextStyles.body.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _purchaseValue(String label, String value) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            SizedBox(height: 5.h),
            Text(
              value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Personal notes',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: onEditDetails,
              child: Text(
                'Edit',
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.space8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppDimensions.space16.w),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '“Keep an eye on the front tyres before the next long trip.”',
                style: AppTextStyles.body.copyWith(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 5.h),
              Text(
                'Updated 2 weeks ago',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachedDocuments() {
    return Container(
      decoration: _cardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _documentRow(
            icon: Icons.verified_user_outlined,
            name: 'Insurance.pdf',
            details: 'Valid until 14 Sep 2026 · 2.4 MB',
            background: const Color(0xFFEDEBFF),
            foreground: const Color(0xFF258C69),
            showBorder: true,
          ),
          _documentRow(
            icon: Icons.badge_outlined,
            name: 'RC.pdf',
            details: 'Verified · 1.1 MB',
            background: const Color(0xFFE5E9F5),
            foreground: const Color(0xFF657087),
            showBorder: true,
          ),
          _documentRow(
            icon: Icons.shield_outlined,
            name: 'PUC Certificate.pdf',
            details: 'Valid until Dec 2025 · 850 KB',
            background: const Color(0xFFFFF3E4),
            foreground: const Color(0xFFEF8200),
          ),
        ],
      ),
    );
  }

  Widget _documentRow({
    required IconData icon,
    required String name,
    required String details,
    required Color background,
    required Color foreground,
    bool showBorder = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space12.w,
        vertical: AppDimensions.space8.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: showBorder
            ? Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          _iconTile(
            icon,
            background: background,
            foreground: foreground,
            size: 36,
          ),
          SizedBox(width: AppDimensions.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  details,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.space8.w),
          Text(
            'View',
            style: AppTextStyles.body.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceCard() {
    return Material(
      color: AppColors.surface,
      borderRadius: AppRadius.largeRadius.r,
      child: InkWell(
        onTap: onMaintenanceTap,
        borderRadius: AppRadius.largeRadius.r,
        child: Container(
          padding: EdgeInsets.all(AppDimensions.space16.w),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: AppRadius.largeRadius.r,
          ),
          child: Row(
            children: [
              _iconTile(
                Icons.build_outlined,
                background: const Color(0xFFFFF3E4),
                foreground: const Color(0xFFEF8200),
                size: 40,
              ),
              SizedBox(width: AppDimensions.space8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maintenance & records',
                      style: AppTextStyles.cardTitle,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'View service, repairs, fuel, expenses and odometer history.',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppDimensions.space8.w),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconTile(
    IconData icon, {
    required Color background,
    required Color foreground,
    required double size,
  }) {
    return Container(
      width: size.w,
      height: size.h,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.mediumRadius.r,
      ),
      child: Icon(icon, color: foreground, size: (size * 0.48).sp),
    );
  }

  Widget _pill(IconData? icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: AppColors.textSecondary),
            SizedBox(width: 4.w),
          ],
          Text(text, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: AppRadius.largeRadius.r,
      border: Border.all(color: AppColors.border),
    );
  }
}
