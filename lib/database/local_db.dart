import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import 'db_schema.dart';

class LocalDb {
  LocalDb._();

  static final LocalDb instance = LocalDb._();

  static const String _databaseName = 'pitfolio.db';

  // true = public Download/Pitfolio database for testing
  // false = normal private application database
  static const bool test = true;

  static const String _publicDatabaseDirectory =
      '/storage/emulated/0/Download/Pitfolio';

  Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    late final String databasePath;

    if (test) {
      final permission = await Permission.manageExternalStorage.request();

      if (!permission.isGranted) {
        throw FileSystemException(
          'Storage permission not granted. Allow all-files access '
          'in Android settings to use the public test database.',
        );
      }

      final directory = Directory(_publicDatabaseDirectory);
      await directory.create(recursive: true);

      databasePath = p.join(directory.path, _databaseName);
    } else {
      final defaultDirectory = await getDatabasesPath();
      databasePath = p.join(defaultDirectory, _databaseName);
    }

    return openDatabase(
      databasePath,
      version: DbSchema.version,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await DbSchema.createTables(db);
      },
    );
  }

  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
    }

    _database = null;
  }
}
