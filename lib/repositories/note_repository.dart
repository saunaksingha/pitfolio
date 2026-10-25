import 'package:sqflite/sqflite.dart';

import '../database/db_keys.dart';
import '../database/local_db.dart';
import '../models/note.dart';

class NoteRepository {
  NoteRepository._();

  static final NoteRepository instance = NoteRepository._();

  Future<int> addNote(NoteModel note) async {
    final db = await LocalDb.instance.database;
    final now = DateTime.now().toIso8601String();

    final data = note.toMap()
      ..remove(Note.noteId)
      ..[Note.createdAt] = now
      ..[Note.updatedAt] = now;

    return db.insert(
      Note.table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<NoteModel>> getNotes(int vehicleId) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Note.table,
      where: '${Note.vehicleId} = ?',
      whereArgs: [vehicleId],
      orderBy: '${Note.updatedAt} DESC',
    );

    return rows.map(NoteModel.fromMap).toList();
  }

  Future<NoteModel?> getNoteById(int id) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Note.table,
      where: '${Note.noteId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return NoteModel.fromMap(rows.first);
  }

  Future<int> updateNote(NoteModel note) async {
    if (note.id == null) {
      throw ArgumentError('Cannot update a note without an ID.');
    }

    final db = await LocalDb.instance.database;

    final data = note.toMap()
      ..remove(Note.noteId)
      ..remove(Note.createdAt)
      ..[Note.updatedAt] = DateTime.now().toIso8601String();

    return db.update(
      Note.table,
      data,
      where: '${Note.noteId} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await LocalDb.instance.database;

    return db.delete(Note.table, where: '${Note.noteId} = ?', whereArgs: [id]);
  }
}
