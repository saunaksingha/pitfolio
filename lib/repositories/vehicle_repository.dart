import 'package:pitfolio/models/attachment.dart';
import 'package:pitfolio/repositories/attachment_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db_keys.dart';
import '../database/local_db.dart';
import '../models/vehicle.dart';

class VehicleRepository {
  VehicleRepository._();

  static final VehicleRepository instance = VehicleRepository._();

  Future<int> addVehicle(VehicleModel vehicle) async {
    final db = await LocalDb.instance.database;
    final now = DateTime.now().toIso8601String();

    final data = vehicle.toMap()
      ..remove(Vehicle.vehicleId)
      ..[Vehicle.createdAt] = now
      ..[Vehicle.updatedAt] = now;

    return db.insert(
      Vehicle.table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<VehicleModel>> getAllVehicles() async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Vehicle.table,
      orderBy: '${Vehicle.createdAt} DESC',
    );

    return rows.map(VehicleModel.fromMap).toList();
  }

  Future<VehicleModel?> getVehicleById(int id) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Vehicle.table,
      where: '${Vehicle.vehicleId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return VehicleModel.fromMap(rows.first);
  }

  Future<int> updateVehicle(int vehicleId, VehicleModel vehicle) async {
    final db = await LocalDb.instance.database;

    final data = vehicle.toMap()
      ..remove(Vehicle.vehicleId)
      ..remove(Vehicle.createdAt)
      ..[Vehicle.updatedAt] = DateTime.now().toIso8601String();

    return db.update(
      Vehicle.table,
      data,
      where: '${Vehicle.vehicleId} = ?',
      whereArgs: [vehicleId],
    );
  }

  Future<int> deleteVehicle(int id) async {
    final db = await LocalDb.instance.database;

    return db.delete(
      Vehicle.table,
      where: '${Vehicle.vehicleId} = ?',
      whereArgs: [id],
    );
  }

  Future<bool> addVehicleWithAttachments(
    VehicleModel vehicle,
    List<AttachmentModel> attachments,
  ) async {
    final db = await LocalDb.instance.database;
    final now = DateTime.now().toIso8601String();

    try {
      await db.transaction<void>((txn) async {
        // 1. Prepare vehicle data
        final vehicleData = vehicle.toMap()
          ..remove(Vehicle.vehicleId)
          ..[Vehicle.createdAt] = now
          ..[Vehicle.updatedAt] = now;

        // 2. Insert vehicle
        final vehicleId = await txn.insert(
          Vehicle.table,
          vehicleData,
          conflictAlgorithm: ConflictAlgorithm.abort,
        );

        // 3. Insert all attachments
        for (final attachment in attachments) {
          final attachmentData = attachment.toMap()
            ..[Attachment.recordId] = vehicleId;

          await AttachmentRepository.instance.addAttachmentTXN(
            AttachmentModel.fromMap(attachmentData),
            txn,
          );
        }
      });

      // The transaction committed successfully.
      return true;
    } catch (e, stackTrace) {
      // // Database transaction failed and was rolled back.
      // print('Failed to save vehicle and attachments: $e');
      // print(stackTrace);

      // // Delete the files associated with the attachments.
      // for (final attachment in attachments) {
      //   try {
      //     await FileStorageService.deleteFile(attachment.filePath);
      //   } catch (fileError) {
      //     print(
      //       'Failed to delete attachment file '
      //       '${attachment.filePath}: $fileError',
      //     );
      //   }
      // }

      return false;
    }
  }
}
