import '../db_keys.dart';

const String serviceSchema =
    '''
  CREATE TABLE ${Service.table} (
    ${Service.serviceId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Service.vehicleId} INTEGER NOT NULL,

    ${Service.category} TEXT NOT NULL,
    ${Service.description} TEXT,

    ${Service.serviceDate} TEXT NOT NULL,
    ${Service.odometerReading} INTEGER NOT NULL,

    ${Service.totalCost} REAL NOT NULL DEFAULT 0,

    ${Service.serviceCenter} TEXT,

    ${Service.createdAt} TEXT NOT NULL,
    ${Service.updatedAt} TEXT NOT NULL,

    FOREIGN KEY (${Service.vehicleId})
      REFERENCES ${Vehicle.table} (${Vehicle.vehicleId})
      ON DELETE CASCADE
  )
''';
