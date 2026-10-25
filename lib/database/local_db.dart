import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_schema.dart';

class LocalDb {
  LocalDb._();

  static final LocalDb instance = LocalDb._();

  static const String _databaseName = 'pitfolio.db';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(
      path,
      version: DbSchema.version,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await DbSchema.createTables(db);
      },
    );
  }
}
