import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/speedometer/domain/entities/trip_stats.dart';
import 'package:speedometer/features/trips/domain/entities/recorded_trip.dart';
import 'package:speedometer/features/trips/domain/entities/track_point.dart';
import 'package:speedometer/features/trips/domain/entities/trip_export_format.dart';
import 'package:speedometer/features/trips/domain/usecases/encode_trip_use_case.dart';

void main() {
  final at = DateTime.utc(2026, 10, 21);
  const encode = EncodeTripUseCase();
  TrackPoint point(int seconds, {double? latitude = 25, int segment = 0}) =>
      TrackPoint(
        timestamp: at.add(Duration(seconds: seconds)),
        speedMetersPerSecond: 10,
        segment: segment,
        overLimit: true,
        latitude: latitude,
        longitude: latitude == null ? null : 55,
      );

  test('GPX escapes XML metadata and splits pause and private-route gaps', () {
    final trip = RecordedTrip(
      id: 'a&<b>"',
      startedAt: at,
      stats: const TripStats(),
      points: [
        point(0),
        point(1),
        point(2, latitude: null),
        point(3),
        point(4, segment: 1),
      ],
    );
    final output = encode(trip, TripExportFormat.gpx);
    expect(output, contains('<name>a&amp;&lt;b&gt;&quot;</name>'));
    expect('<trkseg>'.allMatches(output).length, 3);
    expect('<trkpt '.allMatches(output).length, 4);
    expect(output, contains('<sp:overLimit>true</sp:overLimit>'));
    expect(output, contains('2026-10-21T00:00:00.000Z'));
  });

  test(
    'CSV quotes embedded commas and quotes and leaves private coordinates empty',
    () {
      final trip = RecordedTrip(
        id: 'a,"b',
        startedAt: at,
        stats: const TripStats(),
        points: [point(0, latitude: null)],
      );
      final output = encode(trip, TripExportFormat.csv);
      expect(output, contains('"a,""b"'));
      expect(output, contains('"10.0",,,,,,"0","true"'));
      expect(output, contains('speed_m_s,latitude,longitude'));
    },
  );

  test('empty GPX exports contain no fabricated route segment', () {
    final trip = RecordedTrip(
      id: 'empty',
      startedAt: at,
      stats: const TripStats(),
    );
    expect(encode(trip, TripExportFormat.gpx), isNot(contains('<trkseg>')));
    expect(
      encode(trip, TripExportFormat.csv),
      startsWith('trip_id,timestamp_utc'),
    );
  });
}
