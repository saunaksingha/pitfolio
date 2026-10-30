import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pitfolio/models/expense.dart';

class CategoryStyle {
  final String label;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;

  const CategoryStyle({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
  });
}

const Map<ExpenseCategory, CategoryStyle> expenseCategoryStyles = {
  ExpenseCategory.insurance: CategoryStyle(
    label: 'Insurance',
    icon: LucideIcons.shieldCheck,
    accentColor: Color(0xFF496BA8),
    backgroundColor: Color(0xFFE8EEF9),
  ),

  ExpenseCategory.repair: CategoryStyle(
    label: 'Repair',
    icon: LucideIcons.hammer,
    accentColor: Color(0xFFBD6653),
    backgroundColor: Color(0xFFF9EAE6),
  ),

  ExpenseCategory.parking: CategoryStyle(
    label: 'Parking',
    icon: LucideIcons.parkingCircle,
    accentColor: Color(0xFF43869A),
    backgroundColor: Color(0xFFE6F2F5),
  ),

  ExpenseCategory.toll: CategoryStyle(
    label: 'Toll',
    icon: LucideIcons.route,
    accentColor: Color(0xFF627895),
    backgroundColor: Color(0xFFE9EDF4),
  ),

  ExpenseCategory.cleaning: CategoryStyle(
    label: 'Cleaning',
    icon: LucideIcons.sprayCan,
    accentColor: Color(0xFF43866D),
    backgroundColor: Color(0xFFE5F2EC),
  ),

  ExpenseCategory.accessories: CategoryStyle(
    label: 'Accessories',
    icon: LucideIcons.package,
    accentColor: Color(0xFFA9784C),
    backgroundColor: Color(0xFFF5EADF),
  ),

  ExpenseCategory.tax: CategoryStyle(
    label: 'Road tax',
    icon: LucideIcons.receiptText,
    accentColor: Color(0xFF6275A5),
    backgroundColor: Color(0xFFE9EDF8),
  ),

  ExpenseCategory.fines: CategoryStyle(
    label: 'Fines',
    icon: LucideIcons.triangleAlert,
    accentColor: Color(0xFFBD5555),
    backgroundColor: Color(0xFFF8E8E8),
  ),

  ExpenseCategory.other: CategoryStyle(
    label: 'Other',
    icon: LucideIcons.ellipsis,
    accentColor: Color(0xFF777777),
    backgroundColor: Color(0xFFEEEEEE),
  ),
};
