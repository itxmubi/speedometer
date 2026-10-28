import 'package:intl/intl.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../domain/entities/fuel_distance_unit.dart';
import '../../domain/entities/fuel_volume_unit.dart';

/// Localized numbers always include an explicit distance, volume or currency.
abstract final class FuelFormat {
  static String number(double value, AppLocalizations l10n) =>
      (NumberFormat.decimalPattern(
        l10n.localeName,
      )..maximumFractionDigits = 2).format(value);

  static String money(double value, String currency, AppLocalizations l10n) =>
      NumberFormat.currency(
        locale: l10n.localeName,
        name: currency,
        symbol: currency,
      ).format(value);

  static String inputNumber(double value, AppLocalizations l10n) =>
      (NumberFormat.decimalPattern(
        l10n.localeName,
      )..maximumFractionDigits = 12).format(value);

  static String distanceUnit(FuelDistanceUnit unit, AppLocalizations l10n) =>
      unit == FuelDistanceUnit.kilometers ? l10n.kilometers : l10n.miles;

  static String volumeUnit(FuelVolumeUnit unit, AppLocalizations l10n) =>
      unit == FuelVolumeUnit.liters ? l10n.fuelLiters : l10n.fuelUsGallons;

  static String date(DateTime value, AppLocalizations l10n) =>
      DateFormat.yMMMd(l10n.localeName).format(value.toLocal());

  static double parse(String value, AppLocalizations l10n) {
    final symbols = NumberFormat.decimalPattern(l10n.localeName).symbols;
    final decimal = symbols.DECIMAL_SEP;
    final group = symbols.GROUP_SEP;
    var normalized = value.trim();
    if (normalized.isEmpty) return 0;
    final zero = symbols.ZERO_DIGIT.runes.single;
    normalized = String.fromCharCodes(
      normalized.runes.map((rune) {
        // Android keyboards can use either Arabic digit family in the same locale.
        for (final start in [zero, 0x0660, 0x06f0]) {
          if (rune >= start && rune <= start + 9) return 0x30 + rune - start;
        }
        return rune;
      }),
    );
    normalized = normalized
        .replaceAll(
          RegExp('[\u061c\u200e\u200f\u202a-\u202e\u2066-\u2069]'),
          '',
        )
        .replaceAll('\u066b', decimal)
        .replaceAll('\u066c', group)
        .replaceAll('\u2212', '-');
    if (group == '\u00a0' || group == '\u202f' || group == ' ') {
      normalized = normalized.replaceAll(RegExp('[ \u00a0\u202f]'), group);
    }
    final sign = normalized.startsWith('-') ? '-' : '';
    if (normalized.startsWith('-') || normalized.startsWith('+')) {
      normalized = normalized.substring(1);
    }
    final parts = normalized.split(decimal);
    if (parts.length > 2 ||
        (parts.length == 2 && !RegExp(r'^[0-9]+$').hasMatch(parts.last))) {
      return double.nan;
    }
    final integer = parts.first;
    final ungrouped = RegExp(r'^[0-9]+$').hasMatch(integer);
    final grouped = RegExp(
      '^[0-9]{1,3}(?:${RegExp.escape(group)}[0-9]{3})+\$',
    ).hasMatch(integer);
    if (!ungrouped && !grouped && !(integer.isEmpty && parts.length == 2)) {
      return double.nan;
    }
    final canonical =
        '$sign${integer.replaceAll(group, '')}'
        '${parts.length == 2 ? '.${parts.last}' : ''}';
    final number = double.tryParse(canonical);
    return number != null && number.isFinite ? number : double.nan;
  }
}
