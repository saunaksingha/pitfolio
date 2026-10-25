import '../db_keys.dart';

const String fuelSchema =
    '''
  CREATE TABLE ${Fuel.table} (
    ${Fuel.fuelId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Fuel.vehicleId} INTEGER NOT NULL,

    ${Fuel.fuelDate} TEXT NOT NULL,
    ${Fuel.odometerReading} INTEGER NOT NULL,

    ${Fuel.fuelType} TEXT NOT NULL,
    ${Fuel.quantity} REAL NOT NULL,
    ${Fuel.pricePerUnit} REAL,
    ${Fuel.totalCost} REAL NOT NULL,

    ${Fuel.fuelStation} TEXT,
    ${Fuel.notes} TEXT,

    ${Fuel.createdAt} TEXT NOT NULL,
    ${Fuel.updatedAt} TEXT NOT NULL,

    FOREIGN KEY (${Fuel.vehicleId})
      REFERENCES ${Vehicle.table} (${Vehicle.vehicleId})
      ON DELETE CASCADE
  )
''';
