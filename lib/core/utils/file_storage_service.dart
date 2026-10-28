import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileStorageService {
  FileStorageService._();

  static const String _appFolderName = 'Pitfolio';
  static const String _filesFolderName = 'Files';

  /// Returns Pitfolio's app-private files directory.
  static Future<Directory> getStorageDirectory() async {
    final baseDirectory = await getApplicationDocumentsDirectory();

    final directory = Directory(
      p.join(baseDirectory.path, _appFolderName, _filesFolderName),
    );

    await directory.create(recursive: true);
    return directory;
  }

  /// Copies the selected file into Pitfolio's storage
  /// and returns its complete absolute path.
  static Future<String> storeFile(
    PlatformFile file, {
    String? namePrefix,
  }) async {
    final sourcePath = file.path;

    if (sourcePath == null || sourcePath.isEmpty) {
      throw FileSystemException(
        'The selected file has no accessible local path.',
        file.name,
      );
    }

    final sourceFile = File(sourcePath);

    if (!await sourceFile.exists()) {
      throw FileSystemException(
        'The selected file no longer exists.',
        sourcePath,
      );
    }

    final originalName = p.basename(file.name);
    final extension = p.extension(originalName);
    final baseName = p.basenameWithoutExtension(originalName);
    final safeBaseName = _sanitize(baseName);

    final safePrefix = namePrefix == null || namePrefix.trim().isEmpty
        ? ''
        : '${_sanitize(namePrefix)}_';

    final fileName =
        '$safePrefix'
        '${safeBaseName.isEmpty ? 'file' : safeBaseName}_'
        '$extension';

    final directory = await getStorageDirectory();
    final destinationPath = p.join(directory.path, fileName);

    final savedFile = await sourceFile.copy(destinationPath);
    final completePath = savedFile.absolute.path;

    debugPrint('Saved file: ${p.basename(completePath)}');
    debugPrint('Complete file path: $completePath');

    return completePath;
  }

  /// Checks whether a saved file still exists.
  static Future<bool> fileExists(String? filePath) async {
    if (filePath == null || filePath.isEmpty) {
      return false;
    }

    return File(filePath).exists();
  }

  /// Gets a File object from a saved path.
  static File? getFile(String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      return null;
    }

    return File(filePath);
  }

  /// Deletes a saved file.
  static Future<void> deleteFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) {
      return;
    }

    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }
  }

  static String _sanitize(String value) {
    return value
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }
}
