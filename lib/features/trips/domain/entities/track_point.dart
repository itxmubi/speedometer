/// One accepted speed sample. Coordinates exist only when route recording was on.
final class TrackPoint {
  const TrackPoint({
    required this.timestamp,
    required this.speedMetersPerSecond,
    required this.segment,
    required this.overLimit,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    this.altitudeMeters,
    this.headingDegrees,
  });

  final DateTime timestamp;
  final double speedMetersPerSecond;
  final int segment;
  final bool overLimit;
  final double? latitude;
  final double? longitude;
  final double? accuracyMeters;
  final double? altitudeMeters;
  final double? headingDegrees;

  bool get hasCoordinates => latitude != null && longitude != null;
}
