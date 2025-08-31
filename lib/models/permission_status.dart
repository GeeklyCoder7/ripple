enum AppPermissionStatus {
  granted,
  denied,
  notDetermined,
  permanentlyDenied,
  restricted,
}

extension PermissionStatusExtension on AppPermissionStatus {
  bool get isGranted => this == AppPermissionStatus.granted;
  bool get isDenied => this == AppPermissionStatus.denied;
  bool get isPermanentlyDenied => this == AppPermissionStatus.permanentlyDenied;
  bool get needsRequest => this == AppPermissionStatus.notDetermined;
  bool get needsSettings => this == AppPermissionStatus.permanentlyDenied;

  String get displayName {
    switch (this) {
      case AppPermissionStatus.granted:
        return 'Granted';
      case AppPermissionStatus.denied:
        return 'Denied';
      case AppPermissionStatus.notDetermined:
        return 'Not Determined';
      case AppPermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
      case AppPermissionStatus.restricted:
        return 'Restricted';
    }
  }
}