import 'package:sqflite/sqflite.dart';

import '../database/db_keys.dart';
import '../database/local_db.dart';
import '../models/document.dart';

class DocumentRepository {
  DocumentRepository._();

  static final DocumentRepository instance = DocumentRepository._();

  Future<int> addDocument(DocumentModel document) async {
    final db = await LocalDb.instance.database;
    final now = DateTime.now().toIso8601String();

    final data = document.toMap()
      ..remove(Document.documentId)
      ..[Document.createdAt] = now
      ..[Document.updatedAt] = now;

    return db.insert(
      Document.table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<DocumentModel>> getDocuments(int vehicleId) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Document.table,
      where: '${Document.vehicleId} = ?',
      whereArgs: [vehicleId],
      orderBy: '${Document.createdAt} DESC',
    );

    return rows.map(DocumentModel.fromMap).toList();
  }

  Future<DocumentModel?> getDocumentById(int id) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Document.table,
      where: '${Document.documentId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return DocumentModel.fromMap(rows.first);
  }

  Future<int> updateDocument(DocumentModel document) async {
    if (document.id == null) {
      throw ArgumentError('Cannot update a document without an ID.');
    }

    final db = await LocalDb.instance.database;

    final data = document.toMap()
      ..remove(Document.documentId)
      ..remove(Document.createdAt)
      ..[Document.updatedAt] = DateTime.now().toIso8601String();

    return db.update(
      Document.table,
      data,
      where: '${Document.documentId} = ?',
      whereArgs: [document.id],
    );
  }

  Future<int> deleteDocument(int id) async {
    final db = await LocalDb.instance.database;

    return db.delete(
      Document.table,
      where: '${Document.documentId} = ?',
      whereArgs: [id],
    );
  }

  Future<List<DocumentModel>> getExpiringDocuments(
    int vehicleId, {
    required String expiryBefore,
  }) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Document.table,
      where:
          '''
        ${Document.vehicleId} = ?
        AND ${Document.expiryDate} IS NOT NULL
        AND ${Document.expiryDate} <= ?
      ''',
      whereArgs: [vehicleId, expiryBefore],
      orderBy: '${Document.expiryDate} ASC',
    );

    return rows.map(DocumentModel.fromMap).toList();
  }
}
