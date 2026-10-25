import '../database/db_keys.dart';

class DocumentModel {
  final int? id;
  final int vehicleId;

  final String documentType;
  final String documentName;
  final String? documentNumber;

  final String? issueDate;
  final String? expiryDate;

  final String? notes;

  final String createdAt;
  final String updatedAt;

  const DocumentModel({
    this.id,
    required this.vehicleId,
    required this.documentType,
    required this.documentName,
    this.documentNumber,
    this.issueDate,
    this.expiryDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      Document.documentId: id,
      Document.vehicleId: vehicleId,
      Document.documentType: documentType,
      Document.documentName: documentName,
      Document.documentNumber: documentNumber,
      Document.issueDate: issueDate,
      Document.expiryDate: expiryDate,
      Document.notes: notes,
      Document.createdAt: createdAt,
      Document.updatedAt: updatedAt,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map[Document.documentId] as int?,
      vehicleId: map[Document.vehicleId] as int,
      documentType: map[Document.documentType] as String,
      documentName: map[Document.documentName] as String,
      documentNumber: map[Document.documentNumber] as String?,
      issueDate: map[Document.issueDate] as String?,
      expiryDate: map[Document.expiryDate] as String?,
      notes: map[Document.notes] as String?,
      createdAt: map[Document.createdAt] as String,
      updatedAt: map[Document.updatedAt] as String,
    );
  }
}
