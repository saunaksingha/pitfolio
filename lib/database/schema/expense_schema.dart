import '../db_keys.dart';

const String expenseSchema =
    '''
  CREATE TABLE ${Expense.table} (
    ${Expense.expenseId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Expense.vehicleId} INTEGER NOT NULL,

    ${Expense.title} TEXT NOT NULL,
    ${Expense.category} TEXT NOT NULL,
    ${Expense.amount} REAL NOT NULL,

    ${Expense.expenseDate} TEXT NOT NULL,
    ${Expense.odometerReading} INTEGER,

    ${Expense.notes} TEXT,

    ${Expense.createdAt} TEXT NOT NULL,
    ${Expense.updatedAt} TEXT NOT NULL,

    FOREIGN KEY (${Expense.vehicleId})
      REFERENCES ${Vehicle.table} (${Vehicle.vehicleId})
      ON DELETE CASCADE
  )
''';
