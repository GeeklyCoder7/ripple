import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/core/utils/helper_methods.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/folder_item.dart';

enum MediaType { photos, videos }

class FetchMediaService {
  // Fetches folders using isolate
  Future<List<FolderItem>> getFoldersWithMedia(MediaType mediaType) async {
    try {
      // Passing data to the isolate
      final isolateData = {
        'mediaType': mediaType,
        'defaultStoragePath': AppConstants.defaultStoragePath,
        'restrictedPaths': AppConstants.restrictedPaths,
        'allowedImageExtensions': AppConstants.allowedImageExtensions,
        'allowedVideoExtensions': AppConstants.allowedVideoExtensions,
      };

      // Scanning folders in the background
      return await compute(_scanFoldersInIsolate, isolateData);
    } catch (e) {
      if (kDebugMode) {
        print(
          'Error fetching media items through fetch_media_service.dart: $e',
        );
      }
      return [];
    }
  }

  // Runs in the background isolate
  static Future<List<FolderItem>> _scanFoldersInIsolate(
    Map<String, dynamic> data,
  ) async {
    final MediaType mediaType = data['mediaType'];
    final String defaultStoragePath = data['defaultStoragePath'];
    final List<String> restrictedPaths = List<String>.from(
      data['restrictedPaths'],
    );
    final List<String> allowedImageExtensions = List<String>.from(
      data['allowedImageExtensions'],
    );
    final List<String> allowedVideoExtensions = List<String>.from(
      data['allowedVideoExtensions'],
    );

    List<FolderItem> mediaFolders = [];

    try {
      final rootDirectory = Directory(defaultStoragePath);
      await _scanDirectorySafelyInIsolate(
        rootDirectory,
        mediaType,
        mediaFolders,
        restrictedPaths,
        allowedImageExtensions,
        allowedVideoExtensions,
      );
    } catch (e) {
      print('Error in isolate fetch_media_service.dart: $e');
    }

    return mediaFolders;
  }

  // Scans for safe to include directories in isolation
  static Future<void> _scanDirectorySafelyInIsolate(
    Directory directory,
    MediaType mediaType,
    List<FolderItem> mediaFolders,
    List<String> restrictedPaths,
    List<String> allowedImageExtensions,
    List<String> allowedVideoExtensions,
  ) async {
    try {
      // Checking if current directory should be skipped (in isolation)
      if (_shouldSkipFolderInIsolate(directory.path, restrictedPaths)) {
        if (kDebugMode) {
          print('Skipped restricted directory: ${directory.path}');
        }
        return;
      }

      // Counting media files inside the current folder
      int mediaCount = await _getMediaItemsCountInIsolate(
        directory,
        mediaType,
        allowedImageExtensions,
        allowedVideoExtensions,
      );

      // Media count should be at least one or more to be included int he list
      if (mediaCount > 0) {
        mediaFolders.add(
          FolderItem(
            itemName: _getFolderNameInIsolate(directory.path),
            itemPath: directory.path,
            itemCount: mediaCount,
            isAccessible: await _isAccessibleInIsolate(directory),
          ),
        );

        if (kDebugMode) {
          print('Found media folder: ${directory.path} with $mediaCount items');
        }
      }

      // Scan further directories in isolate
      await for (FileSystemEntity entity in directory.list()) {
        if (entity is Directory) {
          await _scanDirectorySafelyInIsolate(
            entity,
            mediaType,
            mediaFolders,
            restrictedPaths,
            allowedImageExtensions,
            allowedVideoExtensions,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          'Skipping folder due to permission error fetch_media_service.dart: $e',
        );
      }
    }
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
  static Future<bool> _isAccessibleInIsolate(Directory directoryToCheck) async {
    try {
      await directoryToCheck.list().isEmpty;
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if accessible through fetch_media_service: $e');
      }
      return false;
    }
  }

  // Helper method to check if the folder should be skipped
  static bool _shouldSkipFolderInIsolate(
    String folderPath,
    List<String> restrictedPaths,
  ) {
    // Check if it's in the restricted paths
    if (restrictedPaths.any(
      (restricted) => folderPath.startsWith(restricted),
    )) {
      return true;
    }

    // Check if it starts with '.'
    String folderName = _getFolderNameInIsolate(folderPath);
    if (folderName.startsWith('.')) return true;

    // If it passes above checks, it should not be skipped
    return false;
  }

  // Helper method to get the specified media items count
  static Future<int> _getMediaItemsCountInIsolate(
    Directory directoryToCheck,
    MediaType mediaType,
    List<String> allowedImageExtensions,
    List<String> allowedVideoExtensions,
  ) async {
    int count = 0;
    try {
      await for (FileSystemEntity entity in directoryToCheck.list()) {
        if (entity is File) {
          // Get the file extension
          String fileExtension = _getFileExtensionInIsolate(entity.path);

          // Check if the file type matches our specified media type
          if (_isTargetMediaTypeInIsolate(
            fileExtension,
            mediaType,
            allowedImageExtensions,
            allowedVideoExtensions,
          )) {
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
  static bool _isTargetMediaTypeInIsolate(
    String fileExtension,
    MediaType mediaType,
    List<String> allowedImageExtensions,
    List<String> allowedVideoExtensions,
  ) {
    switch (mediaType) {
      case MediaType.photos:
        return allowedImageExtensions.contains(fileExtension);
      case MediaType.videos:
        return allowedVideoExtensions.contains(fileExtension);
      default:
        return false;
    }
  }

  // Extracts folder name from path in isolate background
  static String _getFolderNameInIsolate(String folderPath) {
    return folderPath.split('/').last;
  }

  // Returns the file extension from path in isolate
  static String _getFileExtensionInIsolate(String filePath) {
    try {
      return filePath.substring(filePath.lastIndexOf('.')).toLowerCase();
    } catch (e) {
      return '';
    }
  }

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

  bool _shouldSkipFolder(String folderPath) {
    if (AppConstants.restrictedPaths.any(
      (restricted) => folderPath.startsWith(restricted),
    )) {
      return true;
    }

    String folderName = HelperMethods.getFolderName(folderPath);
    if (folderName.startsWith('.')) return true;

    return false;
  }

  Future<int> _getMediaItemsCount(
    Directory directoryToCheck,
    MediaType mediaType,
  ) async {
    int count = 0;
    try {
      await for (FileSystemEntity entity in directoryToCheck.list()) {
        if (entity is File) {
          String fileExtension = HelperMethods.getFileExtension(entity.path);
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
      if (_shouldSkipFolder(directory.path)) {
        if (kDebugMode) {
          print('Skipped restricted directory: ${directory.path}');
        }
        return;
      }

      int mediaCount = await _getMediaItemsCount(directory, mediaType);

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

      await for (FileSystemEntity entity in directory.list()) {
        if (entity is Directory) {
          await _scanDirectorySafely(entity, mediaType, mediaFolders);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Skipping folder due to permission error: ${directory.path}');
      }
    }
  }
}
