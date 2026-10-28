import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/activities/domain/entities/activity_mode.dart';
import 'package:speedometer/features/activities/domain/usecases/select_activity_use_case.dart';
import 'package:speedometer/features/speedometer/data/models/display_preferences_model.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/gauge_style.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';

void main() {
  group('DisplayPreferencesModel', () {
    test('activity unit style range and optional weight survive restart', () {
      final p = const SelectActivityUseCase()(
        preferences: const DisplayPreferences(
          unit: SpeedUnit.milesPerHour,
          gaugeStyle: GaugeStyle.analog,
          gaugeRangeMetersPerSecond: 45,
          bodyWeightKilograms: 83.5,
        ),
        mode: ActivityMode.boating,
        hasActiveTrip: false,
      ).copyWith(gaugeStyle: GaugeStyle.hud);
      final restored = DisplayPreferencesModel.fromJson(
        DisplayPreferencesModel.fromEntity(p).toJson(),
      ).toEntity();
      expect(restored, p);
      final car = const SelectActivityUseCase()(
        preferences: restored,
        mode: ActivityMode.car,
        hasActiveTrip: false,
      );
      expect(car.unit, SpeedUnit.milesPerHour);
      expect(car.gaugeStyle, GaugeStyle.analog);
      expect(car.gaugeRangeMetersPerSecond, 45);
      expect(car.bodyWeightKilograms, 83.5);
    });

    test('rejects corrupt activity defaults and body weights', () {
      for (final document in [
        '{"bodyWeightKilograms":19}',
        '{"bodyWeightKilograms":301}',
        '{"bodyWeightKilograms":1e999}',
        '{"bodyWeightKilograms":"heavy"}',
        '{"activityDisplays":[]}',
        '{"activityDisplays":{"walking":false}}',
        '{"activityDisplays":{"walking":{"gaugeRangeMetersPerSecond":0}}}',
        '{"activityDisplays":{"walking":{"gaugeRangeMetersPerSecond":201}}}',
      ]) {
        expect(
          () => DisplayPreferencesModel.fromJson(document),
          throwsFormatException,
        );
      }
      final fallback = DisplayPreferencesModel.fromJson(
        '{"activityMode":"future"}',
      ).toEntity();
      expect(fallback.activityMode, ActivityMode.car);
      expect(fallback.bodyWeightKilograms, isNull);
    });
    test('round trips all settings through a JSON document', () {
      const preferences = DisplayPreferences(
        unit: SpeedUnit.milesPerHour,
        gaugeStyle: GaugeStyle.hud,
        mirroredHud: true,
        simpleView: true,
        darkMode: false,
        limitEnabled: true,
        speedLimitMetersPerSecond: 25,
        hasDisclosureConsent: true,
      );

      final encoded = DisplayPreferencesModel.fromEntity(preferences).toJson();
      final restored = DisplayPreferencesModel.fromJson(encoded).toEntity();

      expect(restored, preferences);
    });

    test('accepts integer speed limits from persisted JSON', () {
      final restored = DisplayPreferencesModel.fromJson(
        '{"speedLimitMetersPerSecond": 20}',
      ).toEntity();

      expect(restored.speedLimitMetersPerSecond, 20.0);
    });

    test('missing optional fields load safe defaults', () {
      final restored = DisplayPreferencesModel.fromJson('{}').toEntity();

      expect(restored, const DisplayPreferences());
    });

    test('unknown enums and wrongly typed optional fields use defaults', () {
      final restored = DisplayPreferencesModel.fromJson('''{
        "unit": "futureUnit",
        "gaugeStyle": "futureStyle",
        "mirroredHud": 1,
        "simpleView": "true",
        "darkMode": null,
        "limitEnabled": [],
        "hasDisclosureConsent": "true",
        "unknownFutureSetting": true
      }''').toEntity();

      expect(restored, const DisplayPreferences());
      expect(restored.hasDisclosureConsent, isFalse);
    });

    test('rejects corrupt documents and non-object JSON', () {
      for (final source in ['{', '[]', 'null', 'false', '"settings"']) {
        expect(
          () => DisplayPreferencesModel.fromJson(source),
          throwsFormatException,
        );
      }
    });

    test('rejects nonsensical persisted speed limits', () {
      for (final value in ['-1', '0', '201', '1e999', '"fast"']) {
        expect(
          () => DisplayPreferencesModel.fromJson(
            '{"speedLimitMetersPerSecond": $value}',
          ),
          throwsFormatException,
        );
      }
    });

    test('rejects invalid entity limits before serialization', () {
      for (final value in [double.nan, double.infinity, -1.0, 0.0, 201.0]) {
        expect(
          () => DisplayPreferencesModel.fromEntity(
            DisplayPreferences(speedLimitMetersPerSecond: value),
          ),
          throwsFormatException,
        );
      }
    });
    test(
      'round trips every expanded preference without losing privacy choices',
      () {
        const p = DisplayPreferences(
          keepAwake: true,
          brightness: 0.65,
          accentColorIndex: 9,
          leftHanded: true,
          gaugeRangeMetersPerSecond: 40,
          nightHud: true,
          hudShowTime: false,
          hudShowCompass: false,
          hudShowTrip: true,
          soundAlert: true,
          vibrationAlert: true,
          voiceAlert: true,
          alertVolume: 0.35,
          alertOffsetMetersPerSecond: 3,
          calibrationFactor: 1.03,
          recordRoute: false,
          autoRecordTrips: false,
          backgroundTracking: false,
          localeCode: 'ar',
          economyGps: true,
        );
        final restored = DisplayPreferencesModel.fromJson(
          DisplayPreferencesModel.fromEntity(p).toJson(),
        ).toEntity();
        expect(restored, p);
      },
    );

    test(
      'loads original version-one snapshots with all newly added defaults',
      () {
        final restored = DisplayPreferencesModel.fromJson('''{
        "unit": "milesPerHour", "gaugeStyle": "hud",
        "mirroredHud": true, "simpleView": true, "darkMode": false,
        "limitEnabled": true, "speedLimitMetersPerSecond": 25,
        "hasDisclosureConsent": true
      }''').toEntity();
        expect(
          restored,
          const DisplayPreferences(
            unit: SpeedUnit.milesPerHour,
            gaugeStyle: GaugeStyle.hud,
            mirroredHud: true,
            simpleView: true,
            darkMode: false,
            limitEnabled: true,
            speedLimitMetersPerSecond: 25,
            hasDisclosureConsent: true,
          ),
        );
      },
    );

    test(
      'rejects corrupt expanded numerical fields and unsupported locales',
      () {
        final documents = [
          '{"brightness":0}',
          '{"brightness":1.01}',
          '{"brightness":"bright"}',
          '{"accentColorIndex":10}',
          '{"accentColorIndex":1.5}',
          '{"gaugeRangeMetersPerSecond":0}',
          '{"gaugeRangeMetersPerSecond":201}',
          '{"alertVolume":-1}',
          '{"alertVolume":1.01}',
          '{"alertOffsetMetersPerSecond":-1}',
          '{"alertOffsetMetersPerSecond":1e999}',
          '{"calibrationFactor":0}',
          '{"calibrationFactor":2}',
          '{"localeCode":"zz"}',
          '{"localeCode":23}',
        ];
        for (final document in documents) {
          expect(
            () => DisplayPreferencesModel.fromJson(document),
            throwsFormatException,
          );
        }
      },
    );

    test('keeps nullable system language across serialization', () {
      const p = DisplayPreferences();
      expect(
        DisplayPreferencesModel.fromJson(
          DisplayPreferencesModel.fromEntity(p).toJson(),
        ).toEntity().localeCode,
        isNull,
      );
    });
  });
}
