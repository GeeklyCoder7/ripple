import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/apk_item.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/models/folder_item.dart';

class FetchFolderItemsService {
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
          // The folder item is a file
          FileItem fileItem = FileItem.fromFile(folderItem);

          // Check if the file is an apk
          if (AppConstants.allowedApkExtensions.contains(
            fileItem.fileExtension,
          )) {
            // The file is an apk file
            ApkItem apkItem = ApkItem.fromApkFile(
              fileName: fileItem.itemName,
              filePath: fileItem.itemPath,
              sizeBytes: fileItem.fileSizeBytes,
            );
            folderContentsList.add(apkItem);
          } else {
            // The item is normal file item
            folderContentsList.add(fileItem);
          }
        } else if (folderItem is Directory) {
          // The folder item is again a folder
          if (restrictedPaths.contains(folderItem.path)) {
            continue;
          }
          // Create folder item and also check it's item count. if < 1, don't add to the list
          FolderItem item = FolderItem.fromDirectory(folderItem);
          if (item.itemCount < 1) {
            continue;
          }
          if (!item.itemName.startsWith('.')) {
            folderContentsList.add(item);
          }
        }
      }
      // Sort the list as folders first and that too in alphabetical order and then files
      folderContentsList.sort((a, b) {
        // folders come before files
        if (a is FolderItem && b is! FolderItem) return -1;
        if (a is! FolderItem && b is FolderItem) return 1;

        // if both are folders, sort by name
        if (a is FolderItem && b is FolderItem) {
          return a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase());
        }

        // If both are files (FileItem or ApkItem), sort by name
        return a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase());
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting folder contents through service class: $e');
      }
    }
    return folderContentsList;
  }
}
