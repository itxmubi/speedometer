/// A device-reported ground speed and its location quality, in SI units.
final class SpeedReading {
  /// Creates a reading; the repository validates external platform input.
  const SpeedReading({
    required this.speedMetersPerSecond,
    required this.accuracyMeters,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.altitudeMeters,
    this.headingDegrees,
  });

  /// Lightly filtered Doppler speed, never coordinate-derived speed.
  final double speedMetersPerSecond;

  /// Estimated horizontal uncertainty in meters.
  final double accuracyMeters;

  /// Altitude when the platform supplies a valid value.
  final double? altitudeMeters;

  /// Course over ground when available; this is not a magnetic compass.
  final double? headingDegrees;

  /// Latitude in degrees, saved to the route only when route storage is enabled.
  final double latitude;

  /// Longitude in degrees, saved to the route only when route storage is enabled.
  final double longitude;

  /// Time the platform determined this fix, rather than its delivery time.
  final DateTime timestamp;
}
