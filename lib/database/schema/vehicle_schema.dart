import '../db_keys.dart';

const String vehicleSchema =
    '''
  CREATE TABLE ${Vehicle.table} (
    ${Vehicle.vehicleId} INTEGER PRIMARY KEY AUTOINCREMENT,

    ${Vehicle.name} TEXT NOT NULL,
    ${Vehicle.make} TEXT NOT NULL,
    ${Vehicle.model} TEXT NOT NULL,
    ${Vehicle.variant} TEXT,

    ${Vehicle.currentOdometer} INTEGER NOT NULL DEFAULT 0,
    ${Vehicle.fuelType} TEXT NOT NULL,
    ${Vehicle.fuelTankCapacity} REAL NOT NULL,

    ${Vehicle.currency} TEXT NOT NULL,
    ${Vehicle.fuelUnit} TEXT NOT NULL,
    ${Vehicle.distanceUnit} TEXT NOT NULL,

    ${Vehicle.purchaseDate} TEXT,
    ${Vehicle.purchasePrice} REAL,
    ${Vehicle.purchaseOdometer} INTEGER,

    ${Vehicle.photoPath} TEXT,

    ${Vehicle.createdAt} TEXT NOT NULL,
    ${Vehicle.updatedAt} TEXT NOT NULL
  )
''';
