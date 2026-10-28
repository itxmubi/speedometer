import '../entities/speed_reading.dart';
import '../services/gps_quality_policy.dart';

/// Lightly damps small Doppler fluctuations without delaying starts or stops.
final class SmoothSpeedUseCase {
  const SmoothSpeedUseCase();

  static const _timeConstantMilliseconds = 350;
  static const _maximumJitterMetersPerSecond = 0.75;

  /// Only nearby, consecutive healthy speeds participate in the filter.
  SpeedReading call(SpeedReading current, {SpeedReading? previous}) {
    if (previous == null ||
        current.speedMetersPerSecond == 0 ||
        previous.speedMetersPerSecond == 0) {
      return current;
    }
    final interval = current.timestamp.difference(previous.timestamp);
    final change = current.speedMetersPerSecond - previous.speedMetersPerSecond;
    if (interval < GpsQualityPolicy.minimumSampleInterval ||
        interval >= GpsQualityPolicy.maximumSampleGap ||
        change.abs() > _maximumJitterMetersPerSecond) {
      return current;
    }
    // At a one-second cadence the latest sample contributes 74%; large changes
    // bypass this filter so meaningful acceleration is shown immediately.
    final weight =
        interval.inMilliseconds /
        (interval.inMilliseconds + _timeConstantMilliseconds);
    return SpeedReading(
      speedMetersPerSecond: previous.speedMetersPerSecond + weight * change,
      accuracyMeters: current.accuracyMeters,
      latitude: current.latitude,
      longitude: current.longitude,
      timestamp: current.timestamp,
      altitudeMeters: current.altitudeMeters,
      headingDegrees: current.headingDegrees,
    );
  }
}
