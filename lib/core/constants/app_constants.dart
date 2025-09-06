import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:ripple/core/constants/app_colors.dart';
import 'package:ripple/models/file_system_item.dart';

class AppConstants {
  AppConstants._(); // Private constructor

  // 📱 APP INFO
  static const String appName = 'Ripple';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Make Every Transfer Matter.';

  // 🧭 ROUTES
  static const String routeHome = '/home';
  static const String routeSend = '/send';

  // 🗂️ TAB LABELS (Send flow)
  static const String sendTabApps = 'Apps';
  static const String sendTabMedia = 'Media';
  static const String sendTabDocuments = 'Documents';

  // 📏 SPACING & PADDING
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // CARD PROPERTIES
  static const double cardElevation = 1;

  // 📐 SIZES & RADIUS
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double borderRadius = 12.0;

  static const double borderRadiusLarge = 100.0;
  static const double borderRadiusMedium = 25.0;
  static const double borderRadiusSmall = 10.0;
  static const double borderRadiusExtraSmall = 5.0;

  static const double fontSizeSmall = 16.0;
  static const double fontSizeMedium = 20.0;
  static const double fontSizeLarge = 24.0;
  static const double fontSizeExtraLarge = 48.0;
  static const double fontSizeDefault = 18.0;

  // 📊 LIMITS
  static const int maxFileNameLength = 100;
  static const int maxFilesPerTransfer = 50;
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const int maxSelectionCount = 100; // overall selection cap
  static const int defaultPageSize = 200; // list chunk size for large folders

  // ⏱ DURATIONS
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animMedium = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 600);

  // 📋 LIST/ROW/UI SIZING (Send browser)
  static const double listItemHeight = 64.0;
  static const double listIconSize = 28.0;
  static const double listTrailingIconSize = 22.0;
  static const double dividerThickness = 0.6;

  // 🧭 BREADCRUMB / CHIPS
  static const double breadcrumbHeight = 40.0;
  static const double breadcrumbSpacing = 6.0;
  static const double chipHeight = 28.0;

  // 🖼 THUMBNAILS
  static const double thumbnailSizeSmall = 40.0;
  static const double thumbnailSizeMedium = 64.0;

  // 🔤 STRINGS (common UX)
  static const String sendFiles = 'Send Files';
  static const String receiveFiles = 'Receive Files';
  static const String noFilesSelected = 'No files selected';
  static const String connectionFailed = 'Connection failed';

  // Permission keys constants
  static const PERMISSION_STORAGE_KEY = 'PERMISSION_STORAGE';
  static const PERMISSION_MEDIA_IMAGES_KEY = 'PERMISSION_MEDIA_IMAGES';
  static const PERMISSION_MEDIA_VIDEOS_KEY = 'PERMISSION_MEDIA_VIDEOS';
  static const PERMISSION_MEDIA_AUDIOS_KEY = 'PERMISSION_MEDIA_AUDIO';
  static const PERMISSION_LOCATION_KEY = 'PERMISSION_LOCATION';
  static const PERMISSION_MANAGE_EXTERNAL_STORAGE_KEY =
      'PERMISSION_MANAGE_EXTERNAL_STORAGE';

  // COMMON STORAGE PATHS CONSTANTS
  static const String defaultStoragePath = '/storage/emulated/0';
  static const String downloadsPath = '/storage/emulated/0/Download';
  static const String documentsPath = '/storage/emulated/0/Documents';
  static const String picturesPath = '/storage/emulated/0/Pictures';
  static const String moviesPath = '/storage/emulated/0/Movies';
  static const String musicPath = '/storage/emulated/0/Music';
  static const String dcimPath = '/storage/emulated/0/DCIM';

  // HELPER METHOD TO GET ALL COMMON STORAGE DIRECTORIES
  static List<String> getAllCommonDirs() {
    return [
      defaultStoragePath,
      downloadsPath,
      documentsPath,
      picturesPath,
      moviesPath,
      musicPath,
      dcimPath,
    ];
  }

  // FILE SYSTEM ERROR MESSAGES CONSTANTS
  static const String errorLoadingFolder = 'Error loading folder';
  static const String errorPermissionDenied = 'Storage permission denied';
  static const String errorDirectoryNotFound = 'Directory not found';
  static const String errorDirectoryNotAccessible = 'Directory not accessible';
  static const String errorUnknownFileSystemError = 'Unknown file system error';

  // NAVIGATION AND BREADCRUMB CONSTANTS
  static const String rootFolderName = 'Internal Storage';
  static const String backButtonLabel = 'Back';
  static const String upOneLevelLabel = 'Up one level';
  static const String homeFolderLabel = 'Home';

  // Permissions / empty states
  static const String permissionMediaTitle = 'Media Access Needed';
  static const String permissionMediaMessage =
      'Allow access to your photos and videos to browse and select files.';
  static const String permissionDocsTitle = 'Files Access Needed';
  static const String permissionDocsMessage =
      'Allow access to your files to browse documents and downloads.';
  static const String actionGrantPermission = 'Grant Permission';
  static const String actionOpenSettings = 'Open Settings';
  static const String actionTryAgain = 'Try Again';

  static const String emptyFolderTitle = 'This folder is empty';
  static const String emptyFolderSubtitle =
      'Try a different folder or go back.';
  static const String loadingLabel = 'Loading...';

  // 📄 FILE FILTERS (extensions)
  static const List<String> allowedImageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
    '.heic',
    '.svg',
  ];
  static const List<String> allowedVideoExtensions = [
    '.mp4',
    '.mov',
    '.m4v',
    '.mkv',
    '.avi',
    '.webm',
    '.wmv',
  ];
  static const List<String> allowedAudioExtensions = [
    '.mp3',
    '.aac',
    '.wav',
    '.flac',
    '.ogg',
    '.m4a',
  ];
  static const List<String> allowedDocumentExtensions = [
    '.pdf',
    '.doc',
    '.docx',
    '.xls',
    '.xlsx',
    '.ppt',
    '.pptx',
    '.txt',
    '.rtf',
    '.odt',
  ];
  static const List<String> allowedApkExtensions = ['.apk'];

  // MIME GROUP HELPERS (for quick checks)
  static const List<String> mediaExtensions = [
    ...allowedImageExtensions,
    ...allowedVideoExtensions,
    ...allowedAudioExtensions,
  ];
  static const List<String> docExtensions = allowedDocumentExtensions;

  // ACCESSIBILITY CONSTANTS
  static const String semanticsSelectItem = 'Select item';
  static const String semanticsOpenFolder = 'Open folder';
  static const String semanticsBack = 'Back';

  // FILE SIZE THRESHOLD CONSTANTS
  static const int bytesToKB = 1024;
  static const int bytesToMB = 1024 * 1024;
  static const int bytesToGB = 1024 * 1024 * 1024;

  // Helper method to get the file item type based on the extension
  static FileType getFileTypeFromExtension(String fileExtension) {
    // It's an image file
    if (allowedImageExtensions.contains(fileExtension)) {
      return FileType.image;
    } else if (allowedVideoExtensions.contains(fileExtension)) {
      return FileType.video;
    } else if (allowedAudioExtensions.contains(fileExtension)) {
      return FileType.audio;
    } else if (allowedDocumentExtensions.contains(fileExtension)) {
      // Check specific document types
      switch (fileExtension) {
        case '.pdf':
          return FileType.pdf;
        case '.doc':
        case '.docx':
          return FileType.word;
        case '.ppt':
        case '.pptx':
          return FileType.powerpoint;
        case '.xls':
        case '.xlsx':
          return FileType.excel;
        case '.txt':
          return FileType.text;
        default:
          return FileType.unknown;
      }
    } else if (allowedApkExtensions.contains(fileExtension)) {
      return FileType.apk;
    }
    return FileType.unknown;
  }

  // FILE AND FOLDER ICON CONSTANTS
  static const IconData folderIcon = FontAwesome.folder_open;
  static const IconData pdfIcon = FontAwesome.file_pdf_solid;
  static const IconData docIcon = Icons.description_rounded;
  static const IconData docxIcon = Icons.description_rounded;
  static const IconData xlsIcon = Icons.table_chart;
  static const IconData xlsxIcon = Icons.table_chart;
  static const IconData pptIcon = FontAwesome.file_powerpoint_solid;
  static const IconData pptxIcons = FontAwesome.file_powerpoint_solid;
  static const IconData txtIcon = Icons.article;
  static const IconData imageIcon = FontAwesome.file_image_solid;
  static const IconData videoIcon = FontAwesome.file_video_solid;
  static const IconData audioIcon = FontAwesome.file_audio_solid;
  static const IconData apkIcon = Bootstrap.android2;
  static const IconData defaultIcon = CupertinoIcons.doc_fill;

  // Helper method for getting specific file icon
  static IconData getIconFromFileType(FileType fileType) {
    switch (fileType) {
      case FileType.image:
        return imageIcon;
      case FileType.video:
        return videoIcon;
      case FileType.audio:
        return audioIcon;
      case FileType.apk:
        return apkIcon;
      case FileType.word:
        return docIcon;
      case FileType.pdf:
        return pdfIcon;
      case FileType.text:
        return txtIcon;
      case FileType.powerpoint:
        return pptIcon;
      case FileType.excel:
        return xlsIcon;
      case FileType.unknown:
      default:
        return Icons.insert_drive_file;
    }
  }

  // Helper method to get color from the file type
  static Color getColorFromFileType(FileType fileType) {
    switch (fileType) {
      case FileType.image:
        return AppColors.imageColor;
      case FileType.video:
        return AppColors.videoColor;
      case FileType.audio:
        return AppColors.fileAudio;
      case FileType.apk:
        return AppColors.apkColor;
      case FileType.excel:
        return AppColors.xlsColor;
      case FileType.powerpoint:
        return AppColors.pptColor;
      case FileType.text:
        return AppColors.txtColor;
      case FileType.word:
        return AppColors.docColor;
      case FileType.pdf:
        return AppColors.pdfColor;
      case FileType.unknown:
      default:
        return AppColors.unknownColor;
    }
  }
}
