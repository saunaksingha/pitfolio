import '../database/db_keys.dart';

class ServiceModel {
  final int? id;
  final int vehicleId;

  final String category;
  final String? description;

  final String serviceDate;
  final int odometerReading;

  final double totalCost;

  final String? serviceCenter;

  final String createdAt;
  final String updatedAt;

  const ServiceModel({
    this.id,
    required this.vehicleId,
    required this.category,
    this.description,
    required this.serviceDate,
    required this.odometerReading,
    required this.totalCost,
    this.serviceCenter,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      Service.serviceId: id,
      Service.vehicleId: vehicleId,
      Service.category: category,
      Service.description: description,
      Service.serviceDate: serviceDate,
      Service.odometerReading: odometerReading,
      Service.totalCost: totalCost,
      Service.serviceCenter: serviceCenter,
      Service.createdAt: createdAt,
      Service.updatedAt: updatedAt,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map[Service.serviceId] as int?,
      vehicleId: map[Service.vehicleId] as int,
      category: map[Service.category] as String,
      description: map[Service.description] as String?,
      serviceDate: map[Service.serviceDate] as String,
      odometerReading: map[Service.odometerReading] as int,
      totalCost: (map[Service.totalCost] as num).toDouble(),
      serviceCenter: map[Service.serviceCenter] as String?,
      createdAt: map[Service.createdAt] as String,
      updatedAt: map[Service.updatedAt] as String,
    );
  }
}
