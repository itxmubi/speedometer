import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/domain/entities/trip_stats.dart';
import 'package:speedometer/features/speedometer/domain/usecases/update_trip_use_case.dart';

void main() {
  const update = UpdateTripUseCase();

  test('empty trip has finite zero averages', () {
    const trip = TripStats();
    expect(trip.averageSpeedMetersPerSecond, 0);
    expect(trip.movingAverageSpeedMetersPerSecond, 0);
  });

  test(
    'first fix anchors the trip without inventing elapsed time or distance',
    () {
      final trip = update(
        previous: const TripStats(),
        reading: _reading(speed: 10),
      );
      expect(trip.distanceMeters, 0);
      expect(trip.elapsed, Duration.zero);
      expect(trip.maxSpeedMetersPerSecond, 10);
      expect(trip.lastReading?.speedMetersPerSecond, 10);
    },
  );

  test('accumulates Haversine distance and accepted moving sample time', () {
    final trip = _movingTrip(update);
    expect(trip.distanceMeters, closeTo(11.119508, 1e-5));
    expect(trip.elapsed, const Duration(seconds: 1));
    expect(trip.movingTime, const Duration(seconds: 1));
    expect(trip.maxSpeedMetersPerSecond, 12);
    expect(trip.averageSpeedMetersPerSecond, closeTo(11.119508, 1e-5));
    expect(
      trip.movingAverageSpeedMetersPerSecond,
      trip.averageSpeedMetersPerSecond,
    );
  });

  test(
    'uses device Doppler speed for max rather than distance-derived speed',
    () {
      final trip = update(
        previous: update(
          previous: const TripStats(),
          reading: _reading(speed: 5),
        ),
        reading: _reading(second: 1, latitude: 0.0001, speed: 6),
      );
      expect(trip.distanceMeters, greaterThan(11));
      expect(trip.maxSpeedMetersPerSecond, 6);
    },
  );

  test(
    'stationary jitter adds elapsed time without distance or moving time',
    () {
      final first = update(
        previous: const TripStats(),
        reading: _reading(speed: 0.2),
      );
      final trip = update(
        previous: first,
        reading: _reading(second: 1, latitude: 0.0002, speed: 0.4),
      );
      expect(trip.distanceMeters, 0);
      expect(trip.elapsed, const Duration(seconds: 1));
      expect(trip.movingTime, Duration.zero);
      expect(trip.maxSpeedMetersPerSecond, 0);
      expect(trip.lastReading?.speedMetersPerSecond, 0);
    },
  );

  test(
    'stopped time lowers total average but does not lower moving average',
    () {
      var trip = _movingTrip(update);
      trip = update(
        previous: trip,
        reading: _reading(second: 2, latitude: 0.0001, speed: 0),
      );
      trip = update(
        previous: trip,
        reading: _reading(second: 3, latitude: 0.0001, speed: 0),
      );
      expect(trip.elapsed, const Duration(seconds: 3));
      expect(trip.movingTime, const Duration(seconds: 2));
      expect(
        trip.averageSpeedMetersPerSecond,
        lessThan(trip.movingAverageSpeedMetersPerSecond),
      );
    },
  );

  test('accuracy boundary accepts 25 meters and rejects poorer fixes', () {
    final trip = update(
      previous: const TripStats(),
      reading: _reading(accuracy: 25),
    );
    expect(trip.lastReading, isNotNull);
    final rejected = update(previous: trip, reading: _reading(accuracy: 25.01));
    expect(rejected.lastReading, isNull);
    expect(rejected.distanceMeters, trip.distanceMeters);
  });

  test(
    'rejected quality breaks the anchor so subsequent fixes do not bridge it',
    () {
      var trip = _movingTrip(update);
      final originalDistance = trip.distanceMeters;
      trip = update(
        previous: trip,
        reading: _reading(second: 2, latitude: 0.002, accuracy: 100),
      );
      trip = update(
        previous: trip,
        reading: _reading(second: 3, latitude: 0.003),
      );
      expect(trip.distanceMeters, originalDistance);
      expect(trip.elapsed, const Duration(seconds: 1));
    },
  );

  test('ignores duplicate and out-of-order timestamps', () {
    final trip = _movingTrip(update);
    expect(update(previous: trip, reading: _reading(second: 1)), same(trip));
    expect(update(previous: trip, reading: _reading()), same(trip));
  });

  test('large GPS gaps reanchor without adding unknown distance or time', () {
    final previous = _movingTrip(update);
    final trip = update(
      previous: previous,
      reading: _reading(second: 30, latitude: 0.01),
    );
    expect(trip.distanceMeters, previous.distanceMeters);
    expect(trip.elapsed, previous.elapsed);
    expect(trip.lastReading?.timestamp, _reading(second: 30).timestamp);
  });

  test('pause and resume preserve totals without connecting the pause', () {
    final previous = _movingTrip(update);
    final trip = update(
      previous: previous.withoutLastReading(),
      reading: _reading(second: 3, latitude: 0.01),
    );
    expect(trip.distanceMeters, previous.distanceMeters);
    expect(trip.elapsed, previous.elapsed);
    expect(trip.movingTime, previous.movingTime);
    expect(trip.maxSpeedMetersPerSecond, previous.maxSpeedMetersPerSecond);
  });

  test('rejects coordinate jumps uncorroborated by reported speed', () {
    final trip = _movingTrip(update);
    final rejected = update(
      previous: trip,
      reading: _reading(second: 2, latitude: 1, speed: 10),
    );
    expect(rejected, same(trip));
    final recovered = update(
      previous: rejected,
      reading: _reading(second: 3, latitude: 0.0003),
    );
    expect(recovered.distanceMeters, closeTo(33.358524, 1e-5));
  });

  test('calibration changes only distance and distance-derived averages', () {
    final baseline = _movingTrip(update);
    final calibrated = _movingTrip(update, calibration: 1.03);
    expect(
      calibrated.distanceMeters,
      closeTo(baseline.distanceMeters * 1.03, 1e-9),
    );
    expect(
      calibrated.maxSpeedMetersPerSecond,
      baseline.maxSpeedMetersPerSecond,
    );
    expect(
      calibrated.lastReading?.speedMetersPerSecond,
      baseline.lastReading?.speedMetersPerSecond,
    );
    expect(calibrated.elapsed, baseline.elapsed);
  });

  for (final factor in [0.0, -1.0, double.nan, double.infinity]) {
    test('invalid calibration $factor uses a neutral factor', () {
      expect(
        _movingTrip(update, calibration: factor).distanceMeters,
        _movingTrip(update).distanceMeters,
      );
    });
  }

  for (final speed in [-1.0, 151.0, double.nan, double.infinity]) {
    test('rejects invalid speed $speed without poisoning totals', () {
      final previous = _movingTrip(update);
      final trip = update(
        previous: previous,
        reading: _reading(speed: speed),
      );
      expect(trip.distanceMeters, previous.distanceMeters);
      expect(trip.maxSpeedMetersPerSecond, previous.maxSpeedMetersPerSecond);
      expect(trip.lastReading, isNull);
    });
  }

  for (final latitude in [-91.0, 91.0, double.nan, double.infinity]) {
    test('rejects invalid latitude $latitude', () {
      expect(
        update(
          previous: const TripStats(),
          reading: _reading(latitude: latitude),
        ).lastReading,
        isNull,
      );
    });
  }

  test('Haversine handles crossing the date line', () {
    final trip = update(
      previous: update(
        previous: const TripStats(),
        reading: _reading(longitude: 179.99995, speed: 12),
      ),
      reading: _reading(second: 1, longitude: -179.99995, speed: 12),
    );
    expect(trip.distanceMeters, closeTo(11.119508, 1e-5));
  });
}

TripStats _movingTrip(UpdateTripUseCase update, {double calibration = 1}) =>
    update(
      previous: update(
        previous: const TripStats(),
        reading: _reading(speed: 10),
      ),
      reading: _reading(second: 1, latitude: 0.0001, speed: 12),
      calibrationFactor: calibration,
    );

SpeedReading _reading({
  int second = 0,
  double speed = 10,
  double accuracy = 5,
  double latitude = 0,
  double longitude = 0,
}) => SpeedReading(
  speedMetersPerSecond: speed,
  accuracyMeters: accuracy,
  latitude: latitude,
  longitude: longitude,
  timestamp: DateTime.utc(2026, 10, 21, 10, 0, second),
);
