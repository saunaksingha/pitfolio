import '../database/db_keys.dart';

class FuelModel {
  final int? id;
  final int vehicleId;

  final String fuelDate;
  final int odometerReading;

  final String fuelType;
  final double quantity;
  final double? pricePerUnit;
  final double totalCost;

  final String? fuelStation;
  final String? notes;

  final String createdAt;
  final String updatedAt;

  const FuelModel({
    this.id,
    required this.vehicleId,
    required this.fuelDate,
    required this.odometerReading,
    required this.fuelType,
    required this.quantity,
    this.pricePerUnit,
    required this.totalCost,
    this.fuelStation,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      Fuel.fuelId: id,
      Fuel.vehicleId: vehicleId,
      Fuel.fuelDate: fuelDate,
      Fuel.odometerReading: odometerReading,
      Fuel.fuelType: fuelType,
      Fuel.quantity: quantity,
      Fuel.pricePerUnit: pricePerUnit,
      Fuel.totalCost: totalCost,
      Fuel.fuelStation: fuelStation,
      Fuel.notes: notes,
      Fuel.createdAt: createdAt,
      Fuel.updatedAt: updatedAt,
    };
  }

  factory FuelModel.fromMap(Map<String, dynamic> map) {
    return FuelModel(
      id: map[Fuel.fuelId] as int?,
      vehicleId: map[Fuel.vehicleId] as int,
      fuelDate: map[Fuel.fuelDate] as String,
      odometerReading: map[Fuel.odometerReading] as int,
      fuelType: map[Fuel.fuelType] as String,
      quantity: (map[Fuel.quantity] as num).toDouble(),
      pricePerUnit: (map[Fuel.pricePerUnit] as num?)?.toDouble(),
      totalCost: (map[Fuel.totalCost] as num).toDouble(),
      fuelStation: map[Fuel.fuelStation] as String?,
      notes: map[Fuel.notes] as String?,
      createdAt: map[Fuel.createdAt] as String,
      updatedAt: map[Fuel.updatedAt] as String,
    );
  }
}
