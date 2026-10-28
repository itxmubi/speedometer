import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';

void main() {
  test('converts SI speed to all supported display units', () {
    expect(SpeedUnit.kilometersPerHour.fromMetersPerSecond(10), 36);
    expect(
      SpeedUnit.milesPerHour.fromMetersPerSecond(10),
      closeTo(22.36936, 1e-5),
    );
    expect(SpeedUnit.metersPerSecond.fromMetersPerSecond(10), 10);
    expect(SpeedUnit.knots.fromMetersPerSecond(10), closeTo(19.43844, 1e-5));
  });

  test('uses distance units corresponding to the selected speed unit', () {
    expect(SpeedUnit.kilometersPerHour.distanceFromMeters(1000), 1);
    expect(SpeedUnit.milesPerHour.distanceFromMeters(1609.344), 1);
    expect(SpeedUnit.metersPerSecond.distanceFromMeters(1000), 1000);
    expect(SpeedUnit.knots.distanceFromMeters(1852), 1);
    expect(SpeedUnit.milesPerHour.usesMiles, isTrue);
    expect(SpeedUnit.kilometersPerHour.usesMiles, isFalse);
    expect(SpeedUnit.metersPerSecond.usesMiles, isFalse);
    expect(SpeedUnit.knots.usesMiles, isFalse);
  });
}
