import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_action.dart';

class DocumentDetailsScreen extends StatelessWidget {
  final String documentName;
  final String documentType;
  final String fileSize;
  final String category;
  final String addedDate;
  final String? expiryDate;
  final String filePath;

  final Future<void>? onViewDocument;
  final VoidCallback? onShareDocument;
  final VoidCallback? onReplaceDocument;
  final VoidCallback? onSaveCopy;

  const DocumentDetailsScreen({
    super.key,
    required this.documentName,
    this.documentType = 'PDF document',
    this.fileSize = '1.8 MB',
    this.category = 'Vehicle documents',
    this.addedDate = '15 Mar 2025',
    this.expiryDate,
    this.filePath = '',
    this.onViewDocument,
    this.onShareDocument,
    this.onReplaceDocument,
    this.onSaveCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          tooltip: 'Go back',
        ),
        title: Text(
          'Document details',
          style: AppTextStyles.screenTitle.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: onShareDocument,
            icon: const Icon(Icons.share_outlined),
            color: AppColors.textSecondary,
            tooltip: 'Share document',
          ),
          SizedBox(width: AppDimensions.space8.w),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.pageHorizontalPadding.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDocumentCard(),
                    SizedBox(height: AppDimensions.space24.h),
                    Text(
                      'Document information',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppDimensions.space12.h),
                    _buildInformationCard(),
                    SizedBox(height: AppDimensions.space24.h),
                    Text(
                      'File location',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppDimensions.space12.h),
                    _buildFileLocation(),
                    SizedBox(height: AppDimensions.space24.h),
                    _buildActionCard(),
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard() {
    final isPdf = documentType.toLowerCase().contains('pdf');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.largeRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 76.w,
            height: 92.h,
            decoration: BoxDecoration(
              color: isPdf ? const Color(0xFFFFEAE7) : AppColors.primarySoft,
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
              color: isPdf ? const Color(0xFFC94C45) : AppColors.primary,
              size: 42.sp,
            ),
          ),
          SizedBox(height: AppDimensions.space16.h),
          Text(
            documentName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.cardTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.space8.h),
          Text(
            '$documentType · $fileSize',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimensions.space16.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space12.w,
              vertical: AppDimensions.space8.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                  size: 16.sp,
                ),
                SizedBox(width: AppDimensions.space4.w),
                Text(
                  'Document added',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.largeRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _informationRow('Document name', documentName),
          _informationRow('File type', documentType),
          _informationRow('File size', fileSize),
          _informationRow('Category', category),
          _informationRow('Date added', addedDate),
          if (expiryDate != null) _informationRow('Expiry date', expiryDate!),
        ],
      ),
    );
  }

  Widget _informationRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.space8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.bodySecondary.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: AppDimensions.space12.w),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileLocation() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.largeRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            color: AppColors.textSecondary,
            size: 22.sp,
          ),
          SizedBox(width: AppDimensions.space8.w),
          Expanded(
            child: Text(
              filePath.isEmpty ? 'File path unavailable' : filePath,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySecondary.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.largeRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document actions',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppDimensions.space16.h),
          // _actionRow(
          //   icon: Icons.visibility_outlined,
          //   title: 'View document',
          //   subtitle: 'Open the PDF or image',
          //   onTap: onViewDocument,
          // ),
          Divider(height: AppDimensions.space24.h),
          _actionRow(
            icon: Icons.swap_horiz,
            title: 'Replace file',
            subtitle: 'Choose a newer version',
            onTap: onReplaceDocument,
          ),
          Divider(height: AppDimensions.space24.h),
          _actionRow(
            icon: Icons.download_outlined,
            title: 'Save a copy',
            subtitle: 'Save a separate copy of this file',
            onTap: onSaveCopy,
          ),
        ],
      ),
    );
  }

  Widget _actionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mediumRadius,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.space4.h),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 23.sp),
            SizedBox(width: AppDimensions.space12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding.w,
        AppDimensions.space12.h,
        AppDimensions.pageHorizontalPadding.w,
        0,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      // child: AppBottomAction(label: 'View document', onPressed: onViewDocument),
    );
  }
}
