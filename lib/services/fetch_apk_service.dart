import 'dart:typed_data';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/foundation.dart';

import '../models/apk_item.dart';

class FetchApkService {
  /// Fetches basic information about installed apps as raw data
  /// This method returns Map data instead of ApkItem objects since
  /// ApkItem creation is now async and requires APK size fetching
  Future<List<Map<String, dynamic>>> fetchInstalledAppsInfo({
    bool includeIcons = true,
    bool includeSystemApps = false,
  }) async {
    List<Map<String, dynamic>> appInfoList = [];

    try {
      List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: includeIcons,
        includeSystemApps: includeSystemApps,
        onlyAppsWithLaunchIntent: true, // Only get apps that can be launched
      );

      // Convert each app to a Map with all necessary information
      for (Application app in apps) {
        Uint8List? iconBytes;

        // Extract icon if available and requested
        if (includeIcons && app is ApplicationWithIcon) {
          iconBytes = app.icon;
        }

        Map<String, dynamic> appInfo = {
          'appLabel': app.appName,
          'packageName': app.packageName,
          'versionName': app.versionName ?? '',
          'versionCode': app.versionCode ?? 0,
          'iconBytes': iconBytes,
          // You can add more fields here if needed
          'installTime': app is ApplicationWithIcon
              ? (app as ApplicationWithIcon).installTimeMillis
              : null,
          'updateTime': app is ApplicationWithIcon
              ? (app as ApplicationWithIcon).updateTimeMillis
              : null,
        };

        appInfoList.add(appInfo);
      }

      // Sort apps alphabetically by name for better UX
      appInfoList.sort(
        (a, b) => (a['appLabel'] as String).toLowerCase().compareTo(
          (b['appLabel'] as String).toLowerCase(),
        ),
      );

      return appInfoList;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching installed apps info through service class: $e');
      }
      throw Exception('Failed to fetch installed apps info: $e');
    }
  }

  /// Updated method that creates ApkItem objects with APK sizes
  /// This method is async and processes each app individually
  Future<List<ApkItem>> fetchInstalledApps({
    bool includeIcons = true,
    bool includeSystemApps = false,
  }) async {
    try {
      // First get the raw app information
      List<Map<String, dynamic>> appInfoList = await fetchInstalledAppsInfo(
        includeIcons: includeIcons,
        includeSystemApps: includeSystemApps,
      );

      // Create ApkItem objects asynchronously
      List<ApkItem> installedApps = [];

      for (Map<String, dynamic> appInfo in appInfoList) {
        try {
          // Use the new async factory method
          final apkItem = await ApkItem.createFromInstalled(
            appLabel: appInfo['appLabel'] ?? 'Unknown App',
            packageName: appInfo['packageName'] ?? '',
            versionName: appInfo['versionName'] ?? '',
            versionCode: appInfo['versionCode'] ?? 0,
            iconBytes: appInfo['iconBytes'],
          );

          installedApps.add(apkItem);
        } catch (e) {
          if (kDebugMode) {
            print('Error creating ApkItem for ${appInfo['packageName']}: $e');
          }
          // Continue with other apps even if one fails
        }
      }

      return installedApps;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching installed apps through service class: $e');
      }
      return [];
    }
  }

  /// Batch processing method for better performance
  /// Processes apps in batches to avoid blocking the UI thread
  Future<List<ApkItem>> fetchInstalledAppsBatch({
    bool includeIcons = true,
    bool includeSystemApps = false,
    int batchSize = 10,
    Function(int loaded, int total)? onProgress,
  }) async {
    try {
      // Get raw app information
      List<Map<String, dynamic>> appInfoList = await fetchInstalledAppsInfo(
        includeIcons: includeIcons,
        includeSystemApps: includeSystemApps,
      );

      List<ApkItem> allApkItems = [];
      int totalApps = appInfoList.length;
      int processedApps = 0;

      // Process apps in batches
      for (int i = 0; i < appInfoList.length; i += batchSize) {
        int end = (i + batchSize < appInfoList.length)
            ? i + batchSize
            : appInfoList.length;
        List<Map<String, dynamic>> batch = appInfoList.sublist(i, end);

        // Process batch concurrently
        List<Future<ApkItem?>> futures = batch.map((appInfo) async {
          try {
            return await ApkItem.createFromInstalled(
              appLabel: appInfo['appLabel'] ?? 'Unknown App',
              packageName: appInfo['packageName'] ?? '',
              versionName: appInfo['versionName'] ?? '',
              versionCode: appInfo['versionCode'] ?? 0,
              iconBytes: appInfo['iconBytes'],
            );
          } catch (e) {
            if (kDebugMode) {
              print('Error creating ApkItem for ${appInfo['packageName']}: $e');
            }
            return null;
          }
        }).toList();

        // Wait for batch to complete
        List<ApkItem?> batchResults = await Future.wait(futures);

        // Add successful results
        for (ApkItem? item in batchResults) {
          if (item != null) {
            allApkItems.add(item);
          }
        }

        // Update progress
        processedApps += batch.length;
        onProgress?.call(processedApps, totalApps);
      }

      return allApkItems;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching installed apps in batches: $e');
      }
      return [];
    }
  }

  /// Get specific app information by package name
  Future<Map<String, dynamic>?> getAppInfo(
    String packageName, {
    bool includeIcon = true,
  }) async {
    try {
      Application? app = await DeviceApps.getApp(packageName, includeIcon);

      if (app == null) return null;

      Uint8List? iconBytes;
      if (includeIcon && app is ApplicationWithIcon) {
        iconBytes = app.icon;
      }

      return {
        'appLabel': app.appName,
        'packageName': app.packageName,
        'versionName': app.versionName ?? '',
        'versionCode': app.versionCode ?? 0,
        'iconBytes': iconBytes,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting app info for $packageName: $e');
      }
      return null;
    }
  }

  /// Create single ApkItem by package name
  Future<ApkItem?> getApkItem(
    String packageName, {
    bool includeIcon = true,
  }) async {
    try {
      final appInfo = await getAppInfo(packageName, includeIcon: includeIcon);
      if (appInfo == null) return null;

      return await ApkItem.createFromInstalled(
        appLabel: appInfo['appLabel'] ?? 'Unknown App',
        packageName: appInfo['packageName'] ?? '',
        versionName: appInfo['versionName'] ?? '',
        versionCode: appInfo['versionCode'] ?? 0,
        iconBytes: appInfo['iconBytes'],
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error creating ApkItem for $packageName: $e');
      }
      return null;
    }
  }
}
