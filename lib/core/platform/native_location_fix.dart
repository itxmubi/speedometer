/// Primitive-only DTO for Android GPS fixes; no feature domain dependency.
final class NativeLocationFix {
  /// Creates a native fix preserving API presence information.
  const NativeLocationFix({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.speedMetersPerSecond,
    required this.accuracyMeters,
    required this.altitudeMeters,
    required this.headingDegrees,
    required this.speedAccuracyMetersPerSecond,
    required this.altitudeAccuracyMeters,
    required this.headingAccuracyDegrees,
    required this.hasSpeed,
    required this.hasAccuracy,
    required this.hasAltitude,
    required this.hasHeading,
    required this.hasSpeedAccuracy,
    required this.isMocked,
  });

  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double speedMetersPerSecond;
  final double accuracyMeters;
  final double altitudeMeters;
  final double headingDegrees;
  final double speedAccuracyMetersPerSecond;
  final double altitudeAccuracyMeters;
  final double headingAccuracyDegrees;
  final bool hasSpeed;
  final bool hasAccuracy;
  final bool hasAltitude;
  final bool hasHeading;
  final bool hasSpeedAccuracy;
  final bool isMocked;

  /// Validates untrusted channel data without inventing speed or accuracy.
  static NativeLocationFix? fromMap(Map<Object?, Object?> values) {
    double? number(String key) => switch (values[key]) {
      final num value when value.isFinite => value.toDouble(),
      _ => null,
    };
    final latitude = number('latitude');
    final longitude = number('longitude');
    final time = values['timestamp'];
    if (latitude == null ||
        latitude.abs() > 90 ||
        longitude == null ||
        longitude.abs() > 180 ||
        time is! int ||
        time < 0 ||
        time > 8640000000000000) {
      return null;
    }
    return NativeLocationFix(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.fromMillisecondsSinceEpoch(time, isUtc: true),
      speedMetersPerSecond: number('speed') ?? -1,
      accuracyMeters: number('accuracy') ?? -1,
      altitudeMeters: number('altitude') ?? 0,
      headingDegrees: number('heading') ?? -1,
      speedAccuracyMetersPerSecond: number('speedAccuracy') ?? -1,
      altitudeAccuracyMeters: number('altitudeAccuracy') ?? -1,
      headingAccuracyDegrees: number('headingAccuracy') ?? -1,
      hasSpeed: values['hasSpeed'] == true && number('speed') != null,
      hasAccuracy: values['hasAccuracy'] == true && number('accuracy') != null,
      hasAltitude: values['hasAltitude'] == true && number('altitude') != null,
      hasHeading: values['hasHeading'] == true && number('heading') != null,
      hasSpeedAccuracy:
          values['hasSpeedAccuracy'] == true && number('speedAccuracy') != null,
      isMocked: values['isMocked'] == true,
    );
  }
}
