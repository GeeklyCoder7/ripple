import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/core/utils/helper_methods.dart';
import 'package:ripple/models/apk_item.dart';

enum FileType {
  apk,
  image,
  video,
  audio,
  pdf,
  word,
  excel,
  powerpoint,
  text,
  unknown,
}

enum FileSystemItemType { file, folder }

abstract class FileSystemItem {
  final String itemName;
  final String itemPath;
  final FileSystemItemType itemType;
  bool isSelected;

  FileSystemItem({
    required this.itemName,
    required this.itemPath,
    required this.itemType,
    this.isSelected = false,
  });

  bool get isFile => itemType == FileSystemItemType.file;
  bool get isFolder => itemType == FileSystemItemType.folder;
  bool get isApk => this is ApkItem;

  String get displayName => itemName;

  String get parentPath => itemPath.substring(0, itemPath.lastIndexOf('/'));
}
