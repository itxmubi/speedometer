import 'package:geolocator/geolocator.dart';

import 'location_data_source.dart';

/// The sole adapter that invokes the geolocator plugin.
final class GeolocatorLocationDataSource implements LocationDataSource {
  /// Creates the stateless platform adapter.
  const GeolocatorLocationDataSource();

  static const Duration _updateInterval = Duration(seconds: 1);

  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Stream<Position> watchPositions() => Geolocator.getPositionStream(
    // No foregroundNotificationConfig: this milestone stops on background.
    locationSettings: AndroidSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      intervalDuration: _updateInterval,
    ),
  );

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();
}
