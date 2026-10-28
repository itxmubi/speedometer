import '../../../../core/error/result.dart';
import '../../../../core/platform/device_services.dart';
import '../../domain/entities/display_preferences.dart';
import '../../domain/entities/tracking_display.dart';
import '../../domain/repositories/device_repository.dart';

/// Maps domain requests to the native device boundary.
final class PlatformDeviceRepository implements DeviceRepository {
  const PlatformDeviceRepository(this._services);
  final DeviceServices _services;
  @override
  Future<Result<void>> applySettings(
    DisplayPreferences preferences, {
    required bool awake,
  }) async {
    final result = await _services.applyDisplay(
      keepAwake: awake && preferences.keepAwake,
      brightness: awake ? preferences.brightness : -1,
    );
    final intervalResult = await _services.setGpsInterval(
      Duration(seconds: preferences.economyGps ? 3 : 1),
    );
    return result is Error<void> ? result : intervalResult;
  }

  @override
  Future<Result<void>> alert(
    DisplayPreferences preferences, {
    required String message,
    required String languageTag,
  }) => _services.emitAlert(
    sound: preferences.soundAlert,
    vibration: preferences.vibrationAlert,
    voice: preferences.voiceAlert,
    volume: preferences.alertVolume,
    message: message,
    languageTag: languageTag,
  );
  @override
  Future<Result<void>> update(TrackingDisplay display) =>
      _services.updateTrackingDisplay(
        speedMetersPerSecond: display.speedMetersPerSecond,
        displaySpeed: display.displaySpeed,
        unit: display.unit,
        overLimit: display.overLimit,
        status: display.status,
        notificationTitle: display.notificationTitle,
        stopLabel: display.stopLabel,
      );
  @override
  Stream<Result<double>> compass() => _services.watchCompass();
  @override
  Future<Result<bool>> canOverlay() => _services.canDrawOverlays();
  @override
  Future<Result<void>> setOverlay(bool enabled) =>
      _services.setOverlayEnabled(enabled);
  @override
  Future<Result<void>> requestOverlay() => _services.requestOverlayPermission();
  @override
  Stream<bool> trackingStatus() => _services.watchTrackingStatus();
  @override
  Future<Result<bool>> isTracking() => _services.isTracking();
  @override
  Future<Result<void>> dispose() => _services.dispose();
}
