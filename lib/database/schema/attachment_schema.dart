import '../db_keys.dart';

const String attachmentSchema =
    '''
  CREATE TABLE ${Attachment.table} (
    ${Attachment.attachmentId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Attachment.recordId} INTEGER NOT NULL,
    ${Attachment.attachmentType} TEXT NOT NULL,
    ${Attachment.fileName} TEXT NOT NULL,
    ${Attachment.filePath} TEXT NOT NULL,
    ${Attachment.mimeType} TEXT,
    ${Attachment.fileSize} INTEGER,
    ${Attachment.createdAt} TEXT NOT NULL,

    CHECK (
      ${Attachment.attachmentType} IN (
        '${AttachmentType.purchaseDocument}',
        '${AttachmentType.vehicleDocument}',
        '${AttachmentType.expenseReceipt}',
        '${AttachmentType.serviceDocument}',
        '${AttachmentType.noteAttachment}'
      )
    )
  )
''';
