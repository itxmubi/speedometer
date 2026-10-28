import '../../../../core/error/result.dart';
import '../entities/display_preferences.dart';
import '../entities/tracking_display.dart';

/// Platform-independent device outputs and optional hardware inputs.
abstract interface class DeviceRepository {
  Future<Result<void>> applySettings(
    DisplayPreferences preferences, {
    required bool awake,
  });
  Future<Result<void>> alert(
    DisplayPreferences preferences, {
    required String message,
    required String languageTag,
  });
  Future<Result<void>> update(TrackingDisplay display);
  Stream<Result<double>> compass();
  Future<Result<bool>> canOverlay();
  Future<Result<void>> setOverlay(bool enabled);
  Future<Result<void>> requestOverlay();
  Stream<bool> trackingStatus();
  Future<Result<bool>> isTracking();
  Future<Result<void>> dispose();
}
