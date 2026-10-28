import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/domain/usecases/smooth_speed_use_case.dart';

void main() {
  const smooth = SmoothSpeedUseCase();

  test('the first Doppler sample is available immediately', () {
    final current = _reading(10);
    expect(smooth(current), same(current));
  });

  test('damps small consecutive fluctuations using the sample interval', () {
    final previous = _reading(10);
    final current = _reading(10.5, milliseconds: 1000);
    final result = smooth(current, previous: previous);

    expect(result.speedMetersPerSecond, closeTo(10 + 0.5 / 1.35, 0.00001));
    expect(result.timestamp, current.timestamp);
    expect(result.latitude, current.latitude);
    expect(result.longitude, current.longitude);
    expect(result.accuracyMeters, current.accuracyMeters);
    expect(result.altitudeMeters, current.altitudeMeters);
    expect(result.headingDegrees, current.headingDegrees);
  });

  test('starts, stops and meaningful speed changes bypass damping', () {
    for (final speeds in [(0.0, 1.0), (10.0, 0.0), (10.0, 12.0), (10.0, 8.0)]) {
      final current = _reading(speeds.$2, milliseconds: 1000);
      expect(smooth(current, previous: _reading(speeds.$1)), same(current));
    }
  });

  test('does not mix duplicate, burst, older or interrupted samples', () {
    for (final interval in [-1, 0, 499, 10000, 11000]) {
      final current = _reading(10.5, milliseconds: interval);
      expect(smooth(current, previous: _reading(10)), same(current));
    }
  });

  test('an unchanged speed remains unchanged across sample frequencies', () {
    for (final interval in [500, 1000, 3000]) {
      expect(
        smooth(
          _reading(10, milliseconds: interval),
          previous: _reading(10),
        ).speedMetersPerSecond,
        10,
      );
    }
  });
}

SpeedReading _reading(double speed, {int milliseconds = 0}) => SpeedReading(
  speedMetersPerSecond: speed,
  accuracyMeters: 3,
  latitude: 25,
  longitude: 55,
  altitudeMeters: 12,
  headingDegrees: 90,
  timestamp: DateTime.utc(
    2026,
    10,
    22,
  ).add(Duration(milliseconds: milliseconds)),
);
