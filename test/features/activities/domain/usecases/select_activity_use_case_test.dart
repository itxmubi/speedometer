import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/activities/domain/entities/activity_display_defaults.dart';
import 'package:speedometer/features/activities/domain/entities/activity_mode.dart';
import 'package:speedometer/features/activities/domain/usecases/select_activity_use_case.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/gauge_style.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';

void main() {
  const select = SelectActivityUseCase();

  test(
    'each new activity uses a suitable dial range and boating uses knots',
    () {
      const original = DisplayPreferences();
      for (final (mode, range, unit) in [
        (ActivityMode.cycling, 60 / 3.6, SpeedUnit.kilometersPerHour),
        (ActivityMode.walking, 12 / 3.6, SpeedUnit.kilometersPerHour),
        (ActivityMode.running, 30 / 3.6, SpeedUnit.kilometersPerHour),
        (ActivityMode.boating, 60 * 1852 / 3600, SpeedUnit.knots),
      ]) {
        final selected = select(
          preferences: original,
          mode: mode,
          hasActiveTrip: false,
        );
        expect(selected.activityMode, mode);
        expect(selected.gaugeRangeMetersPerSecond, closeTo(range, 0.001));
        expect(selected.unit, unit);
        expect(selected.hasValidValues, isTrue);
      }
      expect(original.activityMode, ActivityMode.car);
    },
  );

  test('switching back restores the exact previous unit style and range', () {
    const car = DisplayPreferences(
      unit: SpeedUnit.milesPerHour,
      gaugeStyle: GaugeStyle.analog,
      gaugeRangeMetersPerSecond: 45,
    );
    final walking =
        select(
          preferences: car,
          mode: ActivityMode.walking,
          hasActiveTrip: false,
        ).copyWith(
          unit: SpeedUnit.metersPerSecond,
          gaugeStyle: GaugeStyle.hud,
          gaugeRangeMetersPerSecond: 4,
        );
    final restoredCar = select(
      preferences: walking,
      mode: ActivityMode.car,
      hasActiveTrip: false,
    );
    expect(restoredCar.unit, car.unit);
    expect(restoredCar.gaugeStyle, car.gaugeStyle);
    expect(
      restoredCar.gaugeRangeMetersPerSecond,
      car.gaugeRangeMetersPerSecond,
    );
    final restoredWalking = select(
      preferences: restoredCar,
      mode: ActivityMode.walking,
      hasActiveTrip: false,
    );
    expect(restoredWalking.unit, SpeedUnit.metersPerSecond);
    expect(restoredWalking.gaugeStyle, GaugeStyle.hud);
    expect(restoredWalking.gaugeRangeMetersPerSecond, 4);
    expect(car.activityDisplays.car, const ActivityDisplayDefaults());
  });

  test('an active or paused trip cannot change activity', () {
    const original = DisplayPreferences();
    expect(
      select(
        preferences: original,
        mode: ActivityMode.cycling,
        hasActiveTrip: true,
      ),
      same(original),
    );
    expect(
      select(
        preferences: original,
        mode: ActivityMode.car,
        hasActiveTrip: false,
      ),
      same(original),
    );
  });
}
