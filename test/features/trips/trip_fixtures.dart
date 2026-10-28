import 'package:speedometer/features/speedometer/domain/entities/trip_stats.dart';
import 'package:speedometer/features/trips/domain/entities/recorded_trip.dart';
import 'package:speedometer/features/trips/domain/entities/track_point.dart';

final tripEpoch = DateTime.utc(2026, 10, 22, 12);

TrackPoint sample({
  int seconds = 0,
  double speed = 10,
  int segment = 0,
  bool overLimit = false,
  double? latitude = 25,
  double? longitude = 55,
}) => TrackPoint(
  timestamp: tripEpoch.add(Duration(seconds: seconds)),
  speedMetersPerSecond: speed,
  segment: segment,
  overLimit: overLimit,
  latitude: latitude,
  longitude: longitude,
);

RecordedTrip savedTrip({
  String id = 'saved-trip',
  List<TrackPoint>? points,
  bool active = false,
}) => RecordedTrip(
  id: id,
  startedAt: tripEpoch,
  endedAt: active ? null : tripEpoch.add(const Duration(minutes: 1)),
  stats: const TripStats(
    distanceMeters: 1200,
    elapsed: Duration(minutes: 1),
    movingTime: Duration(seconds: 40),
    maxSpeedMetersPerSecond: 20,
  ),
  points: points ?? [sample(), sample(seconds: 5, latitude: 25.001)],
);
