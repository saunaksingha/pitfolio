import 'package:sqflite/sqflite.dart';

import '../database/db_keys.dart';
import '../database/local_db.dart';
import '../models/fuel.dart';

class FuelRepository {
  FuelRepository._();

  static final FuelRepository instance = FuelRepository._();

  Future<int> addFuelEntry(FuelModel fuel) async {
    final db = await LocalDb.instance.database;
    final now = DateTime.now().toIso8601String();

    final data = fuel.toMap()
      ..remove(Fuel.fuelId)
      ..[Fuel.createdAt] = now
      ..[Fuel.updatedAt] = now;

    return db.insert(
      Fuel.table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<FuelModel>> getFuelHistory(int vehicleId) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Fuel.table,
      where: '${Fuel.vehicleId} = ?',
      whereArgs: [vehicleId],
      orderBy: '${Fuel.fuelDate} DESC',
    );

    return rows.map(FuelModel.fromMap).toList();
  }

  Future<FuelModel?> getFuelEntryById(int id) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Fuel.table,
      where: '${Fuel.fuelId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return FuelModel.fromMap(rows.first);
  }

  Future<int> updateFuelEntry(FuelModel fuel) async {
    if (fuel.id == null) {
      throw ArgumentError('Cannot update a fuel entry without an ID.');
    }

    final db = await LocalDb.instance.database;

    final data = fuel.toMap()
      ..remove(Fuel.fuelId)
      ..remove(Fuel.createdAt)
      ..[Fuel.updatedAt] = DateTime.now().toIso8601String();

    return db.update(
      Fuel.table,
      data,
      where: '${Fuel.fuelId} = ?',
      whereArgs: [fuel.id],
    );
  }

  Future<int> deleteFuelEntry(int id) async {
    final db = await LocalDb.instance.database;

    return db.delete(Fuel.table, where: '${Fuel.fuelId} = ?', whereArgs: [id]);
  }
}
