import '../db_keys.dart';

const String preferenceSchema =
    '''
  CREATE TABLE ${Preference.table} (
    ${Preference.preferenceId} INTEGER PRIMARY KEY
      CHECK (${Preference.preferenceId} = 1),

    ${Preference.currency} TEXT NOT NULL DEFAULT 'INR',
    ${Preference.distanceUnit} TEXT NOT NULL DEFAULT 'km',
    ${Preference.fuelUnit} TEXT NOT NULL DEFAULT 'L',

    ${Preference.createdAt} TEXT NOT NULL,
    ${Preference.updatedAt} TEXT NOT NULL
  )
''';
