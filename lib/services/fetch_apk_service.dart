import 'dart:typed_data'; // ✅ Correct import

import 'package:device_apps/device_apps.dart';
import 'package:flutter/foundation.dart';

import '../models/apk_item.dart';

class FetchApkService {
  // Method to fetch the installed apps
  Future<List<ApkItem>> fetchInstalledApps({bool includeIcons = true}) async {
    List<ApkItem> installedApps = [];
    try {
      List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: includeIcons,
        includeSystemApps: false,
      );
      installedApps = apps.map((app) {
        Uint8List? iconBytes;

        // Extracting icon if available
        if (includeIcons && app is ApplicationWithIcon) {
          iconBytes = app.icon;
        }
        return ApkItem.fromInstalled(
          appLabel: app.appName,
          packageName: app.packageName,
          versionName: app.versionName ?? '',
          versionCode: app.versionCode ?? 0,
          iconBytes: iconBytes,
        );
      }).toList();
      return installedApps;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching installed apps through service class: $e');
      }
      return installedApps;
    }
  }
}
