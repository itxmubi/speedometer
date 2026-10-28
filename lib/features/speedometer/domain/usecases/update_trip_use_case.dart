import 'dart:math' as math;

import '../entities/speed_reading.dart';
import '../entities/trip_stats.dart';
import '../services/gps_quality_policy.dart';
import '../services/gps_segment_policy.dart';

/// Accumulates trip statistics without timers or platform dependencies.
final class UpdateTripUseCase {
  /// Creates the stateless trip accumulator.
  const UpdateTripUseCase();

  /// Uses accepted fix timestamps, excluding invalid, paused, and lost intervals.
  ///
  /// Distance comes from positions; displayed/max speed always remains Doppler
  /// speed. Calibration affects odometer distance only, never live speed.
  TripStats call({
    required TripStats previous,
    required SpeedReading reading,
    double calibrationFactor = 1,
  }) {
    if (!GpsQualityPolicy.isUsable(reading)) {
      return previous.withoutLastReading();
    }
    final normalized = _normalize(reading);
    final last = previous.lastReading;
    if (last == null) return _withAnchor(previous, normalized);
    final interval = normalized.timestamp.difference(last.timestamp);
    if (interval <= Duration.zero) return previous;
    if (interval > GpsQualityPolicy.maximumSampleGap) {
      return _withAnchor(previous, normalized);
    }
    final distance = GpsSegmentPolicy.distanceBetween(last, normalized);
    final seconds = interval.inMicroseconds / Duration.microsecondsPerSecond;
    final moving =
        last.speedMetersPerSecond > 0 || normalized.speedMetersPerSecond > 0;
    if (moving &&
        GpsSegmentPolicy.isJump(last, normalized, distance, seconds)) {
      return previous;
    }
    final calibration = calibrationFactor.isFinite && calibrationFactor > 0
        ? calibrationFactor
        : 1.0;
    return TripStats(
      distanceMeters:
          previous.distanceMeters + (moving ? distance * calibration : 0),
      maxSpeedMetersPerSecond: math.max(
        previous.maxSpeedMetersPerSecond,
        normalized.speedMetersPerSecond,
      ),
      elapsed: previous.elapsed + interval,
      movingTime: previous.movingTime + (moving ? interval : Duration.zero),
      lastReading: normalized,
    );
  }

  TripStats _withAnchor(TripStats previous, SpeedReading reading) => TripStats(
    distanceMeters: previous.distanceMeters,
    maxSpeedMetersPerSecond: math.max(
      previous.maxSpeedMetersPerSecond,
      reading.speedMetersPerSecond,
    ),
    elapsed: previous.elapsed,
    movingTime: previous.movingTime,
    lastReading: reading,
  );

  SpeedReading _normalize(SpeedReading reading) => SpeedReading(
    speedMetersPerSecond: GpsQualityPolicy.normalizeSpeed(
      reading.speedMetersPerSecond,
    ),
    accuracyMeters: reading.accuracyMeters,
    altitudeMeters: reading.altitudeMeters,
    headingDegrees: reading.headingDegrees,
    latitude: reading.latitude,
    longitude: reading.longitude,
    timestamp: reading.timestamp,
  );
}
