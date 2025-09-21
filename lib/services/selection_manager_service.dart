import 'package:flutter/cupertino.dart';
import 'package:ripple/models/apk_item.dart';
import 'package:ripple/models/file_item.dart';
import 'package:ripple/models/file_system_item.dart';

class SelectionManagerService extends ChangeNotifier {
  final List<FileSystemItem> _selectedItemsList = [];

  // Getters
  int get totalSelectedCount => _selectedItemsList.length;
  List<FileSystemItem> get selectedItemsList =>
      List.unmodifiable(_selectedItemsList);
  bool get hasSelection => _selectedItemsList.isNotEmpty;
  int get filesCount => _getDocumentsCount();
  int get imagesCount => getSelectionByType(FileType.image).length;
  int get videosCount => getSelectionByType(FileType.video).length;
  int get appsCount => _getApksCount();

  // Checks if the item is selected based on the path
  bool isSelected(FileSystemItem item) {
    if (item is ApkItem) {
      return selectedItemsList.any((selected) => selected == item);
    } else {
      return selectedItemsList.any(
        (selected) => selected.itemPath == item.itemPath,
      );
    }
  }

  // Toggles the selection
  void toggleSelection(FileSystemItem item) {
    bool wasSelected = isSelected(item);
    if (wasSelected) {
      if (item is ApkItem) {
        _selectedItemsList.removeWhere((selected) => selected == item);
      } else {
        _selectedItemsList.removeWhere(
              (selected) => selected.itemPath == item.itemPath,
        );
      }
      item.isSelected = false;
    } else {
      _selectedItemsList.add(item);
      item.isSelected = true;
    }
    notifyListeners();
  }

  // Returns items from the selection except images, videos and apps
  List<FileSystemItem> getDocumentsFromSelection() {
    List<FileSystemItem> selectedDocumentsList = [];
    if (hasSelection) {
      selectedDocumentsList.addAll(getSelectionByType(FileType.word));
      selectedDocumentsList.addAll(getSelectionByType(FileType.unknown));
      selectedDocumentsList.addAll(getSelectionByType(FileType.text));
      selectedDocumentsList.addAll(getSelectionByType(FileType.excel));
      selectedDocumentsList.addAll(getSelectionByType(FileType.powerpoint));
      selectedDocumentsList.addAll(getSelectionByType(FileType.pdf));
    }
    return selectedDocumentsList;
  }

  // Returns the selected apks list
  List<ApkItem> getApksFromSelection() {
    return _selectedItemsList.whereType<ApkItem>().toList();
  }

  // Returns list of items of specific type
  List<FileSystemItem> getSelectionByType(FileType fileType) {
    return _selectedItemsList
        .where(
          (item) => item is FileItem && (item as FileItem).fileType == fileType,
        )
        .toList();
  }

  // Returns item count for just the ApkItems as it's different from normal FileItem
  int _getApksCount() {
    return _selectedItemsList.whereType<ApkItem>().length;
  }

  // Returns count of items of type 'Document'
  int _getDocumentsCount() {
    int total = 0;
    total += getSelectionByType(FileType.pdf).length;
    total += getSelectionByType(FileType.word).length;
    total += getSelectionByType(FileType.powerpoint).length;
    total += getSelectionByType(FileType.excel).length;
    total += getSelectionByType(FileType.text).length;
    total += getSelectionByType(FileType.unknown).length;

    return total;
  }

  // Clears all selections
  void clearAllSelections() {
    for (var item in _selectedItemsList) {
      item.isSelected = false;
    }
    _selectedItemsList.clear();
    notifyListeners();
  }

  // Clears particular selection based on type
  void clearSelectionByType({required isDocument, FileType? filetype}) {
    List<FileSystemItem> itemsToRemove = [];
    if (isDocument) {
      itemsToRemove = getDocumentsFromSelection();
    } else {
      if (filetype == FileType.apk) {
        itemsToRemove = getApksFromSelection();
      } else {
        itemsToRemove = getSelectionByType(filetype!);
      }
    }

    for (var item in itemsToRemove) {
      item.isSelected = false;
      _selectedItemsList.removeWhere(
        (selected) => selected.itemPath == item.itemPath,
      );
    }

    notifyListeners();
  }

  // Returns total selection size
  double get totalSelectionSize {
    return _selectedItemsList
        .whereType<FileItem>()
        .map((item) => (item).fileSizeBytes ?? 0)
        .fold(0, (sum, size) => sum + size);
  }

  // Sync the selection state when the folder is reloaded
  void syncSelectionState(List<FileSystemItem> newItems) {
    for (var newItem in newItems) {
      if (isSelected(newItem)) {
        newItem.isSelected = true;
      }
      notifyListeners();
    }
  }
}
