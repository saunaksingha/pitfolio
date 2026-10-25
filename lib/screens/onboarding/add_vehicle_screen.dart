import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../core/widgets/app_expandable_section.dart';
import 'vehicle_setup_complete_screen.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  Uint8List? _vehicleImageBytes;
  String? _vehicleImageName;

  static const int _maxVehicleImageSize = 10 * 1024 * 1024;

  static const Set<String> _allowedDocumentExtensions = {
    'pdf',
    'jpg',
    'jpeg',
    'png',
  };

  final _vehicleNameController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _odometerController = TextEditingController();

  final _purchaseDateController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _purchaseOdometerController = TextEditingController();

  final _notesController = TextEditingController();

  String? _year;
  String? _fuelType;
  bool _isSaving = false;

  bool _vehicleNameHasError = false;
  bool _makeHasError = false;
  bool _modelHasError = false;
  bool _odometerHasError = false;

  final List<AppDocumentItem> _purchaseDocuments = [];
  final List<AppDocumentItem> _otherDocuments = [];

  late final Map<String, String> _years = {
    for (int year = DateTime.now().year; year >= 1980; year--) '$year': '$year',
  };

  @override
  void dispose() {
    _vehicleNameController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _odometerController.dispose();
    _purchaseDateController.dispose();
    _purchasePriceController.dispose();
    _purchaseOdometerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // ------------------------------------------------------------
  // Document picker
  // ------------------------------------------------------------

  Future<void> _pickDocuments(List<AppDocumentItem> destination) async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedDocumentExtensions.toList(),
      );

      if (!mounted || files.isEmpty) return;

      final existingNames = destination
          .map((document) => document.name.toLowerCase())
          .toSet();

      final documentsToAdd = <AppDocumentItem>[];
      var rejectedCount = 0;
      var duplicateCount = 0;

      for (final file in files) {
        final extension = file.extension?.toLowerCase();

        if (extension == null ||
            !_allowedDocumentExtensions.contains(extension)) {
          rejectedCount++;
          continue;
        }

        final fileSize = await file.length();

        if (!mounted) return;

        if (fileSize == null ||
            fileSize <= 0 ||
            fileSize > _maxVehicleImageSize) {
          rejectedCount++;
          continue;
        }

        final normalizedName = file.name.toLowerCase();

        if (existingNames.contains(normalizedName)) {
          duplicateCount++;
          continue;
        }

        documentsToAdd.add(
          AppDocumentItem(
            name: file.name,
            description: '${(fileSize / 1024).ceil()} KB',
            icon: extension == 'pdf'
                ? Icons.picture_as_pdf_outlined
                : Icons.image_outlined,
          ),
        );

        existingNames.add(normalizedName);
      }

      if (!mounted) return;

      setState(() {
        destination.addAll(documentsToAdd);
      });

      final messages = <String>[];

      if (documentsToAdd.isNotEmpty) {
        messages.add('${documentsToAdd.length} document(s) added');
      }

      if (rejectedCount > 0) {
        messages.add('$rejectedCount file(s) rejected: invalid or over 10 MB');
      }

      if (duplicateCount > 0) {
        messages.add('$duplicateCount duplicate(s) skipped');
      }

      if (messages.isEmpty) {
        messages.add('No new documents selected');
      }

      _showSnackBar(messages.join('. '));
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Unable to select documents. Please try again.');
    }
  }

  // ------------------------------------------------------------
  // Vehicle photo picker
  // ------------------------------------------------------------

  Future<void> _pickVehicleImage() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
      );

      if (file == null || !mounted) return;

      final extension = file.extension?.toLowerCase();

      if (extension == null || !['png', 'jpg', 'jpeg'].contains(extension)) {
        _showSnackBar('Please select a PNG or JPG image.');
        return;
      }

      final fileSize = await file.length();

      if (!mounted) return;

      if (fileSize == null ||
          fileSize <= 0 ||
          fileSize > _maxVehicleImageSize) {
        _showSnackBar('Select an image that is 10 MB or smaller.');
        return;
      }

      final bytes = await file.readAsBytes();

      if (!mounted) return;

      setState(() {
        _vehicleImageBytes = bytes;
        _vehicleImageName = file.name;
      });
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Unable to select the image. Please try again.');
    }
  }

  Widget _buildVehiclePhotoPicker() {
    final hasImage = _vehicleImageBytes != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle photo',
          style: AppTextStyles.fieldLabel.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.space8.h),
        InkWell(
          onTap: _pickVehicleImage,
          borderRadius: AppRadius.largeRadius,
          child: Container(
            padding: EdgeInsets.all(AppDimensions.space12.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.largeRadius,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.mediumRadius,
                  child: Container(
                    width: 72.w,
                    height: 72.w,
                    color: AppColors.surface,
                    child: hasImage
                        ? Image.memory(
                            _vehicleImageBytes!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.textSecondary,
                                size: AppDimensions.iconLarge.sp,
                              );
                            },
                          )
                        : Icon(
                            Icons.directions_car_outlined,
                            color: AppColors.textSecondary,
                            size: AppDimensions.iconLarge.sp,
                          ),
                  ),
                ),
                SizedBox(width: AppDimensions.space12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasImage
                            ? 'Change vehicle photo'
                            : 'Add vehicle photo (optional)',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppDimensions.space4.h),
                      Text(
                        hasImage
                            ? _vehicleImageName ?? 'Image selected'
                            : 'PNG, JPG up to 10MB',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Icon(
                  hasImage ? Icons.edit_outlined : Icons.add_a_photo_outlined,
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

  // ------------------------------------------------------------
  // Purchase date picker
  // ------------------------------------------------------------

  Future<void> _selectPurchaseDate() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1950),
      lastDate: now,
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

    if (pickedDate == null || !mounted) return;

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

    _purchaseDateController.text =
        '${pickedDate.day.toString().padLeft(2, '0')} '
        '${months[pickedDate.month - 1]} ${pickedDate.year}';
  }

  // ------------------------------------------------------------
  // Save validation
  // ------------------------------------------------------------

  Future<void> _saveVehicle() async {
    if (_isSaving) return;

    final vehicleNameInvalid = _vehicleNameController.text.trim().isEmpty;
    final makeInvalid = _makeController.text.trim().isEmpty;
    final modelInvalid = _modelController.text.trim().isEmpty;
    final yearInvalid = _year == null;
    final fuelTypeInvalid = _fuelType == null;

    final odometerText = _odometerController.text.replaceAll(',', '').trim();

    final odometerValue = int.tryParse(odometerText);
    final odometerInvalid =
        odometerText.isEmpty || odometerValue == null || odometerValue < 0;

    setState(() {
      _vehicleNameHasError = vehicleNameInvalid;
      _makeHasError = makeInvalid;
      _modelHasError = modelInvalid;
      _odometerHasError = odometerInvalid;
    });

    if (vehicleNameInvalid ||
        makeInvalid ||
        modelInvalid ||
        yearInvalid ||
        fuelTypeInvalid ||
        odometerInvalid) {
      final missingFields = <String>[];

      if (vehicleNameInvalid) missingFields.add('vehicle name');
      if (makeInvalid) missingFields.add('make');
      if (modelInvalid) missingFields.add('model');
      if (yearInvalid) missingFields.add('year');
      if (fuelTypeInvalid) missingFields.add('fuel type');

      if (odometerInvalid) {
        missingFields.add('a valid current odometer reading');
      }

      _showSnackBar('Please complete: ${missingFields.join(', ')}.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      // TODO: Save the vehicle using your repository/controller.
      // This delay is temporary; it does not persist vehicle data.
      await Future<void>.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => VehicleSetupCompleteScreen(
            vehicleName: _vehicleNameController.text.trim(),
            make: _makeController.text.trim(),
            model: _modelController.text.trim(),
            year: _year!,
            odometer: odometerText,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // ------------------------------------------------------------
  // Screen layout
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
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
                        AppDimensions.space16.h,
                        AppDimensions.pageHorizontalPadding.w,
                        AppDimensions.space24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProgress(),
                          SizedBox(height: AppDimensions.space24.h),
                          Text(
                            'Add your vehicle',
                            style: AppTextStyles.pageTitle,
                          ),
                          SizedBox(height: AppDimensions.space4.h),
                          Text(
                            "Let's get your vehicle set up.",
                            style: AppTextStyles.bodySecondary,
                          ),
                          SizedBox(height: AppDimensions.space24.h),
                          _buildVehiclePhotoPicker(),
                          SizedBox(height: AppDimensions.space20.h),

                          AppTextField(
                            label: 'Vehicle name',
                            controller: _vehicleNameController,
                            hint: 'e.g. My daily car',
                            hasError: _vehicleNameHasError,
                            onChanged: (_) {
                              if (_vehicleNameHasError) {
                                setState(() => _vehicleNameHasError = false);
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppTextField(
                            label: 'Make',
                            controller: _makeController,
                            hint: 'e.g. Maruti Suzuki',
                            hasError: _makeHasError,
                            onChanged: (_) {
                              if (_makeHasError) {
                                setState(() => _makeHasError = false);
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppTextField(
                            label: 'Model',
                            controller: _modelController,
                            hint: 'e.g. Swift',
                            hasError: _modelHasError,
                            onChanged: (_) {
                              if (_modelHasError) {
                                setState(() => _modelHasError = false);
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppDropdown(
                            label: 'Year',
                            value: _year ?? '',
                            options: _years,
                            hint: 'Select year',
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _year = value);
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppTextField(
                            label: 'Current odometer',
                            controller: _odometerController,
                            hint: 'e.g. 24,500',
                            suffix: 'km',
                            hasError: _odometerHasError,
                            keyboardType: TextInputType.number,
                            onChanged: (_) {
                              if (_odometerHasError) {
                                setState(() => _odometerHasError = false);
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppDropdown(
                            label: 'Fuel type',
                            value: _fuelType ?? '',
                            options: fuelTypes,
                            hint: 'Select fuel type',
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _fuelType = value);
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space24.h),

                          AppExpandableSection(
                            title: 'Purchase details (optional)',
                            icon: Icons.receipt_long_outlined,
                            initiallyExpanded: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextField(
                                  label: 'Purchase date',
                                  controller: _purchaseDateController,
                                  hint: 'e.g. 15 Oct 2023',
                                  readOnly: true,
                                  suffixIcon: Icons.calendar_today_outlined,
                                  onTap: _selectPurchaseDate,
                                ),

                                SizedBox(height: AppDimensions.space16.h),

                                AppTextField(
                                  label: 'Purchase price',
                                  controller: _purchasePriceController,
                                  hint: 'e.g. 8,50,000',
                                  prefix: '₹',
                                  keyboardType: TextInputType.number,
                                ),

                                SizedBox(height: AppDimensions.space16.h),

                                AppTextField(
                                  label: 'Purchase odometer',
                                  controller: _purchaseOdometerController,
                                  hint: 'e.g. 12,000',
                                  suffix: 'km',
                                  keyboardType: TextInputType.number,
                                ),

                                SizedBox(height: AppDimensions.space20.h),

                                AppDocumentSection(
                                  title: 'Purchase documents',
                                  subtitle:
                                      'Add invoices, bills of sale, payment receipts or sale agreements.',
                                  documents: _purchaseDocuments,
                                  onAddDocuments: () {
                                    _pickDocuments(_purchaseDocuments);
                                  },
                                  onRemoveDocument: (index) {
                                    setState(() {
                                      if (index >= 0 &&
                                          index < _purchaseDocuments.length) {
                                        _purchaseDocuments.removeAt(index);
                                      }
                                    });
                                  },
                                  emptyMessage:
                                      'No purchase documents added yet',
                                  emptySubtitle: 'PDF, JPG or PNG up to 10MB',
                                ),
                              ],
                            ),
                          ),

                          // SizedBox(height: AppDimensions.space16.h),

                          // AppExpandableSection(
                          //   title: 'More (optional)',
                          //   icon: Icons.folder_open_outlined,
                          //   initiallyExpanded: true,
                          //   notesController: _notesController,
                          //   documents: _otherDocuments,
                          //   onAddDocuments: () {
                          //     _pickDocuments(_otherDocuments);
                          //   },
                          //   onRemoveDocument: (index) {
                          //     setState(() {
                          //       if (index >= 0 &&
                          //           index < _otherDocuments.length) {
                          //         _otherDocuments.removeAt(index);
                          //       }
                          //     });
                          //   },
                          // ),
                          SizedBox(height: AppDimensions.space24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppDimensions.pageHorizontalPadding.w,
                  AppDimensions.space12.h,
                  AppDimensions.pageHorizontalPadding.w,
                  AppDimensions.space16.h,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: AppBottomAction(
                      label: 'Save vehicle',
                      isLoading: _isSaving,
                      onPressed: _isSaving ? null : _saveVehicle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space16.w,
        vertical: AppDimensions.space8.h,
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
          ),
          Expanded(
            child: Text(
              'Vehicle Profile Setup',
              textAlign: TextAlign.center,
              style: AppTextStyles.cardTitle,
            ),
          ),
          Container(
            width: AppDimensions.iconExtraLarge.w,
            height: AppDimensions.iconExtraLarge.w,
            decoration: const BoxDecoration(
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

  Widget _buildProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 2 of 3',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontSize: 13.sp,
              ),
            ),
            Text(
              'Vehicle Setup',
              style: AppTextStyles.caption.copyWith(fontSize: 13.sp),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.space8.h),
        Row(
          children: [
            const Expanded(child: _ProgressSegment(color: AppColors.primary)),
            SizedBox(width: AppDimensions.progressGap.w),
            const Expanded(child: _ProgressSegment(color: AppColors.primary)),
            SizedBox(width: AppDimensions.progressGap.w),
            const Expanded(
              child: _ProgressSegment(color: AppColors.progressTrack),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressSegment extends StatelessWidget {
  const _ProgressSegment({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.progressHeight.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
    );
  }
}
