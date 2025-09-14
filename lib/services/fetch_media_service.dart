import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/core/utils/helper_methods.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/folder_item.dart';

enum MediaType { photos, videos }

class FetchMediaService {
  // Method to fetch the folders with the specified MediaType
  Future<List<FolderItem>> getFoldersWithMedia(MediaType mediaType) async {
    List<FolderItem> mediaFolders = [];
    try {
      final rootDirectory = Directory(
        AppConstants.defaultStoragePath,
      ); // Root directory to start searching from

      // Get all nested directories and files with proper check for restricted paths
      await _scanDirectorySafely(rootDirectory, mediaType, mediaFolders);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching the media items through fetch_media: $e');
      }
    }
    return mediaFolders;
  }

  // Fetches actual specified media items from the selected folder
  Future<List<FileItem>> getMediaFilesFromFolders(
    String folderPath,
    MediaType mediaType,
  ) async {
    List<FileItem> mediaFilesList = [];
    try {
      final Directory directoryToSearch = Directory(
        folderPath,
      ); // Creating directory from path to check for files
      if (!await directoryToSearch.exists()) {
        return mediaFilesList;
      }

      await for (FileSystemEntity entity in directoryToSearch.list()) {
        // Checking if the entity if a File
        if (entity is File) {
          String fileExtension = HelperMethods.getFileExtension(entity.path);
          // Checking if the file type matches specified media type
          if (_isTargetMediaType(fileExtension, mediaType)) {
            FileItem mediaFile = FileItem.fromFile(entity);
            mediaFilesList.add(mediaFile);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          'Error fetching media files from target folder through fetch_media_service: $e',
        );
      }
    }
    return mediaFilesList;
  }

  // Helper method to check if the folder is accessible
  static bool _isAccessible(Directory directoryToCheck) {
    try {
      directoryToCheck.listSync();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if accessible through fetch_media_service: $e');
      }
      return false;
    }
  }

  // Helper method to check if the folder should be skipped
  bool _shouldSkipFolder(String folderPath) {
    // Check if it's in the restricted paths
    if (AppConstants.restrictedPaths.any(
      (restricted) => folderPath.startsWith(restricted),
    )) {
      return true;
    }

    // Check if it starts with '.'
    String folderName = HelperMethods.getFolderName(folderPath);
    if (folderName.startsWith('.')) return true;

    // If it passes above checks, it should not be skipped
    return false;
  }

  // Helper method to get the specified media items count
  Future<int> _getMediaItemsCount(
    Directory directoryToCheck,
    MediaType mediaType,
  ) async {
    int count = 0;
    try {
      await for (FileSystemEntity entity in directoryToCheck.list()) {
        if (entity is File) {
          // Get the file extension
          String fileExtension = HelperMethods.getFileExtension(entity.path);

          // Check if the file type matches our specified media type
          if (_isTargetMediaType(fileExtension, mediaType)) {
            count++;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error counting media items through fetch_media_service: $e');
      }
    }
    return count;
  }

  // Helper method to check if the file type matches the specified media type
  bool _isTargetMediaType(String fileExtension, MediaType mediaType) {
    switch (mediaType) {
      case MediaType.photos:
        return AppConstants.allowedImageExtensions.contains(fileExtension);
      case MediaType.videos:
        return AppConstants.allowedVideoExtensions.contains(fileExtension);
      default:
        return false;
    }
  }

  Future<void> _scanDirectorySafely(
    Directory directory,
    MediaType mediaType,
    List<FolderItem> mediaFolders,
  ) async {
    try {
      // Checking if the current directory should be skipped
      if (_shouldSkipFolder(directory.path)) {
        if (kDebugMode) {
          print('Skipped restricted directory: ${directory.path}');
        }
        return;
      }

      // Counting media files inside the current folder
      int mediaCount = await _getMediaItemsCount(directory, mediaType);

      // Media count should be at least one or more to be included in the list
      if (mediaCount > 0) {
        mediaFolders.add(
          FolderItem(
            itemName: HelperMethods.getFolderName(directory.path),
            itemPath: directory.path,
            itemCount: mediaCount,
            isAccessible: _isAccessible(directory),
          ),
        );

        if (kDebugMode) {
          print('Found media folder: ${directory.path} with $mediaCount items');
        }
      }

      // Scan further directories
      await for (FileSystemEntity entity in directory.list()) {
        if (entity is Directory) {
          await _scanDirectorySafely(entity, mediaType, mediaFolders);
        }
      }
    } catch (e) {
      // Skip individual folders that cause errors
      if (kDebugMode) {
        print('Skipping folder due to permission error: ${directory.path}');
      }
      // Continue scanning other folders
    }
  }
}
