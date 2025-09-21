import 'dart:typed_data';
import 'package:ripple/models/file_system_item.dart';
import 'package:ripple/services/app_size_service.dart';

enum ApkSource { installed, file }

class ApkItem extends FileSystemItem {
  final String? packageName;
  final String? versionName;
  final int? versionCode;
  final int? sizeBytes;
  final bool isInstalled;
  final ApkSource apkSource;
  final Uint8List? iconBytes;

  ApkItem({
    // FileSystemItem fields
    required super.itemName, // used for displaying the app name
    required super.itemPath, // '' for installed app and absolute path for the file
    // ApkItem specific fields
    required this.isInstalled,
    required this.apkSource,
    this.packageName,
    this.versionName,
    this.versionCode,
    this.sizeBytes,
    this.iconBytes,
  }) : super(itemType: FileSystemItemType.file);

  // Getter for human readable app label or name
  @override
  String get displayName => itemName;

  // Getter for parent path if the app source is from the file
  @override
  String get parentPath {
    if (apkSource == ApkSource.installed ||
        itemPath.isEmpty ||
        !itemPath.contains('/')) {
      return '';
    }
    return super.parentPath;
  }

  // Factory method for creating apk item from installed apk
  static Future<ApkItem> createFromInstalled({
    required String appLabel,
    required String packageName,
    String? versionName,
    int? versionCode,
    Uint8List? iconBytes,
  }) async {
    // Trying to get the APK file size
    int? apkSize;
    try {
      apkSize = await AppSizeService.getApkFileSize(packageName);
    } catch (e) {
      print('Could not get APK size for $packageName: $e');
    }
    return ApkItem(
      itemName: appLabel,
      itemPath: '', // Because installed app doesn't have any path
      isInstalled: true,
      apkSource: ApkSource.installed,
      packageName: packageName,
      versionName: versionName,
      versionCode: versionCode,
      iconBytes: iconBytes,
      sizeBytes: apkSize,
    );
  }

  // Factory method for creating apk item from apk file
  factory ApkItem.fromApkFile({
    required String fileName,
    required String filePath,
    required int sizeBytes,
    String? packageName,
    String? versionName,
    int? versionCode,
    Uint8List? iconBytes,
  }) {
    return ApkItem(
      itemName: fileName,
      itemPath: filePath,
      isInstalled: false,
      apkSource: ApkSource.file,
      packageName: packageName,
      versionName: versionName,
      versionCode: versionCode,
      sizeBytes: sizeBytes,
      iconBytes: iconBytes,
    );
  }

  // Simple identity for dedupe: package for installed, path for file
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ApkItem) return false;
    if (apkSource == ApkSource.installed) {
      return packageName == other.packageName;
    }
    return itemPath == other.itemPath;
  }

  @override
  int get hashCode => apkSource == ApkSource.installed
      ? Object.hash(packageName ?? '', versionCode ?? 0)
      : itemPath.hashCode;

  @override
  String toString() {
    return 'ApkItem(name: $itemName, package: $packageName, version: $versionName, source: $apkSource)';
  }
}
