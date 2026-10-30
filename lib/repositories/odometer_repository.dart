import 'package:sqflite/sqflite.dart';

import '../database/db_keys.dart';
import '../database/local_db.dart';
import '../models/odometer.dart';

class OdometerRepository {
  OdometerRepository._();

  static final OdometerRepository instance = OdometerRepository._();

  Future<AddOdometerResult> addOdometerRecord(
    int vehicleId,
    OdometerModel record,
  ) async {
    try {
      final db = await LocalDb.instance.database;

      return await db.transaction((txn) async {
        // Check that the vehicle exists and get its current odometer.
        final vehicleRows = await txn.query(
          Vehicle.table,
          columns: [Vehicle.currentOdometer],
          where: '${Vehicle.vehicleId} = ?',
          whereArgs: [vehicleId],
          limit: 1,
        );

        if (vehicleRows.isEmpty) {
          return const AddOdometerResult(errorMessage: 'Vehicle not found.');
        }

        final currentOdometer =
            vehicleRows.first[Vehicle.currentOdometer] as int;

        // Get the existing odometer history.
        final rows = await txn.query(
          Odometer.table,
          columns: [Odometer.odometerReading, Odometer.recordedAt],
          where: '${Odometer.vehicleId} = ?',
          whereArgs: [vehicleId],
        );

        final newDate = DateTime.parse(record.recordedAt);

        // If there is no history, the reading must exceed the vehicle's
        // current odometer.
        if (rows.isEmpty && record.odometerReading <= currentOdometer) {
          return AddOdometerResult(
            errorMessage:
                'The odometer reading must be greater than the current reading of $currentOdometer km.',
          );
        }

        for (final row in rows) {
          final existingDate = DateTime.parse(
            row[Odometer.recordedAt] as String,
          );

          final existingReading = row[Odometer.odometerReading] as int;

          // The reading must be strictly greater than readings
          // recorded on earlier dates.
          if (existingDate.isBefore(newDate) &&
              record.odometerReading <= existingReading) {
            return AddOdometerResult(
              errorMessage:
                  'The odometer reading must be greater than the reading recorded on '
                  '${existingDate.day}/${existingDate.month}/${existingDate.year} ($existingReading km).',
            );
          }

          // The reading must be strictly less than readings
          // recorded on later dates.
          if (existingDate.isAfter(newDate) &&
              record.odometerReading >= existingReading) {
            return AddOdometerResult(
              errorMessage:
                  'The odometer reading must be less than the reading recorded on '
                  '${existingDate.day}/${existingDate.month}/${existingDate.year} ($existingReading km).',
            );
          }
        }

        // Determine whether this record is the latest by recorded date.
        final latestRows = await txn.query(
          Odometer.table,
          columns: [Odometer.recordedAt],
          where: '${Odometer.vehicleId} = ?',
          whereArgs: [vehicleId],
          orderBy: '${Odometer.recordedAt} DESC',
          limit: 1,
        );

        final isLatestRecord =
            latestRows.isEmpty ||
            !newDate.isBefore(
              DateTime.parse(latestRows.first[Odometer.recordedAt] as String),
            );

        // Insert the new odometer record.
        final data = record.toMap()
          ..[Odometer.vehicleId] = vehicleId
          ..[Odometer.createdAt] = DateTime.now().toIso8601String();

        await txn.insert(
          Odometer.table,
          data,
          conflictAlgorithm: ConflictAlgorithm.abort,
        );

        // Update the vehicle only if this record is the latest.
        if (isLatestRecord) {
          final updatedRows = await txn.update(
            Vehicle.table,
            {
              Vehicle.currentOdometer: record.odometerReading,
              Vehicle.updatedAt: DateTime.now().toIso8601String(),
            },
            where: '${Vehicle.vehicleId} = ?',
            whereArgs: [vehicleId],
          );

          if (updatedRows == 0) {
            throw StateError('Vehicle with ID $vehicleId does not exist.');
          }
        }

        return AddOdometerResult(isLatestRecord: isLatestRecord);
      });
    } catch (e) {
      print('Failed to add odometer record: $e');

      return const AddOdometerResult(
        errorMessage: 'Failed to save the odometer record. Please try again.',
      );
    }
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

  Future<OdometerModel?> getLatestOdometerRecord(int vehicleId) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Odometer.table,
      where: '${Odometer.vehicleId} = ?',
      whereArgs: [vehicleId],
      orderBy: '${Odometer.recordedAt} DESC',
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return OdometerModel.fromMap(rows.first);
  }
}

class AddOdometerResult {
  final String errorMessage;
  final bool isLatestRecord;

  const AddOdometerResult({
    this.errorMessage = '',
    this.isLatestRecord = false,
  });

  bool get isSuccess => errorMessage.isEmpty;
}
