import 'package:flutter/foundation.dart';
import 'package:ripple/models/apk_item.dart';
import 'package:ripple/services/fetch_apk_service.dart';

class FetchApkViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<ApkItem> _installedAppsList = [];
  String? errorMessage;
  final FetchApkService _fetchApkService = FetchApkService();

  // Getters for readonly access
  List<ApkItem> get installedApps => List.unmodifiable(_installedAppsList);
  bool get hasError => errorMessage != null;
  bool get hasData => _installedAppsList.isNotEmpty;

  // Method to fetch and load installed apps with sizes
  Future<void> loadInstalledApps() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _installedAppsList.clear();

      // Get basic app info from service (without sizes)
      List<Map<String, dynamic>> appInfoList = await _fetchApkService.fetchInstalledAppsInfo(
        includeIcons: true,
      );

      // Create ApkItem objects with sizes asynchronously
      List<ApkItem> apkItems = [];

      for (Map<String, dynamic> appInfo in appInfoList) {
        try {
          // Use the new async factory method that gets APK size
          final apkItem = await ApkItem.createFromInstalled(
            appLabel: appInfo['appLabel'] ?? 'Unknown App',
            packageName: appInfo['packageName'] ?? '',
            versionName: appInfo['versionName'],
            versionCode: appInfo['versionCode'],
            iconBytes: appInfo['iconBytes'],
          );
          apkItems.add(apkItem);

          // Optionally notify listeners during loading for better UX
          if (apkItems.length % 5 == 0) {
            _installedAppsList = List.from(apkItems);
            notifyListeners();
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error creating ApkItem for ${appInfo['packageName']}: $e');
          }
          // Continue with other apps even if one fails
        }
      }

      _installedAppsList = apkItems;
    } catch (e) {
      errorMessage = 'Failed to load installed apps: $e';
      _installedAppsList.clear();
      if (kDebugMode) {
        print(errorMessage);
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to refresh the list
  Future<void> refresh() => loadInstalledApps();

  // Method to clear everything
  void clearData() {
    _installedAppsList.clear();
    errorMessage = null;
    notifyListeners();
  }
}
