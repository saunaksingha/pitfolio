import '../database/db_keys.dart';

class NoteModel {
  final int? id;
  final int vehicleId;

  final String title;
  final String content;

  final String createdAt;
  final String updatedAt;

  const NoteModel({
    this.id,
    required this.vehicleId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      Note.noteId: id,
      Note.vehicleId: vehicleId,
      Note.title: title,
      Note.content: content,
      Note.createdAt: createdAt,
      Note.updatedAt: updatedAt,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[Note.noteId] as int?,
      vehicleId: map[Note.vehicleId] as int,
      title: map[Note.title] as String,
      content: map[Note.content] as String,
      createdAt: map[Note.createdAt] as String,
      updatedAt: map[Note.updatedAt] as String,
    );
  }
}
