import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/widgets/app_document_section.dart';
import '../../core/constants/app_options.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';

/// Result returned when a note is saved.
class VehicleNoteResult {
  final String vehicleName;
  final String title;
  final String details;
  final DateTime noteDate;
  final String? category;
  final List<NoteAttachment> attachments;

  const VehicleNoteResult({
    required this.vehicleName,
    required this.title,
    required this.details,
    required this.noteDate,
    required this.category,
    required this.attachments,
  });
}

/// A selected file attached to a note.
class NoteAttachment {
  final String name;
  final String? path;
  final int sizeBytes;

  const NoteAttachment({
    required this.name,
    required this.path,
    required this.sizeBytes,
  });

  String get formattedSize {
    if (sizeBytes >= 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }

    if (sizeBytes >= 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    }

    return '$sizeBytes B';
  }
}

class AddNoteScreen extends StatefulWidget {
  final String vehicleName;
  final String make;
  final String model;
  final String year;

  const AddNoteScreen({
    super.key,
    required this.vehicleName,
    required this.make,
    required this.model,
    required this.year,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();

  DateTime _noteDate = DateTime.now();
  String? _category;
  final List<NoteAttachment> _attachments = [];

  bool _saveAttempted = false;
  bool _isSaving = false;

  static const int _maxDetailsLength = 1000;
  static const int _maxFileSizeBytes = 25 * 1024 * 1024;

  static const Map<String, String> _categories = {
    'maintenance': 'Maintenance',
    'repair': 'Repair',
    'fuel': 'Fuel',
    'purchase': 'Purchase',
    'insurance': 'Insurance',
    'general': 'General',
    'other': 'Other',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final today = DateTime.now();

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today, ${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _noteDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null && mounted) {
      setState(() => _noteDate = selectedDate);
    }
  }

  Future<void> _pickAttachments() async {
    try {
      final selectedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (!mounted || selectedFiles.isEmpty) return;

      final newAttachments = <NoteAttachment>[];
      final skippedFiles = <String>[];

      for (final file in selectedFiles) {
        final path = file.path;

        // This screen requires a local path to read and attach the file.
        if (path == null) {
          skippedFiles.add(file.name);
          continue;
        }

        final alreadyAdded = _attachments.any(
          (attachment) => attachment.name == file.name,
        );

        final alreadySelected = newAttachments.any(
          (attachment) => attachment.name == file.name,
        );

        if (alreadyAdded || alreadySelected) continue;

        int fileSize;

        try {
          fileSize = await File(path).length();
        } catch (_) {
          skippedFiles.add(file.name);
          continue;
        }

        if (fileSize > _maxFileSizeBytes) {
          skippedFiles.add('${file.name} (over 25 MB)');
          continue;
        }

        newAttachments.add(
          NoteAttachment(name: file.name, path: path, sizeBytes: fileSize),
        );
      }

      if (!mounted) return;

      setState(() => _attachments.addAll(newAttachments));

      if (skippedFiles.isNotEmpty) {
        _showMessage(
          'Some files could not be attached: ${skippedFiles.join(', ')}',
        );
      }
    } catch (error) {
      if (mounted) {
        _showMessage('Unable to select files. Please try again.');
      }
    }
  }

  void _removeAttachment(int index) {
    setState(() => _attachments.removeAt(index));
  }

  void _saveNote() {
    FocusScope.of(context).unfocus();
    setState(() => _saveAttempted = true);

    if (_titleController.text.trim().isEmpty) {
      _showMessage('Please enter a note title.');
      return;
    }

    setState(() => _isSaving = true);

    final result = VehicleNoteResult(
      vehicleName: widget.vehicleName,
      title: _titleController.text.trim(),
      details: _detailsController.text.trim(),
      noteDate: _noteDate,
      category: _category,
      attachments: List.unmodifiable(_attachments),
    );

    // TODO: Save through the local JSON repository.

    setState(() => _isSaving = false);
    Navigator.of(context).pop(result);
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          duration: const Duration(seconds: 3),
        ),
      );
  }

  Widget _buildVehicleSelector() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.space12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Icon(
              Icons.directions_car_filled_outlined,
              color: AppColors.primary,
              size: 22.sp,
            ),
          ),
          SizedBox(width: AppDimensions.space12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehicleName,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '${widget.make} ${widget.model} · ${widget.year}',
                  style: AppTextStyles.bodySecondary.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.unfold_more, color: AppColors.textSecondary, size: 22.sp),
        ],
      ),
    );
  }

  Widget _buildFieldHeading(
    String title, {
    String? trailing,
    Color? trailingColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.fieldLabel.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: AppTextStyles.caption.copyWith(
              color: trailingColor ?? AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _selectDate,
      borderRadius: AppRadius.mediumRadius,
      child: Container(
        height: AppDimensions.inputHeight.h,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.space16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: AppRadius.mediumRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatDate(_noteDate),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.calendar_month_outlined,
              color: AppColors.textSecondary,
              size: 21.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIndicator() {
    final color = _category == 'maintenance'
        ? AppColors.primary
        : AppColors.textSecondary;

    return Container(
      width: 9.w,
      height: 9.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildAttachments() {
    final documents = _attachments.map((attachment) {
      final isPdf = attachment.name.toLowerCase().endsWith('.pdf');

      return AppDocumentItem(
        name: attachment.name,
        description: '${attachment.formattedSize} · Attached',
        icon: isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
      );
    }).toList();

    return AppDocumentSection(
      title: 'Attachments',
      subtitle: 'Add photos or files related to this note.',
      documents: documents,
      onAddDocuments: _pickAttachments,
      onRemoveDocument: _removeAttachment,
      emptyMessage: 'No files attached yet',
      emptySubtitle: 'PDF, JPG or PNG up to 25MB',
    );
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
          tooltip: 'Back',
        ),
        title: Text(
          'Add Note',
          style: AppTextStyles.screenTitle.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppDimensions.space16.w),
            child: CircleAvatar(
              radius: 17.r,
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person_outline,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.pageHorizontalPadding.w,
                    vertical: AppDimensions.space12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVehicleSelector(),
                      SizedBox(height: AppDimensions.space24.h),

                      Text(
                        'What would you like to remember?',
                        style: AppTextStyles.pageTitle.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppDimensions.space8.h),
                      Text(
                        'Save useful details about your vehicle.',
                        style: AppTextStyles.bodySecondary.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppDimensions.space24.h),

                      _buildFieldHeading(
                        'Note title',
                        trailing: 'Required',
                        trailingColor: AppColors.primary,
                      ),
                      SizedBox(height: AppDimensions.space8.h),
                      AppTextField(
                        label: '',
                        controller: _titleController,
                        hint: 'Enter a title for your note',
                        maxLines: 1,
                        hasError:
                            _saveAttempted &&
                            _titleController.text.trim().isEmpty,
                        onChanged: (_) => setState(() {}),
                      ),
                      FormField<String>(
                        validator: (_) {
                          if (_titleController.text.trim().isEmpty) {
                            return 'Please enter a note title.';
                          }
                          return null;
                        },
                        builder: (field) {
                          if (field.errorText == null) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding: EdgeInsets.only(
                              top: AppDimensions.space4.h,
                            ),
                            child: Text(
                              field.errorText!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppDimensions.space20.h),

                      _buildFieldHeading(
                        'Note details',
                        trailing: '${_detailsController.text.length} chars',
                      ),
                      SizedBox(height: AppDimensions.space8.h),
                      AppTextField(
                        label: '',
                        controller: _detailsController,
                        hint: 'Write down the details you want to remember...',
                        maxLines: 5,
                        onChanged: (_) => setState(() {}),
                      ),
                      SizedBox(height: AppDimensions.space20.h),

                      _buildFieldHeading('Date of note'),
                      SizedBox(height: AppDimensions.space8.h),
                      _buildDateField(),
                      SizedBox(height: AppDimensions.space20.h),

                      _buildFieldHeading('Category', trailing: 'Optional'),
                      SizedBox(height: AppDimensions.space8.h),
                      AppDropdown(
                        label: '',
                        value: _category ?? "",
                        options: _categories,
                        hint: 'Select a category',
                        onChanged: (value) {
                          setState(() => _category = value);
                        },
                      ),
                      if (_category != null) ...[
                        SizedBox(height: AppDimensions.space8.h),
                        Row(
                          children: [
                            _buildCategoryIndicator(),
                            SizedBox(width: AppDimensions.space8.w),
                            Text(
                              _categories[_category] ?? 'Other',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: AppDimensions.space24.h),

                      _buildAttachments(),
                      SizedBox(height: AppDimensions.space24.h),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed bottom actions, matching the Fuel Refill screen.
            Container(
              width: double.infinity,
              color: AppColors.background,
              padding: EdgeInsets.fromLTRB(
                AppDimensions.pageHorizontalPadding.w,
                AppDimensions.space8.h,
                AppDimensions.pageHorizontalPadding.w,
                AppDimensions.space16.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeight.h,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveNote,
                      icon: _isSaving
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check, size: 20),
                      label: Text(_isSaving ? 'Saving...' : 'Save note'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.mediumRadius,
                        ),
                        textStyle: AppTextStyles.button,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.space4.h),
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).maybePop(),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.bodySecondary.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
