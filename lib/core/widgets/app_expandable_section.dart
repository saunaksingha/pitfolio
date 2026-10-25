import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_text_styles.dart';
import 'app_text_field.dart';
import 'app_document_section.dart';

class AppExpandableSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget? child;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;

  // Built-in Notes and Documents content.
  final TextEditingController? notesController;
  final List<AppDocumentItem>? documents;
  final VoidCallback? onAddDocuments;
  final ValueChanged<int>? onRemoveDocument;

  const AppExpandableSection({
    super.key,
    required this.title,
    required this.icon,
    this.child,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
    this.notesController,
    this.documents,
    this.onAddDocuments,
    this.onRemoveDocument,
  }) : assert(
         child != null || notesController != null || documents != null,
         'Provide custom child content or Notes/Documents content.',
       ),
       assert(
         documents == null ||
             (onAddDocuments != null && onRemoveDocument != null),
         'Document callbacks are required when documents are provided.',
       );

  @override
  State<AppExpandableSection> createState() => _AppExpandableSectionState();
}

class _AppExpandableSectionState extends State<AppExpandableSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    final nextValue = !_isExpanded;

    setState(() {
      _isExpanded = nextValue;
    });

    widget.onExpansionChanged?.call(nextValue);
  }

  Widget _buildContent() {
    // Custom content takes precedence over the built-in layout.
    if (widget.child != null) {
      return widget.child!;
    }

    final children = <Widget>[];

    // Built-in Notes field.
    if (widget.notesController != null) {
      children.add(
        AppTextField(
          label: 'Notes',
          controller: widget.notesController!,
          hint: 'Add notes about your vehicle...',
          maxLines: 4,
        ),
      );
    }

    // Built-in Other Documents section.
    if (widget.documents != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: AppDimensions.space20.h));
      }

      children.add(
        AppDocumentSection(
          title: 'Other documents',
          subtitle: 'Add any other documents related to your vehicle.',
          documents: widget.documents!,
          onAddDocuments: widget.onAddDocuments!,
          onRemoveDocument: widget.onRemoveDocument!,
          emptyMessage: 'No other documents added yet',
          emptySubtitle: 'Upload warranty cards, manuals, or maintenance slips',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: AppColors.surfaceSecondary,
            child: InkWell(
              onTap: _toggleExpanded,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.space12.w,
                  vertical: AppDimensions.space16.h,
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: AppDimensions.iconMedium.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: AppDimensions.space8.w),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: AppDimensions.iconMedium.sp,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.all(AppDimensions.space16.w),
              child: _buildContent(),
            ),
        ],
      ),
    );
  }
}
