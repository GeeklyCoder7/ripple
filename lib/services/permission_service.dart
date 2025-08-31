import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/permission_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionService {
  // Check if the permission was requested before
  Future<bool> wasPermissionRequested(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('${key}_requested') ?? false;
  }

  // Mark the permission as requested
  Future<void> markPermissionRequested(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${key}_requested', true);
  }

  // Get stored permission status
  Future<AppPermissionStatus> getStoredPermissionStatus(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final statusString = prefs.getString(key);
    if (statusString == null) return AppPermissionStatus.notDetermined;

    return AppPermissionStatus.values.firstWhere(
      (status) => status.name == statusString,
      orElse: () => AppPermissionStatus.notDetermined,
    );
  }

  // Store the permission status
  Future<void> storePermissionStatus(
    String key,
    AppPermissionStatus status,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, status.name);
  }

  // Check current runtime permission status
  Future<AppPermissionStatus> getCurrentPermissionStatus(
    Permission permission,
  ) async {
    final status = await permission.status;

    switch (status) {
      case PermissionStatus.granted:
        return AppPermissionStatus.granted;
      case PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return AppPermissionStatus.restricted;
      case PermissionStatus.limited:
        return AppPermissionStatus.granted;
      case PermissionStatus.provisional:
        return AppPermissionStatus.granted;
    }
  }

  // Request the permission
  Future<AppPermissionStatus> requestPermission(
    Permission
    permission, // Will be used to perform methods like request(), getCurrentPermissionStatus(), etc.
    String key, // Used for saving permission status in shared preference
  ) async {
    await markPermissionRequested(key); // Mark as requested for future checks
    final status = await permission.request(); // Request the permission
    final permissionStatus = await getCurrentPermissionStatus(permission);
    await storePermissionStatus(key, permissionStatus);
    return permissionStatus;
  }

  // Get all storage permissions (not location) status based on android version
  Future<Map<String, AppPermissionStatus>> checkAllStoragePermissions() async {
    final Map<String, AppPermissionStatus> results = {};

    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      if (androidVersion >= 33) {
        // Request granular permissions
        results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
            await getCurrentPermissionStatus(Permission.photos);
        results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
            await getCurrentPermissionStatus(Permission.videos);
        results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
            await getCurrentPermissionStatus(Permission.audio);
        results[AppConstants.PERMISSION_STORAGE_KEY] = AppPermissionStatus
            .granted; // No need to request storage for android 13 and above
      } else {
        // Request broad storage permissions
        results[AppConstants.PERMISSION_STORAGE_KEY] =
            await getCurrentPermissionStatus(Permission.storage);
        // On version above 13, only storage request is required and all others come withing that permission
        results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
            results[AppConstants.PERMISSION_STORAGE_KEY]!;
        results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
            results[AppConstants.PERMISSION_STORAGE_KEY]!;
        results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
            results[AppConstants.PERMISSION_STORAGE_KEY]!;
      }
    } else if (Platform.isIOS) {
      // IOS just needs the Photos permission
      results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
          await getCurrentPermissionStatus(Permission.photos);
      // Other media like videos and audio come along with images
      results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
          results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY]!;
      results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
          results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY]!;
      results[AppConstants.PERMISSION_STORAGE_KEY] =
          AppPermissionStatus.granted; // No need for storage permission on IOS
    }
    return results;
  }

  // Request just the storage permissions (not location) based on the Android version
  Future<Map<String, AppPermissionStatus>> requestStoragePermissions() async {
    final Map<String, AppPermissionStatus> results = {};

    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();

      if (androidVersion >= 33) {
        // If version is >=33 request granular permissions
        results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
            await requestPermission(
              Permission.photos,
              AppConstants.PERMISSION_MEDIA_IMAGES_KEY,
            );
        results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
            await requestPermission(
              Permission.videos,
              AppConstants.PERMISSION_MEDIA_VIDEOS_KEY,
            );
        results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
            await requestPermission(
              Permission.audio,
              AppConstants.PERMISSION_MEDIA_AUDIOS_KEY,
            );
        results[AppConstants.PERMISSION_STORAGE_KEY] = AppPermissionStatus
            .granted; // No need to ask for storage permission for version 13 and above
      } else {
        // Else request broad storage permissions (only storage permission required)
        results[AppConstants.PERMISSION_STORAGE_KEY] = await requestPermission(
          Permission.storage,
          AppConstants.PERMISSION_STORAGE_KEY,
        );
        // Others are not required as they come along with the storage
        results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
            results[AppConstants.PERMISSION_STORAGE_KEY]!;
        results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
            results[AppConstants.PERMISSION_STORAGE_KEY]!;
        results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
            results[AppConstants.PERMISSION_STORAGE_KEY]!;
      }
    } else if (Platform.isIOS) {
      // Only request photos and other media like videos and audio come along with it
      results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
          await requestPermission(
            Permission.photos,
            AppConstants.PERMISSION_MEDIA_IMAGES_KEY,
          );
      results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
          results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY]!;
      results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
          results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY]!;
      // Doesn't need to request the storage permission
      results[AppConstants.PERMISSION_STORAGE_KEY] =
          AppPermissionStatus.granted;
    }
    return results;
  }

  // Check location permission
  Future<AppPermissionStatus> checkLocationPermission() async {
    return await getCurrentPermissionStatus(Permission.location);
  }

  // Request location permission
  Future<AppPermissionStatus> requestLocationPermission() async {
    return await requestPermission(
      Permission.location,
      AppConstants.PERMISSION_LOCATION_KEY,
    );
  }

  // Check whether all required permissions are granted
  Future<bool> areAllPermissionsGranted() async {
    final storagePermissions = await checkAllStoragePermissions();
    final locationPermission = await checkLocationPermission();

    return storagePermissions.values.every((status) => status.isGranted) &&
        locationPermission.isGranted;
  }

  // Open app settings for manually giving the permission
  Future<bool> navigateToAppSettings() async {
    return await openAppSettings();
  }

  // Helper method to find the android version of the device
  Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      try {
        final photoStatus = await Permission.photos.status;
        return 33; // If we can check photos status we are on version 13+
      } catch (e) {
        return 29; // If some error occurs while checking the status, we are below version 13.
      }
    }
    return 0;
  }
}