import '../database/db_keys.dart';

class ExpenseModel {
  final int? id;
  final int vehicleId;

  final String title;
  final String category;
  final double amount;

  final String expenseDate;
  final int? odometerReading;

  final String? notes;

  final String createdAt;
  final String updatedAt;

  const ExpenseModel({
    this.id,
    required this.vehicleId,
    required this.title,
    required this.category,
    required this.amount,
    required this.expenseDate,
    this.odometerReading,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      Expense.expenseId: id,
      Expense.vehicleId: vehicleId,
      Expense.title: title,
      Expense.category: category,
      Expense.amount: amount,
      Expense.expenseDate: expenseDate,
      Expense.odometerReading: odometerReading,
      Expense.notes: notes,
      Expense.createdAt: createdAt,
      Expense.updatedAt: updatedAt,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map[Expense.expenseId] as int?,
      vehicleId: map[Expense.vehicleId] as int,
      title: map[Expense.title] as String,
      category: map[Expense.category] as String,
      amount: (map[Expense.amount] as num).toDouble(),
      expenseDate: map[Expense.expenseDate] as String,
      odometerReading: map[Expense.odometerReading] as int?,
      notes: map[Expense.notes] as String?,
      createdAt: map[Expense.createdAt] as String,
      updatedAt: map[Expense.updatedAt] as String,
    );
  }
}

enum ExpenseCategory {
  insurance,
  repair,
  parking,
  toll,
  cleaning,
  accessories,
  tax,
  fines,
  other,
}

enum PaymentMethod { upi, cash, card, netBanking, bankTransfer, other }
