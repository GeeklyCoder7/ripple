import 'dart:io';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/models/folder_item.dart';

class SelectFilesService {
  // Method to get the folder contents for the documents tab
  List<FileSystemItem> getFolderContents(String path) {
    List<FileSystemItem> folderContentsList = [];
    try {
      Directory directory = Directory(path); // Current directory from path
      for (FileSystemEntity folderItem in directory.listSync()) {
        if (folderItem is File) {
          FileItem item = FileItem.fromFile(folderItem);
          folderContentsList.add(item);
        } else if (folderItem is Directory) {
          FolderItem item = FolderItem.fromDirectory(folderItem);
          folderContentsList.add(item);
        }
      }
    } catch (e) {
      print('Error reading directory: $e');
    }
    return folderContentsList;
  }

}
