import '../database/db_keys.dart';

class AttachmentModel {
  final int? id;
  final int recordId;
  final String attachmentType;

  final String fileName;
  final String filePath;
  final String? mimeType;
  final int? fileSize;

  final String createdAt;

  const AttachmentModel({
    this.id,
    required this.recordId,
    required this.attachmentType,
    required this.fileName,
    required this.filePath,
    this.mimeType,
    this.fileSize,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      Attachment.attachmentId: id,
      Attachment.recordId: recordId,
      Attachment.attachmentType: attachmentType,
      Attachment.fileName: fileName,
      Attachment.filePath: filePath,
      Attachment.mimeType: mimeType,
      Attachment.fileSize: fileSize,
      Attachment.createdAt: createdAt,
    };
  }

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      id: map[Attachment.attachmentId] as int?,
      recordId: map[Attachment.recordId] as int,
      attachmentType: map[Attachment.attachmentType] as String,
      fileName: map[Attachment.fileName] as String,
      filePath: map[Attachment.filePath] as String,
      mimeType: map[Attachment.mimeType] as String?,
      fileSize: map[Attachment.fileSize] as int?,
      createdAt: map[Attachment.createdAt] as String,
    );
  }
}
