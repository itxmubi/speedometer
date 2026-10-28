import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/speedometer/domain/usecases/evaluate_speed_limit_use_case.dart';

void main() {
  const evaluate = EvaluateSpeedLimitUseCase();

  test('warns only strictly above an enabled limit', () {
    expect(
      evaluate(
        speedMetersPerSecond: 21,
        limitMetersPerSecond: 20,
        enabled: true,
      ),
      isTrue,
    );
    expect(
      evaluate(
        speedMetersPerSecond: 20,
        limitMetersPerSecond: 20,
        enabled: true,
      ),
      isFalse,
    );
    expect(
      evaluate(
        speedMetersPerSecond: 21,
        limitMetersPerSecond: 20,
        enabled: false,
      ),
      isFalse,
    );
  });

  test('rejects nonfinite values and nonpositive limits', () {
    for (final value in [
      double.nan,
      double.infinity,
      double.negativeInfinity,
    ]) {
      expect(
        evaluate(
          speedMetersPerSecond: value,
          limitMetersPerSecond: 20,
          enabled: true,
        ),
        isFalse,
      );
      expect(
        evaluate(
          speedMetersPerSecond: 21,
          limitMetersPerSecond: value,
          enabled: true,
        ),
        isFalse,
      );
    }
    expect(
      evaluate(
        speedMetersPerSecond: 21,
        limitMetersPerSecond: 0,
        enabled: true,
      ),
      isFalse,
    );
    expect(
      evaluate(
        speedMetersPerSecond: 21,
        limitMetersPerSecond: -1,
        enabled: true,
      ),
      isFalse,
    );
  });
}
