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

  Future<int> updateVehicle(VehicleModel vehicle) async {
    if (vehicle.id == null) {
      throw ArgumentError('Cannot update a vehicle without an ID.');
    }

    final db = await LocalDb.instance.database;

    final data = vehicle.toMap()
      ..remove(Vehicle.vehicleId)
      ..remove(Vehicle.createdAt)
      ..[Vehicle.updatedAt] = DateTime.now().toIso8601String();

    return db.update(
      Vehicle.table,
      data,
      where: '${Vehicle.vehicleId} = ?',
      whereArgs: [vehicle.id],
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
}
