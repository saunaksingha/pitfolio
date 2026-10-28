import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_action.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_document_section.dart';

class ServiceRepairResult {
  const ServiceRepairResult({
    required this.serviceType,
    required this.description,
    required this.serviceDate,
    required this.odometer,
    required this.totalCost,
    required this.provider,
    required this.attachments,
  });

  final String serviceType;
  final String description;
  final DateTime serviceDate;
  final int odometer;
  final double totalCost;
  final String provider;
  final List<AppDocumentItem> attachments;
}

class ServiceRepairScreen extends StatefulWidget {
  const ServiceRepairScreen({
    super.key,
    required this.vehicleName,
    required this.make,
    required this.model,
    required this.year,
    required this.currentOdometer,
  });

  final String vehicleName;
  final String make;
  final String model;
  final String year;
  final int currentOdometer;

  @override
  State<ServiceRepairScreen> createState() => _ServiceRepairScreenState();
}

class _ServiceRepairScreenState extends State<ServiceRepairScreen> {
  final _descriptionController = TextEditingController();
  final _odometerController = TextEditingController();
  final _costController = TextEditingController();
  final _providerController = TextEditingController();

  DateTime _serviceDate = DateTime.now();
  String _serviceType = 'regular_service';

  bool _isSaving = false;
  bool _odometerHasError = false;
  bool _costHasError = false;

  final List<AppDocumentItem> _attachments = [];

  static const Map<String, String> _serviceTypes = {
    'regular_service': 'Regular service',
    'oil_change': 'Oil change',
    'repair': 'Repair',
    'inspection': 'Inspection',
    'tyre_service': 'Tyre service',
    'battery': 'Battery service',
    'brake_service': 'Brake service',
    'ac_service': 'AC service',
    'washing': 'Washing / detailing',
    'other': 'Other',
  };

  @override
  void initState() {
    super.initState();
    _odometerController.text = _formatNumber(widget.currentOdometer);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _odometerController.dispose();
    _costController.dispose();
    _providerController.dispose();
    super.dispose();
  }

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
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
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    final formatted =
        '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} ${date.year}';

    return isToday ? 'Today, $formatted' : formatted;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectServiceDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _serviceDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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

    if (selected != null && mounted) {
      setState(() => _serviceDate = selected);
    }
  }

  Future<void> _pickAttachments() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (!mounted || result.isEmpty) return;

      const maxSize = 10 * 1024 * 1024;
      final added = <AppDocumentItem>[];
      var rejected = 0;
      var duplicates = 0;

      for (final file in result) {
        final extension = file.extension?.toLowerCase();
        final size = await file.length();

        if (!mounted) return;

        if (extension == null ||
            !['pdf', 'jpg', 'jpeg', 'png'].contains(extension) ||
            size == null ||
            size <= 0 ||
            size > maxSize) {
          rejected++;
          continue;
        }

        final duplicate = [
          ..._attachments,
          ...added,
        ].any((item) => item.name.toLowerCase() == file.name.toLowerCase());

        if (duplicate) {
          duplicates++;
          continue;
        }

        final sizeLabel = size >= 1024 * 1024
            ? '${(size / (1024 * 1024)).toStringAsFixed(1)} MB'
            : '${(size / 1024).ceil()} KB';

        added.add(
          AppDocumentItem(
            name: file.name,
            description: '$sizeLabel · Uploaded',
            icon: extension == 'pdf'
                ? Icons.picture_as_pdf_outlined
                : Icons.image_outlined,
          ),
        );
      }

      if (!mounted) return;

      setState(() => _attachments.addAll(added));

      if (added.isNotEmpty) {
        _showSnackBar('${added.length} attachment(s) added.');
      }

      if (duplicates > 0) {
        _showSnackBar('$duplicates duplicate file(s) skipped.');
      }

      if (rejected > 0) {
        _showSnackBar(
          '$rejected file(s) rejected. Use PDF, JPG or PNG up to 10 MB.',
        );
      }

      if (added.isEmpty && duplicates == 0 && rejected == 0) {
        _showSnackBar('No attachments selected.');
      }
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Unable to select attachments. Please try again.');
    }
  }

  Future<void> _saveService() async {
    if (_isSaving) return;

    final odometerText = _odometerController.text.replaceAll(',', '').trim();
    final odometer = int.tryParse(odometerText);
    final odometerInvalid =
        odometer == null || odometer < widget.currentOdometer;

    final cost = double.tryParse(
      _costController.text.replaceAll(',', '').trim(),
    );
    final costInvalid = cost == null || cost < 0;

    setState(() {
      _odometerHasError = odometerInvalid;
      _costHasError = costInvalid;
    });

    if (odometerInvalid) {
      _showSnackBar(
        'Enter an odometer reading of at least '
        '${_formatNumber(widget.currentOdometer)} km.',
      );
      return;
    }

    if (costInvalid) {
      _showSnackBar('Enter a valid total cost (zero or more).');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final result = ServiceRepairResult(
        serviceType: _serviceType,
        description: _descriptionController.text.trim(),
        serviceDate: _serviceDate,
        odometer: odometer,
        totalCost: cost,
        provider: _providerController.text.trim(),
        attachments: List.unmodifiable(_attachments),
      );

      if (!mounted) return;
      Navigator.of(context).pop<ServiceRepairResult>(result);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Unable to save the service record. Please try again.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
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
                          'Log service or repair',
                          style: AppTextStyles.pageTitle.copyWith(
                            fontSize: 27.sp,
                          ),
                        ),
                        SizedBox(height: AppDimensions.space4.h),
                        Text(
                          'Keep a record of the work done on your vehicle.',
                          style: AppTextStyles.bodySecondary,
                        ),

                        SizedBox(height: AppDimensions.space24.h),

                        AppDropdown(
                          label: 'Service type',
                          value: _serviceType,
                          options: _serviceTypes,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _serviceType = value);
                            }
                          },
                        ),

                        SizedBox(height: AppDimensions.space16.h),

                        AppTextField(
                          label: 'Description (Optional)',
                          controller: _descriptionController,
                          hint:
                              'Describe the work performed, replaced parts, or inspection notes...',
                          maxLines: 3,
                        ),

                        SizedBox(height: AppDimensions.space20.h),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 340) {
                              return Column(
                                children: [
                                  _buildServiceDateField(),
                                  SizedBox(height: AppDimensions.space16.h),
                                  _buildOdometerField(),
                                  SizedBox(height: AppDimensions.space16.h),
                                  _buildCostField(),
                                  SizedBox(height: AppDimensions.space16.h),
                                  _buildProviderField(),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _buildServiceDateField()),
                                    SizedBox(width: AppDimensions.space12.w),
                                    Expanded(child: _buildOdometerField()),
                                  ],
                                ),
                                SizedBox(height: AppDimensions.space20.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _buildCostField()),
                                    SizedBox(width: AppDimensions.space12.w),
                                    Expanded(child: _buildProviderField()),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),

                        SizedBox(height: AppDimensions.space24.h),

                        _buildAttachmentsSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.pageHorizontalPadding.w,
                AppDimensions.space8.h,
                AppDimensions.pageHorizontalPadding.w,
                AppDimensions.space8.h,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppBottomAction(
                        label: 'Save service record',

                        onPressed: _isSaving ? null : _saveService,
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
              ),
            ),
          ],
        ),
      ),
    );
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
            tooltip: 'Go back',
            color: AppColors.textPrimary,
          ),
          SizedBox(width: AppDimensions.space4.w),
          Expanded(
            child: Text(
              'Service & Repair',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
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
              size: AppDimensions.iconLarge.sp,
            ),
          ),
          SizedBox(width: AppDimensions.space12.w),
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
                  maxLines: 2,
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

  Widget _buildServiceDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service date',
          style: AppTextStyles.fieldLabel.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.space8.h),
        InkWell(
          onTap: _selectServiceDate,
          borderRadius: AppRadius.largeRadius,
          child: Container(
            height: AppDimensions.inputHeight.h,
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.space12.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.largeRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _formatDate(_serviceDate),
                    maxLines: 2,
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
      ],
    );
  }

  Widget _buildOdometerField() {
    return AppTextField(
      label: 'Odometer reading',
      controller: _odometerController,
      hint: 'e.g. 24,500',
      suffix: 'km',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      //  hasError: _odometerHasError,
      onChanged: (_) {
        if (_odometerHasError) {
          setState(() => _odometerHasError = false);
        }
      },
    );
  }

  Widget _buildCostField() {
    return AppTextField(
      label: 'Total cost',
      controller: _costController,
      hint: 'e.g. 4,250',
      prefix: '₹',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      //  hasError: _costHasError,
      onChanged: (_) {
        if (_costHasError) {
          setState(() => _costHasError = false);
        }
      },
    );
  }

  Widget _buildProviderField() {
    return AppTextField(
      label: 'Service provider (Optional)',
      controller: _providerController,
      hint: 'e.g. Maruti Service Masters',
    );
  }

  Widget _buildAttachmentsSection() {
    return AppDocumentSection(
      title: 'Attachments (Optional)',
      subtitle: 'Attach invoices, receipts or service reports.',
      documents: _attachments,
      onAddDocuments: _pickAttachments,
      onRemoveDocument: (index) {
        setState(() {
          if (index >= 0 && index < _attachments.length) {
            _attachments.removeAt(index);
          }
        });
      },
      emptyMessage: 'No attachments added yet',
      emptySubtitle: 'PDF, JPG or PNG up to 10MB',
    );
  }
}
