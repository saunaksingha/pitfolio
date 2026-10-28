import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:pitfolio/core/utils/file_storage_service.dart';
import 'package:pitfolio/core/widgets/app_date_picker.dart';
import 'package:pitfolio/core/widgets/app_page_header.dart';
import 'package:pitfolio/models/attachment.dart';
import 'package:pitfolio/models/vehicle.dart';
import 'package:pitfolio/repositories/attachment_repository.dart';
import 'package:pitfolio/repositories/vehicle_repository.dart';
import 'package:pitfolio/screens/onboarding/unit_preferences_screen.dart';
import 'package:pitfolio/screens/onboarding/vehicle_setup_complete_screen.dart';

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

class AddVehicleScreen extends StatefulWidget {
  final UnitPreferencesData preferences;
  const AddVehicleScreen({super.key, required this.preferences});

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

  //Files to store
  PlatformFile? _selectedVehicleImage;
  final List<PlatformFile> _selectedPurchaseFiles = [];

  final _vehicleNameController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _variantController = TextEditingController();
  final _odometerController = TextEditingController();
  final _tankCapacityController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _purchaseOdometerController = TextEditingController();
  final _notesController = TextEditingController();

  //errors
  String? _vehicanNameErrorText;
  String? _makeErrorText;
  String? _modelErrorText;
  String? _currentOdometerErrorText;
  String? _fuelTypeErrorText;
  String? _tankCapacityErrorText;

  //Non essentials

  String? _purchasePriceErrorText;
  String? _purchaseOdometerErrorText;

  //date picker
  DateTime? _purchaseDate;

  String? _fuelType;
  bool _isSaving = false;

  final List<AppDocumentItem> _purchaseDocuments = [];

  @override
  void dispose() {
    _vehicleNameController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _odometerController.dispose();
    _purchasePriceController.dispose();
    _purchaseOdometerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // Document picker
  // ------------------------------------------------------------

  VehicleModel _buildVehicleModel({
    required String vehicleName,
    required String make,
    required String model,
    required int odometerValue,
    required String fuelType,
    required double tankCapacityValue,
    required int? purchaseValue,
    required int? purchaseOdometerValue,
    String? photoPath,
  }) {
    return VehicleModel(
      name: vehicleName,
      make: make,
      model: model,
      variant: _variantController.text.trim().isEmpty
          ? null
          : _variantController.text.trim(),
      currentOdometer: odometerValue,
      fuelType: fuelType,
      fuelTankCapacity: tankCapacityValue,
      currency: widget.preferences.currency,
      fuelUnit: widget.preferences.fuelCapacityUnit,
      distanceUnit: widget.preferences.distanceUnit,
      purchaseDate: _purchaseDate?.toIso8601String(),
      purchasePrice: purchaseValue?.toDouble(),
      purchaseOdometer: purchaseOdometerValue,
      photoPath: photoPath,
    );
  }

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
      final filesToAdd = <PlatformFile>[];

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

        filesToAdd.add(file);
        existingNames.add(normalizedName);
      }

      if (!mounted) return;

      setState(() {
        destination.addAll(documentsToAdd);

        // Keep the actual files in the same order as the UI documents.
        _selectedPurchaseFiles.addAll(filesToAdd);
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

      // _showSnackBar(messages.join('. '));
    } catch (_) {
      if (!mounted) return;

      // _showSnackBar('Unable to select documents. Please try again.');
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
        // _showSnackBar('Please select a PNG or JPG image.');
        return;
      }

      final fileSize = await file.length();

      if (!mounted) return;

      if (fileSize == null ||
          fileSize <= 0 ||
          fileSize > _maxVehicleImageSize) {
        // _showSnackBar('Select an image that is 10 MB or smaller.');
        return;
      }

      final bytes = await file.readAsBytes();

      if (!mounted) return;

      setState(() {
        _selectedVehicleImage = file;
        _vehicleImageBytes = bytes;
        _vehicleImageName = file.name;
      });
    } catch (_) {
      if (!mounted) return;
      // _showSnackBar('Unable to select the image. Please try again.');
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

  // ------------------------------------------------------------
  // Save validation
  // ------------------------------------------------------------

  Future<bool> _saveVehicalRecords(
    VehicleModel vehicleModel,
    List<AttachmentModel> attachmentModels,
  ) async {
    return await VehicleRepository.instance.addVehicleWithAttachments(
      vehicleModel,
      attachmentModels,
    );
  }

  Future<void> _processInputs() async {
    if (_isSaving) return;

    //essential information

    final vehicleName = _vehicleNameController.text.trim();
    final make = _makeController.text.trim();
    final model = _modelController.text.trim();

    final odometerText = _odometerController.text.replaceAll(',', '').trim();
    final odometerValue = int.tryParse(odometerText);

    final tankCapacityText = _tankCapacityController.text
        .replaceAll(',', '')
        .trim();
    final tankCapacityValue = int.tryParse(tankCapacityText);

    final seclectedFuelType = _fuelType;

    // Optional purchase price
    final purchasePrice = _purchasePriceController.text
        .replaceAll(',', '')
        .trim();

    final purchaseValue = purchasePrice.isEmpty
        ? null
        : int.tryParse(purchasePrice);

    // Optional purchase odometer
    final purchaseOdometer = _purchaseOdometerController.text
        .replaceAll(',', '')
        .trim();

    final purchaseOdometerValue = purchaseOdometer.isEmpty
        ? null
        : int.tryParse(purchaseOdometer);
    //Now check the essential

    setState(() {
      _vehicanNameErrorText = vehicleName.isEmpty
          ? 'Please enter a vehicle name'
          : null;

      _makeErrorText = make.isEmpty ? 'Please enter the vehicle make' : null;

      _modelErrorText = model.isEmpty ? 'Please enter the vehicle model' : null;

      _currentOdometerErrorText = odometerValue == null || odometerValue < 0
          ? 'Please enter a valid odometer reading'
          : null;

      _fuelTypeErrorText = seclectedFuelType == null
          ? 'Please select a fuel type'
          : null;

      _tankCapacityErrorText =
          tankCapacityValue == null || tankCapacityValue <= 0
          ? "Please enter a valid tank capacity"
          : null;
    });

    if (vehicleName.isEmpty ||
        make.isEmpty ||
        model.isEmpty ||
        odometerValue == null ||
        odometerValue < 0 ||
        seclectedFuelType == null ||
        tankCapacityValue == null ||
        tankCapacityValue <= 0) {
      return;
    }

    // Validate purchase price only if entered.
    if (purchasePrice.isNotEmpty) {
      if (purchaseValue == null || purchaseValue < 0) {
        setState(() {
          _purchasePriceErrorText = 'Please enter a valid purchase price';
        });
        return;
      }
    }

    // Validate purchase odometer only if entered.
    if (purchaseOdometer.isNotEmpty) {
      if (purchaseOdometerValue == null || purchaseOdometerValue < 0) {
        setState(() {
          _purchaseOdometerErrorText = 'Please enter a valid purchase odometer';
        });
        return;
      }
    }

    //I can go ahed and save the data

    _isSaving = true;

    final List<AttachmentModel> attachmentModels = [];

    VehicleModel vehicleModel = _buildVehicleModel(
      vehicleName: vehicleName,
      make: make,
      model: model,
      odometerValue: odometerValue,
      fuelType: _fuelType!,
      purchaseValue: purchaseValue,
      tankCapacityValue: tankCapacityValue.toDouble(),
      purchaseOdometerValue: purchaseOdometerValue,
    );

    if (_selectedVehicleImage != null) {
      final savedImagePath = await FileStorageService.storeFile(
        _selectedVehicleImage!,
        namePrefix: 'vehicle',
      );

      vehicleModel.photoPath = savedImagePath;

      final attachment = AttachmentModel(
        recordId: -1,
        attachmentType: AttachmentType.vehiclePhoto,
        fileName: _selectedVehicleImage!.name,
        filePath: savedImagePath,
      );

      attachmentModels.add(attachment);
    }

    for (final file in _selectedPurchaseFiles) {
      final savedPath = await FileStorageService.storeFile(
        file,
        namePrefix: 'purchase',
      );

      final attachment = AttachmentModel(
        recordId: -1,
        attachmentType: AttachmentType.purchaseDocument,
        fileName: file.name,
        filePath: savedPath,
      );

      attachmentModels.add(attachment);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VehicleSetupCompleteScreen(
          vehicleName: vehicleName,
          make: make,
          model: model,
          year: _purchaseDate?.year
              .toString(), // Pass the actual year if you collect it.
          odometer: odometerValue.toString(),
          onConfirm: () => _saveVehicalRecords(vehicleModel, attachmentModels),
        ),
      ),
    );

    _isSaving = false;
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
              //_buildHeader(),
              AppPageHeader(title: "Vehical Profile Setup"),
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
                            errorText: _vehicanNameErrorText,
                            onChanged: (_) {
                              if (_vehicanNameErrorText != null ||
                                  _vehicanNameErrorText!.isNotEmpty) {
                                setState(() {
                                  _vehicanNameErrorText = null;
                                });
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppTextField(
                            label: 'Make',
                            controller: _makeController,
                            hint: 'e.g. Maruti Suzuki',
                            errorText: _makeErrorText,
                            onChanged: (_) {
                              if (_makeErrorText != null ||
                                  _makeErrorText!.isNotEmpty) {
                                setState(() {
                                  _makeErrorText = null;
                                });
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppTextField(
                            label: 'Model',
                            controller: _modelController,
                            hint: 'e.g. Swift',
                            errorText: _makeErrorText,
                            onChanged: (_) {
                              if (_modelErrorText != null ||
                                  _modelErrorText!.isNotEmpty) {
                                setState(() {
                                  _modelErrorText = null;
                                });
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppTextField(
                            label: 'Variant',
                            controller: _variantController,
                            hint: 'e.g. Swift',
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppTextField(
                            label: 'Current odometer',
                            controller: _odometerController,
                            hint: 'e.g. 24,500',
                            suffix: widget.preferences.distanceUnit,
                            errorText: _currentOdometerErrorText,
                            keyboardType: TextInputType.number,
                            onChanged: (_) {
                              if (_currentOdometerErrorText != null ||
                                  _currentOdometerErrorText!.isNotEmpty) {
                                setState(() {
                                  _currentOdometerErrorText = null;
                                });
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppTextField(
                            label: 'Tank capacity',
                            controller: _tankCapacityController,
                            hint: 'e.g. 35',
                            suffix: widget.preferences.fuelCapacityUnit,
                            errorText: _tankCapacityErrorText,
                            keyboardType: TextInputType.number,
                            onChanged: (_) {
                              if (_tankCapacityErrorText != null ||
                                  _tankCapacityErrorText!.isNotEmpty) {
                                setState(() {
                                  _tankCapacityErrorText = null;
                                });
                              }
                            },
                          ),

                          SizedBox(height: AppDimensions.space16.h),

                          AppDropdown(
                            label: 'Fuel type',
                            value: _fuelType ?? '',
                            options: fuelTypes,
                            hint: 'Select fuel type',
                            errorText: _fuelTypeErrorText,
                            onChanged: (value) {
                              setState(() {
                                _fuelType = value;
                                _fuelTypeErrorText = null;
                              });
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
                                AppDatePicker(
                                  label: 'Purchase date',
                                  value: _purchaseDate,
                                  hint: 'e.g. 15 Oct 2023',
                                  firstDate: DateTime(1980),
                                  lastDate: DateTime.now(),
                                  onChanged: (date) {
                                    setState(() {
                                      _purchaseDate = date;
                                    });
                                  },
                                ),

                                SizedBox(height: AppDimensions.space16.h),

                                AppTextField(
                                  label: 'Purchase price',
                                  controller: _purchasePriceController,
                                  errorText: _purchasePriceErrorText,
                                  hint: 'e.g. 8,50,000',
                                  prefix:
                                      currencySymbols[widget
                                          .preferences
                                          .currency] ??
                                      widget.preferences.currency,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {
                                    if (_purchasePriceErrorText != null ||
                                        _purchasePriceErrorText!.isNotEmpty) {
                                      setState(() {
                                        _purchasePriceErrorText = null;
                                      });
                                    }
                                  },
                                ),

                                SizedBox(height: AppDimensions.space16.h),

                                AppTextField(
                                  label: 'Purchase odometer',
                                  errorText: _purchaseOdometerErrorText,
                                  controller: _purchaseOdometerController,
                                  hint: 'e.g. 12,000',
                                  suffix: widget.preferences.distanceUnit,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {
                                    if (_purchaseOdometerErrorText != null ||
                                        _purchaseOdometerErrorText!
                                            .isNotEmpty) {
                                      setState(() {
                                        _purchaseOdometerErrorText = null;
                                      });
                                    }
                                  },
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
                                          index < _purchaseDocuments.length &&
                                          index <
                                              _selectedPurchaseFiles.length) {
                                        _purchaseDocuments.removeAt(index);
                                        _selectedPurchaseFiles.removeAt(index);
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
                      onPressed: _isSaving ? null : _processInputs,
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

  Widget _buildProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step 2 of 2',
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
