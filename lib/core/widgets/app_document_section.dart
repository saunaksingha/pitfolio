import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';

/// Simple display data for an attached document.
/// The parent screen owns the actual document data and actions.
class AppDocumentItem {
  final String name;
  final String description;
  final IconData icon;

  const AppDocumentItem({
    required this.name,
    required this.description,
    this.icon = Icons.description_outlined,
  });
}

class AppDocumentSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<AppDocumentItem> documents;
  final VoidCallback onAddDocuments;
  final ValueChanged<int> onRemoveDocument;
  final String emptyMessage;
  final String emptySubtitle;

  const AppDocumentSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.documents,
    required this.onAddDocuments,
    required this.onRemoveDocument,
    this.emptyMessage = 'No documents added yet',
    this.emptySubtitle = 'PDF, JPG or PNG up to 10MB',
  });

  @override
  Widget build(BuildContext context) {
    final hasDocuments = documents.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.fieldLabel.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.space4.h),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: AppDimensions.space12.h),

        OutlinedButton.icon(
          onPressed: onAddDocuments,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add documents'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
            textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
          ),
        ),

        SizedBox(height: AppDimensions.space12.h),

        if (hasDocuments)
          Container(
            padding: EdgeInsets.all(AppDimensions.space12.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Attached documents (${documents.length})',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      'Selected',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: AppDimensions.space20.h,
                  color: AppColors.divider,
                ),
                ...List.generate(documents.length, (index) {
                  final document = documents[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == documents.length - 1
                          ? 0
                          : AppDimensions.space12.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36.w,
                          height: 36.w,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.smallRadius,
                          ),
                          child: Icon(
                            document.icon,
                            color: AppColors.primary,
                            size: AppDimensions.iconMedium.sp,
                          ),
                        ),
                        SizedBox(width: AppDimensions.space8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                document.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove document',
                          onPressed: () => onRemoveDocument(index),
                          icon: Icon(
                            Icons.close,
                            size: AppDimensions.iconMedium.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.space12.w,
              vertical: AppDimensions.space24.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.file_upload_outlined,
                  size: AppDimensions.iconLarge.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppDimensions.space8.h),
                Text(
                  emptyMessage,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppDimensions.space4.h),
                Text(
                  emptySubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
