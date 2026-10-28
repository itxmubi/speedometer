import '../error/result.dart';
import 'native_location_fix.dart';

/// Device capabilities isolated from application and feature logic.
abstract interface class DeviceServices {
  /// Applies activity-local display preferences; -1 restores system brightness.
  Future<Result<void>> applyDisplay({
    required bool keepAwake,
    required double brightness,
  });

  /// Plays optional alert outputs without taking music audio focus.
  Future<Result<void>> emitAlert({
    required bool sound,
    required bool vibration,
    required bool voice,
    required double volume,
    required String message,
    required String languageTag,
  });

  /// Emits display-adjusted magnetic headings, or unsupported on absent sensors.
  Stream<Result<double>> watchCompass();

  /// Updates the notification, optional overlay and home-screen widgets.
  Future<Result<void>> updateTrackingDisplay({
    required double? speedMetersPerSecond,
    required double displaySpeed,
    required String unit,
    required bool overLimit,
    required String status,
    required String notificationTitle,
    required String stopLabel,
  });

  /// Shows an overlay only while tracking and with previously granted permission.
  Future<Result<void>> setOverlayEnabled(bool enabled);

  /// Checks the special overlay grant without displaying system UI.
  Future<Result<bool>> canDrawOverlays();

  /// Opens the special grant screen after the app explains the permission.
  Future<Result<void>> requestOverlayPermission();

  /// Starts foreground GPS after an explicit user action and location permission.
  Future<Result<void>> startTracking();

  /// Chooses a 1–3 second GPS interval without changing permission or starting GPS.
  Future<Result<void>> setGpsInterval(Duration interval);

  /// Stops GPS and clears all active service, overlay and display resources.
  Future<Result<void>> stopTracking();

  /// Native Doppler fixes; subscribing alone never starts location collection.
  Stream<Result<NativeLocationFix>> watchLocation();

  /// Reports service state, including Stop from the persistent notification.
  Stream<bool> watchTrackingStatus();

  /// Checks the running service without starting one.
  Future<Result<bool>> isTracking();

  /// Releases native resources when the owning application scope ends.
  Future<Result<void>> dispose();
}
