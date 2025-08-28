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

  // 📐 SIZES & RADIUS
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double cardElevation = 4.0;
  static const double borderRadius = 12.0;

  static const double borderRadiusLarge = 100.0;
  static const double borderRadiusMedium = 25.0;
  static const double borderRadiusSmall = 10.0;

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
  static const int defaultPageSize = 200;   // list chunk size for large folders

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
  static const String emptyFolderSubtitle = 'Try a different folder or go back.';
  static const String loadingLabel = 'Loading...';

  // 📄 FILE FILTERS (extensions)
  static const List<String> allowedImageExtensions = [
    '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.heic', '.svg'
  ];
  static const List<String> allowedVideoExtensions = [
    '.mp4', '.mov', '.m4v', '.mkv', '.avi', '.webm', '.wmv'
  ];
  static const List<String> allowedAudioExtensions = [
    '.mp3', '.aac', '.wav', '.flac', '.ogg', '.m4a'
  ];
  static const List<String> allowedDocumentExtensions = [
    '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.txt', '.rtf', '.odt'
  ];
  static const List<String> allowedApkExtensions = ['.apk'];

  // 🟦 MIME GROUP HELPERS (for quick checks)
  static const List<String> mediaExtensions = [
    ...allowedImageExtensions,
    ...allowedVideoExtensions,
    ...allowedAudioExtensions,
  ];
  static const List<String> docExtensions = allowedDocumentExtensions;

  // ♿️ ACCESSIBILITY / SEMANTICS
  static const String semanticsSelectItem = 'Select item';
  static const String semanticsOpenFolder = 'Open folder';
  static const String semanticsBack = 'Back';
}