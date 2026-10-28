/// Localized content for Android notification, overlay and widget surfaces.
final class TrackingDisplay {
  const TrackingDisplay({
    required this.speedMetersPerSecond,
    required this.displaySpeed,
    required this.unit,
    required this.overLimit,
    required this.status,
    required this.notificationTitle,
    required this.stopLabel,
  });
  final double? speedMetersPerSecond;
  final double displaySpeed;
  final String unit;
  final bool overLimit;
  final String status;
  final String notificationTitle;
  final String stopLabel;
}
