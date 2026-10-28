import 'package:geolocator/geolocator.dart';

/// The plugin boundary; tests substitute a fake without native GPS calls.
abstract interface class LocationDataSource {
  /// Checks whether the device's location service is available.
  Future<bool> isLocationServiceEnabled();

  /// Reads the current platform permission without displaying a dialog.
  Future<LocationPermission> checkPermission();

  /// Requests only the location permission configured for this application.
  Future<LocationPermission> requestPermission();

  /// Streams raw plugin fixes using foreground-only location settings.
  Stream<Position> watchPositions();

  /// Opens this app's permission settings.
  Future<bool> openAppSettings();

  /// Opens device location settings.
  Future<bool> openLocationSettings();
}
