import '../db_keys.dart';
import '../../core/constants/app_options.dart';

final String attachmentSchema =
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
        ${AttachmentType.values.map((type) => "'${type.name}'").join(',\n        ')}
      )
    )
  )
''';
