import 'package:intl/intl.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../domain/entities/speed_unit.dart';

/// Locale-aware presentation formatting for the instrument panel.
abstract final class SpeedometerFormat {
  static double dialRange(SpeedUnit unit) => switch (unit) {
    SpeedUnit.kilometersPerHour => AppMetrics.kilometersDialRange,
    SpeedUnit.milesPerHour => AppMetrics.milesDialRange,
    SpeedUnit.metersPerSecond => AppMetrics.metersDialRange,
    SpeedUnit.knots => AppMetrics.knotsDialRange,
  };

  static String unit(SpeedUnit unit, AppLocalizations l10n) => switch (unit) {
    SpeedUnit.kilometersPerHour => l10n.unitKilometers,
    SpeedUnit.milesPerHour => l10n.unitMiles,
    SpeedUnit.metersPerSecond => l10n.unitMeters,
    SpeedUnit.knots => l10n.unitKnots,
  };

  static String unitName(SpeedUnit unit, AppLocalizations l10n) =>
      switch (unit) {
        SpeedUnit.kilometersPerHour => l10n.unitKilometersFull,
        SpeedUnit.milesPerHour => l10n.unitMilesFull,
        SpeedUnit.metersPerSecond => l10n.unitMetersFull,
        SpeedUnit.knots => l10n.unitKnotsFull,
      };

  static String distanceUnit(SpeedUnit unit, AppLocalizations l10n) =>
      switch (unit) {
        SpeedUnit.kilometersPerHour => l10n.kilometers,
        SpeedUnit.milesPerHour => l10n.miles,
        SpeedUnit.metersPerSecond => l10n.meters,
        SpeedUnit.knots => l10n.nauticalMiles,
      };

  static String number(num value, AppLocalizations l10n, {int decimals = 0}) {
    final format = NumberFormat.decimalPattern(l10n.localeName)
      ..minimumFractionDigits = decimals
      ..maximumFractionDigits = decimals;
    return format.format(value);
  }

  static String speed(
    double metersPerSecond,
    SpeedUnit unit,
    AppLocalizations l10n,
  ) {
    return number(unit.fromMetersPerSecond(metersPerSecond), l10n);
  }

  static String duration(Duration value, AppLocalizations l10n) {
    final twoDigits = NumberFormat('00', l10n.localeName);
    return l10n.durationValue(
      twoDigits.format(value.inHours),
      twoDigits.format(value.inMinutes.remainder(Duration.minutesPerHour)),
      twoDigits.format(value.inSeconds.remainder(Duration.secondsPerMinute)),
    );
  }
}
