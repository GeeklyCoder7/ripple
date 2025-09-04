import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ripple/models/file_system_item.dart';

class FolderItem extends FileSystemItem {
  final int itemCount;
  final bool isAccessible;

  FolderItem({
    required super.itemName,
    required super.itemPath,
    required this.itemCount,
    required this.isAccessible,
  }) : super(itemType: FileSystemItemType.folder);

  // Getters
  String get folderDisplayName => itemName.isEmpty ? 'Root' : itemName;
  String get itemCountText => itemCount == 1 ? '1 item' : '$itemCount items';

  // Find total items count inside the current folder
  static int _getItemCount(Directory directory) {
    try {
      return directory.listSync().length;
    } catch (e) {
      if (kDebugMode) {
        print('Get item count error: $e');
      }
      return 0;
    }
  }

  // Check if the current folder is accessible
  static bool _isAccessible(Directory directory) {
    try {
      directory.listSync();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('isAccessible check error: $e');
      }
      return false;
    }
  }

  // Get the folder name
  static String _getFolderName(Directory directory) {
    try {
      return directory.path.split('/').last;
    } catch (e) {
      if (kDebugMode) {
        print('Get folder name error: $e');
      }
      return "";
    }
  }

  // Factory method to create FolderItem from Directory
  factory FolderItem.fromDirectory(Directory directory) {
    return FolderItem(
      itemName: _getFolderName(directory),
      itemPath: directory.path,
      itemCount: _getItemCount(directory),
      isAccessible: _isAccessible(directory),
    );
  }
}
