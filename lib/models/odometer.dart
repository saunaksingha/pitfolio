import '../database/db_keys.dart';

class OdometerModel {
  final int? id;
  final int vehicleId;
  final int odometerReading;
  final String recordedAt;
  final String? notes;
  final String createdAt;

  const OdometerModel({
    this.id,
    required this.vehicleId,
    required this.odometerReading,
    required this.recordedAt,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      Odometer.odometerId: id,
      Odometer.vehicleId: vehicleId,
      Odometer.odometerReading: odometerReading,
      Odometer.recordedAt: recordedAt,
      Odometer.notes: notes,
      Odometer.createdAt: createdAt,
    };
  }

  factory OdometerModel.fromMap(Map<String, dynamic> map) {
    return OdometerModel(
      id: map[Odometer.odometerId] as int?,
      vehicleId: map[Odometer.vehicleId] as int,
      odometerReading: map[Odometer.odometerReading] as int,
      recordedAt: map[Odometer.recordedAt] as String,
      notes: map[Odometer.notes] as String?,
      createdAt: map[Odometer.createdAt] as String,
    );
  }
}
