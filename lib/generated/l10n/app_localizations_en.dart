// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Speedometer';

  @override
  String get appTagline => 'ACCURATE. PRIVATE. FREE.';

  @override
  String get dashboardTitle => 'Live dashboard';

  @override
  String get dashboardSubtitle => 'A little more clarity for every journey.';

  @override
  String get settings => 'Settings';

  @override
  String get backToDashboard => 'Back to dashboard';

  @override
  String get digital => 'Digital';

  @override
  String get analog => 'Analog';

  @override
  String get hud => 'HUD';

  @override
  String get displayMode => 'Display mode';

  @override
  String get currentSpeed => 'CURRENT SPEED';

  @override
  String get speedUnit => 'Speed unit';

  @override
  String get unitKilometers => 'km/h';

  @override
  String get unitMiles => 'mph';

  @override
  String get unitMeters => 'm/s';

  @override
  String get unitKnots => 'kn';

  @override
  String get unitKilometersFull => 'Kilometers per hour';

  @override
  String get unitMilesFull => 'Miles per hour';

  @override
  String get unitMetersFull => 'Meters per second';

  @override
  String get unitKnotsFull => 'Knots';

  @override
  String get kilometers => 'km';

  @override
  String get miles => 'mi';

  @override
  String get nauticalMiles => 'nmi';

  @override
  String get meters => 'm';

  @override
  String get gpsStandby => 'GPS on standby';

  @override
  String get gpsSearching => 'Finding GPS signal';

  @override
  String get gpsLive => 'GPS connected';

  @override
  String get gpsPaused => 'GPS paused';

  @override
  String get gpsUnavailable => 'GPS unavailable';

  @override
  String accuracyValue(String value) {
    return '±$value m accuracy';
  }

  @override
  String speedSemantics(String value, String unit) {
    return 'Current speed $value $unit';
  }

  @override
  String get startPrompt => 'Ready when you are';

  @override
  String get startHint => 'Start a trip to see your live GPS speed.';

  @override
  String get searchingHint => 'A clear view of the sky helps GPS find you.';

  @override
  String get pausedHint => 'Your trip is paused. Resume when you are ready.';

  @override
  String get trackingHint =>
      'GPS is active. Use the trip controls or notification to stop.';

  @override
  String get thisTrip => 'This trip';

  @override
  String get sessionOnly => 'Local trip · saved when you finish';

  @override
  String get tripDistance => 'DISTANCE';

  @override
  String get averageSpeed => 'AVERAGE SPEED';

  @override
  String get topSpeed => 'TOP SPEED';

  @override
  String get tripDuration => 'DURATION';

  @override
  String get movingAverage => 'Moving average';

  @override
  String get movingTime => 'Moving time';

  @override
  String get altitude => 'Altitude';

  @override
  String get heading => 'Heading';

  @override
  String get unavailableValue => '—';

  @override
  String durationValue(String hours, String minutes, String seconds) {
    return '$hours:$minutes:$seconds';
  }

  @override
  String headingValue(String value) {
    return '$value°';
  }

  @override
  String measurementValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get startTrip => 'Start trip';

  @override
  String get pauseTrip => 'Pause trip';

  @override
  String get resumeTrip => 'Resume trip';

  @override
  String get startingTrip => 'Connecting…';

  @override
  String get resetTrip => 'Reset trip';

  @override
  String get resetTitle => 'Start fresh?';

  @override
  String get resetMessage =>
      'This stops tracking and discards the current trip. Earlier saved trips, the total odometer and calendar distance totals are kept.';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get exitAppTitle => 'Exit app?';

  @override
  String get exitAppMessage => 'Do you want to close the app?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get privacyFooter => 'Offline by design. No account. No uploads.';

  @override
  String get safeDriving =>
      'Set up before you move. Keep your attention on the road.';

  @override
  String get speedLimit => 'Speed limit';

  @override
  String limitValue(String value, String unit) {
    return 'LIMIT $value $unit';
  }

  @override
  String get overLimit => 'Over your speed limit';

  @override
  String get overLimitSemantics =>
      'Warning: you are over your selected speed limit.';

  @override
  String get mirrorHud => 'Mirror HUD';

  @override
  String get mirrorHudSubtitle =>
      'Flip the readout for a windshield reflection.';

  @override
  String get hudHint =>
      'For a clear, glanceable view. Position your phone safely before moving.';

  @override
  String get displaySettings => 'Your display';

  @override
  String get displaySettingsDescription =>
      'Make the dashboard feel right for you.';

  @override
  String get simpleView => 'Simple view';

  @override
  String get simpleViewSubtitle => 'Keep the focus on your current speed.';

  @override
  String get darkMode => 'Dark appearance';

  @override
  String get darkModeSubtitle => 'A softer display for the journey after dark.';

  @override
  String get warningSettings => 'Speed warnings';

  @override
  String get warningSettingsDescription =>
      'Choose a personal limit and the warnings you prefer.';

  @override
  String get enableWarning => 'Enable speed warning';

  @override
  String get enableWarningSubtitle =>
      'Show a warning above your selected limit and margin.';

  @override
  String get warningScope =>
      'Sound, vibration and speech are optional. A warning is an aid; keep your attention on the road. Device sound settings and hardware can affect audible and haptic alerts.';

  @override
  String get decreaseLimit => 'Decrease speed limit';

  @override
  String get increaseLimit => 'Increase speed limit';

  @override
  String get privacySettings => 'Privacy, by design';

  @override
  String get privacySettingsDescription =>
      'Your location powers the speedometer on this device. No location or trip data is uploaded.';

  @override
  String get foregroundDisclosure =>
      'GPS starts only when you tap Start trip. With background tracking enabled, a visible notification keeps tracking when you leave the app and offers a Stop button. Trips and optional precise routes stay on this device until you delete them or explicitly export a file. No account or automatic uploads.';

  @override
  String get precisionDisclaimer =>
      'GPS readings can vary with signal conditions. This app is an aid, not a replacement for your vehicle’s speedometer.';

  @override
  String get permissionEyebrow => 'LET’S GET YOU READY';

  @override
  String get permissionTitle => 'Your journey.\nYour privacy.';

  @override
  String get permissionDescription =>
      'A clear view of your speed starts with your phone’s GPS.';

  @override
  String get permissionLocationTitle => 'Location, with a purpose';

  @override
  String get permissionLocationBody =>
      'Precise location lets us read the speed reported by GPS and measure your trip distance.';

  @override
  String get permissionOfflineTitle => 'Always on your device';

  @override
  String get permissionOfflineBody =>
      'No account, no automatic uploads, and no internet needed. Trips and optional precise routes are saved on this device. You can turn route storage off, export a local backup or delete your data in Settings.';

  @override
  String get permissionControlTitle => 'You are in control';

  @override
  String get permissionControlBody =>
      'GPS starts when you tap Start trip. A visible notification can keep tracking when minimized and has a Stop button. Background tracking, route recording and warnings are controlled in Settings.';

  @override
  String get permissionContinue => 'Continue to dashboard';

  @override
  String get permissionRequestHint =>
      'We will ask for location permission when you start your first trip.';

  @override
  String get failurePermissionDenied =>
      'Location permission is needed to show GPS speed. Tap Start trip to try again.';

  @override
  String get failurePermissionDeniedForever =>
      'Location access is turned off for this app. Enable precise location in app settings to start a trip.';

  @override
  String get failureLocationDisabled =>
      'Your device’s location service is off. Turn it on to find your GPS speed.';

  @override
  String get failureLocationUnavailable =>
      'A reliable GPS reading is not available yet. Try again with a clear view of the sky.';

  @override
  String get failureUnsupported =>
      'GPS tracking is not supported on this platform. The dashboard and display settings are available to preview.';

  @override
  String get failureStorage =>
      'Your local data could not be read or saved. Please try again.';

  @override
  String get failureUnexpected =>
      'Something interrupted the trip. Please try again.';

  @override
  String get openAppSettings => 'Open app settings';

  @override
  String get openLocationSettings => 'Turn on location';

  @override
  String get dismissError => 'Dismiss message';

  @override
  String get preferencesLoadFailure =>
      'Your saved preferences could not be loaded.';

  @override
  String get retry => 'Try again';

  @override
  String get continueWithDefaults => 'Continue with default settings';

  @override
  String get loadingPreferences => 'Getting your dashboard ready…';

  @override
  String get startupTitle => 'A clearer journey starts here.';

  @override
  String get keepAwake => 'Keep screen awake';

  @override
  String get keepAwakeDescription =>
      'Prevent screen sleep while tracking with the dashboard visible.';

  @override
  String get brightness => 'Display brightness';

  @override
  String get systemBrightness => 'Use system brightness';

  @override
  String get brightnessDescription =>
      'Only changes this app. System brightness returns when you leave.';

  @override
  String get accentColor => 'Instrument color';

  @override
  String get colorLime => 'Lime';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorCyan => 'Cyan';

  @override
  String get colorAmber => 'Amber';

  @override
  String get colorRose => 'Rose';

  @override
  String get colorLavender => 'Lavender';

  @override
  String get colorMint => 'Mint';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorWhite => 'White';

  @override
  String get colorPink => 'Pink';

  @override
  String get leftHanded => 'Left-handed layout';

  @override
  String get leftHandedDescription =>
      'Place the instrument on the left in wide layouts.';

  @override
  String get gaugeRange => 'Full gauge range';

  @override
  String get nightHud => 'Maximum-contrast HUD';

  @override
  String get nightHudDescription =>
      'Use a pure-black HUD with a bright readout for night driving.';

  @override
  String get hudContent => 'HUD information';

  @override
  String get hudTime => 'Show time';

  @override
  String get hudCompass => 'Show compass';

  @override
  String get hudTrip => 'Show trip distance';

  @override
  String get soundAlert => 'Sound warning';

  @override
  String get vibrationAlert => 'Vibration warning';

  @override
  String get voiceAlert => 'Spoken warning';

  @override
  String get alertVolume => 'Warning volume';

  @override
  String get alertOffset => 'Warning margin above limit';

  @override
  String get alertOffsetDescription =>
      'The warning starts at your limit plus this margin.';

  @override
  String get calibration => 'Distance calibration';

  @override
  String get calibrationDescription =>
      'Adjust future distance measurements to match a reference odometer. GPS speed and previously recorded distances stay unchanged.';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageArabic => 'العربية';

  @override
  String get trackingSettings => 'Tracking and recording';

  @override
  String get autoRecordTrips => 'Save trips automatically';

  @override
  String get autoRecordTripsDescription =>
      'Save each session you explicitly start. Finish a trip to add it to history. GPS never starts automatically.';

  @override
  String get recordRoute => 'Save precise route';

  @override
  String get recordRouteDescription =>
      'Keep start/end coordinates and accepted GPS points locally for the map, replay and GPX export. Turn off to save only statistics and speed samples. Existing routes remain until deleted.';

  @override
  String get backgroundTracking => 'Continue when minimized';

  @override
  String get backgroundTrackingDescription =>
      'After you tap Start trip, a visible location-service notification keeps GPS active outside the app. Use its Stop button to end recording. No background-location permission is requested.';

  @override
  String get economyGps => 'Battery-friendly GPS';

  @override
  String get economyGpsDescription =>
      'Request a fix about every 3 seconds instead of every second. Accuracy and responsiveness depend on your device.';

  @override
  String get overlaySettings => 'Floating speedometer';

  @override
  String get overlayDescription =>
      'Show speed over other apps while a trip is running. Drag to move and use the corner handle to resize.';

  @override
  String get enableOverlay => 'Show floating speedometer';

  @override
  String get disableOverlay => 'Hide floating speedometer';

  @override
  String get overlayPermissionTitle => 'Allow a floating speedometer?';

  @override
  String get overlayPermissionBody =>
      'Android needs permission to display the speed readout over navigation and other apps. The overlay only shows this app’s speed and warning state; it does not read the content of other apps. You can hide it here or stop your trip from the notification.';

  @override
  String get openOverlaySettings => 'Allow display over other apps';

  @override
  String get continueAction => 'Continue';

  @override
  String get backupSettings => 'Local backup and data';

  @override
  String get backupDescription =>
      'Backups include settings, optional body weight, trips, saved precise routes, fuel records and vehicle costs. Share them only with people and apps you trust. Nothing uploads automatically.';

  @override
  String get exportBackup => 'Export local backup';

  @override
  String get restoreBackup => 'Restore local backup';

  @override
  String get restoreBackupTitle => 'Restore a backup?';

  @override
  String get restoreBackupMessage =>
      'A valid backup replaces saved trips, odometer, fuel records, vehicle costs and settings on this device. Export a backup first to keep your current data. Tracking stops before restoring.';

  @override
  String get deleteAllData => 'Delete all local data';

  @override
  String get deleteAllDataTitle => 'Delete all local data?';

  @override
  String get deleteAllDataMessage =>
      'This stops tracking and permanently deletes trips, precise routes, the odometer, fuel records, vehicle costs and saved settings on this device. Previously exported files are not deleted.';

  @override
  String get deleteAction => 'Delete';

  @override
  String get resetPreferences => 'Reset settings';

  @override
  String get resetPreferencesTitle => 'Reset settings?';

  @override
  String get resetPreferencesMessage =>
      'Restore default display, warning and recording settings. Saved trips and the odometer are kept.';

  @override
  String get odometer => 'Total odometer';

  @override
  String get todayDistance => 'Today';

  @override
  String get weekDistance => 'This week';

  @override
  String get monthDistance => 'This month';

  @override
  String get compass => 'Device compass';

  @override
  String get compassUnavailable => 'Compass unavailable on this device';

  @override
  String get courseOverGround => 'GPS course over ground';

  @override
  String get tripHistory => 'Trip history';

  @override
  String get finishTrip => 'Finish and save trip';

  @override
  String get platformUnsupported =>
      'This device does not support that feature.';

  @override
  String get invalidBackup => 'The selected backup is invalid or incompatible.';

  @override
  String get storageMessage =>
      'Your local data could not be read or saved. Please try again.';

  @override
  String get warningSpoken => 'You are above your selected speed limit.';

  @override
  String get notificationTitle => 'Speedometer tracking';

  @override
  String get notificationStop => 'Stop';

  @override
  String get nativePaused => 'Tracking paused';

  @override
  String get nativeTracking => 'Tracking active';

  @override
  String get overlayPermissionMessage =>
      'Allow Speedometer to appear over other apps, then return and enable the overlay.';

  @override
  String get backupRestored => 'Your backup has been restored.';

  @override
  String get sessionRecordingOff =>
      'Trip saving is off · odometer stays on this device';

  @override
  String get timeLabel => 'Time';

  @override
  String get tripHistoryEmpty => 'Your journeys will appear here';

  @override
  String get tripHistoryEmptyDescription =>
      'Start a trip on the dashboard, then finish it to keep the statistics and optional route on this device.';

  @override
  String get tripDetail => 'Trip details';

  @override
  String get tripNotFound => 'This trip is no longer available.';

  @override
  String get tripInProgress => 'In progress';

  @override
  String get tripFinished => 'Finished';

  @override
  String get deleteTrip => 'Delete trip';

  @override
  String get deleteTripTitle => 'Delete this trip?';

  @override
  String get deleteTripMessage =>
      'This permanently removes its statistics and saved route from this device. Your total odometer and calendar distance totals are kept. Exported files are not deleted.';

  @override
  String get tripRoute => 'Recorded route';

  @override
  String get tripRouteDescription =>
      'Offline map with coarse land outlines. Pinch to zoom and drag to explore. Streets are not included. Breaks mark pauses or periods without a saved route.';

  @override
  String get tripNoRoute =>
      'No route was saved. Speed samples and statistics are still available.';

  @override
  String get tripStartPoint => 'First saved point';

  @override
  String get tripEndPoint => 'Last saved point';

  @override
  String get tripSpeedGraph => 'Speed over time';

  @override
  String get tripSpeedGraphDescription =>
      'Speed samples are shown against elapsed trip time. Gaps separate pauses and missing GPS intervals.';

  @override
  String get tripNoSamples => 'No accepted GPS samples were recorded.';

  @override
  String get tripReplay => 'Route replay';

  @override
  String get tripReplayPlay => 'Play route replay';

  @override
  String get tripReplayPause => 'Pause route replay';

  @override
  String get tripReplayProgress => 'Replay position';

  @override
  String get tripReplayDescription =>
      'Replay follows the saved samples. Dashed segments and warning markers identify samples above the speed limit selected during recording.';

  @override
  String get tripOverLimitLegend => 'Warning markers: above selected limit';

  @override
  String get tripExportGpx => 'Share GPX route';

  @override
  String get tripExportCsv => 'Share CSV samples';

  @override
  String get tripShareSummary => 'Share trip summary';

  @override
  String get tripExportDisclosure =>
      'Exports can include precise saved coordinates. Only share them with apps and people you trust.';

  @override
  String get tripChartSemantics => 'Recorded speed graph';

  @override
  String get tripRouteSemantics =>
      'Saved route with start, end and replay position markers';

  @override
  String tripSummaryText(
    String date,
    String distance,
    String duration,
    String average,
    String maximum,
  ) {
    return 'Trip on $date\nDistance: $distance\nDuration: $duration\nAverage: $average\nTop speed: $maximum';
  }

  @override
  String tripSamplePosition(String position, String total) {
    return 'Sample $position of $total';
  }

  @override
  String tripSampleTime(String time) {
    return 'Recorded at $time';
  }

  @override
  String get tripBasemapAttribution =>
      'Land outlines: Natural Earth (public domain). Coarse global basemap; streets are not included.';

  @override
  String get activitySettings => 'Activity';

  @override
  String get activityDescription =>
      'Each activity remembers its unit, gauge style and dial range.';

  @override
  String get activityMode => 'Activity mode';

  @override
  String get activityCar => 'Car';

  @override
  String get activityCycling => 'Cycling';

  @override
  String get activityWalking => 'Walking';

  @override
  String get activityRunning => 'Running';

  @override
  String get activityBoating => 'Boating';

  @override
  String get activityLocked =>
      'Finish or reset the current trip before changing activity or weight.';

  @override
  String get bodyWeight => 'Body weight';

  @override
  String get bodyWeightDescription =>
      'Stored locally for a rough calorie estimate. Included in local backups.';

  @override
  String get bodyWeightEnabled => 'Estimate calories';

  @override
  String get bodyWeightEnabledDescription =>
      'Add your weight to estimate calories for cycling, walking and running.';

  @override
  String get kilograms => 'kg';

  @override
  String get estimatedCalories => 'Estimated calories';

  @override
  String get kilocalories => 'kcal';

  @override
  String get calorieEstimateDescription =>
      'Rough total energy estimate at moderate effort, based on moving time and weight. Actual energy use varies.';

  @override
  String get fuelCosts => 'Fuel and vehicle costs';

  @override
  String get fuelLogEmpty => 'No fuel or vehicle costs yet';

  @override
  String get fuelLogDescription =>
      'Record fuel and the distance it covered. For maintenance only, leave fuel and distance at zero. Keep recorded trips as your mileage log. Currency totals stay separate; no exchange rates are applied.';

  @override
  String get fuelAddEntry => 'Add entry';

  @override
  String get fuelEditEntry => 'Edit entry';

  @override
  String get fuelDeleteEntry => 'Delete entry';

  @override
  String get fuelDeleteConfirmation => 'Delete this fuel and cost entry?';

  @override
  String get fuelEntryDate => 'Date';

  @override
  String get fuelDistance => 'Distance covered';

  @override
  String get fuelVolume => 'Fuel used';

  @override
  String get fuelVolumeUnit => 'Fuel unit';

  @override
  String get fuelDistanceUnit => 'Distance unit';

  @override
  String get fuelLiters => 'L';

  @override
  String get fuelUsGallons => 'US gal';

  @override
  String get fuelCost => 'Fuel cost';

  @override
  String get fuelOtherCost => 'Other vehicle costs';

  @override
  String get fuelCurrency => 'Currency code';

  @override
  String get fuelCurrencyHint => 'Three letters, such as USD or AED';

  @override
  String get fuelNote => 'Note (optional)';

  @override
  String get fuelSaveEntry => 'Save entry';

  @override
  String get fuelValidation =>
      'Enter valid numbers. Fuel and distance must both be positive, or both zero for a maintenance-only entry with other costs. Costs cannot be negative. Use a three-letter currency code and a note of up to 500 characters.';

  @override
  String get fuelSaved => 'Entry saved';

  @override
  String get fuelDeleted => 'Entry deleted';

  @override
  String get fuelTotalCost => 'Total vehicle costs';

  @override
  String get fuelConsumption => 'Fuel consumption';

  @override
  String get fuelLoggedDistance => 'Logged distance';

  @override
  String get fuelCostPerDistance => 'Cost per logged distance';

  @override
  String get fuelNoConsumption =>
      'Add fuel with distance to calculate consumption';

  @override
  String get fuelLitersPer100Kilometers => 'L/100 km';

  @override
  String get fuelMilesPerUsGallon => 'mi/US gal';

  @override
  String get fuelMileageLog => 'Trip mileage log';

  @override
  String fuelAmountPerDistance(String amount, String unit) {
    return '$amount/$unit';
  }

  @override
  String get focusedDisplay => 'Focused display';

  @override
  String get exitFocusedDisplay => 'Exit focused display';

  @override
  String get settingsSections => 'Settings sections';

  @override
  String get allSettings => 'All settings';

  @override
  String get allTrips => 'All trips';

  @override
  String get activeTrips => 'In progress';

  @override
  String get finishedTrips => 'Finished trips';

  @override
  String get filterDates => 'Filter dates';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get previousPage => 'Previous page';

  @override
  String get nextPage => 'Next page';

  @override
  String historyPage(String page) {
    return 'Page $page';
  }

  @override
  String get historyNoMatches => 'No trips match these filters.';

  @override
  String get loadRegionalMap => 'Load regional map';

  @override
  String get removeRegionalMap => 'Remove regional map';

  @override
  String get regionalMapDisclosure =>
      'Local GeoJSON lines only (up to 5 MB). Choose data you have permission to use and include source attribution. The layer stays in memory while this trip screen is open; it is not saved or included in backups.';

  @override
  String get regionalMapFailure =>
      'Regional map could not be loaded. Choose a valid GeoJSON FeatureCollection with LineString or MultiLineString geometry.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get readOnlyWebPage => 'Read-only page. Links and forms are disabled.';

  @override
  String get webPageLoadError =>
      'The page could not be loaded. Check your connection and try again.';

  @override
  String regionalMapSource(String source) {
    return 'Regional map: $source';
  }
}
