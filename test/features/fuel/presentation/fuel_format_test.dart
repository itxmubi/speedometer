import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/fuel/presentation/widgets/fuel_format.dart';
import 'package:speedometer/generated/l10n/app_localizations_ar.dart';
import 'package:speedometer/generated/l10n/app_localizations_de.dart';
import 'package:speedometer/generated/l10n/app_localizations_en.dart';
import 'package:speedometer/generated/l10n/app_localizations_fr.dart';

void main() {
  final en = AppLocalizationsEn();
  final de = AppLocalizationsDe();
  final fr = AppLocalizationsFr();
  final ar = AppLocalizationsAr();

  test('parses only correctly grouped or ungrouped locale decimal input', () {
    expect(FuelFormat.parse('12.5', en), 12.5);
    expect(FuelFormat.parse('1,234.5', en), 1234.5);
    expect(FuelFormat.parse('12,5', de), 12.5);
    expect(FuelFormat.parse('1.234,5', de), 1234.5);
    expect(FuelFormat.parse('1\u202f234,5', fr), 1234.5);
    expect(FuelFormat.parse('1\u00a0234,5', fr), 1234.5);
    expect(FuelFormat.parse('1 234,5', fr), 1234.5);
    expect(FuelFormat.parse('.5', en), 0.5);
    expect(FuelFormat.parse(',5', de), 0.5);
    expect(FuelFormat.parse('-5', en), -5);
    expect(FuelFormat.parse(' ', en), 0);
  });

  test(
    'rejects malformed grouping and decimal separators instead of rescaling',
    () {
      for (final value in [
        '12,5',
        '1,2,3',
        '1234,567',
        '1.2.3',
        '1,234.5.6',
        '1 23',
        '1e3',
        'NaN',
        'Infinity',
        '.',
        '--2',
        '2-3',
        '12%',
      ]) {
        expect(FuelFormat.parse(value, en).isNaN, isTrue, reason: value);
      }
      for (final value in ['12.5', '1.2.3', '1234.567', '1,2,3']) {
        expect(FuelFormat.parse(value, de).isNaN, isTrue, reason: value);
      }
      expect(FuelFormat.parse('12.5', fr).isNaN, isTrue);
    },
  );

  test('accepts Arabic and Persian digits and explicit Arabic separators', () {
    expect(FuelFormat.parse('١٢٫٥', ar), 12.5);
    expect(FuelFormat.parse('۱۲٫۵', ar), 12.5);
    expect(FuelFormat.parse('١٬٢٣٤٫٥', ar), 1234.5);
    expect(FuelFormat.parse('١٢.٥', ar), 12.5);
    expect(FuelFormat.parse('\u061c-١٢٫٥', ar), -12.5);
    expect(FuelFormat.parse('١٢٬٥', ar).isNaN, isTrue);
    expect(FuelFormat.parse('١٬٢٬٣', ar).isNaN, isTrue);
  });

  test(
    'edit input preserves volume precision across every supported formatter',
    () {
      for (final locale in [en, de, fr, ar]) {
        final text = FuelFormat.inputNumber(3.785411784, locale);
        expect(FuelFormat.parse(text, locale), closeTo(3.785411784, 1e-12));
      }
    },
  );
}
