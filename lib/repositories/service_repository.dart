import 'package:sqflite/sqflite.dart';

import '../database/db_keys.dart';
import '../database/local_db.dart';
import '../models/service.dart';

class ServiceRepository {
  ServiceRepository._();

  static final ServiceRepository instance = ServiceRepository._();

  Future<int> addService(ServiceModel service) async {
    final db = await LocalDb.instance.database;
    final now = DateTime.now().toIso8601String();

    final data = service.toMap()
      ..remove(Service.serviceId)
      ..[Service.createdAt] = now
      ..[Service.updatedAt] = now;

    return db.insert(
      Service.table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<ServiceModel>> getServices(int vehicleId) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Service.table,
      where: '${Service.vehicleId} = ?',
      whereArgs: [vehicleId],
      orderBy: '${Service.serviceDate} DESC',
    );

    return rows.map(ServiceModel.fromMap).toList();
  }

  Future<ServiceModel?> getServiceById(int id) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Service.table,
      where: '${Service.serviceId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return ServiceModel.fromMap(rows.first);
  }

  Future<int> updateService(ServiceModel service) async {
    if (service.id == null) {
      throw ArgumentError('Cannot update a service record without an ID.');
    }

    final db = await LocalDb.instance.database;

    final data = service.toMap()
      ..remove(Service.serviceId)
      ..remove(Service.createdAt)
      ..[Service.updatedAt] = DateTime.now().toIso8601String();

    return db.update(
      Service.table,
      data,
      where: '${Service.serviceId} = ?',
      whereArgs: [service.id],
    );
  }

  Future<int> deleteService(int id) async {
    final db = await LocalDb.instance.database;

    return db.delete(
      Service.table,
      where: '${Service.serviceId} = ?',
      whereArgs: [id],
    );
  }
}
