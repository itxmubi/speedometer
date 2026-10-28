import '../../../speedometer/domain/entities/trip_stats.dart';
import 'track_point.dart';

/// An immutable persisted trip, including privacy-filtered speed samples.
final class RecordedTrip {
  RecordedTrip({
    required this.id,
    required this.startedAt,
    required this.stats,
    this.endedAt,
    this.isPaused = true,
    Iterable<TrackPoint> points = const [],
  }) : points = List.unmodifiable(points);

  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final TripStats stats;
  final bool isPaused;
  final List<TrackPoint> points;

  bool get isActive => endedAt == null;
  TrackPoint? get startPoint => _endpoint(points);
  TrackPoint? get endPoint => _endpoint(points.reversed);

  static TrackPoint? _endpoint(Iterable<TrackPoint> candidates) {
    for (final point in candidates) {
      if (point.hasCoordinates) return point;
    }
    return null;
  }
}
