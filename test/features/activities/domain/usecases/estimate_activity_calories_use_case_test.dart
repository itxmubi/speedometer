import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/activities/domain/entities/activity_mode.dart';
import 'package:speedometer/features/activities/domain/usecases/estimate_activity_calories_use_case.dart';

void main() {
  const estimate = EstimateActivityCaloriesUseCase();

  test('scales representative MET energy with weight and moving hours', () {
    expect(
      estimate(
        mode: ActivityMode.cycling,
        weightKilograms: 70,
        movingTime: const Duration(hours: 1),
      ),
      490,
    );
    expect(
      estimate(
        mode: ActivityMode.walking,
        weightKilograms: 70,
        movingTime: const Duration(minutes: 30),
      ),
      133,
    );
    expect(
      estimate(
        mode: ActivityMode.running,
        weightKilograms: 60,
        movingTime: const Duration(minutes: 15),
      ),
      127.5,
    );
    expect(
      estimate(
        mode: ActivityMode.walking,
        weightKilograms: 70,
        movingTime: Duration.zero,
      ),
      0,
    );
    expect(
      estimate(
        mode: ActivityMode.walking,
        weightKilograms: 140,
        movingTime: const Duration(minutes: 30),
      ),
      266,
    );
  });

  test('motorized modes and missing weight never imply exercise calories', () {
    for (final mode in [ActivityMode.car, ActivityMode.boating]) {
      expect(
        estimate(
          mode: mode,
          weightKilograms: 70,
          movingTime: const Duration(hours: 1),
        ),
        isNull,
      );
    }
    expect(
      estimate(
        mode: ActivityMode.cycling,
        weightKilograms: null,
        movingTime: const Duration(hours: 1),
      ),
      isNull,
    );
  });

  test('invalid and unbounded inputs do not produce estimates', () {
    for (final weight in [
      double.nan,
      double.infinity,
      -1.0,
      0.0,
      19.9,
      300.1,
    ]) {
      expect(
        estimate(
          mode: ActivityMode.walking,
          weightKilograms: weight,
          movingTime: const Duration(hours: 1),
        ),
        isNull,
      );
    }
    expect(
      estimate(
        mode: ActivityMode.walking,
        weightKilograms: 70,
        movingTime: const Duration(seconds: -1),
      ),
      isNull,
    );
    for (final weight in [20.0, 300.0]) {
      expect(
        estimate(
          mode: ActivityMode.walking,
          weightKilograms: weight,
          movingTime: const Duration(hours: 1),
        ),
        isNonNegative,
      );
    }
  });
}
