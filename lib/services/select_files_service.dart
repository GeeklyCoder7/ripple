import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/models/folder_item.dart';

class SelectFilesService {
  // Method to get the folder contents for the documents tab
  Future<List<FileSystemItem>> getFolderContents(String path) async {
    final restrictedPaths = [
      '/storage/emulated/0/Android/data',
      '/storage/emulated/0/Android/obb',
    ];

    List<FileSystemItem> folderContentsList = [];
    try {
      Directory directory = Directory(path); // Current directory from path
      if (!await directory.exists()) {
        if (kDebugMode) {
          print('Directory does not exists: $path');
        }
        return folderContentsList;
      }
      await for (FileSystemEntity folderItem in directory.list()) {
        if (folderItem is File) {
          FileItem item = FileItem.fromFile(folderItem);
          folderContentsList.add(item);
        } else if (folderItem is Directory) {
          if (restrictedPaths.contains(folderItem.path)) {
            continue;
          }
          FolderItem item = FolderItem.fromDirectory(folderItem);
          if (!item.itemName.startsWith('.')) {
            folderContentsList.add(item);
          }
        }
      }
      // Sort the list as folders first and that too in alphabetical order and then files
      folderContentsList.sort((a, b) {
        // a is for folders and b is for files so ensuring that folder comes before files
        if (a is FolderItem && b is FileItem) return -1;
        if (a is FileItem && b is FolderItem) return 1;

        // If both are folders sort by name
        if (a is FolderItem && b is FolderItem) {
          return a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase());
        }

        // If both are files sort by name
        if (a is FileItem && b is FileItem) {
          return a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase());
        }
        return 0;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting folder contents through service class: $e');
      }
    }
    return folderContentsList;
  }
}
