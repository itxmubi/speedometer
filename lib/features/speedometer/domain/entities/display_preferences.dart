import '../../../activities/domain/entities/activity_display_preferences.dart';
import '../../../activities/domain/entities/activity_mode.dart';
import '../../../activities/domain/usecases/estimate_activity_calories_use_case.dart';
import 'gauge_style.dart';
import 'speed_unit.dart';

/// Immutable on-device settings; trips and precise routes live in the database.
final class DisplayPreferences {
  /// Creates offline defaults without requesting permission or starting GPS.
  const DisplayPreferences({
    this.unit = SpeedUnit.kilometersPerHour,
    this.gaugeStyle = GaugeStyle.digital,
    this.mirroredHud = false,
    this.simpleView = false,
    this.darkMode = true,
    this.limitEnabled = false,
    this.speedLimitMetersPerSecond = defaultSpeedLimitMetersPerSecond,
    this.hasDisclosureConsent = false,
    this.keepAwake = false,
    this.brightness = -1,
    this.accentColorIndex = 0,
    this.leftHanded = false,
    this.gaugeRangeMetersPerSecond = defaultGaugeRangeMetersPerSecond,
    this.nightHud = false,
    this.hudShowTime = true,
    this.hudShowCompass = true,
    this.hudShowTrip = false,
    this.soundAlert = false,
    this.vibrationAlert = false,
    this.voiceAlert = false,
    this.alertVolume = 0.7,
    this.alertOffsetMetersPerSecond = 0,
    this.calibrationFactor = 1,
    this.recordRoute = true,
    this.autoRecordTrips = true,
    this.backgroundTracking = true,
    this.localeCode,
    this.economyGps = false,
    this.activityMode = ActivityMode.car,
    this.activityDisplays = const ActivityDisplayPreferences(),
    this.bodyWeightKilograms,
  });

  /// Initial manual limit, equivalent to 100 km/h.
  static const double defaultSpeedLimitMetersPerSecond = 100 / 3.6;

  /// Initial full dial range, equivalent to 200 km/h.
  static const double defaultGaugeRangeMetersPerSecond = 200 / 3.6;

  /// Sanity bound for manual limits and dial ranges.
  static const double maximumSpeedLimitMetersPerSecond = 200;

  /// Lowest configurable full dial range.
  static const double minimumGaugeRangeMetersPerSecond = 1;

  /// Number of supported accessible accent palettes.
  static const int accentColorCount = 10;

  /// Languages with complete application translations.
  static const supportedLocaleCodes = {'en', 'es', 'fr', 'de', 'ar'};

  /// The unit used to present speed.
  final SpeedUnit unit;

  /// The preferred instrument layout.
  final GaugeStyle gaugeStyle;

  /// Whether HUD content is reflected horizontally.
  final bool mirroredHud;

  /// Whether secondary trip information is hidden.
  final bool simpleView;

  /// Whether the dark theme is preferred.
  final bool darkMode;

  /// Whether manual speed warnings are enabled.
  final bool limitEnabled;

  /// The manual limit in canonical metres per second.
  final double speedLimitMetersPerSecond;

  /// Whether the location explanation was accepted.
  final bool hasDisclosureConsent;

  /// Whether a running dashboard prevents screen sleep.
  final bool keepAwake;

  /// Brightness from 0.05 to 1, or -1 for system control.
  final double brightness;

  /// An index into the ten accessible accent palettes.
  final int accentColorIndex;

  /// Whether the instrument is placed on the leading side.
  final bool leftHanded;

  /// The manually chosen full dial range in metres per second.
  final double gaugeRangeMetersPerSecond;

  /// Whether HUD uses a pure-black maximum-contrast surface.
  final bool nightHud;

  /// Whether the HUD shows the current time.
  final bool hudShowTime;

  /// Whether the HUD shows hardware compass heading.
  final bool hudShowCompass;

  /// Whether the HUD shows current trip distance.
  final bool hudShowTrip;

  /// Whether the selected limit triggers an audible warning.
  final bool soundAlert;

  /// Whether the selected limit triggers a haptic warning.
  final bool vibrationAlert;

  /// Whether the selected limit triggers a spoken warning.
  final bool voiceAlert;

  /// The user-selected warning volume between zero and one.
  final double alertVolume;

  /// The nonnegative warning margin above the chosen limit.
  final double alertOffsetMetersPerSecond;

  /// Distance calibration multiplier; GPS speed is not changed.
  final double calibrationFactor;

  /// Whether future accepted fixes retain precise route coordinates.
  final bool recordRoute;

  /// Whether a user-started session is saved automatically.
  final bool autoRecordTrips;

  /// Whether a user-started foreground service continues when minimized.
  final bool backgroundTracking;

  /// An explicitly selected language, or null for the system language.
  final String? localeCode;

  /// Whether GPS updates use the lower-frequency battery option.
  final bool economyGps;

  /// The activity for the next trip; retained until the current trip is ended.
  final ActivityMode activityMode;

  /// Remembered unit, gauge style and dial range for every activity.
  final ActivityDisplayPreferences activityDisplays;

  /// Optional on-device weight used only to estimate activity energy.
  final double? bodyWeightKilograms;

  bool get _hasValidBodyWeight {
    final weight = bodyWeightKilograms;
    return weight == null ||
        (weight.isFinite &&
            weight >= EstimateActivityCaloriesUseCase.minimumWeightKilograms &&
            weight <= EstimateActivityCaloriesUseCase.maximumWeightKilograms);
  }

  /// Whether the manual limit is safe for warning comparisons.
  bool get hasValidSpeedLimit =>
      speedLimitMetersPerSecond.isFinite &&
      speedLimitMetersPerSecond > 0 &&
      speedLimitMetersPerSecond <= maximumSpeedLimitMetersPerSecond;

  /// Rejects corrupt settings before persisting or applying platform effects.
  bool get hasValidValues =>
      hasValidSpeedLimit &&
      brightness.isFinite &&
      (brightness == -1 || (brightness >= 0.05 && brightness <= 1)) &&
      accentColorIndex >= 0 &&
      accentColorIndex < accentColorCount &&
      gaugeRangeMetersPerSecond.isFinite &&
      gaugeRangeMetersPerSecond >= minimumGaugeRangeMetersPerSecond &&
      gaugeRangeMetersPerSecond <= maximumSpeedLimitMetersPerSecond &&
      alertVolume.isFinite &&
      alertVolume >= 0 &&
      alertVolume <= 1 &&
      alertOffsetMetersPerSecond.isFinite &&
      alertOffsetMetersPerSecond >= 0 &&
      alertOffsetMetersPerSecond <= maximumSpeedLimitMetersPerSecond &&
      calibrationFactor.isFinite &&
      calibrationFactor >= 0.5 &&
      calibrationFactor <= 1.5 &&
      activityDisplays.isValid &&
      _hasValidBodyWeight &&
      (localeCode == null || supportedLocaleCodes.contains(localeCode));

  /// Replaces selected settings. Use [clearLocaleCode] for system language.
  DisplayPreferences copyWith({
    SpeedUnit? unit,
    GaugeStyle? gaugeStyle,
    bool? mirroredHud,
    bool? simpleView,
    bool? darkMode,
    bool? limitEnabled,
    double? speedLimitMetersPerSecond,
    bool? hasDisclosureConsent,
    bool? keepAwake,
    double? brightness,
    int? accentColorIndex,
    bool? leftHanded,
    double? gaugeRangeMetersPerSecond,
    bool? nightHud,
    bool? hudShowTime,
    bool? hudShowCompass,
    bool? hudShowTrip,
    bool? soundAlert,
    bool? vibrationAlert,
    bool? voiceAlert,
    double? alertVolume,
    double? alertOffsetMetersPerSecond,
    double? calibrationFactor,
    bool? recordRoute,
    bool? autoRecordTrips,
    bool? backgroundTracking,
    String? localeCode,
    bool? economyGps,
    ActivityMode? activityMode,
    ActivityDisplayPreferences? activityDisplays,
    double? bodyWeightKilograms,
    bool clearBodyWeight = false,
    bool clearLocaleCode = false,
  }) => DisplayPreferences(
    unit: unit ?? this.unit,
    gaugeStyle: gaugeStyle ?? this.gaugeStyle,
    mirroredHud: mirroredHud ?? this.mirroredHud,
    simpleView: simpleView ?? this.simpleView,
    darkMode: darkMode ?? this.darkMode,
    limitEnabled: limitEnabled ?? this.limitEnabled,
    speedLimitMetersPerSecond:
        speedLimitMetersPerSecond ?? this.speedLimitMetersPerSecond,
    hasDisclosureConsent: hasDisclosureConsent ?? this.hasDisclosureConsent,
    keepAwake: keepAwake ?? this.keepAwake,
    brightness: brightness ?? this.brightness,
    accentColorIndex: accentColorIndex ?? this.accentColorIndex,
    leftHanded: leftHanded ?? this.leftHanded,
    gaugeRangeMetersPerSecond:
        gaugeRangeMetersPerSecond ?? this.gaugeRangeMetersPerSecond,
    nightHud: nightHud ?? this.nightHud,
    hudShowTime: hudShowTime ?? this.hudShowTime,
    hudShowCompass: hudShowCompass ?? this.hudShowCompass,
    hudShowTrip: hudShowTrip ?? this.hudShowTrip,
    soundAlert: soundAlert ?? this.soundAlert,
    vibrationAlert: vibrationAlert ?? this.vibrationAlert,
    voiceAlert: voiceAlert ?? this.voiceAlert,
    alertVolume: alertVolume ?? this.alertVolume,
    alertOffsetMetersPerSecond:
        alertOffsetMetersPerSecond ?? this.alertOffsetMetersPerSecond,
    calibrationFactor: calibrationFactor ?? this.calibrationFactor,
    recordRoute: recordRoute ?? this.recordRoute,
    autoRecordTrips: autoRecordTrips ?? this.autoRecordTrips,
    backgroundTracking: backgroundTracking ?? this.backgroundTracking,
    localeCode: clearLocaleCode ? null : localeCode ?? this.localeCode,
    economyGps: economyGps ?? this.economyGps,
    activityMode: activityMode ?? this.activityMode,
    activityDisplays: activityDisplays ?? this.activityDisplays,
    bodyWeightKilograms: clearBodyWeight
        ? null
        : bodyWeightKilograms ?? this.bodyWeightKilograms,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisplayPreferences &&
          unit == other.unit &&
          gaugeStyle == other.gaugeStyle &&
          mirroredHud == other.mirroredHud &&
          simpleView == other.simpleView &&
          darkMode == other.darkMode &&
          limitEnabled == other.limitEnabled &&
          speedLimitMetersPerSecond == other.speedLimitMetersPerSecond &&
          hasDisclosureConsent == other.hasDisclosureConsent &&
          keepAwake == other.keepAwake &&
          brightness == other.brightness &&
          accentColorIndex == other.accentColorIndex &&
          leftHanded == other.leftHanded &&
          gaugeRangeMetersPerSecond == other.gaugeRangeMetersPerSecond &&
          nightHud == other.nightHud &&
          hudShowTime == other.hudShowTime &&
          hudShowCompass == other.hudShowCompass &&
          hudShowTrip == other.hudShowTrip &&
          soundAlert == other.soundAlert &&
          vibrationAlert == other.vibrationAlert &&
          voiceAlert == other.voiceAlert &&
          alertVolume == other.alertVolume &&
          alertOffsetMetersPerSecond == other.alertOffsetMetersPerSecond &&
          calibrationFactor == other.calibrationFactor &&
          recordRoute == other.recordRoute &&
          autoRecordTrips == other.autoRecordTrips &&
          backgroundTracking == other.backgroundTracking &&
          localeCode == other.localeCode &&
          economyGps == other.economyGps &&
          activityMode == other.activityMode &&
          activityDisplays == other.activityDisplays &&
          bodyWeightKilograms == other.bodyWeightKilograms;

  @override
  int get hashCode => Object.hashAll([
    unit,
    gaugeStyle,
    mirroredHud,
    simpleView,
    darkMode,
    limitEnabled,
    speedLimitMetersPerSecond,
    hasDisclosureConsent,
    keepAwake,
    brightness,
    accentColorIndex,
    leftHanded,
    gaugeRangeMetersPerSecond,
    nightHud,
    hudShowTime,
    hudShowCompass,
    hudShowTrip,
    soundAlert,
    vibrationAlert,
    voiceAlert,
    alertVolume,
    alertOffsetMetersPerSecond,
    calibrationFactor,
    recordRoute,
    autoRecordTrips,
    backgroundTracking,
    localeCode,
    economyGps,
    activityMode,
    activityDisplays,
    bodyWeightKilograms,
  ]);
}
