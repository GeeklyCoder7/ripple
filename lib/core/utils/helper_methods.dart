import 'package:flutter/foundation.dart';
import 'package:ripple/models/file_system_item.dart';

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

  // Returns the formatted count text - specifically used for the dialog title
  static String getFormattedCountText({required int count, FileType? type}) {
    if (count == 1) {
      if (type == FileType.image) {
        return 'Selected $count Image';
      } else if (type == FileType.video) {
        return 'Selected $count Video';
      } else if (type == FileType.apk) {
        return 'Selected $count App';
      } else {
        return 'Selected $count Document';
      }
    } else {
      if (type == FileType.image) {
        return 'Selected $count Images';
      } else if (type == FileType.video) {
        return 'Selected $count Videos';
      } else if (type == FileType.apk) {
        return 'Selected $count Apps';
      } else {
        return 'Selected $count Documents';
      }
    }
  }
}
