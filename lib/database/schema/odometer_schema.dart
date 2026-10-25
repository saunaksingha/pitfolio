import '../db_keys.dart';

const String odometerSchema =
    '''
  CREATE TABLE ${Odometer.table} (
    ${Odometer.odometerId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Odometer.vehicleId} INTEGER NOT NULL,
    ${Odometer.odometerReading} INTEGER NOT NULL,
    ${Odometer.recordedAt} TEXT NOT NULL,
    ${Odometer.notes} TEXT,
    ${Odometer.createdAt} TEXT NOT NULL,

    FOREIGN KEY (${Odometer.vehicleId})
      REFERENCES ${Vehicle.table} (${Vehicle.vehicleId})
      ON DELETE CASCADE
  )
''';
