import 'package:sqflite/sqflite.dart';

import '../core/constants/app_options.dart';
import '../database/db_keys.dart';
import '../database/local_db.dart';
import '../models/attachment.dart';

class AttachmentRepository {
  AttachmentRepository._();

  static final AttachmentRepository instance = AttachmentRepository._();

  Future<int> addAttachment(AttachmentModel attachment) async {
    final db = await LocalDb.instance.database;

    final data = attachment.toMap()
      ..remove(Attachment.attachmentId)
      ..[Attachment.createdAt] = DateTime.now().toIso8601String();

    return db.insert(
      Attachment.table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<AttachmentModel>> getAttachments({
    required int recordId,
    required AttachmentType attachmentType,
  }) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Attachment.table,
      where:
          '''
        ${Attachment.recordId} = ?
        AND ${Attachment.attachmentType} = ?
      ''',
      whereArgs: [recordId, attachmentType.name],
      orderBy: '${Attachment.createdAt} DESC',
    );

    return rows.map(AttachmentModel.fromMap).toList();
  }

  Future<AttachmentModel?> getAttachmentById(int id) async {
    final db = await LocalDb.instance.database;

    final rows = await db.query(
      Attachment.table,
      where: '${Attachment.attachmentId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return AttachmentModel.fromMap(rows.first);
  }

  Future<int> deleteAttachment(int id) async {
    final db = await LocalDb.instance.database;

    return db.delete(
      Attachment.table,
      where: '${Attachment.attachmentId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> addAttachmentTXN(
    AttachmentModel attachment,
    Transaction txn,
  ) async {
    final data = attachment.toMap()
      ..remove(Attachment.attachmentId)
      ..[Attachment.createdAt] = DateTime.now().toIso8601String();

    return txn.insert(
      Attachment.table,
      data,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }
}
