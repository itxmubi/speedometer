import 'dart:convert';

import '../../../activities/domain/entities/activity_display_defaults.dart';
import '../../../activities/domain/entities/activity_display_preferences.dart';
import '../../../activities/domain/entities/activity_mode.dart';
import '../../domain/entities/display_preferences.dart';
import '../../domain/entities/gauge_style.dart';
import '../../domain/entities/speed_unit.dart';

/// Maps backward-compatible version-one JSON settings to immutable domain data.
final class DisplayPreferencesModel {
  const DisplayPreferencesModel._(this._preferences);

  /// Validates a snapshot before it crosses the persistence boundary.
  factory DisplayPreferencesModel.fromEntity(DisplayPreferences preferences) {
    if (!preferences.hasValidValues) {
      throw const FormatException('Invalid preferences values');
    }
    return DisplayPreferencesModel._(preferences);
  }

  /// Missing fields use defaults so existing version-one documents still load.
  factory DisplayPreferencesModel.fromJson(String source) {
    final Object? decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Expected a preferences object');
    }
    const defaults = DisplayPreferences();
    final preferences = DisplayPreferences(
      unit: _enumValue(SpeedUnit.values, decoded['unit'], defaults.unit),
      gaugeStyle: _enumValue(
        GaugeStyle.values,
        decoded['gaugeStyle'],
        defaults.gaugeStyle,
      ),
      mirroredHud: _boolValue(decoded['mirroredHud'], defaults.mirroredHud),
      simpleView: _boolValue(decoded['simpleView'], defaults.simpleView),
      darkMode: _boolValue(decoded['darkMode'], defaults.darkMode),
      limitEnabled: _boolValue(decoded['limitEnabled'], defaults.limitEnabled),
      speedLimitMetersPerSecond: _number(
        decoded['speedLimitMetersPerSecond'],
        defaults.speedLimitMetersPerSecond,
      ),
      hasDisclosureConsent: _boolValue(
        decoded['hasDisclosureConsent'],
        defaults.hasDisclosureConsent,
      ),
      keepAwake: _boolValue(decoded['keepAwake'], defaults.keepAwake),
      brightness: _number(decoded['brightness'], defaults.brightness),
      accentColorIndex: _integer(
        decoded['accentColorIndex'],
        defaults.accentColorIndex,
      ),
      leftHanded: _boolValue(decoded['leftHanded'], defaults.leftHanded),
      gaugeRangeMetersPerSecond: _number(
        decoded['gaugeRangeMetersPerSecond'],
        defaults.gaugeRangeMetersPerSecond,
      ),
      nightHud: _boolValue(decoded['nightHud'], defaults.nightHud),
      hudShowTime: _boolValue(decoded['hudShowTime'], defaults.hudShowTime),
      hudShowCompass: _boolValue(
        decoded['hudShowCompass'],
        defaults.hudShowCompass,
      ),
      hudShowTrip: _boolValue(decoded['hudShowTrip'], defaults.hudShowTrip),
      soundAlert: _boolValue(decoded['soundAlert'], defaults.soundAlert),
      vibrationAlert: _boolValue(
        decoded['vibrationAlert'],
        defaults.vibrationAlert,
      ),
      voiceAlert: _boolValue(decoded['voiceAlert'], defaults.voiceAlert),
      alertVolume: _number(decoded['alertVolume'], defaults.alertVolume),
      alertOffsetMetersPerSecond: _number(
        decoded['alertOffsetMetersPerSecond'],
        defaults.alertOffsetMetersPerSecond,
      ),
      calibrationFactor: _number(
        decoded['calibrationFactor'],
        defaults.calibrationFactor,
      ),
      recordRoute: _boolValue(decoded['recordRoute'], defaults.recordRoute),
      autoRecordTrips: _boolValue(
        decoded['autoRecordTrips'],
        defaults.autoRecordTrips,
      ),
      backgroundTracking: _boolValue(
        decoded['backgroundTracking'],
        defaults.backgroundTracking,
      ),
      localeCode: _locale(decoded['localeCode']),
      economyGps: _boolValue(decoded['economyGps'], defaults.economyGps),
      activityMode: _enumValue(
        ActivityMode.values,
        decoded['activityMode'],
        defaults.activityMode,
      ),
      activityDisplays: _activityDisplays(decoded['activityDisplays']),
      bodyWeightKilograms: switch (decoded['bodyWeightKilograms']) {
        null => null,
        num value => value.toDouble(),
        _ => throw const FormatException('Expected a numeric body weight'),
      },
    );
    return DisplayPreferencesModel.fromEntity(preferences);
  }

  final DisplayPreferences _preferences;

  /// Returns settings without leaking serialization details.
  DisplayPreferences toEntity() => _preferences;

  /// Serializes small settings only, never trips or GPS samples.
  String toJson() => jsonEncode(<String, Object?>{
    'unit': _preferences.unit.name,
    'gaugeStyle': _preferences.gaugeStyle.name,
    'mirroredHud': _preferences.mirroredHud,
    'simpleView': _preferences.simpleView,
    'darkMode': _preferences.darkMode,
    'limitEnabled': _preferences.limitEnabled,
    'speedLimitMetersPerSecond': _preferences.speedLimitMetersPerSecond,
    'hasDisclosureConsent': _preferences.hasDisclosureConsent,
    'keepAwake': _preferences.keepAwake,
    'brightness': _preferences.brightness,
    'accentColorIndex': _preferences.accentColorIndex,
    'leftHanded': _preferences.leftHanded,
    'gaugeRangeMetersPerSecond': _preferences.gaugeRangeMetersPerSecond,
    'nightHud': _preferences.nightHud,
    'hudShowTime': _preferences.hudShowTime,
    'hudShowCompass': _preferences.hudShowCompass,
    'hudShowTrip': _preferences.hudShowTrip,
    'soundAlert': _preferences.soundAlert,
    'vibrationAlert': _preferences.vibrationAlert,
    'voiceAlert': _preferences.voiceAlert,
    'alertVolume': _preferences.alertVolume,
    'alertOffsetMetersPerSecond': _preferences.alertOffsetMetersPerSecond,
    'calibrationFactor': _preferences.calibrationFactor,
    'recordRoute': _preferences.recordRoute,
    'autoRecordTrips': _preferences.autoRecordTrips,
    'backgroundTracking': _preferences.backgroundTracking,
    'localeCode': _preferences.localeCode,
    'economyGps': _preferences.economyGps,
    'activityMode': _preferences.activityMode.name,
    'bodyWeightKilograms': _preferences.bodyWeightKilograms,
    'activityDisplays': {
      for (final mode in ActivityMode.values)
        mode.name: _displayJson(_preferences.activityDisplays.forMode(mode)),
    },
  });

  static Map<String, Object?> _displayJson(ActivityDisplayDefaults value) => {
    'unit': value.unit.name,
    'gaugeStyle': value.gaugeStyle.name,
    'gaugeRangeMetersPerSecond': value.gaugeRangeMetersPerSecond,
  };

  static ActivityDisplayPreferences _activityDisplays(Object? raw) {
    var result = const ActivityDisplayPreferences();
    if (raw == null) return result;
    if (raw is! Map<String, Object?>) {
      throw const FormatException('Expected activity display settings');
    }
    for (final mode in ActivityMode.values) {
      final value = raw[mode.name];
      if (value == null) continue;
      if (value is! Map<String, Object?>) {
        throw const FormatException('Expected activity display settings');
      }
      final defaults = result.forMode(mode);
      result = result.withMode(
        mode,
        ActivityDisplayDefaults(
          unit: _enumValue(SpeedUnit.values, value['unit'], defaults.unit),
          gaugeStyle: _enumValue(
            GaugeStyle.values,
            value['gaugeStyle'],
            defaults.gaugeStyle,
          ),
          gaugeRangeMetersPerSecond: _number(
            value['gaugeRangeMetersPerSecond'],
            defaults.gaugeRangeMetersPerSecond,
          ),
        ),
      );
    }
    return result;
  }

  static T _enumValue<T extends Enum>(List<T> values, Object? raw, T fallback) {
    for (final value in values) {
      if (value.name == raw) return value;
    }
    return fallback;
  }

  static bool _boolValue(Object? raw, bool fallback) => switch (raw) {
    bool value => value,
    _ => fallback,
  };

  static double _number(Object? raw, double fallback) => switch (raw) {
    null => fallback,
    num value => value.toDouble(),
    _ => throw const FormatException('Expected a numeric preference'),
  };

  static int _integer(Object? raw, int fallback) => switch (raw) {
    null => fallback,
    int value => value,
    _ => throw const FormatException('Expected an integer preference'),
  };

  static String? _locale(Object? raw) => switch (raw) {
    null => null,
    String value when DisplayPreferences.supportedLocaleCodes.contains(value) =>
      value,
    _ => throw const FormatException('Unsupported locale preference'),
  };
}
