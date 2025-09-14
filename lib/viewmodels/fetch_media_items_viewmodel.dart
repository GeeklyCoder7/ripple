import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/folder_item.dart';
import 'package:ripple/services/fetch_media_service.dart';

class FetchMediaItemsViewModel extends ChangeNotifier {
  bool _isLoadingFolders = false;
  bool _isLoadingFiles = false;
  List<FolderItem> _mediaFoldersList = [];
  List<FileItem> _mediaFilesList = [];
  String? _currentPath;
  final FetchMediaService _fetchMediaService = FetchMediaService();
  MediaType _selectedMediaType = MediaType.photos;
  String? _errorMessage;

  // Getters
  bool get isLoadingFolders => _isLoadingFolders;
  bool get isLoadingFiles => _isLoadingFiles;
  List<FolderItem> get mediaFolders => List.unmodifiable(_mediaFoldersList);
  List<FileItem> get mediaFiles => List.unmodifiable(_mediaFilesList);
  bool get isInsideFolder => _currentPath != null;
  MediaType get selectedMediaType => _selectedMediaType;
  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;
  bool get hasFoldersData => _mediaFoldersList.isNotEmpty;
  bool get hasFilesData => _mediaFilesList.isNotEmpty;

  // Loads all the media folders
  Future<void> loadMediaFolders() async {
    try {
      _isLoadingFolders = true;
      _errorMessage = null;
      notifyListeners();
      _mediaFoldersList.clear();
      print('🔍 Starting to load media folders for ${selectedMediaType.name}');
      _mediaFoldersList = await _fetchMediaService.getFoldersWithMedia(
        selectedMediaType,
      );
      print('📁 Found ${_mediaFoldersList.length} folders'); // Debug
      for (var folder in _mediaFoldersList) {
        print('  - ${folder.itemName} (${folder.itemCount} items)'); // Debug
      }
    } catch (e) {
      if (kDebugMode) {
        _errorMessage =
            'Error loading folder through media_items_viewmodel: $e';
        print(errorMessage);
      }
    } finally {
      _isLoadingFolders = false;
      notifyListeners();
    }
  }

  // Loads media files inside the selected folder
  Future<void> loadMediaFiles(String selectedFolderPath) async {
    try {
      _isLoadingFiles = true;
      _errorMessage = null;
      _currentPath = selectedFolderPath;
      notifyListeners();
      _mediaFilesList.clear();
      _mediaFilesList = await _fetchMediaService.getMediaFilesFromFolders(
        selectedFolderPath,
        _selectedMediaType,
      );
    } catch (e) {
      _errorMessage =
          'Failed to load media files of the selected folder through media_items_viewmodel.dart';
      if (kDebugMode) {
        print('Error loading files: $_errorMessage');
      }
    } finally {
      _isLoadingFiles = false;
      notifyListeners();
    }
  }

  // Navigates back to the media folders grid view
  void navigateBack() {
    _currentPath = null;
    _mediaFilesList.clear();
    _errorMessage = null;
    notifyListeners();
  }

  // Updates the media type based on the user selection
  void switchMediaType(MediaType newSelection) {
    _selectedMediaType = newSelection;
    _currentPath = null;
    _mediaFilesList.clear();
    _errorMessage = null;
    notifyListeners();
    loadMediaFolders();
  }
}
