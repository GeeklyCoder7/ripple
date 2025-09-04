enum FileType { apk, document, image, video, audio, unknown }

enum FileSystemItemType { file, folder }

abstract class FileSystemItem {
  final String itemName;
  final String itemPath;
  final FileSystemItemType itemType;

  const FileSystemItem({
    required this.itemName,
    required this.itemPath,
    required this.itemType,
  });

  bool get isFile => itemType == FileSystemItemType.file;
  bool get isFolder => itemType == FileSystemItemType.folder;

  String get displayName => itemName;

  String get parentPath => itemPath.substring(0, itemPath.lastIndexOf('/'));
}
