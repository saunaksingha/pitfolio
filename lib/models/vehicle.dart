import '../database/db_keys.dart';

class VehicleModel {
  final int? id;

  // Basic vehicle details
  final String name;
  final String make;
  final String model;
  final String? variant;

  // Vehicle specifications
  final int currentOdometer;
  final String fuelType;
  final double fuelTankCapacity;

  // Display preferences
  final String currency;
  final String fuelUnit;
  final String distanceUnit;

  // Purchase details
  final String? purchaseDate;
  final double? purchasePrice;
  final int? purchaseOdometer;

  // Vehicle image
  String? photoPath;

  // Timestamps
  String? createdAt;
  String? updatedAt;

  VehicleModel({
    this.id,
    required this.name,
    required this.make,
    required this.model,
    this.variant,
    required this.currentOdometer,
    required this.fuelType,
    required this.fuelTankCapacity,
    required this.currency,
    required this.fuelUnit,
    required this.distanceUnit,
    this.purchaseDate,
    this.purchasePrice,
    this.purchaseOdometer,
    this.photoPath,
    this.createdAt,
    this.updatedAt,
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
      Vehicle.fuelTankCapacity: fuelTankCapacity,
      Vehicle.currency: currency,
      Vehicle.fuelUnit: fuelUnit,
      Vehicle.distanceUnit: distanceUnit,
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
      fuelTankCapacity: (map[Vehicle.fuelTankCapacity] as num?)!.toDouble(),
      currency: map[Vehicle.currency] as String,
      fuelUnit: map[Vehicle.fuelUnit] as String,
      distanceUnit: map[Vehicle.distanceUnit] as String,
      purchaseDate: map[Vehicle.purchaseDate] as String?,
      purchasePrice: (map[Vehicle.purchasePrice] as num?)?.toDouble(),
      purchaseOdometer: map[Vehicle.purchaseOdometer] as int?,
      photoPath: map[Vehicle.photoPath] as String?,
      createdAt: map[Vehicle.createdAt] as String,
      updatedAt: map[Vehicle.updatedAt] as String,
    );
  }
}
