import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/gauge_style.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';

void main() {
  group('DisplayPreferences', () {
    test('starts with dark digital view and no location consent or alerts', () {
      const preferences = DisplayPreferences();

      expect(preferences.unit, SpeedUnit.kilometersPerHour);
      expect(preferences.gaugeStyle, GaugeStyle.digital);
      expect(preferences.darkMode, isTrue);
      expect(preferences.hasDisclosureConsent, isFalse);
      expect(preferences.limitEnabled, isFalse);
      expect(preferences.mirroredHud, isFalse);
      expect(preferences.simpleView, isFalse);
      expect(preferences.speedLimitMetersPerSecond, closeTo(100 / 3.6, 0.001));
      expect(preferences.hasValidSpeedLimit, isTrue);
    });

    test('copyWith replaces every field without modifying the original', () {
      const original = DisplayPreferences();

      final replacement = original.copyWith(
        unit: SpeedUnit.knots,
        gaugeStyle: GaugeStyle.hud,
        mirroredHud: true,
        simpleView: true,
        darkMode: false,
        limitEnabled: true,
        speedLimitMetersPerSecond: 15,
        hasDisclosureConsent: true,
      );

      expect(
        replacement,
        const DisplayPreferences(
          unit: SpeedUnit.knots,
          gaugeStyle: GaugeStyle.hud,
          mirroredHud: true,
          simpleView: true,
          darkMode: false,
          limitEnabled: true,
          speedLimitMetersPerSecond: 15,
          hasDisclosureConsent: true,
        ),
      );
      expect(original, const DisplayPreferences());
      expect(replacement.copyWith(), replacement);
      expect(replacement.copyWith().hashCode, replacement.hashCode);
    });

    test('invalid limits never pass the domain sanity check', () {
      for (final value in [
        double.nan,
        double.infinity,
        double.negativeInfinity,
        -1.0,
        0.0,
        DisplayPreferences.maximumSpeedLimitMetersPerSecond + 1,
      ]) {
        expect(
          DisplayPreferences(
            speedLimitMetersPerSecond: value,
          ).hasValidSpeedLimit,
          isFalse,
        );
      }
      expect(
        const DisplayPreferences(
          speedLimitMetersPerSecond:
              DisplayPreferences.maximumSpeedLimitMetersPerSecond,
        ).hasValidSpeedLimit,
        isTrue,
      );
    });
    test(
      'new settings default to valid values without platform side effects',
      () {
        const p = DisplayPreferences();
        expect(p.hasValidValues, isTrue);
        expect(p.keepAwake, isFalse);
        expect(p.brightness, -1);
        expect(p.accentColorIndex, 0);
        expect(p.soundAlert || p.vibrationAlert || p.voiceAlert, isFalse);
        expect(p.backgroundTracking, isTrue);
        expect(p.recordRoute, isTrue);
        expect(p.autoRecordTrips, isTrue);
        expect(p.localeCode, isNull);
        expect(p.calibrationFactor, 1);
      },
    );

    test(
      'copies and compares every new setting and clears selected locale',
      () {
        const original = DisplayPreferences();
        final changes = [
          original.copyWith(keepAwake: true),
          original.copyWith(brightness: 0.8),
          original.copyWith(accentColorIndex: 9),
          original.copyWith(leftHanded: true),
          original.copyWith(gaugeRangeMetersPerSecond: 30),
          original.copyWith(nightHud: true),
          original.copyWith(hudShowTime: false),
          original.copyWith(hudShowCompass: false),
          original.copyWith(hudShowTrip: true),
          original.copyWith(soundAlert: true),
          original.copyWith(vibrationAlert: true),
          original.copyWith(voiceAlert: true),
          original.copyWith(alertVolume: 0.1),
          original.copyWith(alertOffsetMetersPerSecond: 2),
          original.copyWith(calibrationFactor: 1.03),
          original.copyWith(recordRoute: false),
          original.copyWith(autoRecordTrips: false),
          original.copyWith(backgroundTracking: false),
          original.copyWith(localeCode: 'ar'),
          original.copyWith(economyGps: true),
        ];
        for (final changed in changes) {
          expect(changed, isNot(original));
          expect(changed.copyWith(), changed);
          expect(changed.copyWith().hashCode, changed.hashCode);
          expect(changed.hasValidValues, isTrue);
        }
        expect(
          original.copyWith(localeCode: 'ar').copyWith(clearLocaleCode: true),
          original,
        );
      },
    );

    test('rejects unsafe platform settings and corrupt numerical values', () {
      const p = DisplayPreferences();
      final invalid = [
        p.copyWith(brightness: 0),
        p.copyWith(brightness: -0.5),
        p.copyWith(brightness: 1.1),
        p.copyWith(brightness: double.nan),
        p.copyWith(accentColorIndex: -1),
        p.copyWith(accentColorIndex: 10),
        p.copyWith(gaugeRangeMetersPerSecond: 0.9),
        p.copyWith(gaugeRangeMetersPerSecond: 201),
        p.copyWith(gaugeRangeMetersPerSecond: double.infinity),
        p.copyWith(alertVolume: -0.1),
        p.copyWith(alertVolume: 1.1),
        p.copyWith(alertVolume: double.nan),
        p.copyWith(alertOffsetMetersPerSecond: -1),
        p.copyWith(alertOffsetMetersPerSecond: 201),
        p.copyWith(alertOffsetMetersPerSecond: double.infinity),
        p.copyWith(calibrationFactor: 0.49),
        p.copyWith(calibrationFactor: 1.51),
        p.copyWith(calibrationFactor: double.nan),
        p.copyWith(localeCode: 'unknown'),
      ];
      for (final settings in invalid) {
        expect(settings.hasValidValues, isFalse);
      }
    });

    test('accepts inclusive numerical boundaries and supported languages', () {
      const p = DisplayPreferences();
      for (final settings in [
        p.copyWith(brightness: 0.05),
        p.copyWith(brightness: 1),
        p.copyWith(gaugeRangeMetersPerSecond: 1),
        p.copyWith(gaugeRangeMetersPerSecond: 200),
        p.copyWith(alertVolume: 0),
        p.copyWith(alertVolume: 1),
        p.copyWith(alertOffsetMetersPerSecond: 0),
        p.copyWith(alertOffsetMetersPerSecond: 200),
        p.copyWith(calibrationFactor: 0.5),
        p.copyWith(calibrationFactor: 1.5),
        for (final code in DisplayPreferences.supportedLocaleCodes)
          p.copyWith(localeCode: code),
      ]) {
        expect(settings.hasValidValues, isTrue);
      }
    });
  });
}
