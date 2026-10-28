import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../../../../core/platform/device_services.dart';
import '../../../../core/platform/native_location_fix.dart';
import 'location_data_source.dart';

/// Reuses geolocator permission checks with user-started native foreground GPS.
final class NativeLocationDataSource implements LocationDataSource {
  const NativeLocationDataSource(this._services, this._permissions);
  final DeviceServices _services;
  final LocationDataSource _permissions;
  @override
  Future<bool> isLocationServiceEnabled() =>
      _permissions.isLocationServiceEnabled();
  @override
  Future<LocationPermission> checkPermission() =>
      _permissions.checkPermission();
  @override
  Future<LocationPermission> requestPermission() =>
      _permissions.requestPermission();
  @override
  Future<bool> openAppSettings() => _permissions.openAppSettings();
  @override
  Future<bool> openLocationSettings() => _permissions.openLocationSettings();
  @override
  Stream<Position> watchPositions() {
    StreamSubscription<Result<NativeLocationFix>>? subscription;
    var cancelled = false;
    Future<Result<void>>? starting;
    late final StreamController<Position> controller;
    controller = StreamController<Position>(
      onListen: () async {
        subscription = _services.watchLocation().listen(
          (event) {
            if (cancelled) return;
            switch (event) {
              case Success(:final value):
                controller.add(_position(value));
              case Error(:final failure):
                controller.addError(_exception(failure));
            }
          },
          onError: (Object error, StackTrace stack) {
            if (!cancelled) {
              controller.addError(
                const PositionUpdateException('native_stream'),
              );
            }
          },
        );
        final startup = _services.startTracking();
        starting = startup;
        final result = await startup;
        if (cancelled) return;
        if (result case Error(:final failure)) {
          controller.addError(_exception(failure));
        }
      },
      onCancel: () async {
        cancelled = true;
        await subscription?.cancel();
        await _services.stopTracking();
        // Cancellation owns pending startup too. A later session must never be
        // stopped by the completion of an older start request.
        await starting;
      },
    );
    return controller.stream;
  }

  Object _exception(Failure failure) => switch (failure.kind) {
    FailureKind.permissionDenied || FailureKind.permissionDeniedForever =>
      PermissionDeniedException('native_permission'),
    FailureKind.locationDisabled => const LocationServiceDisabledException(),
    FailureKind.unsupported => UnsupportedError('native_location'),
    _ => const PositionUpdateException('native_location'),
  };
  Position _position(NativeLocationFix fix) => Position(
    latitude: fix.latitude,
    longitude: fix.longitude,
    timestamp: fix.timestamp,
    accuracy: fix.accuracyMeters,
    altitude: fix.altitudeMeters,
    altitudeAccuracy: fix.altitudeAccuracyMeters,
    heading: fix.headingDegrees,
    headingAccuracy: fix.headingAccuracyDegrees,
    speed: fix.speedMetersPerSecond,
    speedAccuracy: fix.speedAccuracyMetersPerSecond,
    isMocked: fix.isMocked,
    hasSpeed: fix.hasSpeed,
    hasAccuracy: fix.hasAccuracy,
    hasAltitude: fix.hasAltitude,
    hasHeading: fix.hasHeading,
    hasSpeedAccuracy: fix.hasSpeedAccuracy,
  );
}
