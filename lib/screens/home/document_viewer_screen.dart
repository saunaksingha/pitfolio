import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class DocumentViewerScreen extends StatefulWidget {
  final String documentName;
  final String filePath;
  final String fileSize;
  final String documentType;
  final VoidCallback? onOpenDocument;
  final VoidCallback? onShareDocument;
  final VoidCallback? onSaveCopy;

  const DocumentViewerScreen({
    super.key,
    required this.documentName,
    required this.filePath,
    this.fileSize = '',
    this.documentType = 'PDF',
    this.onOpenDocument,
    this.onShareDocument,
    this.onSaveCopy,
  });

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  double _zoom = 1.0;

  void _zoomIn() {
    setState(() {
      _zoom = (_zoom + 0.1).clamp(0.5, 2.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoom = (_zoom - 0.1).clamp(0.5, 2.0);
    });
  }

  void _resetZoom() {
    setState(() {
      _zoom = 1.0;
    });
  }

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
          'Document Viewer',
          style: AppTextStyles.screenTitle.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.onShareDocument,
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
            _buildDocumentHeader(),
            Expanded(child: _buildPreviewArea()),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space16.w),
      color: AppColors.surface,
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E4),
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Icon(
              widget.documentType.toUpperCase() == 'PDF'
                  ? Icons.picture_as_pdf_outlined
                  : Icons.image_outlined,
              color: AppColors.primary,
              size: 23.sp,
            ),
          ),
          SizedBox(width: AppDimensions.space12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.documentName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppDimensions.space4.h),
                Text(
                  [
                    widget.documentType.toUpperCase(),
                    if (widget.fileSize.isNotEmpty) widget.fileSize,
                  ].join(' · '),
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

  Widget _buildPreviewArea() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.space16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: AppRadius.largeRadius,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space16.w,
                vertical: AppDimensions.space12.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'DOCUMENT PREVIEW',
                      style: AppTextStyles.fieldLabel.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    '${(_zoom * 100).round()}%',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.space12.w,
                  0,
                  AppDimensions.space12.w,
                  AppDimensions.space12.h,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.mediumRadius,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _buildPreviewPlaceholder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewPlaceholder() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.space24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.documentType.toUpperCase() == 'PDF'
                  ? Icons.picture_as_pdf_outlined
                  : Icons.image_outlined,
              size: 56.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppDimensions.space16.h),
            Text(
              'Preview not connected yet',
              textAlign: TextAlign.center,
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppDimensions.space8.h),
            Text(
              'Connect a PDF or image renderer to inspect this file here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppDimensions.space16.h),
            Text(
              widget.filePath,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding.w,
        AppDimensions.space12.h,
        AppDimensions.pageHorizontalPadding.w,
        AppDimensions.space16.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _zoomOut,
                icon: const Icon(Icons.remove),
                tooltip: 'Zoom out',
              ),
              TextButton(
                onPressed: _resetZoom,
                child: Text(
                  'Reset zoom',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: _zoomIn,
                icon: const Icon(Icons.add),
                tooltip: 'Zoom in',
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight.h,
            child: ElevatedButton.icon(
              onPressed: widget.onOpenDocument,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open full document'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                textStyle: AppTextStyles.button,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.largeRadius,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.space8.h),
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight.h,
            child: OutlinedButton.icon(
              onPressed: widget.onSaveCopy,
              icon: const Icon(Icons.download_outlined),
              label: const Text('Save a copy'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(color: AppColors.border),
                textStyle: AppTextStyles.button,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.largeRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
