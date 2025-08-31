import 'package:flutter/foundation.dart';
import 'package:ripple/core/constants/app_constants.dart';
import 'package:ripple/models/permission_status.dart';
import 'package:ripple/services/permission_service.dart';

class PermissionViewModel extends ChangeNotifier {
  final PermissionService permissionService = PermissionService();

  // Set all permissions as 'notDetermined' for the first time
  AppPermissionStatus _storagePermission = AppPermissionStatus.notDetermined;
  AppPermissionStatus _mediaImagesPermission =
      AppPermissionStatus.notDetermined;
  AppPermissionStatus _mediaVideosPermission =
      AppPermissionStatus.notDetermined;
  AppPermissionStatus _mediaAudiosPermission =
      AppPermissionStatus.notDetermined;
  AppPermissionStatus _locationPermission = AppPermissionStatus.notDetermined;

  // Variables to manage loading states
  bool _isCheckingPermission = false;
  bool _isRequestingPermission = false;

  // Getters
  AppPermissionStatus get storagePermission => _storagePermission;
  AppPermissionStatus get mediaImagesPermission => _mediaImagesPermission;
  AppPermissionStatus get mediaVideosPermission => _mediaVideosPermission;
  AppPermissionStatus get mediaAudioPermission => _mediaAudiosPermission;
  AppPermissionStatus get locationPermission => _locationPermission;

  bool get isCheckingPermission => _isCheckingPermission;
  bool get isRequestingPermission => _isRequestingPermission;

  // Check if all required permissions are granted
  bool get areAllPermissionsGranted {
    return _storagePermission.isGranted &&
        _mediaImagesPermission.isGranted &&
        _mediaVideosPermission.isGranted &&
        _mediaAudiosPermission.isGranted &&
        _locationPermission.isGranted;
  }

  // Check if any of the permission is permanently denied
  bool get isAnyPermissionPermanentlyDenied {
    return _storagePermission.isPermanentlyDenied ||
        _mediaImagesPermission.isPermanentlyDenied ||
        _mediaVideosPermission.isPermanentlyDenied ||
        _mediaAudiosPermission.isPermanentlyDenied ||
        _locationPermission.isPermanentlyDenied;
  }

  // Check if permissions need to be requested
  bool get needsPermissionRequest {
    return _storagePermission.needsRequest ||
        _mediaImagesPermission.needsRequest ||
        _mediaVideosPermission.needsSettings ||
        _mediaAudiosPermission.needsRequest ||
        _locationPermission.needsRequest;
  }

  // Check if any permission was previously requested
  bool get werePermissionsPreviouslyRequested {
    return _storagePermission != AppPermissionStatus.notDetermined ||
        _mediaImagesPermission != AppPermissionStatus.notDetermined ||
        _mediaVideosPermission != AppPermissionStatus.notDetermined ||
        _mediaAudiosPermission != AppPermissionStatus.notDetermined ||
        _locationPermission != AppPermissionStatus.notDetermined;
  }

  // Initialize and check current permission states
  Future<void> initializePermissions() async {
    _isCheckingPermission = true;
    notifyListeners();

    try {
      await _loadStoredPermissions();
      await _checkCurrentPermissions();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing permissions: $e');
      }
    } finally {
      _isCheckingPermission = false;
      notifyListeners();
    }
  }

  // Load stored permission states from shared preferences
  Future<void> _loadStoredPermissions() async {
    _storagePermission = await permissionService.getStoredPermissionStatus(
      AppConstants.PERMISSION_STORAGE_KEY,
    );
    _mediaImagesPermission = await permissionService.getStoredPermissionStatus(
      AppConstants.PERMISSION_MEDIA_IMAGES_KEY,
    );
    _mediaVideosPermission = await permissionService.getStoredPermissionStatus(
      AppConstants.PERMISSION_MEDIA_VIDEOS_KEY,
    );
    _mediaAudiosPermission = await permissionService.getStoredPermissionStatus(
      AppConstants.PERMISSION_MEDIA_AUDIOS_KEY,
    );
    _locationPermission = await permissionService.getStoredPermissionStatus(
      AppConstants.PERMISSION_LOCATION_KEY,
    );
  }

  // Check current runtime permission states
  Future<void> _checkCurrentPermissions() async {
    final storagePermissions = await permissionService
        .checkAllStoragePermissions();
    final locationPermission = await permissionService
        .checkLocationPermission();

    _storagePermission =
        storagePermissions[AppConstants.PERMISSION_STORAGE_KEY] ??
        AppPermissionStatus.notDetermined;
    _mediaImagesPermission =
        storagePermissions[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] ??
        AppPermissionStatus.notDetermined;
    _mediaVideosPermission =
        storagePermissions[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] ??
        AppPermissionStatus.notDetermined;
    _mediaAudiosPermission =
        storagePermissions[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] ??
        AppPermissionStatus.notDetermined;
    _locationPermission = locationPermission;
  }

  // Request all permissions
  Future<Map<String, AppPermissionStatus>> requestAllPermissions() async {
    _isRequestingPermission = false;
    notifyListeners();

    try {
      final allStoragePermissionsResult = await permissionService
          .requestStoragePermissions();
      final locationPermissionResult = await permissionService
          .requestLocationPermission();

      // Store permissions locally for state management
      _storagePermission =
          allStoragePermissionsResult[AppConstants.PERMISSION_STORAGE_KEY] ??
          AppPermissionStatus.notDetermined;
      _mediaImagesPermission =
          allStoragePermissionsResult[AppConstants
              .PERMISSION_MEDIA_IMAGES_KEY] ??
          AppPermissionStatus.notDetermined;
      _mediaVideosPermission =
          allStoragePermissionsResult[AppConstants
              .PERMISSION_MEDIA_VIDEOS_KEY] ??
          AppPermissionStatus.notDetermined;
      _mediaAudiosPermission =
          allStoragePermissionsResult[AppConstants
              .PERMISSION_MEDIA_AUDIOS_KEY] ??
          AppPermissionStatus.notDetermined;
      _locationPermission = locationPermissionResult;

      // Combine all permissions result
      final allResults = Map<String, AppPermissionStatus>.from(
        allStoragePermissionsResult,
      );
      allResults[AppConstants.PERMISSION_LOCATION_KEY] =
          locationPermissionResult;

      notifyListeners();
      return allResults;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting permissions: $e');
      }
      return {};
    } finally {
      _isRequestingPermission = false;
      notifyListeners();
    }
  }

  // Request specific permissions
  Future<AppPermissionStatus> requestSpecificPermissions(
    String permissionKey,
  ) async {
    _isRequestingPermission = true;
    notifyListeners();

    try {
      AppPermissionStatus specificPermissionStatus =
          AppPermissionStatus.notDetermined; // Initialize with default

      switch (permissionKey) {
        case AppConstants.PERMISSION_STORAGE_KEY:
        case AppConstants.PERMISSION_MEDIA_IMAGES_KEY:
        case AppConstants.PERMISSION_MEDIA_VIDEOS_KEY:
        case AppConstants.PERMISSION_MEDIA_AUDIOS_KEY:
          final allPermissionsResult = await permissionService
              .requestStoragePermissions();
          // Update states locally too
          _storagePermission =
              allPermissionsResult[AppConstants.PERMISSION_STORAGE_KEY] ??
              AppPermissionStatus.notDetermined;
          _mediaImagesPermission =
              allPermissionsResult[AppConstants.PERMISSION_MEDIA_IMAGES_KEY] ??
              AppPermissionStatus.notDetermined;
          _mediaVideosPermission =
              allPermissionsResult[AppConstants.PERMISSION_MEDIA_VIDEOS_KEY] ??
              AppPermissionStatus.notDetermined;
          _mediaAudiosPermission =
              allPermissionsResult[AppConstants.PERMISSION_MEDIA_AUDIOS_KEY] ??
              AppPermissionStatus.notDetermined;
          specificPermissionStatus =
              allPermissionsResult[permissionKey] ??
              AppPermissionStatus.notDetermined;
          break;
        case AppConstants.PERMISSION_LOCATION_KEY:
          specificPermissionStatus = await permissionService
              .requestLocationPermission();
          _locationPermission = specificPermissionStatus;
          break;
        default:
          specificPermissionStatus = AppPermissionStatus.notDetermined;
      }
      notifyListeners();
      return specificPermissionStatus;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting the specified permission: $e');
      }
      return AppPermissionStatus.notDetermined;
    } finally {
      _isRequestingPermission = false;
      notifyListeners();
    }
  }

  // Open the app settings
  Future<bool> openAppSettings() async {
    return await permissionService.navigateToAppSettings();
  }

  // Refresh the permission states
  Future<void> refreshPermissionStates() async {
    await _checkCurrentPermissions();
    notifyListeners();
  }

  // Check if any permission is granted
  bool isPermissionGranted(String permissionKey) {
    switch (permissionKey) {
      case AppConstants.PERMISSION_STORAGE_KEY:
        return _storagePermission.isGranted;
      case AppConstants.PERMISSION_MEDIA_IMAGES_KEY:
        return _mediaImagesPermission.isGranted;
      case AppConstants.PERMISSION_MEDIA_VIDEOS_KEY:
        return _mediaVideosPermission.isGranted;
      case AppConstants.PERMISSION_MEDIA_AUDIOS_KEY:
        return _mediaAudiosPermission.isGranted;
      case AppConstants.PERMISSION_LOCATION_KEY:
        return _locationPermission.isGranted;
      default:
        return false;
    }
  }

  // Get permission status for specific permissions
  AppPermissionStatus getPermissionStatus(String permissionKey) {
    switch (permissionKey) {
      case AppConstants.PERMISSION_STORAGE_KEY:
        return _storagePermission;
      case AppConstants.PERMISSION_MEDIA_IMAGES_KEY:
        return _mediaImagesPermission;
      case AppConstants.PERMISSION_MEDIA_VIDEOS_KEY:
        return _mediaVideosPermission;
      case AppConstants.PERMISSION_MEDIA_AUDIOS_KEY:
        return _mediaAudiosPermission;
      case AppConstants.PERMISSION_LOCATION_KEY:
        return _locationPermission;
      default:
        return AppPermissionStatus.notDetermined;
    }
  }
}
