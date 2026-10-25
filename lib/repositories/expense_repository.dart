import 'package:sqflite/sqflite.dart';

import '../database/db_keys.dart';
import '../database/local_db.dart';
import '../models/expense.dart';

class ExpenseRepository {
  ExpenseRepository._();

  static final ExpenseRepository instance = ExpenseRepository._();

  Future<int> addExpense(ExpenseModel expense) async {
    final db = await LocalDb.instance.database;
    final now = DateTime.now().toIso8601String();

    final data = expense.toMap()
      ..remove(Expense.expenseId)
      ..[Expense.createdAt] = now
      ..[Expense.updatedAt] = now;

    return db.insert(
      Expense.table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<ExpenseModel>> getExpenses(int vehicleId) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Expense.table,
      where: '${Expense.vehicleId} = ?',
      whereArgs: [vehicleId],
      orderBy: '${Expense.expenseDate} DESC',
    );

    return rows.map(ExpenseModel.fromMap).toList();
  }

  Future<ExpenseModel?> getExpenseById(int id) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Expense.table,
      where: '${Expense.expenseId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return ExpenseModel.fromMap(rows.first);
  }

  Future<int> updateExpense(ExpenseModel expense) async {
    if (expense.id == null) {
      throw ArgumentError('Cannot update an expense without an ID.');
    }

    final db = await LocalDb.instance.database;

    final data = expense.toMap()
      ..remove(Expense.expenseId)
      ..remove(Expense.createdAt)
      ..[Expense.updatedAt] = DateTime.now().toIso8601String();

    return db.update(
      Expense.table,
      data,
      where: '${Expense.expenseId} = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await LocalDb.instance.database;

    return db.delete(
      Expense.table,
      where: '${Expense.expenseId} = ?',
      whereArgs: [id],
    );
  }
}
