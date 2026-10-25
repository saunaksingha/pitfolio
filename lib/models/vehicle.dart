import '../database/db_keys.dart';

class VehicleModel {
  final int? id;
  final String name;
  final String make;
  final String model;
  final String? variant;
  final int currentOdometer;
  final String fuelType;

  final String? purchaseDate;
  final double? purchasePrice;
  final int? purchaseOdometer;

  final String? photoPath;
  final String createdAt;
  final String updatedAt;

  const VehicleModel({
    this.id,
    required this.name,
    required this.make,
    required this.model,
    this.variant,
    required this.currentOdometer,
    required this.fuelType,
    this.purchaseDate,
    this.purchasePrice,
    this.purchaseOdometer,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      Vehicle.vehicleId: id,
      Vehicle.name: name,
      Vehicle.make: make,
      Vehicle.model: model,
      Vehicle.variant: variant,
      Vehicle.currentOdometer: currentOdometer,
      Vehicle.fuelType: fuelType,
      Vehicle.purchaseDate: purchaseDate,
      Vehicle.purchasePrice: purchasePrice,
      Vehicle.purchaseOdometer: purchaseOdometer,
      Vehicle.photoPath: photoPath,
      Vehicle.createdAt: createdAt,
      Vehicle.updatedAt: updatedAt,
    };
  }

  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    return VehicleModel(
      id: map[Vehicle.vehicleId] as int?,
      name: map[Vehicle.name] as String,
      make: map[Vehicle.make] as String,
      model: map[Vehicle.model] as String,
      variant: map[Vehicle.variant] as String?,
      currentOdometer: map[Vehicle.currentOdometer] as int,
      fuelType: map[Vehicle.fuelType] as String,
      purchaseDate: map[Vehicle.purchaseDate] as String?,
      purchasePrice: (map[Vehicle.purchasePrice] as num?)?.toDouble(),
      purchaseOdometer: map[Vehicle.purchaseOdometer] as int?,
      photoPath: map[Vehicle.photoPath] as String?,
      createdAt: map[Vehicle.createdAt] as String,
      updatedAt: map[Vehicle.updatedAt] as String,
    );
  }
}
