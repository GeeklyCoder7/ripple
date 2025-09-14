import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/core/utils/helper_methods.dart';
import 'package:ripple/models/file_system_item.dart';

class FileItem extends FileSystemItem {
  final int fileSizeBytes;
  final String fileExtension;
  final FileType fileType;

  FileItem({
    required super.itemName,
    required super.itemPath,
    required this.fileSizeBytes,
    required this.fileExtension,
    required this.fileType,
  }) : super(itemType: FileSystemItemType.file);

  // Factory method to create FileItem from File
  factory FileItem.fromFile(File file) {
    String fileExtension = HelperMethods.getFileExtension(file.path);
    return FileItem(
      itemName: _getFileName(file.path),
      itemPath: file.path,
      fileSizeBytes: getFileSizeBytes(file),
      fileExtension: fileExtension,
      fileType: _getFileType(fileExtension),
    );
  }

  // Helper method for getting file name
  static String _getFileName(String filePath) {
    if (filePath.isNotEmpty) {
      return filePath.substring(filePath.lastIndexOf('/') + 1);
    }
    return '!';
  }

  // Method for deciding the file type (either image or document, etc)
  static FileType _getFileType(String fileExtension) {
    return AppConstants.getFileTypeFromExtension(fileExtension);
  }

  // Method to get the file size
  static int getFileSizeBytes(File file) {
    try {
      return file.lengthSync();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting file size bytes: $e');
      }
      return 0;
    }
  }
}
