const String vehiclesTable = 'vehicles';

const String vehicleId = 'id';
const String vehicleName = 'vehicle_name';
const String vehicleMake = 'make';
const String vehicleModel = 'model';
const String vehicleYear = 'year';
const String vehicleOdometer = 'odometer';
const String vehicleFuelType = 'fuel_type';
const String vehicleVariant = 'variant';

const String vehiclePurchasePrice = 'purchase_price';
const String vehiclePurchaseDate = 'purchase_date';
const String vehicleRegistrationNumber = 'registration_number';
const String vehicleCreatedAt = 'created_at';
const String vehicleUpdatedAt = 'updated_at';

const String vehicleSchema =
    '''
  CREATE TABLE $vehiclesTable (
    $vehicleId INTEGER PRIMARY KEY AUTOINCREMENT,
    $vehicleName TEXT NOT NULL,
    $vehicleMake TEXT NOT NULL,
    $vehicleModel TEXT NOT NULL,
    $vehicleYear INTEGER NOT NULL,
    $vehicleOdometer INTEGER NOT NULL DEFAULT 0,
    $vehicleFuelType TEXT NOT NULL,
    $vehicleVariant TEXT,
    $vehiclePurchasePrice REAL,
    $vehiclePurchaseDate TEXT,
    $vehicleRegistrationNumber TEXT,
    $vehicleCreatedAt TEXT NOT NULL,
    $vehicleUpdatedAt TEXT NOT NULL
  )
''';
