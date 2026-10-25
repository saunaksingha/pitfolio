import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/constants/app_options.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_action.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_document_section.dart';

class VehicleDocumentFile {
  const VehicleDocumentFile({
    required this.name,
    required this.sizeBytes,
    required this.path,
    required this.extension,
  });

  final String name;
  final int sizeBytes;
  final String? path;
  final String extension;

  String get sizeLabel {
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData get icon => extension.toLowerCase() == 'pdf'
      ? Icons.picture_as_pdf_outlined
      : Icons.image_outlined;

  AppDocumentItem toAppDocumentItem() => AppDocumentItem(
    name: name,
    description: '$sizeLabel · Ready',
    icon: icon,
  );
}

class VehicleDocumentResult {
  const VehicleDocumentResult({
    required this.documentType,
    required this.documentName,
    required this.documentNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.notes,
    required this.files,
  });

  final String documentType;
  final String documentName;
  final String documentNumber;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final String notes;
  final List<VehicleDocumentFile> files;
}

class AddDocumentsScreen extends StatefulWidget {
  const AddDocumentsScreen({
    super.key,
    required this.vehicleName,
    required this.make,
    required this.model,
    required this.year,
  });

  final String vehicleName;
  final String make;
  final String model;
  final String year;

  @override
  State<AddDocumentsScreen> createState() => _AddDocumentsScreenState();
}

class _AddDocumentsScreenState extends State<AddDocumentsScreen> {
  final _documentNameController = TextEditingController();
  final _documentNumberController = TextEditingController();
  final _notesController = TextEditingController();

  static const _allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
  static const _maxFileSizeBytes = 25 * 1024 * 1024;

  String _documentType = documentTypes.containsKey('insurance')
      ? 'insurance'
      : documentTypes.keys.first;

  DateTime? _issueDate;
  DateTime? _expiryDate;

  final List<VehicleDocumentFile> _files = [];

  bool _documentNameHasError = false;
  bool _isSaving = false;
  bool _isPickingFiles = false;

  @override
  void dispose() {
    _documentNameController.dispose();
    _documentNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<int?> _getFileSize(String? path) async {
    if (path == null) return null;

    try {
      return await File(path).length();
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickFiles() async {
    if (_isPickingFiles) return;

    setState(() => _isPickingFiles = true);

    try {
      // Uses the pickFiles API available in your project.
      final selectedFiles = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
      );

      if (!mounted || selectedFiles.isEmpty) return;

      final newFiles = <VehicleDocumentFile>[];
      var rejected = 0;
      var duplicates = 0;

      for (final file in selectedFiles) {
        final extension = (file.extension ?? '').toLowerCase();
        final fileSize = await _getFileSize(file.path);

        if (!_allowedExtensions.contains(extension) ||
            fileSize == null ||
            fileSize > _maxFileSizeBytes) {
          rejected++;
          continue;
        }

        final exists = [
          ..._files,
          ...newFiles,
        ].any((item) => item.name.toLowerCase() == file.name.toLowerCase());

        if (exists) {
          duplicates++;
          continue;
        }

        newFiles.add(
          VehicleDocumentFile(
            name: file.name,
            sizeBytes: fileSize,
            path: file.path,
            extension: extension,
          ),
        );
      }

      if (!mounted) return;

      setState(() => _files.addAll(newFiles));

      if (rejected > 0) {
        _showMessage(
          '$rejected file(s) skipped. Use PDF, JPG or PNG up to 25 MB.',
        );
      } else if (duplicates > 0) {
        _showMessage('$duplicates duplicate file(s) skipped.');
      } else if (newFiles.isNotEmpty) {
        _showMessage('${newFiles.length} file(s) added.');
      }
    } catch (_) {
      _showMessage('Could not select files. Please try again.');
    } finally {
      if (mounted) setState(() => _isPickingFiles = false);
    }
  }

  void _removeFile(int index) {
    if (index < 0 || index >= _files.length) return;
    setState(() => _files.removeAt(index));
  }

  Future<void> _selectDate({required bool isIssueDate}) async {
    final current = isIssueDate ? _issueDate : _expiryDate;
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: isIssueDate ? 'Select issue date' : 'Select expiry date',
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

    if (!mounted || selected == null) return;

    setState(() {
      if (isIssueDate) {
        _issueDate = selected;

        if (_expiryDate != null && !_expiryDate!.isAfter(selected)) {
          _expiryDate = null;
        }
      } else {
        _expiryDate = selected;
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';

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

    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space16.w,
        vertical: AppDimensions.space4.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
            tooltip: 'Back',
          ),
          SizedBox(width: AppDimensions.space4.w),
          Expanded(
            child: Text(
              'Add Documents',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: const BoxDecoration(
              color: Color(0xFF995500),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: AppDimensions.iconMedium.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.space12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
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
              size: AppDimensions.iconLarge.sp,
            ),
          ),
          SizedBox(width: AppDimensions.space8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vehicleName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14.sp),
                ),
                Text(
                  '${widget.make} ${widget.model} · ${widget.year}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Icon(
            Icons.unfold_more,
            color: AppColors.textSecondary,
            size: AppDimensions.iconMedium.sp,
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String label, {bool required = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.fieldLabel.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          required ? 'Required' : 'Optional',
          style: AppTextStyles.caption.copyWith(
            color: required ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required bool isIssueDate,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label),
          SizedBox(height: AppDimensions.space8.h),
          InkWell(
            onTap: () => _selectDate(isIssueDate: isIssueDate),
            borderRadius: AppRadius.largeRadius,
            child: Container(
              height: AppDimensions.inputHeight.h,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.space12.w,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border),
                borderRadius: AppRadius.largeRadius,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatDate(date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(fontSize: 13.sp),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                    size: AppDimensions.iconMedium.sp,
                  ),
                ],
              ),
            ),
          ),
          if (!isIssueDate && date != null && date.isAfter(DateTime.now())) ...[
            SizedBox(height: AppDimensions.space4.h),
            Text(
              'Expires in ${date.difference(DateTime.now()).inDays} days',
              style: AppTextStyles.caption.copyWith(color: AppColors.success),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Document type', required: true),
        SizedBox(height: AppDimensions.space8.h),
        AppDropdown(
          label: '',
          value: _documentType,
          options: documentTypes,
          onChanged: (value) {
            if (value != null) {
              setState(() => _documentType = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDocumentNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Document name', required: true),
        SizedBox(height: AppDimensions.space8.h),
        AppTextField(
          label: '',
          controller: _documentNameController,
          hint: 'Enter document name',
          hasError: _documentNameHasError,
          onChanged: (value) {
            if (_documentNameHasError && value.trim().isNotEmpty) {
              setState(() => _documentNameHasError = false);
            }
          },
        ),
      ],
    );
  }

  Widget _buildDocumentNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Document number'),
        SizedBox(height: AppDimensions.space8.h),
        AppTextField(
          label: '',
          controller: _documentNumberController,
          hint: 'Enter policy or certificate number',
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Notes'),
        SizedBox(height: AppDimensions.space8.h),
        AppTextField(
          label: '',
          controller: _notesController,
          hint: 'Add notes about this document',
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }

  Widget _buildFilesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Files',
                style: AppTextStyles.fieldLabel.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              '${_files.length} uploaded',
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.space8.h),
        AppDocumentSection(
          title: 'Upload documents or photos',
          subtitle: 'PDF, JPG or PNG (up to 25 MB)',
          documents: _files.map((file) => file.toAppDocumentItem()).toList(),
          onAddDocuments: _pickFiles,
          onRemoveDocument: _removeFile,
          emptyMessage: 'Upload documents or photos',
          emptySubtitle: 'PDF, JPG or PNG (up to 25 MB)',
        ),
        if (_files.isEmpty) ...[
          SizedBox(height: AppDimensions.space4.h),
          Text(
            'At least one document is required.',
            style: AppTextStyles.caption.copyWith(color: AppColors.error),
          ),
        ],
        if (_isPickingFiles) ...[
          SizedBox(height: AppDimensions.space8.h),
          const LinearProgressIndicator(),
        ],
      ],
    );
  }

  void _saveDocuments() {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    final name = _documentNameController.text.trim();
    setState(() => _documentNameHasError = name.isEmpty);

    if (name.isEmpty) {
      _showMessage('Please enter a document name.');
      return;
    }

    if (_files.isEmpty) {
      _showMessage('Please upload at least one document.');
      return;
    }

    if (_issueDate != null &&
        _expiryDate != null &&
        !_expiryDate!.isAfter(_issueDate!)) {
      _showMessage('Expiry date must be after the issue date.');
      return;
    }

    setState(() => _isSaving = true);

    Navigator.of(context).pop<VehicleDocumentResult>(
      VehicleDocumentResult(
        documentType: _documentType,
        documentName: name,
        documentNumber: _documentNumberController.text.trim(),
        issueDate: _issueDate,
        expiryDate: _expiryDate,
        notes: _notesController.text.trim(),
        files: List.unmodifiable(_files),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            // Same header structure as Fuel Refill.
            _buildHeader(),

            // Same scrollable form structure as Fuel Refill.
            Expanded(
              child: Form(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppDimensions.pageHorizontalPadding.w,
                    AppDimensions.space8.h,
                    AppDimensions.pageHorizontalPadding.w,
                    AppDimensions.space24.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVehicleCard(),
                      SizedBox(height: AppDimensions.space24.h),

                      Text(
                        'Keep your documents\norganized',
                        style: AppTextStyles.pageTitle.copyWith(
                          fontSize: 27.sp,
                        ),
                      ),
                      SizedBox(height: AppDimensions.space4.h),
                      Text(
                        'Store important files for easy access whenever you need them.',
                        style: AppTextStyles.bodySecondary.copyWith(
                          fontSize: 14.sp,
                        ),
                      ),

                      SizedBox(height: AppDimensions.space24.h),
                      _buildDocumentTypeField(),

                      SizedBox(height: AppDimensions.space16.h),
                      _buildDocumentNameField(),

                      SizedBox(height: AppDimensions.space16.h),
                      _buildDocumentNumberField(),

                      SizedBox(height: AppDimensions.space16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateField(
                            label: 'Issue date',
                            date: _issueDate,
                            isIssueDate: true,
                          ),
                          SizedBox(width: AppDimensions.space12.w),
                          _buildDateField(
                            label: 'Expiry date',
                            date: _expiryDate,
                            isIssueDate: false,
                          ),
                        ],
                      ),

                      SizedBox(height: AppDimensions.space16.h),
                      _buildNotesField(),

                      SizedBox(height: AppDimensions.space16.h),
                      _buildFilesSection(),
                    ],
                  ),
                ),
              ),
            ),

            // Same fixed bottom actions as Fuel Refill.
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.pageHorizontalPadding.w,
                AppDimensions.space8.h,
                AppDimensions.pageHorizontalPadding.w,
                AppDimensions.space8.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBottomAction(
                    label: 'Save documents',
                    isLoading: _isSaving,
                    onPressed: _isSaving ? null : _saveDocuments,
                  ),
                  TextButton(
                    onPressed: _isSaving
                        ? null
                        : () => Navigator.of(context).maybePop(),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.bodySecondary.copyWith(
                        fontWeight: FontWeight.w600,
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
