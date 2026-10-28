import 'speed_reading.dart';

/// Session statistics accumulated only between trustworthy foreground fixes.
final class TripStats {
  /// Creates an empty trip or replaces it with an immutable snapshot.
  const TripStats({
    this.distanceMeters = 0,
    this.maxSpeedMetersPerSecond = 0,
    this.elapsed = Duration.zero,
    this.movingTime = Duration.zero,
    this.lastReading,
  });

  /// Calibrated distance traveled during accepted sample intervals.
  final double distanceMeters;

  /// Highest accepted Doppler speed during the session.
  final double maxSpeedMetersPerSecond;

  /// Time between consecutive accepted fixes, excluding pauses and GPS gaps.
  final Duration elapsed;

  /// Accepted time intervals during which the device was moving.
  final Duration movingTime;

  /// The latest accepted fix, used as the next interval's anchor.
  final SpeedReading? lastReading;

  /// Distance per accepted session second; zero before a full interval.
  double get averageSpeedMetersPerSecond => _average(elapsed);

  /// Distance per moving second; stopped intervals add no distance.
  double get movingAverageSpeedMetersPerSecond => _average(movingTime);

  /// Breaks the interval at pause, lifecycle, error, or lost-signal boundaries.
  TripStats withoutLastReading() => TripStats(
    distanceMeters: distanceMeters,
    maxSpeedMetersPerSecond: maxSpeedMetersPerSecond,
    elapsed: elapsed,
    movingTime: movingTime,
  );

  double _average(Duration duration) => duration > Duration.zero
      ? distanceMeters /
            (duration.inMicroseconds / Duration.microsecondsPerSecond)
      : 0;
}
