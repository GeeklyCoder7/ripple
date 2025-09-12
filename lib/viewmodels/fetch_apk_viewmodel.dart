import 'package:flutter/foundation.dart';
import 'package:ripple/models/apk_item.dart';
import 'package:ripple/services/fetch_apk_service.dart';

class FetchApkViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<ApkItem> installedAppsList = [];
  String? errorMessage;
  final FetchApkService _fetchApkService = FetchApkService();

  // Getters for readonly access
  List<ApkItem> get installedApps => List.unmodifiable(installedAppsList);
  bool get hasError => errorMessage != null;
  bool get hasData => installedAppsList.isNotEmpty;

  // Method to fetch and load installed apps
  Future<void> loadInstalledApps() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      installedAppsList.clear();
      installedAppsList = await _fetchApkService.fetchInstalledApps(includeIcons: true); // fetch installed apps using service class
    } catch (e) {
      errorMessage = 'Failed to load installed apps through fetch apk view model: $e';
      installedAppsList.clear();
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
    installedAppsList.clear();
    errorMessage = null;
    notifyListeners();
  }
}