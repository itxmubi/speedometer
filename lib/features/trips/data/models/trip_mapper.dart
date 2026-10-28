import '../../../../core/database/app_database.dart';
import '../../../speedometer/domain/entities/trip_stats.dart';
import '../../domain/entities/recorded_trip.dart';
import '../../domain/entities/track_point.dart';

/// Keeps generated SQLite rows within the data boundary.
abstract final class TripMapper {
  static RecordedTrip toEntity(
    TripRecord row, [
    List<TripPoint> points = const [],
  ]) => RecordedTrip(
    id: row.id,
    startedAt: DateTime.fromMillisecondsSinceEpoch(
      row.startedAtMs,
      isUtc: true,
    ),
    endedAt: switch (row.endedAtMs) {
      final end? => DateTime.fromMillisecondsSinceEpoch(end, isUtc: true),
      null => null,
    },
    stats: TripStats(
      distanceMeters: row.distanceMeters,
      maxSpeedMetersPerSecond: row.maxSpeed,
      elapsed: Duration(microseconds: row.elapsedUs),
      movingTime: Duration(microseconds: row.movingUs),
    ),
    isPaused: row.paused,
    points: points.map(
      (point) => TrackPoint(
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          point.timestampMs,
          isUtc: true,
        ),
        speedMetersPerSecond: point.speed,
        segment: point.segment,
        overLimit: point.overLimit,
        latitude: point.latitude,
        longitude: point.longitude,
        accuracyMeters: point.accuracy,
        altitudeMeters: point.altitude,
        headingDegrees: point.heading,
      ),
    ),
  );
}
