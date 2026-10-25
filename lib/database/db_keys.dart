class Attachment {
  Attachment._();

  static const String table = 'attachments';

  static const String attachmentId = 'id';
  static const String recordId = 'record_id';
  static const String attachmentType = 'attachment_type';

  static const String fileName = 'file_name';
  static const String filePath = 'file_path';
  static const String mimeType = 'mime_type';
  static const String fileSize = 'file_size';

  static const String createdAt = 'created_at';
}

class AttachmentType {
  AttachmentType._();

  static const String purchaseDocument = 'purchase_document';
  static const String vehicleDocument = 'vehicle_document';
  static const String expenseReceipt = 'expense_receipt';
  static const String serviceDocument = 'service_document';
  static const String noteAttachment = 'note_attachment';

  static const List<String> values = [
    purchaseDocument,
    vehicleDocument,
    expenseReceipt,
    serviceDocument,
    noteAttachment,
  ];
}

class Vehicle {
  Vehicle._();

  static const String table = 'vehicles';

  static const String vehicleId = 'id';

  static const String name = 'name';
  static const String make = 'make';
  static const String model = 'model';
  static const String variant = 'variant';

  static const String currentOdometer = 'current_odometer';

  static const String fuelType = 'fuel_type';

  // Purchase details
  static const String purchaseDate = 'purchase_date';
  static const String purchasePrice = 'purchase_price';
  static const String purchaseOdometer = 'purchase_odometer';

  static const String photoPath = 'photo_path';

  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Odometer {
  Odometer._();

  static const String table = 'odometer_records';

  static const String odometerId = 'id';

  static const String vehicleId = 'vehicle_id';

  static const String odometerReading = 'odometer_reading';
  static const String recordedAt = 'recorded_at';

  static const String notes = 'notes';

  static const String createdAt = 'created_at';
}

class Fuel {
  Fuel._();

  static const String table = 'fuel_records';

  static const String fuelId = 'id';
  static const String vehicleId = 'vehicle_id';

  static const String fuelDate = 'fuel_date';
  static const String odometerReading = 'odometer_reading';

  static const String fuelType = 'fuel_type';
  static const String quantity = 'quantity';
  static const String pricePerUnit = 'price_per_unit';
  static const String totalCost = 'total_cost';

  static const String fuelStation = 'fuel_station';
  static const String notes = 'notes';

  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Expense {
  Expense._();

  static const String table = 'expenses';

  static const String expenseId = 'id';
  static const String vehicleId = 'vehicle_id';

  static const String title = 'title';
  static const String category = 'category';
  static const String amount = 'amount';

  static const String expenseDate = 'expense_date';
  static const String odometerReading = 'odometer_reading';

  static const String notes = 'notes';

  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Service {
  Service._();

  static const String table = 'service_records';

  static const String serviceId = 'id';
  static const String vehicleId = 'vehicle_id';

  static const String category = 'category';
  static const String description = 'description';

  static const String serviceDate = 'service_date';
  static const String odometerReading = 'odometer_reading';

  static const String totalCost = 'total_cost';

  static const String serviceCenter = 'service_center';

  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Note {
  Note._();

  static const String table = 'notes';

  static const String noteId = 'id';
  static const String vehicleId = 'vehicle_id';

  static const String title = 'title';
  static const String content = 'content';

  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Document {
  Document._();

  static const String table = 'documents';

  static const String documentId = 'id';
  static const String vehicleId = 'vehicle_id';

  static const String documentType = 'document_type';
  static const String documentName = 'document_name';
  static const String documentNumber = 'document_number';

  static const String issueDate = 'issue_date';
  static const String expiryDate = 'expiry_date';

  static const String notes = 'notes';

  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class Preference {
  Preference._();

  static const String table = 'preferences';

  static const String preferenceId = 'id';

  static const String currency = 'currency';
  static const String distanceUnit = 'distance_unit';
  static const String fuelUnit = 'fuel_unit';

  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}
