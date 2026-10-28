import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/tracking_display.dart';
import 'package:speedometer/features/speedometer/domain/repositories/device_repository.dart';

/// No hardware, timers, audio, permissions or GPS in controller/widget tests.
class FakeDeviceRepository implements DeviceRepository {
  int alertCalls = 0;
  bool overlayGranted = false;
  bool overlayEnabled = false;
  @override
  Future<Result<void>> applySettings(
    DisplayPreferences preferences, {
    required bool awake,
  }) async => const Success(null);
  @override
  Future<Result<void>> alert(
    DisplayPreferences preferences, {
    required String message,
    required String languageTag,
  }) async {
    alertCalls++;
    return const Success(null);
  }

  @override
  Future<Result<void>> update(TrackingDisplay display) async =>
      const Success(null);
  @override
  Stream<Result<double>> compass() => const Stream.empty();
  @override
  Future<Result<bool>> canOverlay() async => Success(overlayGranted);
  @override
  Future<Result<void>> setOverlay(bool enabled) async {
    overlayEnabled = enabled;
    return const Success(null);
  }

  @override
  Future<Result<void>> requestOverlay() async => const Success(null);
  @override
  Stream<bool> trackingStatus() => const Stream.empty();
  @override
  Future<Result<bool>> isTracking() async => const Success(false);
  @override
  Future<Result<void>> dispose() async => const Success(null);
}
