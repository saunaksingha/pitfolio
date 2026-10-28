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

class ExpenseResult {
  const ExpenseResult({
    required this.category,
    required this.description,
    required this.amount,
    required this.datePaid,
    required this.paymentMethod,
    required this.isRecurring,
    required this.repeatFrequency,
    required this.repeatDay,
    required this.startsOn,
    required this.endType,
    required this.endDate,
    required this.occurrences,
    required this.notes,
    required this.receipts,
  });

  final String category;
  final String description;
  final double amount;
  final DateTime datePaid;
  final String paymentMethod;
  final bool isRecurring;
  final String repeatFrequency;
  final String repeatDay;
  final DateTime startsOn;
  final String endType;
  final DateTime? endDate;
  final int? occurrences;
  final String notes;
  final List<AppDocumentItem> receipts;
}

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({
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
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _occurrencesController = TextEditingController(text: '12');

  String _category = 'insurance';
  String _paymentMethod = 'upi';

  bool _isRecurring = true;
  String _repeatFrequency = 'month';
  String _repeatDay = '1';
  String _endType = 'never';

  DateTime _datePaid = DateTime.now();
  DateTime _startsOn = DateTime.now();
  DateTime? _endDate;

  bool _isSaving = false;
  bool _amountHasError = false;

  final List<AppDocumentItem> _receipts = [];

  static const Map<String, String> _categories = {
    'insurance': 'Insurance',
    'maintenance': 'Maintenance',
    'repair': 'Repair',
    'fuel': 'Fuel',
    'parking': 'Parking',
    'toll': 'Toll',
    'cleaning': 'Cleaning',
    'accessories': 'Accessories',
    'tax': 'Road tax',
    'fines': 'Fines',
    'other': 'Other',
  };

  static const Map<String, String> _paymentMethods = {
    'upi': 'UPI',
    'cash': 'Cash',
    'card': 'Credit / Debit card',
    'net_banking': 'Net banking',
    'bank_transfer': 'Bank transfer',
    'other': 'Other',
  };

  static const Map<String, String> _frequencies = {
    'week': 'Every week',
    'month': 'Every month',
    '3_months': 'Every 3 months',
    '6_months': 'Every 6 months',
    'year': 'Every year',
  };

  static const Map<String, String> _endOptions = {
    'never': 'Never',
    'on_date': 'On date',
    'after': 'After',
  };

  Map<String, String> get _repeatDays {
    if (_repeatFrequency == 'week') {
      return const {
        '1': 'Monday',
        '2': 'Tuesday',
        '3': 'Wednesday',
        '4': 'Thursday',
        '5': 'Friday',
        '6': 'Saturday',
        '7': 'Sunday',
      };
    }

    return {
      for (int day = 1; day <= 31; day++)
        '$day': '${_ordinal(day)} of each month',
    };
  }

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    _datePaid = today;
    _startsOn = today;
    _repeatDay = '${today.day}';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _occurrencesController.dispose();
    super.dispose();
  }

  static String _ordinal(int number) {
    if (number >= 11 && number <= 13) return '${number}th';

    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  String _formatDate(DateTime date, {bool includeToday = false}) {
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

    final formatted = '${date.day} ${months[date.month - 1]} ${date.year}';

    return includeToday && isToday ? 'Today, $formatted' : formatted;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<DateTime?> _pickDate({
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
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
  }

  Future<void> _selectPaidDate() async {
    final picked = await _pickDate(
      initialDate: _datePaid,
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() => _datePaid = picked);
    }
  }

  Future<void> _selectStartDate() async {
    final picked = await _pickDate(initialDate: _startsOn);

    if (picked == null || !mounted) return;

    setState(() {
      _startsOn = picked;

      if (_endDate != null && _endDate!.isBefore(picked)) {
        _endDate = null;
      }
    });
  }

  Future<void> _selectEndDate() async {
    final picked = await _pickDate(
      initialDate: _endDate ?? _startsOn,
      firstDate: _startsOn,
    );

    if (picked != null && mounted) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _pickReceipts() async {
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

        final duplicate = [..._receipts, ...added].any(
          (receipt) => receipt.name.toLowerCase() == file.name.toLowerCase(),
        );

        if (duplicate) {
          duplicates++;
          continue;
        }

        added.add(
          AppDocumentItem(
            name: file.name,
            description: '${(size / 1024).ceil()} KB · Uploaded',
            icon: extension == 'pdf'
                ? Icons.picture_as_pdf_outlined
                : Icons.image_outlined,
          ),
        );
      }

      if (!mounted) return;

      setState(() => _receipts.addAll(added));

      if (added.isNotEmpty) {
        _showSnackBar('${added.length} receipt(s) added.');
      }

      if (duplicates > 0) {
        _showSnackBar('$duplicates duplicate receipt(s) skipped.');
      }

      if (rejected > 0) {
        _showSnackBar(
          '$rejected file(s) rejected. Use PDF, JPG or PNG up to 10 MB.',
        );
      }

      if (added.isEmpty && duplicates == 0 && rejected == 0) {
        _showSnackBar('No receipts selected.');
      }
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Unable to select receipts. Please try again.');
    }
  }

  Future<void> _saveExpense() async {
    if (_isSaving) return;

    final amount = double.tryParse(
      _amountController.text.replaceAll(',', '').trim(),
    );

    final amountInvalid = amount == null || amount <= 0;
    final occurrences = int.tryParse(_occurrencesController.text.trim());

    final occurrencesInvalid =
        _isRecurring &&
        _endType == 'after' &&
        (occurrences == null || occurrences <= 0);

    final endDateInvalid =
        _isRecurring &&
        _endType == 'on_date' &&
        (_endDate == null || _endDate!.isBefore(_startsOn));

    setState(() => _amountHasError = amountInvalid);

    if (amountInvalid) {
      _showSnackBar('Enter an amount greater than zero.');
      return;
    }

    if (occurrencesInvalid) {
      _showSnackBar('Enter a valid number of recurring payments.');
      return;
    }

    if (endDateInvalid) {
      _showSnackBar('Choose an end date on or after the start date.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final expense = ExpenseResult(
        category: _category,
        description: _descriptionController.text.trim(),
        amount: amount,
        datePaid: _datePaid,
        paymentMethod: _paymentMethod,
        isRecurring: _isRecurring,
        repeatFrequency: _repeatFrequency,
        repeatDay: _repeatDay,
        startsOn: _startsOn,
        endType: _isRecurring ? _endType : 'never',
        endDate: _isRecurring && _endType == 'on_date' ? _endDate : null,
        occurrences: _isRecurring && _endType == 'after' ? occurrences : null,
        notes: _notesController.text.trim(),
        receipts: List.unmodifiable(_receipts),
      );

      if (!mounted) return;
      Navigator.of(context).pop<ExpenseResult>(expense);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Unable to save the expense. Please try again.');
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
                      AppDimensions.space16.h,
                      AppDimensions.pageHorizontalPadding.w,
                      AppDimensions.space24.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildVehicleCard(),
                        SizedBox(height: AppDimensions.space24.h),
                        Text(
                          'Record an expense',
                          style: AppTextStyles.pageTitle.copyWith(
                            fontSize: 27.sp,
                          ),
                        ),
                        SizedBox(height: AppDimensions.space4.h),
                        Text(
                          'Keep track of what your vehicle costs.',
                          style: AppTextStyles.bodySecondary,
                        ),
                        SizedBox(height: AppDimensions.space24.h),

                        AppDropdown(
                          label: 'Expense category',
                          value: _category,
                          options: _categories,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _category = value);
                            }
                          },
                        ),

                        SizedBox(height: AppDimensions.space16.h),

                        AppTextField(
                          label: 'Expense description (Optional)',
                          controller: _descriptionController,
                          hint: 'e.g. Annual comprehensive insurance policy',
                        ),

                        SizedBox(height: AppDimensions.space16.h),

                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 340) {
                              return Column(
                                children: [
                                  _buildAmountField(),
                                  SizedBox(height: AppDimensions.space16.h),
                                  _buildPaidDateField(),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildAmountField()),
                                SizedBox(width: AppDimensions.space12.w),
                                Expanded(child: _buildPaidDateField()),
                              ],
                            );
                          },
                        ),

                        SizedBox(height: AppDimensions.space16.h),

                        AppDropdown(
                          label: 'Payment method (Optional)',
                          value: _paymentMethod,
                          options: _paymentMethods,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _paymentMethod = value);
                            }
                          },
                        ),

                        SizedBox(height: AppDimensions.space20.h),
                        _buildRecurringSection(),
                        SizedBox(height: AppDimensions.space20.h),

                        AppTextField(
                          label: 'Notes (Optional)',
                          controller: _notesController,
                          hint:
                              'Add any additional details about this payment...',
                          maxLines: 3,
                        ),

                        SizedBox(height: AppDimensions.space24.h),
                        _buildReceiptSection(),
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
                        label: 'Save expense',
                        onPressed: _isSaving ? null : _saveExpense,
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
            tooltip: 'Go back',
            icon: const Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
          ),
          SizedBox(width: AppDimensions.space4.w),
          Expanded(
            child: Text(
              'Add Expense',
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
                  '${widget.make} ${widget.model}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(fontSize: 12.sp),
                ),
                Text(
                  '${widget.model} · ${widget.year}',
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

  Widget _buildAmountField() {
    return AppTextField(
      label: 'Amount',
      controller: _amountController,
      hint: '2,500.00',
      prefix: '₹',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      //  hasError: _amountHasError,
      onChanged: (_) {
        if (_amountHasError) {
          setState(() => _amountHasError = false);
        }
      },
    );
  }

  Widget _buildPaidDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date paid',
          style: AppTextStyles.fieldLabel.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.space8.h),
        InkWell(
          onTap: _selectPaidDate,
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
                    _formatDate(_datePaid, includeToday: true),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(fontSize: 13.sp),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  size: AppDimensions.iconMedium.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurringSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isRecurring = !_isRecurring),
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.space12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Checkbox(
                      value: _isRecurring,
                      onChanged: (value) {
                        setState(() => _isRecurring = value ?? false);
                      },
                      activeColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  SizedBox(width: AppDimensions.space12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recurring expense',
                          style: AppTextStyles.cardTitle.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: AppDimensions.space4.h),
                        Text(
                          'Mark if this expense repeats periodically '
                          '(e.g. monthly or yearly).',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 12.sp,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isRecurring) ...[
            const Divider(height: 1, color: AppColors.divider),
            Padding(
              padding: EdgeInsets.all(AppDimensions.space12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppDropdown(
                    label: 'Repeat',
                    value: _repeatFrequency,
                    options: _frequencies,
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _repeatFrequency = value;
                        _repeatDay = value == 'week' ? '1' : '${_startsOn.day}';
                      });
                    },
                  ),
                  SizedBox(height: AppDimensions.space16.h),
                  AppDropdown(
                    label: 'Repeat on',
                    value: _repeatDays.containsKey(_repeatDay)
                        ? _repeatDay
                        : _repeatDays.keys.first,
                    options: _repeatDays,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _repeatDay = value);
                      }
                    },
                  ),
                  SizedBox(height: AppDimensions.space16.h),
                  _buildDateSelector(
                    label: 'Starts on',
                    date: _startsOn,
                    onTap: _selectStartDate,
                  ),
                  SizedBox(height: AppDimensions.space16.h),
                  Text(
                    'Ends',
                    style: AppTextStyles.fieldLabel.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppDimensions.space8.h),
                  _buildEndTypeSelector(),
                  if (_endType == 'on_date') ...[
                    SizedBox(height: AppDimensions.space16.h),
                    _buildDateSelector(
                      label: 'End date',
                      date: _endDate,
                      placeholder: 'Select end date',
                      onTap: _selectEndDate,
                    ),
                  ],
                  if (_endType == 'after') ...[
                    SizedBox(height: AppDimensions.space16.h),
                    AppTextField(
                      label: 'Number of occurrences',
                      controller: _occurrencesController,
                      hint: 'e.g. 12',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    String placeholder = 'Select date',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppDimensions.space8.h),
        InkWell(
          onTap: onTap,
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
                    date == null ? placeholder : _formatDate(date),
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
      ],
    );
  }

  Widget _buildEndTypeSelector() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        border: Border.all(color: AppColors.border),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Row(
        children: _endOptions.entries.map((entry) {
          final selected = _endType == entry.key;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _endType = entry.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: selected ? AppColors.surface : Colors.transparent,
                  borderRadius: AppRadius.mediumRadius,
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  entry.value,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 12.sp,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReceiptSection() {
    return AppDocumentSection(
      title: 'Receipt (Optional)',
      subtitle: 'Keep the receipt with this expense.',
      documents: _receipts,
      onAddDocuments: _pickReceipts,
      onRemoveDocument: (index) {
        setState(() {
          if (index >= 0 && index < _receipts.length) {
            _receipts.removeAt(index);
          }
        });
      },
      emptyMessage: 'No receipt attached yet',
      emptySubtitle: 'PDF, JPG or PNG up to 10MB',
    );
  }
}
