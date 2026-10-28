import '../entities/speed_reading.dart';

/// Shared, deterministic limits for usable speed and trip samples.
abstract final class GpsQualityPolicy {
  /// Coarse/approximate fixes are unsuitable for a trustworthy speedometer.
  static const double maximumAccuracyMeters = 25;

  /// Suppresses the small Doppler fluctuations seen when stationary.
  static const double stoppedSpeedMetersPerSecond = 0.5;

  /// Rejects impossible road, cycling, walking, and boating speed samples.
  static const double maximumSpeedMetersPerSecond = 150;

  /// Rejects speed estimates too uncertain for a useful live readout.
  static const double maximumSpeedAccuracyMetersPerSecond = 3;

  /// A missing interval must not invent travel during GPS loss or a pause.
  static const Duration maximumSampleGap = Duration(seconds: 10);

  /// A native one-second stream can occasionally deliver fixes in bursts.
  static const Duration minimumSampleInterval = Duration(milliseconds: 500);

  /// Validates untrusted values before any statistics are accumulated.
  static bool isUsable(SpeedReading reading) =>
      reading.accuracyMeters.isFinite &&
      reading.accuracyMeters >= 0 &&
      reading.accuracyMeters <= maximumAccuracyMeters &&
      reading.speedMetersPerSecond.isFinite &&
      reading.speedMetersPerSecond >= 0 &&
      reading.speedMetersPerSecond <= maximumSpeedMetersPerSecond &&
      reading.latitude.isFinite &&
      reading.latitude >= -90 &&
      reading.latitude <= 90 &&
      reading.longitude.isFinite &&
      reading.longitude >= -180 &&
      reading.longitude <= 180;

  /// Converts stationary jitter to zero without delaying genuine changes.
  static double normalizeSpeed(double speed) =>
      speed >= 0 && speed < stoppedSpeedMetersPerSecond ? 0 : speed;
}
