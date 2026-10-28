import 'dart:math' as math;

import '../entities/speed_reading.dart';
import 'gps_quality_policy.dart';

/// Shared coordinate checks for the live readout, routes and odometer.
abstract final class GpsSegmentPolicy {
  static const double _earthRadiusMeters = 6371008.8;
  static const double _degreesToRadians = math.pi / 180;
  static const double _jumpSpeedAllowance = 2;
  static const double _minimumJumpAllowanceMeters = 10;

  /// Rejects displacement unsupported by Doppler speed and position uncertainty.
  static bool isJump(
    SpeedReading previous,
    SpeedReading reading,
    double distance,
    double seconds,
  ) {
    final speed = math.max(
      previous.speedMetersPerSecond,
      reading.speedMetersPerSecond,
    );
    final uncertainty = math.max(
      previous.accuracyMeters,
      reading.accuracyMeters,
    );
    final allowance = math.max(
      _minimumJumpAllowanceMeters,
      speed * seconds * _jumpSpeedAllowance + uncertainty,
    );
    return distance > allowance ||
        distance / seconds > GpsQualityPolicy.maximumSpeedMetersPerSecond;
  }

  /// Great-circle distance with safe rounding at antipodes.
  static double distanceBetween(SpeedReading start, SpeedReading end) {
    final latitudeDelta = (end.latitude - start.latitude) * _degreesToRadians;
    final longitudeDelta =
        (end.longitude - start.longitude) * _degreesToRadians;
    final latitudeSine = math.sin(latitudeDelta / 2);
    final longitudeSine = math.sin(longitudeDelta / 2);
    final haversine =
        latitudeSine * latitudeSine +
        math.cos(start.latitude * _degreesToRadians) *
            math.cos(end.latitude * _degreesToRadians) *
            longitudeSine *
            longitudeSine;
    // Floating-point rounding near antipodes can otherwise produce NaN.
    return 2 * _earthRadiusMeters * math.asin(math.sqrt(haversine.clamp(0, 1)));
  }
}
