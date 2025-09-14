import 'package:flutter/foundation.dart';

class HelperMethods {
  // Returns the folder name from the path
  static String getFolderName(String folderPath) {
    return folderPath.split('/').last;
  }

  // Returns the file extension from the file path
  static String getFileExtension(String filePath) {
    try {
      return filePath.substring(filePath.lastIndexOf('.')).toLowerCase();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting file extension: $e');
      }
      return '';
    }
  }
}
