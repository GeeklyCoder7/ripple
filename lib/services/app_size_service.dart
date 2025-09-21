import 'package:flutter/services.dart';

/// This is a seprate service class just for getting the apk size
/// since it requires communicating with the native kotlin code

class AppSizeService {
  static const MethodChannel _channel = MethodChannel('app_size_channel');

  // Gets the APK file size fo the installed apps by package name through native kotlin code
  static Future<int?> getApkFileSize(String packageName) async {
    try {
      final result = await _channel.invokeMethod('getApkFileSize', {
        'packageName': packageName,
      });

      // Converting Long from Kotlin to int in Dart
      return result?.toInt();
    } on PlatformException catch (e) {
      // Handling specific exception : PlatformException
      print('Error getting APK file size for $packageName: ${e.message}');
      return null;
    } catch (e) {
      // Handling other exceptions
      print('Unexpected error getting APK file size for $packageName: $e');
      return null;
    }
  }

  // Gets APK file sizes for multiple packages and returns a Map with packageName as key and size as it's value
  static Future<Map<String, int>> getMultipleApkFileSizes(
    List<String> packageNames,
  ) async {
    final Map<String, int> results = {};

    for (String packageName in packageNames) {
      final size = await getApkFileSize(packageName);
      if (size != null) {
        results[packageName] = size;
      }
    }

    return results;
  }
}
