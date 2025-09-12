import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/services/fetch_folder_items_service.dart';

class FetchFolderItemsViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<FileSystemItem> folderContentsList = [];
  String? currentPath;
  FetchFolderItemsService fetchFilesService = FetchFolderItemsService();

  // Method to fetch and load current folder items
  Future<void> loadFolder(String path) async {
    try {
      isLoading = true;
      notifyListeners();
      folderContentsList.clear();
      currentPath = path;
      folderContentsList = await fetchFilesService.getFolderContents(path);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading folder contents through viewmodel class: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to get bread crumb (entire path at the top)
  List<String> get breadcrumbPaths {
    if (currentPath == null) return [];
    return currentPath!.split('/').where((s) => s.isNotEmpty).toList();
  }

  // Method to go back to previous folder
  Future<void> loadPreviousFolder() async {
    if (currentPath == null || currentPath!.isEmpty) return;

    String parentPath = getParentPath(currentPath!);
    if (parentPath.isNotEmpty) {
      await loadFolder(parentPath);
    }
  }

  // Helper method to get the parent path
  String getParentPath(String path) {
    // Remove trailing slash if exists
    String cleanedPath = path.endsWith('/')
        ? path.substring(0, path.length - 1)
        : path;
    int lastSlashIndex = cleanedPath.lastIndexOf('/');

    if (lastSlashIndex > AppConstants.defaultStoragePath.length &&
        lastSlashIndex > 0) {
      return cleanedPath.substring(0, lastSlashIndex);
    }

    return AppConstants.defaultStoragePath;
  }

  // Method to check if user can navigate back
  bool get canNavigateBack {
    if (currentPath == null) return false;
    String parentPath = getParentPath(currentPath!);

    return parentPath != currentPath &&
        parentPath.isNotEmpty &&
        currentPath != AppConstants.defaultStoragePath;
  }
}
