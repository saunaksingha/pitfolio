import 'package:sqflite/sqflite.dart';

import 'schema/vehicle_schema.dart';
import 'schema/odometer_schema.dart';
import 'schema/fuel_schema.dart';
import 'schema/expense_schema.dart';
import 'schema/service_schema.dart';
import 'schema/note_schema.dart';
import 'schema/attachment_schema.dart';
import 'schema/document_schema.dart';

class DbSchema {
  DbSchema._();

  static const int version = 1;

  static Future<void> createTables(DatabaseExecutor db) async {
    await db.execute(vehicleSchema);
    await db.execute(odometerSchema);
    await db.execute(fuelSchema);
    await db.execute(expenseSchema);
    await db.execute(serviceSchema);
    await db.execute(noteSchema);
    await db.execute(attachmentSchema);
    await db.execute(documentSchema);
  }
}
