import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
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
    Map<String, AppPermissionStatus> results = {};

    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final int androidVersion = int.parse(androidInfo.version.release);

      if (androidVersion >= 13) {
        // Check Android 13+ permissions
        results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
            _convertToAppPermissionStatus(await Permission.photos.status);
        results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
            _convertToAppPermissionStatus(await Permission.videos.status);
        results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
            _convertToAppPermissionStatus(await Permission.audio.status);
        results[AppConstants.PERMISSION_STORAGE_KEY] =
            _convertToAppPermissionStatus(
              await Permission.manageExternalStorage.status,
            );
      } else {
        // Check Android 12 and below
        AppPermissionStatus storageStatus = _convertToAppPermissionStatus(
          await Permission.storage.status,
        );
        results[AppConstants.PERMISSION_STORAGE_KEY] = storageStatus;
        results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] = storageStatus;
        results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] = storageStatus;
        results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] = storageStatus;
      }
    } else {
      // iOS
      results[AppConstants.PERMISSION_STORAGE_KEY] =
          AppPermissionStatus.granted;
      results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
          AppPermissionStatus.granted;
      results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
          AppPermissionStatus.granted;
      results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
          AppPermissionStatus.granted;
    }

    return results;
  }

  Future<Map<String, AppPermissionStatus>> requestStoragePermissions() async {
    Map<String, AppPermissionStatus> results = {};

    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final int androidVersion = int.parse(androidInfo.version.release);

      if (androidVersion >= 13) {
        // Android 13+ granular permissions
        Map<Permission, PermissionStatus> statuses = await [
          Permission.photos,
          Permission.videos,
          Permission.audio,
          Permission.manageExternalStorage,
        ].request();

        // Convert to your custom AppPermissionStatus
        results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
            _convertToAppPermissionStatus(statuses[Permission.photos]!);
        results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
            _convertToAppPermissionStatus(statuses[Permission.videos]!);
        results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
            _convertToAppPermissionStatus(statuses[Permission.audio]!);
        results[AppConstants.PERMISSION_STORAGE_KEY] =
            _convertToAppPermissionStatus(
              statuses[Permission.manageExternalStorage]!,
            );
      } else {
        // Android 12 and below
        PermissionStatus storageStatus = await Permission.storage.request();
        AppPermissionStatus appStatus = _convertToAppPermissionStatus(
          storageStatus,
        );

        // Set all storage-related permissions to the same status for older Android
        results[AppConstants.PERMISSION_STORAGE_KEY] = appStatus;
        results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] = appStatus;
        results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] = appStatus;
        results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] = appStatus;
      }
    } else {
      // iOS - set all as granted (iOS doesn't need explicit storage permissions)
      results[AppConstants.PERMISSION_STORAGE_KEY] =
          AppPermissionStatus.granted;
      results[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] =
          AppPermissionStatus.granted;
      results[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] =
          AppPermissionStatus.granted;
      results[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] =
          AppPermissionStatus.granted;
    }
    return results;
  }

  // Helper method to convert PermissionStatus to AppPermissionStatus
  AppPermissionStatus _convertToAppPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return AppPermissionStatus.granted;
      case PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return AppPermissionStatus.denied; // Treat restricted as denied
      default:
        return AppPermissionStatus.notDetermined;
    }
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
}
