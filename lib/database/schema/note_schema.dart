import '../db_keys.dart';

const String noteSchema =
    '''
  CREATE TABLE ${Note.table} (
    ${Note.noteId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Note.vehicleId} INTEGER NOT NULL,

    ${Note.title} TEXT NOT NULL,
    ${Note.content} TEXT NOT NULL,

    ${Note.createdAt} TEXT NOT NULL,
    ${Note.updatedAt} TEXT NOT NULL,

    FOREIGN KEY (${Note.vehicleId})
      REFERENCES ${Vehicle.table} (${Vehicle.vehicleId})
      ON DELETE CASCADE
  )
''';
