import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Speedometer'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'ACCURATE. PRIVATE. FREE.'**
  String get appTagline;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Live dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A little more clarity for every journey.'**
  String get dashboardSubtitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to dashboard'**
  String get backToDashboard;

  /// No description provided for @digital.
  ///
  /// In en, this message translates to:
  /// **'Digital'**
  String get digital;

  /// No description provided for @analog.
  ///
  /// In en, this message translates to:
  /// **'Analog'**
  String get analog;

  /// No description provided for @hud.
  ///
  /// In en, this message translates to:
  /// **'HUD'**
  String get hud;

  /// No description provided for @displayMode.
  ///
  /// In en, this message translates to:
  /// **'Display mode'**
  String get displayMode;

  /// No description provided for @currentSpeed.
  ///
  /// In en, this message translates to:
  /// **'CURRENT SPEED'**
  String get currentSpeed;

  /// No description provided for @speedUnit.
  ///
  /// In en, this message translates to:
  /// **'Speed unit'**
  String get speedUnit;

  /// No description provided for @unitKilometers.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get unitKilometers;

  /// No description provided for @unitMiles.
  ///
  /// In en, this message translates to:
  /// **'mph'**
  String get unitMiles;

  /// No description provided for @unitMeters.
  ///
  /// In en, this message translates to:
  /// **'m/s'**
  String get unitMeters;

  /// No description provided for @unitKnots.
  ///
  /// In en, this message translates to:
  /// **'kn'**
  String get unitKnots;

  /// No description provided for @unitKilometersFull.
  ///
  /// In en, this message translates to:
  /// **'Kilometers per hour'**
  String get unitKilometersFull;

  /// No description provided for @unitMilesFull.
  ///
  /// In en, this message translates to:
  /// **'Miles per hour'**
  String get unitMilesFull;

  /// No description provided for @unitMetersFull.
  ///
  /// In en, this message translates to:
  /// **'Meters per second'**
  String get unitMetersFull;

  /// No description provided for @unitKnotsFull.
  ///
  /// In en, this message translates to:
  /// **'Knots'**
  String get unitKnotsFull;

  /// No description provided for @kilometers.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kilometers;

  /// No description provided for @miles.
  ///
  /// In en, this message translates to:
  /// **'mi'**
  String get miles;

  /// No description provided for @nauticalMiles.
  ///
  /// In en, this message translates to:
  /// **'nmi'**
  String get nauticalMiles;

  /// No description provided for @meters.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get meters;

  /// No description provided for @gpsStandby.
  ///
  /// In en, this message translates to:
  /// **'GPS on standby'**
  String get gpsStandby;

  /// No description provided for @gpsSearching.
  ///
  /// In en, this message translates to:
  /// **'Finding GPS signal'**
  String get gpsSearching;

  /// No description provided for @gpsLive.
  ///
  /// In en, this message translates to:
  /// **'GPS connected'**
  String get gpsLive;

  /// No description provided for @gpsPaused.
  ///
  /// In en, this message translates to:
  /// **'GPS paused'**
  String get gpsPaused;

  /// No description provided for @gpsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'GPS unavailable'**
  String get gpsUnavailable;

  /// No description provided for @accuracyValue.
  ///
  /// In en, this message translates to:
  /// **'±{value} m accuracy'**
  String accuracyValue(String value);

  /// No description provided for @speedSemantics.
  ///
  /// In en, this message translates to:
  /// **'Current speed {value} {unit}'**
  String speedSemantics(String value, String unit);

  /// No description provided for @startPrompt.
  ///
  /// In en, this message translates to:
  /// **'Ready when you are'**
  String get startPrompt;

  /// No description provided for @startHint.
  ///
  /// In en, this message translates to:
  /// **'Start a trip to see your live GPS speed.'**
  String get startHint;

  /// No description provided for @searchingHint.
  ///
  /// In en, this message translates to:
  /// **'A clear view of the sky helps GPS find you.'**
  String get searchingHint;

  /// No description provided for @pausedHint.
  ///
  /// In en, this message translates to:
  /// **'Your trip is paused. Resume when you are ready.'**
  String get pausedHint;

  /// No description provided for @trackingHint.
  ///
  /// In en, this message translates to:
  /// **'GPS is active. Use the trip controls or notification to stop.'**
  String get trackingHint;

  /// No description provided for @thisTrip.
  ///
  /// In en, this message translates to:
  /// **'This trip'**
  String get thisTrip;

  /// No description provided for @sessionOnly.
  ///
  /// In en, this message translates to:
  /// **'Local trip · saved when you finish'**
  String get sessionOnly;

  /// No description provided for @tripDistance.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE'**
  String get tripDistance;

  /// No description provided for @averageSpeed.
  ///
  /// In en, this message translates to:
  /// **'AVERAGE SPEED'**
  String get averageSpeed;

  /// No description provided for @topSpeed.
  ///
  /// In en, this message translates to:
  /// **'TOP SPEED'**
  String get topSpeed;

  /// No description provided for @tripDuration.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get tripDuration;

  /// No description provided for @movingAverage.
  ///
  /// In en, this message translates to:
  /// **'Moving average'**
  String get movingAverage;

  /// No description provided for @movingTime.
  ///
  /// In en, this message translates to:
  /// **'Moving time'**
  String get movingTime;

  /// No description provided for @altitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get altitude;

  /// No description provided for @heading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get heading;

  /// No description provided for @unavailableValue.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get unavailableValue;

  /// No description provided for @durationValue.
  ///
  /// In en, this message translates to:
  /// **'{hours}:{minutes}:{seconds}'**
  String durationValue(String hours, String minutes, String seconds);

  /// No description provided for @headingValue.
  ///
  /// In en, this message translates to:
  /// **'{value}°'**
  String headingValue(String value);

  /// No description provided for @measurementValue.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String measurementValue(String value, String unit);

  /// No description provided for @startTrip.
  ///
  /// In en, this message translates to:
  /// **'Start trip'**
  String get startTrip;

  /// No description provided for @pauseTrip.
  ///
  /// In en, this message translates to:
  /// **'Pause trip'**
  String get pauseTrip;

  /// No description provided for @resumeTrip.
  ///
  /// In en, this message translates to:
  /// **'Resume trip'**
  String get resumeTrip;

  /// No description provided for @startingTrip.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get startingTrip;

  /// No description provided for @resetTrip.
  ///
  /// In en, this message translates to:
  /// **'Reset trip'**
  String get resetTrip;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Start fresh?'**
  String get resetTitle;

  /// No description provided for @resetMessage.
  ///
  /// In en, this message translates to:
  /// **'This stops tracking and discards the current trip. Earlier saved trips, the total odometer and calendar distance totals are kept.'**
  String get resetMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @privacyFooter.
  ///
  /// In en, this message translates to:
  /// **'Offline by design. No account. No uploads.'**
  String get privacyFooter;

  /// No description provided for @safeDriving.
  ///
  /// In en, this message translates to:
  /// **'Set up before you move. Keep your attention on the road.'**
  String get safeDriving;

  /// No description provided for @speedLimit.
  ///
  /// In en, this message translates to:
  /// **'Speed limit'**
  String get speedLimit;

  /// No description provided for @limitValue.
  ///
  /// In en, this message translates to:
  /// **'LIMIT {value} {unit}'**
  String limitValue(String value, String unit);

  /// No description provided for @overLimit.
  ///
  /// In en, this message translates to:
  /// **'Over your speed limit'**
  String get overLimit;

  /// No description provided for @overLimitSemantics.
  ///
  /// In en, this message translates to:
  /// **'Warning: you are over your selected speed limit.'**
  String get overLimitSemantics;

  /// No description provided for @mirrorHud.
  ///
  /// In en, this message translates to:
  /// **'Mirror HUD'**
  String get mirrorHud;

  /// No description provided for @mirrorHudSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flip the readout for a windshield reflection.'**
  String get mirrorHudSubtitle;

  /// No description provided for @hudHint.
  ///
  /// In en, this message translates to:
  /// **'For a clear, glanceable view. Position your phone safely before moving.'**
  String get hudHint;

  /// No description provided for @displaySettings.
  ///
  /// In en, this message translates to:
  /// **'Your display'**
  String get displaySettings;

  /// No description provided for @displaySettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Make the dashboard feel right for you.'**
  String get displaySettingsDescription;

  /// No description provided for @simpleView.
  ///
  /// In en, this message translates to:
  /// **'Simple view'**
  String get simpleView;

  /// No description provided for @simpleViewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the focus on your current speed.'**
  String get simpleViewSubtitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark appearance'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A softer display for the journey after dark.'**
  String get darkModeSubtitle;

  /// No description provided for @warningSettings.
  ///
  /// In en, this message translates to:
  /// **'Speed warnings'**
  String get warningSettings;

  /// No description provided for @warningSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a personal limit and the warnings you prefer.'**
  String get warningSettingsDescription;

  /// No description provided for @enableWarning.
  ///
  /// In en, this message translates to:
  /// **'Enable speed warning'**
  String get enableWarning;

  /// No description provided for @enableWarningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show a warning above your selected limit and margin.'**
  String get enableWarningSubtitle;

  /// No description provided for @warningScope.
  ///
  /// In en, this message translates to:
  /// **'Sound, vibration and speech are optional. A warning is an aid; keep your attention on the road. Device sound settings and hardware can affect audible and haptic alerts.'**
  String get warningScope;

  /// No description provided for @decreaseLimit.
  ///
  /// In en, this message translates to:
  /// **'Decrease speed limit'**
  String get decreaseLimit;

  /// No description provided for @increaseLimit.
  ///
  /// In en, this message translates to:
  /// **'Increase speed limit'**
  String get increaseLimit;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy, by design'**
  String get privacySettings;

  /// No description provided for @privacySettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Your location powers the speedometer on this device. No location or trip data is uploaded.'**
  String get privacySettingsDescription;

  /// No description provided for @foregroundDisclosure.
  ///
  /// In en, this message translates to:
  /// **'GPS starts only when you tap Start trip. With background tracking enabled, a visible notification keeps tracking when you leave the app and offers a Stop button. Trips and optional precise routes stay on this device until you delete them or explicitly export a file. No account or automatic uploads.'**
  String get foregroundDisclosure;

  /// No description provided for @precisionDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'GPS readings can vary with signal conditions. This app is an aid, not a replacement for your vehicle’s speedometer.'**
  String get precisionDisclaimer;

  /// No description provided for @permissionEyebrow.
  ///
  /// In en, this message translates to:
  /// **'LET’S GET YOU READY'**
  String get permissionEyebrow;

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your journey.\nYour privacy.'**
  String get permissionTitle;

  /// No description provided for @permissionDescription.
  ///
  /// In en, this message translates to:
  /// **'A clear view of your speed starts with your phone’s GPS.'**
  String get permissionDescription;

  /// No description provided for @permissionLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location, with a purpose'**
  String get permissionLocationTitle;

  /// No description provided for @permissionLocationBody.
  ///
  /// In en, this message translates to:
  /// **'Precise location lets us read the speed reported by GPS and measure your trip distance.'**
  String get permissionLocationBody;

  /// No description provided for @permissionOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Always on your device'**
  String get permissionOfflineTitle;

  /// No description provided for @permissionOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'No account, no automatic uploads, and no internet needed. Trips and optional precise routes are saved on this device. You can turn route storage off, export a local backup or delete your data in Settings.'**
  String get permissionOfflineBody;

  /// No description provided for @permissionControlTitle.
  ///
  /// In en, this message translates to:
  /// **'You are in control'**
  String get permissionControlTitle;

  /// No description provided for @permissionControlBody.
  ///
  /// In en, this message translates to:
  /// **'GPS starts when you tap Start trip. A visible notification can keep tracking when minimized and has a Stop button. Background tracking, route recording and warnings are controlled in Settings.'**
  String get permissionControlBody;

  /// No description provided for @permissionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue to dashboard'**
  String get permissionContinue;

  /// No description provided for @permissionRequestHint.
  ///
  /// In en, this message translates to:
  /// **'We will ask for location permission when you start your first trip.'**
  String get permissionRequestHint;

  /// No description provided for @failurePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission is needed to show GPS speed. Tap Start trip to try again.'**
  String get failurePermissionDenied;

  /// No description provided for @failurePermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location access is turned off for this app. Enable precise location in app settings to start a trip.'**
  String get failurePermissionDeniedForever;

  /// No description provided for @failureLocationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Your device’s location service is off. Turn it on to find your GPS speed.'**
  String get failureLocationDisabled;

  /// No description provided for @failureLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'A reliable GPS reading is not available yet. Try again with a clear view of the sky.'**
  String get failureLocationUnavailable;

  /// No description provided for @failureUnsupported.
  ///
  /// In en, this message translates to:
  /// **'GPS tracking is not supported on this platform. The dashboard and display settings are available to preview.'**
  String get failureUnsupported;

  /// No description provided for @failureStorage.
  ///
  /// In en, this message translates to:
  /// **'Your local data could not be read or saved. Please try again.'**
  String get failureStorage;

  /// No description provided for @failureUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something interrupted the trip. Please try again.'**
  String get failureUnexpected;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get openAppSettings;

  /// No description provided for @openLocationSettings.
  ///
  /// In en, this message translates to:
  /// **'Turn on location'**
  String get openLocationSettings;

  /// No description provided for @dismissError.
  ///
  /// In en, this message translates to:
  /// **'Dismiss message'**
  String get dismissError;

  /// No description provided for @preferencesLoadFailure.
  ///
  /// In en, this message translates to:
  /// **'Your saved preferences could not be loaded.'**
  String get preferencesLoadFailure;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @continueWithDefaults.
  ///
  /// In en, this message translates to:
  /// **'Continue with default settings'**
  String get continueWithDefaults;

  /// No description provided for @loadingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Getting your dashboard ready…'**
  String get loadingPreferences;

  /// No description provided for @startupTitle.
  ///
  /// In en, this message translates to:
  /// **'A clearer journey starts here.'**
  String get startupTitle;

  /// No description provided for @keepAwake.
  ///
  /// In en, this message translates to:
  /// **'Keep screen awake'**
  String get keepAwake;

  /// No description provided for @keepAwakeDescription.
  ///
  /// In en, this message translates to:
  /// **'Prevent screen sleep while tracking with the dashboard visible.'**
  String get keepAwakeDescription;

  /// No description provided for @brightness.
  ///
  /// In en, this message translates to:
  /// **'Display brightness'**
  String get brightness;

  /// No description provided for @systemBrightness.
  ///
  /// In en, this message translates to:
  /// **'Use system brightness'**
  String get systemBrightness;

  /// No description provided for @brightnessDescription.
  ///
  /// In en, this message translates to:
  /// **'Only changes this app. System brightness returns when you leave.'**
  String get brightnessDescription;

  /// No description provided for @accentColor.
  ///
  /// In en, this message translates to:
  /// **'Instrument color'**
  String get accentColor;

  /// No description provided for @colorLime.
  ///
  /// In en, this message translates to:
  /// **'Lime'**
  String get colorLime;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorCyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get colorCyan;

  /// No description provided for @colorAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get colorAmber;

  /// No description provided for @colorRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get colorRose;

  /// No description provided for @colorLavender.
  ///
  /// In en, this message translates to:
  /// **'Lavender'**
  String get colorLavender;

  /// No description provided for @colorMint.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get colorMint;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @leftHanded.
  ///
  /// In en, this message translates to:
  /// **'Left-handed layout'**
  String get leftHanded;

  /// No description provided for @leftHandedDescription.
  ///
  /// In en, this message translates to:
  /// **'Place the instrument on the left in wide layouts.'**
  String get leftHandedDescription;

  /// No description provided for @gaugeRange.
  ///
  /// In en, this message translates to:
  /// **'Full gauge range'**
  String get gaugeRange;

  /// No description provided for @nightHud.
  ///
  /// In en, this message translates to:
  /// **'Maximum-contrast HUD'**
  String get nightHud;

  /// No description provided for @nightHudDescription.
  ///
  /// In en, this message translates to:
  /// **'Use a pure-black HUD with a bright readout for night driving.'**
  String get nightHudDescription;

  /// No description provided for @hudContent.
  ///
  /// In en, this message translates to:
  /// **'HUD information'**
  String get hudContent;

  /// No description provided for @hudTime.
  ///
  /// In en, this message translates to:
  /// **'Show time'**
  String get hudTime;

  /// No description provided for @hudCompass.
  ///
  /// In en, this message translates to:
  /// **'Show compass'**
  String get hudCompass;

  /// No description provided for @hudTrip.
  ///
  /// In en, this message translates to:
  /// **'Show trip distance'**
  String get hudTrip;

  /// No description provided for @soundAlert.
  ///
  /// In en, this message translates to:
  /// **'Sound warning'**
  String get soundAlert;

  /// No description provided for @vibrationAlert.
  ///
  /// In en, this message translates to:
  /// **'Vibration warning'**
  String get vibrationAlert;

  /// No description provided for @voiceAlert.
  ///
  /// In en, this message translates to:
  /// **'Spoken warning'**
  String get voiceAlert;

  /// No description provided for @alertVolume.
  ///
  /// In en, this message translates to:
  /// **'Warning volume'**
  String get alertVolume;

  /// No description provided for @alertOffset.
  ///
  /// In en, this message translates to:
  /// **'Warning margin above limit'**
  String get alertOffset;

  /// No description provided for @alertOffsetDescription.
  ///
  /// In en, this message translates to:
  /// **'The warning starts at your limit plus this margin.'**
  String get alertOffsetDescription;

  /// No description provided for @calibration.
  ///
  /// In en, this message translates to:
  /// **'Distance calibration'**
  String get calibration;

  /// No description provided for @calibrationDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust future distance measurements to match a reference odometer. GPS speed and previously recorded distances stay unchanged.'**
  String get calibrationDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get systemLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @trackingSettings.
  ///
  /// In en, this message translates to:
  /// **'Tracking and recording'**
  String get trackingSettings;

  /// No description provided for @autoRecordTrips.
  ///
  /// In en, this message translates to:
  /// **'Save trips automatically'**
  String get autoRecordTrips;

  /// No description provided for @autoRecordTripsDescription.
  ///
  /// In en, this message translates to:
  /// **'Save each session you explicitly start. Finish a trip to add it to history. GPS never starts automatically.'**
  String get autoRecordTripsDescription;

  /// No description provided for @recordRoute.
  ///
  /// In en, this message translates to:
  /// **'Save precise route'**
  String get recordRoute;

  /// No description provided for @recordRouteDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep start/end coordinates and accepted GPS points locally for the map, replay and GPX export. Turn off to save only statistics and speed samples. Existing routes remain until deleted.'**
  String get recordRouteDescription;

  /// No description provided for @backgroundTracking.
  ///
  /// In en, this message translates to:
  /// **'Continue when minimized'**
  String get backgroundTracking;

  /// No description provided for @backgroundTrackingDescription.
  ///
  /// In en, this message translates to:
  /// **'After you tap Start trip, a visible location-service notification keeps GPS active outside the app. Use its Stop button to end recording. No background-location permission is requested.'**
  String get backgroundTrackingDescription;

  /// No description provided for @economyGps.
  ///
  /// In en, this message translates to:
  /// **'Battery-friendly GPS'**
  String get economyGps;

  /// No description provided for @economyGpsDescription.
  ///
  /// In en, this message translates to:
  /// **'Request a fix about every 3 seconds instead of every second. Accuracy and responsiveness depend on your device.'**
  String get economyGpsDescription;

  /// No description provided for @overlaySettings.
  ///
  /// In en, this message translates to:
  /// **'Floating speedometer'**
  String get overlaySettings;

  /// No description provided for @overlayDescription.
  ///
  /// In en, this message translates to:
  /// **'Show speed over other apps while a trip is running. Drag to move and use the corner handle to resize.'**
  String get overlayDescription;

  /// No description provided for @enableOverlay.
  ///
  /// In en, this message translates to:
  /// **'Show floating speedometer'**
  String get enableOverlay;

  /// No description provided for @disableOverlay.
  ///
  /// In en, this message translates to:
  /// **'Hide floating speedometer'**
  String get disableOverlay;

  /// No description provided for @overlayPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow a floating speedometer?'**
  String get overlayPermissionTitle;

  /// No description provided for @overlayPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Android needs permission to display the speed readout over navigation and other apps. The overlay only shows this app’s speed and warning state; it does not read the content of other apps. You can hide it here or stop your trip from the notification.'**
  String get overlayPermissionBody;

  /// No description provided for @openOverlaySettings.
  ///
  /// In en, this message translates to:
  /// **'Allow display over other apps'**
  String get openOverlaySettings;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @backupSettings.
  ///
  /// In en, this message translates to:
  /// **'Local backup and data'**
  String get backupSettings;

  /// No description provided for @backupDescription.
  ///
  /// In en, this message translates to:
  /// **'Backups include settings, optional body weight, trips, saved precise routes, fuel records and vehicle costs. Share them only with people and apps you trust. Nothing uploads automatically.'**
  String get backupDescription;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export local backup'**
  String get exportBackup;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore local backup'**
  String get restoreBackup;

  /// No description provided for @restoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore a backup?'**
  String get restoreBackupTitle;

  /// No description provided for @restoreBackupMessage.
  ///
  /// In en, this message translates to:
  /// **'A valid backup replaces saved trips, odometer, fuel records, vehicle costs and settings on this device. Export a backup first to keep your current data. Tracking stops before restoring.'**
  String get restoreBackupMessage;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data'**
  String get deleteAllData;

  /// No description provided for @deleteAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all local data?'**
  String get deleteAllDataTitle;

  /// No description provided for @deleteAllDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This stops tracking and permanently deletes trips, precise routes, the odometer, fuel records, vehicle costs and saved settings on this device. Previously exported files are not deleted.'**
  String get deleteAllDataMessage;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @resetPreferences.
  ///
  /// In en, this message translates to:
  /// **'Reset settings'**
  String get resetPreferences;

  /// No description provided for @resetPreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset settings?'**
  String get resetPreferencesTitle;

  /// No description provided for @resetPreferencesMessage.
  ///
  /// In en, this message translates to:
  /// **'Restore default display, warning and recording settings. Saved trips and the odometer are kept.'**
  String get resetPreferencesMessage;

  /// No description provided for @odometer.
  ///
  /// In en, this message translates to:
  /// **'Total odometer'**
  String get odometer;

  /// No description provided for @todayDistance.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayDistance;

  /// No description provided for @weekDistance.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get weekDistance;

  /// No description provided for @monthDistance.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get monthDistance;

  /// No description provided for @compass.
  ///
  /// In en, this message translates to:
  /// **'Device compass'**
  String get compass;

  /// No description provided for @compassUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Compass unavailable on this device'**
  String get compassUnavailable;

  /// No description provided for @courseOverGround.
  ///
  /// In en, this message translates to:
  /// **'GPS course over ground'**
  String get courseOverGround;

  /// No description provided for @tripHistory.
  ///
  /// In en, this message translates to:
  /// **'Trip history'**
  String get tripHistory;

  /// No description provided for @finishTrip.
  ///
  /// In en, this message translates to:
  /// **'Finish and save trip'**
  String get finishTrip;

  /// No description provided for @platformUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This device does not support that feature.'**
  String get platformUnsupported;

  /// No description provided for @invalidBackup.
  ///
  /// In en, this message translates to:
  /// **'The selected backup is invalid or incompatible.'**
  String get invalidBackup;

  /// No description provided for @storageMessage.
  ///
  /// In en, this message translates to:
  /// **'Your local data could not be read or saved. Please try again.'**
  String get storageMessage;

  /// No description provided for @warningSpoken.
  ///
  /// In en, this message translates to:
  /// **'You are above your selected speed limit.'**
  String get warningSpoken;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Speedometer tracking'**
  String get notificationTitle;

  /// No description provided for @notificationStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get notificationStop;

  /// No description provided for @nativePaused.
  ///
  /// In en, this message translates to:
  /// **'Tracking paused'**
  String get nativePaused;

  /// No description provided for @nativeTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking active'**
  String get nativeTracking;

  /// No description provided for @overlayPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Allow Speedometer to appear over other apps, then return and enable the overlay.'**
  String get overlayPermissionMessage;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Your backup has been restored.'**
  String get backupRestored;

  /// No description provided for @sessionRecordingOff.
  ///
  /// In en, this message translates to:
  /// **'Trip saving is off · odometer stays on this device'**
  String get sessionRecordingOff;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @tripHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your journeys will appear here'**
  String get tripHistoryEmpty;

  /// No description provided for @tripHistoryEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Start a trip on the dashboard, then finish it to keep the statistics and optional route on this device.'**
  String get tripHistoryEmptyDescription;

  /// No description provided for @tripDetail.
  ///
  /// In en, this message translates to:
  /// **'Trip details'**
  String get tripDetail;

  /// No description provided for @tripNotFound.
  ///
  /// In en, this message translates to:
  /// **'This trip is no longer available.'**
  String get tripNotFound;

  /// No description provided for @tripInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get tripInProgress;

  /// No description provided for @tripFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get tripFinished;

  /// No description provided for @deleteTrip.
  ///
  /// In en, this message translates to:
  /// **'Delete trip'**
  String get deleteTrip;

  /// No description provided for @deleteTripTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this trip?'**
  String get deleteTripTitle;

  /// No description provided for @deleteTripMessage.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes its statistics and saved route from this device. Your total odometer and calendar distance totals are kept. Exported files are not deleted.'**
  String get deleteTripMessage;

  /// No description provided for @tripRoute.
  ///
  /// In en, this message translates to:
  /// **'Recorded route'**
  String get tripRoute;

  /// No description provided for @tripRouteDescription.
  ///
  /// In en, this message translates to:
  /// **'Offline map with coarse land outlines. Pinch to zoom and drag to explore. Streets are not included. Breaks mark pauses or periods without a saved route.'**
  String get tripRouteDescription;

  /// No description provided for @tripNoRoute.
  ///
  /// In en, this message translates to:
  /// **'No route was saved. Speed samples and statistics are still available.'**
  String get tripNoRoute;

  /// No description provided for @tripStartPoint.
  ///
  /// In en, this message translates to:
  /// **'First saved point'**
  String get tripStartPoint;

  /// No description provided for @tripEndPoint.
  ///
  /// In en, this message translates to:
  /// **'Last saved point'**
  String get tripEndPoint;

  /// No description provided for @tripSpeedGraph.
  ///
  /// In en, this message translates to:
  /// **'Speed over time'**
  String get tripSpeedGraph;

  /// No description provided for @tripSpeedGraphDescription.
  ///
  /// In en, this message translates to:
  /// **'Speed samples are shown against elapsed trip time. Gaps separate pauses and missing GPS intervals.'**
  String get tripSpeedGraphDescription;

  /// No description provided for @tripNoSamples.
  ///
  /// In en, this message translates to:
  /// **'No accepted GPS samples were recorded.'**
  String get tripNoSamples;

  /// No description provided for @tripReplay.
  ///
  /// In en, this message translates to:
  /// **'Route replay'**
  String get tripReplay;

  /// No description provided for @tripReplayPlay.
  ///
  /// In en, this message translates to:
  /// **'Play route replay'**
  String get tripReplayPlay;

  /// No description provided for @tripReplayPause.
  ///
  /// In en, this message translates to:
  /// **'Pause route replay'**
  String get tripReplayPause;

  /// No description provided for @tripReplayProgress.
  ///
  /// In en, this message translates to:
  /// **'Replay position'**
  String get tripReplayProgress;

  /// No description provided for @tripReplayDescription.
  ///
  /// In en, this message translates to:
  /// **'Replay follows the saved samples. Dashed segments and warning markers identify samples above the speed limit selected during recording.'**
  String get tripReplayDescription;

  /// No description provided for @tripOverLimitLegend.
  ///
  /// In en, this message translates to:
  /// **'Warning markers: above selected limit'**
  String get tripOverLimitLegend;

  /// No description provided for @tripExportGpx.
  ///
  /// In en, this message translates to:
  /// **'Share GPX route'**
  String get tripExportGpx;

  /// No description provided for @tripExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Share CSV samples'**
  String get tripExportCsv;

  /// No description provided for @tripShareSummary.
  ///
  /// In en, this message translates to:
  /// **'Share trip summary'**
  String get tripShareSummary;

  /// No description provided for @tripExportDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Exports can include precise saved coordinates. Only share them with apps and people you trust.'**
  String get tripExportDisclosure;

  /// No description provided for @tripChartSemantics.
  ///
  /// In en, this message translates to:
  /// **'Recorded speed graph'**
  String get tripChartSemantics;

  /// No description provided for @tripRouteSemantics.
  ///
  /// In en, this message translates to:
  /// **'Saved route with start, end and replay position markers'**
  String get tripRouteSemantics;

  /// No description provided for @tripSummaryText.
  ///
  /// In en, this message translates to:
  /// **'Trip on {date}\nDistance: {distance}\nDuration: {duration}\nAverage: {average}\nTop speed: {maximum}'**
  String tripSummaryText(
    String date,
    String distance,
    String duration,
    String average,
    String maximum,
  );

  /// No description provided for @tripSamplePosition.
  ///
  /// In en, this message translates to:
  /// **'Sample {position} of {total}'**
  String tripSamplePosition(String position, String total);

  /// No description provided for @tripSampleTime.
  ///
  /// In en, this message translates to:
  /// **'Recorded at {time}'**
  String tripSampleTime(String time);

  /// No description provided for @tripBasemapAttribution.
  ///
  /// In en, this message translates to:
  /// **'Land outlines: Natural Earth (public domain). Coarse global basemap; streets are not included.'**
  String get tripBasemapAttribution;

  /// No description provided for @activitySettings.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activitySettings;

  /// No description provided for @activityDescription.
  ///
  /// In en, this message translates to:
  /// **'Each activity remembers its unit, gauge style and dial range.'**
  String get activityDescription;

  /// No description provided for @activityMode.
  ///
  /// In en, this message translates to:
  /// **'Activity mode'**
  String get activityMode;

  /// No description provided for @activityCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get activityCar;

  /// No description provided for @activityCycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get activityCycling;

  /// No description provided for @activityWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get activityWalking;

  /// No description provided for @activityRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get activityRunning;

  /// No description provided for @activityBoating.
  ///
  /// In en, this message translates to:
  /// **'Boating'**
  String get activityBoating;

  /// No description provided for @activityLocked.
  ///
  /// In en, this message translates to:
  /// **'Finish or reset the current trip before changing activity or weight.'**
  String get activityLocked;

  /// No description provided for @bodyWeight.
  ///
  /// In en, this message translates to:
  /// **'Body weight'**
  String get bodyWeight;

  /// No description provided for @bodyWeightDescription.
  ///
  /// In en, this message translates to:
  /// **'Stored locally for a rough calorie estimate. Included in local backups.'**
  String get bodyWeightDescription;

  /// No description provided for @bodyWeightEnabled.
  ///
  /// In en, this message translates to:
  /// **'Estimate calories'**
  String get bodyWeightEnabled;

  /// No description provided for @bodyWeightEnabledDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your weight to estimate calories for cycling, walking and running.'**
  String get bodyWeightEnabledDescription;

  /// No description provided for @kilograms.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kilograms;

  /// No description provided for @estimatedCalories.
  ///
  /// In en, this message translates to:
  /// **'Estimated calories'**
  String get estimatedCalories;

  /// No description provided for @kilocalories.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get kilocalories;

  /// No description provided for @calorieEstimateDescription.
  ///
  /// In en, this message translates to:
  /// **'Rough total energy estimate at moderate effort, based on moving time and weight. Actual energy use varies.'**
  String get calorieEstimateDescription;

  /// No description provided for @fuelCosts.
  ///
  /// In en, this message translates to:
  /// **'Fuel and vehicle costs'**
  String get fuelCosts;

  /// No description provided for @fuelLogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No fuel or vehicle costs yet'**
  String get fuelLogEmpty;

  /// No description provided for @fuelLogDescription.
  ///
  /// In en, this message translates to:
  /// **'Record fuel and the distance it covered. For maintenance only, leave fuel and distance at zero. Keep recorded trips as your mileage log. Currency totals stay separate; no exchange rates are applied.'**
  String get fuelLogDescription;

  /// No description provided for @fuelAddEntry.
  ///
  /// In en, this message translates to:
  /// **'Add entry'**
  String get fuelAddEntry;

  /// No description provided for @fuelEditEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get fuelEditEntry;

  /// No description provided for @fuelDeleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get fuelDeleteEntry;

  /// No description provided for @fuelDeleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete this fuel and cost entry?'**
  String get fuelDeleteConfirmation;

  /// No description provided for @fuelEntryDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fuelEntryDate;

  /// No description provided for @fuelDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance covered'**
  String get fuelDistance;

  /// No description provided for @fuelVolume.
  ///
  /// In en, this message translates to:
  /// **'Fuel used'**
  String get fuelVolume;

  /// No description provided for @fuelVolumeUnit.
  ///
  /// In en, this message translates to:
  /// **'Fuel unit'**
  String get fuelVolumeUnit;

  /// No description provided for @fuelDistanceUnit.
  ///
  /// In en, this message translates to:
  /// **'Distance unit'**
  String get fuelDistanceUnit;

  /// No description provided for @fuelLiters.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get fuelLiters;

  /// No description provided for @fuelUsGallons.
  ///
  /// In en, this message translates to:
  /// **'US gal'**
  String get fuelUsGallons;

  /// No description provided for @fuelCost.
  ///
  /// In en, this message translates to:
  /// **'Fuel cost'**
  String get fuelCost;

  /// No description provided for @fuelOtherCost.
  ///
  /// In en, this message translates to:
  /// **'Other vehicle costs'**
  String get fuelOtherCost;

  /// No description provided for @fuelCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency code'**
  String get fuelCurrency;

  /// No description provided for @fuelCurrencyHint.
  ///
  /// In en, this message translates to:
  /// **'Three letters, such as USD or AED'**
  String get fuelCurrencyHint;

  /// No description provided for @fuelNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get fuelNote;

  /// No description provided for @fuelSaveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save entry'**
  String get fuelSaveEntry;

  /// No description provided for @fuelValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter valid numbers. Fuel and distance must both be positive, or both zero for a maintenance-only entry with other costs. Costs cannot be negative. Use a three-letter currency code and a note of up to 500 characters.'**
  String get fuelValidation;

  /// No description provided for @fuelSaved.
  ///
  /// In en, this message translates to:
  /// **'Entry saved'**
  String get fuelSaved;

  /// No description provided for @fuelDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get fuelDeleted;

  /// No description provided for @fuelTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total vehicle costs'**
  String get fuelTotalCost;

  /// No description provided for @fuelConsumption.
  ///
  /// In en, this message translates to:
  /// **'Fuel consumption'**
  String get fuelConsumption;

  /// No description provided for @fuelLoggedDistance.
  ///
  /// In en, this message translates to:
  /// **'Logged distance'**
  String get fuelLoggedDistance;

  /// No description provided for @fuelCostPerDistance.
  ///
  /// In en, this message translates to:
  /// **'Cost per logged distance'**
  String get fuelCostPerDistance;

  /// No description provided for @fuelNoConsumption.
  ///
  /// In en, this message translates to:
  /// **'Add fuel with distance to calculate consumption'**
  String get fuelNoConsumption;

  /// No description provided for @fuelLitersPer100Kilometers.
  ///
  /// In en, this message translates to:
  /// **'L/100 km'**
  String get fuelLitersPer100Kilometers;

  /// No description provided for @fuelMilesPerUsGallon.
  ///
  /// In en, this message translates to:
  /// **'mi/US gal'**
  String get fuelMilesPerUsGallon;

  /// No description provided for @fuelMileageLog.
  ///
  /// In en, this message translates to:
  /// **'Trip mileage log'**
  String get fuelMileageLog;

  /// No description provided for @fuelAmountPerDistance.
  ///
  /// In en, this message translates to:
  /// **'{amount}/{unit}'**
  String fuelAmountPerDistance(String amount, String unit);

  /// No description provided for @focusedDisplay.
  ///
  /// In en, this message translates to:
  /// **'Focused display'**
  String get focusedDisplay;

  /// No description provided for @exitFocusedDisplay.
  ///
  /// In en, this message translates to:
  /// **'Exit focused display'**
  String get exitFocusedDisplay;

  /// No description provided for @settingsSections.
  ///
  /// In en, this message translates to:
  /// **'Settings sections'**
  String get settingsSections;

  /// No description provided for @allSettings.
  ///
  /// In en, this message translates to:
  /// **'All settings'**
  String get allSettings;

  /// No description provided for @allTrips.
  ///
  /// In en, this message translates to:
  /// **'All trips'**
  String get allTrips;

  /// No description provided for @activeTrips.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get activeTrips;

  /// No description provided for @finishedTrips.
  ///
  /// In en, this message translates to:
  /// **'Finished trips'**
  String get finishedTrips;

  /// No description provided for @filterDates.
  ///
  /// In en, this message translates to:
  /// **'Filter dates'**
  String get filterDates;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @historyPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String historyPage(String page);

  /// No description provided for @historyNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No trips match these filters.'**
  String get historyNoMatches;

  /// No description provided for @loadRegionalMap.
  ///
  /// In en, this message translates to:
  /// **'Load regional map'**
  String get loadRegionalMap;

  /// No description provided for @removeRegionalMap.
  ///
  /// In en, this message translates to:
  /// **'Remove regional map'**
  String get removeRegionalMap;

  /// No description provided for @regionalMapDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Local GeoJSON lines only (up to 5 MB). Choose data you have permission to use and include source attribution. The layer stays in memory while this trip screen is open; it is not saved or included in backups.'**
  String get regionalMapDisclosure;

  /// No description provided for @regionalMapFailure.
  ///
  /// In en, this message translates to:
  /// **'Regional map could not be loaded. Choose a valid GeoJSON FeatureCollection with LineString or MultiLineString geometry.'**
  String get regionalMapFailure;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @readOnlyWebPage.
  ///
  /// In en, this message translates to:
  /// **'Read-only page. Links and forms are disabled.'**
  String get readOnlyWebPage;

  /// No description provided for @webPageLoadError.
  ///
  /// In en, this message translates to:
  /// **'The page could not be loaded. Check your connection and try again.'**
  String get webPageLoadError;

  /// No description provided for @regionalMapSource.
  ///
  /// In en, this message translates to:
  /// **'Regional map: {source}'**
  String regionalMapSource(String source);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
