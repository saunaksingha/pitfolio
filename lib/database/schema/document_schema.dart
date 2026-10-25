import '../db_keys.dart';

const String documentSchema =
    '''
  CREATE TABLE ${Document.table} (
    ${Document.documentId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Document.vehicleId} INTEGER NOT NULL,

    ${Document.documentType} TEXT NOT NULL,
    ${Document.documentName} TEXT NOT NULL,
    ${Document.documentNumber} TEXT,

    ${Document.issueDate} TEXT,
    ${Document.expiryDate} TEXT,

    ${Document.notes} TEXT,

    ${Document.createdAt} TEXT NOT NULL,
    ${Document.updatedAt} TEXT NOT NULL,

    FOREIGN KEY (${Document.vehicleId})
      REFERENCES ${Vehicle.table} (${Vehicle.vehicleId})
      ON DELETE CASCADE
  )
''';
