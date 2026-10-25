import 'package:sqflite/sqflite.dart';

import '../database/db_keys.dart';
import '../database/local_db.dart';
import '../models/odometer.dart';

class OdometerRepository {
  OdometerRepository._();

  static final OdometerRepository instance = OdometerRepository._();

  Future<int> addOdometerRecord(OdometerModel record) async {
    final db = await LocalDb.instance.database;

    return db.transaction((txn) async {
      final vehicles = await txn.query(
        Vehicle.table,
        columns: [Vehicle.currentOdometer],
        where: '${Vehicle.vehicleId} = ?',
        whereArgs: [record.vehicleId],
        limit: 1,
      );

      if (vehicles.isEmpty) {
        throw ArgumentError(
          'Vehicle with ID ${record.vehicleId} does not exist.',
        );
      }

      final currentReading = vehicles.first[Vehicle.currentOdometer] as int;

      if (record.odometerReading < currentReading) {
        throw ArgumentError(
          'The new odometer reading cannot be lower '
          'than the vehicle current reading.',
        );
      }

      final data = record.toMap()
        ..remove(Odometer.odometerId)
        ..[Odometer.createdAt] = DateTime.now().toIso8601String();

      final id = await txn.insert(
        Odometer.table,
        data,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      await txn.update(
        Vehicle.table,
        {
          Vehicle.currentOdometer: record.odometerReading,
          Vehicle.updatedAt: DateTime.now().toIso8601String(),
        },
        where: '${Vehicle.vehicleId} = ?',
        whereArgs: [record.vehicleId],
      );

      return id;
    });
  }

  Future<List<OdometerModel>> getOdometerHistory(int vehicleId) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Odometer.table,
      where: '${Odometer.vehicleId} = ?',
      whereArgs: [vehicleId],
      orderBy: '${Odometer.recordedAt} DESC',
    );

    return rows.map(OdometerModel.fromMap).toList();
  }

  Future<OdometerModel?> getOdometerRecordById(int id) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Odometer.table,
      where: '${Odometer.odometerId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return OdometerModel.fromMap(rows.first);
  }

  Future<int> deleteOdometerRecord(int id) async {
    final db = await LocalDb.instance.database;

    return db.delete(
      Odometer.table,
      where: '${Odometer.odometerId} = ?',
      whereArgs: [id],
    );
  }
}
