import 'package:intl/intl.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../speedometer/domain/entities/speed_unit.dart';

/// Locale-aware history and export-summary formatting.
abstract final class TripFormat {
  static String date(DateTime time, AppLocalizations l10n) =>
      DateFormat.yMMMd(l10n.localeName).add_jm().format(time.toLocal());

  static String number(num value, AppLocalizations l10n, {int decimals = 1}) =>
      (NumberFormat.decimalPattern(
        l10n.localeName,
      )..maximumFractionDigits = decimals).format(value);

  static String speed(double value, SpeedUnit unit, AppLocalizations l10n) =>
      l10n.measurementValue(
        number(unit.fromMetersPerSecond(value), l10n),
        switch (unit) {
          SpeedUnit.kilometersPerHour => l10n.unitKilometers,
          SpeedUnit.milesPerHour => l10n.unitMiles,
          SpeedUnit.metersPerSecond => l10n.unitMeters,
          SpeedUnit.knots => l10n.unitKnots,
        },
      );

  static String distance(double value, SpeedUnit unit, AppLocalizations l10n) =>
      l10n.measurementValue(
        number(unit.distanceFromMeters(value), l10n, decimals: 2),
        switch (unit) {
          SpeedUnit.kilometersPerHour => l10n.kilometers,
          SpeedUnit.milesPerHour => l10n.miles,
          SpeedUnit.metersPerSecond => l10n.meters,
          SpeedUnit.knots => l10n.nauticalMiles,
        },
      );

  static String duration(Duration duration, AppLocalizations l10n) {
    final two = NumberFormat('00', l10n.localeName);
    return l10n.durationValue(
      two.format(duration.inHours),
      two.format(duration.inMinutes % 60),
      two.format(duration.inSeconds % 60),
    );
  }
}
