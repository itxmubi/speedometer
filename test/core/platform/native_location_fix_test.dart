import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/platform/native_location_fix.dart';

void main() {
  Map<Object?, Object?> fix() => {
    'latitude': 0.0,
    'longitude': 0.0,
    'timestamp': 1792540800000,
    'speed': 10.0,
    'accuracy': 4.0,
    'hasSpeed': true,
    'hasAccuracy': true,
  };

  test('preserves measured speed and absent API presence flags', () {
    final result = NativeLocationFix.fromMap(fix());

    expect(result?.speedMetersPerSecond, 10);
    expect(result?.hasSpeed, isTrue);
    expect(result?.hasAccuracy, isTrue);
    expect(result?.hasSpeedAccuracy, isFalse);
    expect(result?.speedAccuracyMetersPerSecond, -1);
    expect(result?.hasAltitude, isFalse);
    expect(result?.hasHeading, isFalse);
    expect(result?.timestamp.isUtc, isTrue);
  });

  test('never treats absent or nonfinite speed as measured zero', () {
    for (final invalid in [null, double.nan, double.infinity, '10']) {
      final result = NativeLocationFix.fromMap(fix()..['speed'] = invalid);

      expect(result?.hasSpeed, isFalse);
      expect(result?.speedMetersPerSecond, -1);
    }
  });

  test('validates coordinates and timestamps at the channel boundary', () {
    for (final entry in <String, Object?>{
      'latitude': 91,
      'longitude': -181,
      'timestamp': 8640000000000001,
    }.entries) {
      expect(
        NativeLocationFix.fromMap(fix()..[entry.key] = entry.value),
        isNull,
      );
    }
    expect(NativeLocationFix.fromMap(fix()..['timestamp'] = -1), isNull);
  });

  test(
    'does not invent presence when native value is supplied without flag',
    () {
      final result = NativeLocationFix.fromMap(fix()..remove('hasSpeed'));

      expect(result?.speedMetersPerSecond, 10);
      expect(result?.hasSpeed, isFalse);
    },
  );
}
