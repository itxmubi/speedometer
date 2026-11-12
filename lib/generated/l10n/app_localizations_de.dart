// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Tachometer';

  @override
  String get appTagline => 'PRÄZISE. PRIVAT. KOSTENLOS.';

  @override
  String get dashboardTitle => 'Live-Anzeige';

  @override
  String get dashboardSubtitle => 'Mehr Klarheit auf jeder Fahrt.';

  @override
  String get settings => 'Einstellungen';

  @override
  String get backToDashboard => 'Zurück zur Anzeige';

  @override
  String get digital => 'Digital';

  @override
  String get analog => 'Analog';

  @override
  String get hud => 'HUD';

  @override
  String get displayMode => 'Anzeigemodus';

  @override
  String get currentSpeed => 'AKTUELLE GESCHWINDIGKEIT';

  @override
  String get speedUnit => 'Geschwindigkeitseinheit';

  @override
  String get unitKilometers => 'km/h';

  @override
  String get unitMiles => 'mph';

  @override
  String get unitMeters => 'm/s';

  @override
  String get unitKnots => 'kn';

  @override
  String get unitKilometersFull => 'Kilometer pro Stunde';

  @override
  String get unitMilesFull => 'Meilen pro Stunde';

  @override
  String get unitMetersFull => 'Meter pro Sekunde';

  @override
  String get unitKnotsFull => 'Knoten';

  @override
  String get kilometers => 'km';

  @override
  String get miles => 'mi';

  @override
  String get nauticalMiles => 'sm';

  @override
  String get meters => 'm';

  @override
  String get gpsStandby => 'GPS in Bereitschaft';

  @override
  String get gpsSearching => 'GPS-Signal wird gesucht';

  @override
  String get gpsLive => 'GPS verbunden';

  @override
  String get gpsPaused => 'GPS pausiert';

  @override
  String get gpsUnavailable => 'GPS nicht verfügbar';

  @override
  String accuracyValue(String value) {
    return 'Genauigkeit ±$value m';
  }

  @override
  String speedSemantics(String value, String unit) {
    return 'Aktuelle Geschwindigkeit: $value $unit';
  }

  @override
  String get startPrompt => 'Bereit, wenn du es bist';

  @override
  String get startHint =>
      'Starte eine Fahrt, um deine GPS-Geschwindigkeit zu sehen.';

  @override
  String get searchingHint =>
      'Freie Sicht zum Himmel verbessert den GPS-Empfang.';

  @override
  String get pausedHint =>
      'Deine Fahrt ist pausiert. Setze sie fort, wenn du bereit bist.';

  @override
  String get trackingHint =>
      'GPS ist aktiv. Beende die Aufzeichnung über die Fahrtsteuerung oder die Benachrichtigung.';

  @override
  String get thisTrip => 'Diese Fahrt';

  @override
  String get sessionOnly => 'Lokale Fahrt · wird beim Beenden gespeichert';

  @override
  String get tripDistance => 'STRECKE';

  @override
  String get averageSpeed => 'DURCHSCHNITT';

  @override
  String get topSpeed => 'HÖCHSTGESCHWINDIGKEIT';

  @override
  String get tripDuration => 'DAUER';

  @override
  String get movingAverage => 'Durchschnitt in Bewegung';

  @override
  String get movingTime => 'Bewegungszeit';

  @override
  String get altitude => 'Höhe';

  @override
  String get heading => 'Richtung';

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
  String get startTrip => 'Fahrt starten';

  @override
  String get pauseTrip => 'Fahrt pausieren';

  @override
  String get resumeTrip => 'Fahrt fortsetzen';

  @override
  String get startingTrip => 'Verbindung wird hergestellt…';

  @override
  String get resetTrip => 'Fahrt zurücksetzen';

  @override
  String get resetTitle => 'Neu beginnen?';

  @override
  String get resetMessage =>
      'Dies stoppt die Aufzeichnung und verwirft die aktuelle Fahrt. Frühere gespeicherte Fahrten, der Gesamtkilometerzähler und Streckensummen nach Zeitraum bleiben erhalten.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get privacyFooter => 'Offline. Ohne Konto. Keine Uploads.';

  @override
  String get safeDriving =>
      'Nimm Einstellungen vor der Fahrt vor. Achte auf die Straße.';

  @override
  String get speedLimit => 'Geschwindigkeitsgrenze';

  @override
  String limitValue(String value, String unit) {
    return 'GRENZE $value $unit';
  }

  @override
  String get overLimit => 'Geschwindigkeitsgrenze überschritten';

  @override
  String get overLimitSemantics =>
      'Warnung: Du überschreitest deine gewählte Geschwindigkeitsgrenze.';

  @override
  String get mirrorHud => 'HUD spiegeln';

  @override
  String get mirrorHudSubtitle =>
      'Spiegle die Anzeige für die Reflexion in der Windschutzscheibe.';

  @override
  String get hudHint =>
      'Gut auf einen Blick ablesbar. Befestige dein Telefon vor der Fahrt sicher.';

  @override
  String get displaySettings => 'Deine Anzeige';

  @override
  String get displaySettingsDescription =>
      'Passe die Anzeige an deine Wünsche an.';

  @override
  String get simpleView => 'Einfache Ansicht';

  @override
  String get simpleViewSubtitle =>
      'Konzentriere dich auf die aktuelle Geschwindigkeit.';

  @override
  String get darkMode => 'Dunkle Darstellung';

  @override
  String get darkModeSubtitle => 'Eine angenehmere Anzeige für Nachtfahrten.';

  @override
  String get warningSettings => 'Geschwindigkeitswarnungen';

  @override
  String get warningSettingsDescription =>
      'Wähle deine persönliche Grenze und die gewünschten Warnungen.';

  @override
  String get enableWarning => 'Geschwindigkeitswarnung aktivieren';

  @override
  String get enableWarningSubtitle =>
      'Warne oberhalb deiner gewählten Grenze einschließlich Toleranz.';

  @override
  String get warningScope =>
      'Ton, Vibration und Sprache sind optional. Warnungen sind eine Hilfe; achte weiter auf die Straße. Geräteeinstellungen und Hardware können hörbare und fühlbare Warnungen beeinflussen.';

  @override
  String get decreaseLimit => 'Geschwindigkeitsgrenze senken';

  @override
  String get increaseLimit => 'Geschwindigkeitsgrenze erhöhen';

  @override
  String get privacySettings => 'Privatsphäre von Anfang an';

  @override
  String get privacySettingsDescription =>
      'Dein Standort ermöglicht die Geschwindigkeitsanzeige auf diesem Gerät. Standort- und Fahrtdaten werden nicht hochgeladen.';

  @override
  String get foregroundDisclosure =>
      'GPS startet nur, wenn du auf Fahrt starten tippst. Bei aktiviertem Hintergrundtracking hält eine sichtbare Benachrichtigung die Aufzeichnung außerhalb der App aktiv und bietet eine Stopp-Taste. Fahrten und optionale genaue Routen bleiben bis zum Löschen oder ausdrücklichen Export auf diesem Gerät. Ohne Konto oder automatische Uploads.';

  @override
  String get precisionDisclaimer =>
      'GPS-Messwerte hängen von den Empfangsbedingungen ab. Diese App ist eine Hilfe und ersetzt nicht den Tachometer deines Fahrzeugs.';

  @override
  String get permissionEyebrow => 'BEREIT FÜR DIE FAHRT';

  @override
  String get permissionTitle => 'Deine Fahrt.\nDeine Privatsphäre.';

  @override
  String get permissionDescription =>
      'Eine klare Geschwindigkeitsanzeige beginnt mit dem GPS deines Telefons.';

  @override
  String get permissionLocationTitle => 'Standort mit klarem Zweck';

  @override
  String get permissionLocationBody =>
      'Der genaue Standort ermöglicht das Ablesen der GPS-Geschwindigkeit und das Messen der Fahrtstrecke.';

  @override
  String get permissionOfflineTitle => 'Immer auf deinem Gerät';

  @override
  String get permissionOfflineBody =>
      'Ohne Konto, automatische Uploads oder Internetverbindung. Fahrten und optionale genaue Routen werden auf diesem Gerät gespeichert. In den Einstellungen kannst du die Routenspeicherung ausschalten, eine lokale Sicherung exportieren oder deine Daten löschen.';

  @override
  String get permissionControlTitle => 'Du behältst die Kontrolle';

  @override
  String get permissionControlBody =>
      'GPS startet, wenn du auf Fahrt starten tippst. Eine sichtbare Benachrichtigung kann die Aufzeichnung bei minimierter App fortsetzen und bietet eine Stopp-Taste. Hintergrundtracking, Routenspeicherung und Warnungen lassen sich in den Einstellungen steuern.';

  @override
  String get permissionContinue => 'Weiter zur Anzeige';

  @override
  String get permissionRequestHint =>
      'Wir fragen beim Start deiner ersten Fahrt nach der Standortberechtigung.';

  @override
  String get failurePermissionDenied =>
      'Die Standortberechtigung wird für die GPS-Geschwindigkeit benötigt. Tippe zum erneuten Versuch auf Fahrt starten.';

  @override
  String get failurePermissionDeniedForever =>
      'Der Standortzugriff ist für diese App ausgeschaltet. Aktiviere den genauen Standort in den App-Einstellungen, um eine Fahrt zu starten.';

  @override
  String get failureLocationDisabled =>
      'Die Standortfunktion deines Geräts ist ausgeschaltet. Schalte sie für die GPS-Geschwindigkeit ein.';

  @override
  String get failureLocationUnavailable =>
      'Noch kein zuverlässiger GPS-Messwert verfügbar. Versuche es mit freier Sicht zum Himmel erneut.';

  @override
  String get failureUnsupported =>
      'GPS-Tracking wird auf dieser Plattform nicht unterstützt. Anzeige und Darstellungseinstellungen können angesehen werden.';

  @override
  String get failureStorage =>
      'Deine lokalen Daten konnten nicht gelesen oder gespeichert werden. Versuche es erneut.';

  @override
  String get failureUnexpected =>
      'Die Fahrt wurde unterbrochen. Versuche es erneut.';

  @override
  String get openAppSettings => 'App-Einstellungen öffnen';

  @override
  String get openLocationSettings => 'Standort einschalten';

  @override
  String get dismissError => 'Meldung schließen';

  @override
  String get preferencesLoadFailure =>
      'Deine gespeicherten Einstellungen konnten nicht geladen werden.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get continueWithDefaults => 'Mit Standardeinstellungen fortfahren';

  @override
  String get loadingPreferences => 'Deine Anzeige wird vorbereitet…';

  @override
  String get startupTitle => 'Hier beginnt eine klarere Fahrt.';

  @override
  String get keepAwake => 'Bildschirm eingeschaltet lassen';

  @override
  String get keepAwakeDescription =>
      'Verhindere den Ruhezustand während der Aufzeichnung bei sichtbarer Anzeige.';

  @override
  String get brightness => 'Bildschirmhelligkeit';

  @override
  String get systemBrightness => 'Systemhelligkeit verwenden';

  @override
  String get brightnessDescription =>
      'Ändert nur diese App. Beim Verlassen gilt wieder die Systemhelligkeit.';

  @override
  String get accentColor => 'Instrumentenfarbe';

  @override
  String get colorLime => 'Limette';

  @override
  String get colorBlue => 'Blau';

  @override
  String get colorCyan => 'Cyan';

  @override
  String get colorAmber => 'Bernstein';

  @override
  String get colorRose => 'Rosé';

  @override
  String get colorLavender => 'Lavendel';

  @override
  String get colorMint => 'Minze';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorWhite => 'Weiß';

  @override
  String get colorPink => 'Pink';

  @override
  String get leftHanded => 'Layout für Linkshänder';

  @override
  String get leftHandedDescription =>
      'Platziere das Instrument in breiten Ansichten links.';

  @override
  String get gaugeRange => 'Voller Anzeigebereich';

  @override
  String get nightHud => 'HUD mit maximalem Kontrast';

  @override
  String get nightHudDescription =>
      'Verwende nachts ein HUD mit reinem Schwarz und heller Anzeige.';

  @override
  String get hudContent => 'HUD-Informationen';

  @override
  String get hudTime => 'Uhrzeit anzeigen';

  @override
  String get hudCompass => 'Kompass anzeigen';

  @override
  String get hudTrip => 'Fahrtstrecke anzeigen';

  @override
  String get soundAlert => 'Tonwarnung';

  @override
  String get vibrationAlert => 'Vibrationswarnung';

  @override
  String get voiceAlert => 'Sprachwarnung';

  @override
  String get alertVolume => 'Warnlautstärke';

  @override
  String get alertOffset => 'Warntoleranz über der Grenze';

  @override
  String get alertOffsetDescription =>
      'Die Warnung beginnt bei deiner Grenze plus dieser Toleranz.';

  @override
  String get calibration => 'Streckenkalibrierung';

  @override
  String get calibrationDescription =>
      'Passe zukünftige Streckenmessungen an einen Referenzkilometerzähler an. GPS-Geschwindigkeit und zuvor gespeicherte Strecken bleiben unverändert.';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Systemsprache';

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
  String get trackingSettings => 'Tracking und Aufzeichnung';

  @override
  String get autoRecordTrips => 'Fahrten automatisch speichern';

  @override
  String get autoRecordTripsDescription =>
      'Speichere jede von dir ausdrücklich gestartete Sitzung. Beende eine Fahrt, um sie zum Verlauf hinzuzufügen. GPS startet nie automatisch.';

  @override
  String get recordRoute => 'Genaue Route speichern';

  @override
  String get recordRouteDescription =>
      'Speichere Start- und Endkoordinaten sowie akzeptierte GPS-Punkte lokal für Karte, Wiedergabe und GPX-Export. Ausgeschaltet werden nur Statistiken und Geschwindigkeitswerte gespeichert. Vorhandene Routen bleiben bis zum Löschen erhalten.';

  @override
  String get backgroundTracking => 'Bei minimierter App fortsetzen';

  @override
  String get backgroundTrackingDescription =>
      'Nach Fahrt starten hält eine sichtbare Benachrichtigung des Standortdienstes GPS außerhalb der App aktiv. Beende die Aufzeichnung mit Stopp. Es wird keine Berechtigung für den Hintergrundstandort angefordert.';

  @override
  String get economyGps => 'Akkuschonendes GPS';

  @override
  String get economyGpsDescription =>
      'Fordert etwa alle 3 Sekunden statt jede Sekunde eine Position an. Genauigkeit und Reaktionszeit hängen vom Gerät ab.';

  @override
  String get overlaySettings => 'Schwebender Tachometer';

  @override
  String get overlayDescription =>
      'Zeige die Geschwindigkeit während einer Fahrt über anderen Apps. Ziehe die Anzeige zum Verschieben und den Eckgriff zum Ändern der Größe.';

  @override
  String get enableOverlay => 'Schwebenden Tachometer anzeigen';

  @override
  String get disableOverlay => 'Schwebenden Tachometer ausblenden';

  @override
  String get overlayPermissionTitle => 'Schwebenden Tachometer erlauben?';

  @override
  String get overlayPermissionBody =>
      'Android benötigt die Berechtigung, die Geschwindigkeit über Navigations- und anderen Apps anzuzeigen. Das Fenster zeigt nur Geschwindigkeit und Warnstatus dieser App und liest keine Inhalte anderer Apps. Blende es hier aus oder stoppe die Fahrt über die Benachrichtigung.';

  @override
  String get openOverlaySettings => 'Anzeige über anderen Apps erlauben';

  @override
  String get continueAction => 'Weiter';

  @override
  String get backupSettings => 'Lokale Sicherung und Daten';

  @override
  String get backupDescription =>
      'Sicherungen enthalten Einstellungen, optionales Körpergewicht, Fahrten, genaue Routen, Kraftstoff und Fahrzeugkosten. Teile sie nur mit vertrauenswürdigen Personen und Apps. Kein automatischer Upload.';

  @override
  String get exportBackup => 'Lokale Sicherung exportieren';

  @override
  String get restoreBackup => 'Lokale Sicherung wiederherstellen';

  @override
  String get restoreBackupTitle => 'Sicherung wiederherstellen?';

  @override
  String get restoreBackupMessage =>
      'Eine gültige Sicherung ersetzt Fahrten, Kilometerstand, Kraftstoff, Kosten und Einstellungen auf diesem Gerät. Exportiere vorher eine Sicherung, um deine Daten zu behalten. Die Aufzeichnung wird gestoppt.';

  @override
  String get deleteAllData => 'Alle lokalen Daten löschen';

  @override
  String get deleteAllDataTitle => 'Alle lokalen Daten löschen?';

  @override
  String get deleteAllDataMessage =>
      'Die Aufzeichnung wird gestoppt. Fahrten, genaue Routen, Kilometerstand, Kraftstoff, Kosten und Einstellungen auf diesem Gerät werden gelöscht. Bereits exportierte Dateien bleiben bestehen.';

  @override
  String get deleteAction => 'Löschen';

  @override
  String get resetPreferences => 'Einstellungen zurücksetzen';

  @override
  String get resetPreferencesTitle => 'Einstellungen zurücksetzen?';

  @override
  String get resetPreferencesMessage =>
      'Stellt die Standardeinstellungen für Anzeige, Warnungen und Aufzeichnung wieder her. Gespeicherte Fahrten und der Kilometerzähler bleiben erhalten.';

  @override
  String get odometer => 'Gesamtkilometerzähler';

  @override
  String get todayDistance => 'Heute';

  @override
  String get weekDistance => 'Diese Woche';

  @override
  String get monthDistance => 'Diesen Monat';

  @override
  String get compass => 'Gerätekompass';

  @override
  String get compassUnavailable => 'Kompass auf diesem Gerät nicht verfügbar';

  @override
  String get courseOverGround => 'GPS-Bewegungsrichtung';

  @override
  String get tripHistory => 'Fahrtverlauf';

  @override
  String get finishTrip => 'Fahrt beenden und speichern';

  @override
  String get platformUnsupported =>
      'Dieses Gerät unterstützt diese Funktion nicht.';

  @override
  String get invalidBackup =>
      'Die ausgewählte Sicherung ist ungültig oder inkompatibel.';

  @override
  String get storageMessage =>
      'Deine lokalen Daten konnten nicht gelesen oder gespeichert werden. Versuche es erneut.';

  @override
  String get warningSpoken =>
      'Du überschreitest deine gewählte Geschwindigkeitsgrenze.';

  @override
  String get notificationTitle => 'Tachometer-Aufzeichnung';

  @override
  String get notificationStop => 'Stopp';

  @override
  String get nativePaused => 'Aufzeichnung pausiert';

  @override
  String get nativeTracking => 'Aufzeichnung aktiv';

  @override
  String get overlayPermissionMessage =>
      'Erlaube dem Tachometer, über anderen Apps zu erscheinen. Kehre dann zurück und aktiviere das schwebende Fenster.';

  @override
  String get backupRestored => 'Deine Sicherung wurde wiederhergestellt.';

  @override
  String get sessionRecordingOff =>
      'Fahrtspeicherung aus · Kilometerzähler bleibt auf diesem Gerät';

  @override
  String get timeLabel => 'Uhrzeit';

  @override
  String get tripHistoryEmpty => 'Hier erscheinen deine Fahrten';

  @override
  String get tripHistoryEmptyDescription =>
      'Starte eine Fahrt in der Anzeige und beende sie anschließend, um Statistiken und die optionale Route auf diesem Gerät zu behalten.';

  @override
  String get tripDetail => 'Fahrtdetails';

  @override
  String get tripNotFound => 'Diese Fahrt ist nicht mehr verfügbar.';

  @override
  String get tripInProgress => 'Läuft';

  @override
  String get tripFinished => 'Beendet';

  @override
  String get deleteTrip => 'Fahrt löschen';

  @override
  String get deleteTripTitle => 'Diese Fahrt löschen?';

  @override
  String get deleteTripMessage =>
      'Statistiken und gespeicherte Route werden dauerhaft von diesem Gerät entfernt. Gesamtkilometerzähler und Streckensummen nach Zeitraum bleiben erhalten. Exportierte Dateien werden nicht gelöscht.';

  @override
  String get tripRoute => 'Aufgezeichnete Route';

  @override
  String get tripRouteDescription =>
      'Offline-Karte mit groben Landumrissen. Zum Zoomen zwei Finger verwenden, zum Erkunden ziehen. Straßen sind nicht enthalten. Unterbrechungen kennzeichnen Pausen oder Zeiten ohne gespeicherte Route.';

  @override
  String get tripNoRoute =>
      'Keine Route gespeichert. Geschwindigkeitswerte und Statistiken sind weiterhin verfügbar.';

  @override
  String get tripStartPoint => 'Erster gespeicherter Punkt';

  @override
  String get tripEndPoint => 'Letzter gespeicherter Punkt';

  @override
  String get tripSpeedGraph => 'Geschwindigkeit im Zeitverlauf';

  @override
  String get tripSpeedGraphDescription =>
      'Geschwindigkeitswerte werden über der vergangenen Fahrtzeit dargestellt. Lücken kennzeichnen Pausen und fehlende GPS-Intervalle.';

  @override
  String get tripNoSamples => 'Keine gültigen GPS-Messwerte aufgezeichnet.';

  @override
  String get tripReplay => 'Routenwiedergabe';

  @override
  String get tripReplayPlay => 'Routenwiedergabe starten';

  @override
  String get tripReplayPause => 'Routenwiedergabe pausieren';

  @override
  String get tripReplayProgress => 'Wiedergabeposition';

  @override
  String get tripReplayDescription =>
      'Die Wiedergabe folgt den gespeicherten Messwerten. Gestrichelte Abschnitte und Warnmarkierungen zeigen Werte oberhalb der bei der Aufzeichnung gewählten Grenze.';

  @override
  String get tripOverLimitLegend =>
      'Warnmarkierungen: gewählte Grenze überschritten';

  @override
  String get tripExportGpx => 'GPX-Route teilen';

  @override
  String get tripExportCsv => 'CSV-Messwerte teilen';

  @override
  String get tripShareSummary => 'Fahrtzusammenfassung teilen';

  @override
  String get tripExportDisclosure =>
      'Exporte können gespeicherte genaue Koordinaten enthalten. Teile sie nur mit vertrauenswürdigen Personen und Apps.';

  @override
  String get tripChartSemantics =>
      'Diagramm der aufgezeichneten Geschwindigkeit';

  @override
  String get tripRouteSemantics =>
      'Gespeicherte Route mit Start-, End- und Wiedergabemarkierungen';

  @override
  String tripSummaryText(
    String date,
    String distance,
    String duration,
    String average,
    String maximum,
  ) {
    return 'Fahrt am $date\nStrecke: $distance\nDauer: $duration\nDurchschnitt: $average\nHöchstgeschwindigkeit: $maximum';
  }

  @override
  String tripSamplePosition(String position, String total) {
    return 'Messwert $position von $total';
  }

  @override
  String tripSampleTime(String time) {
    return 'Aufgezeichnet um $time';
  }

  @override
  String get tripBasemapAttribution =>
      'Landumrisse: Natural Earth (gemeinfrei). Grobe globale Basiskarte ohne Straßen.';

  @override
  String get activitySettings => 'Aktivität';

  @override
  String get activityDescription =>
      'Jede Aktivität merkt sich Einheit, Anzeige und Skalenbereich.';

  @override
  String get activityMode => 'Aktivitätsmodus';

  @override
  String get activityCar => 'Auto';

  @override
  String get activityCycling => 'Radfahren';

  @override
  String get activityWalking => 'Gehen';

  @override
  String get activityRunning => 'Laufen';

  @override
  String get activityBoating => 'Bootfahren';

  @override
  String get activityLocked =>
      'Beende oder setze die aktuelle Fahrt zurück, bevor du Aktivität oder Gewicht änderst.';

  @override
  String get bodyWeight => 'Körpergewicht';

  @override
  String get bodyWeightDescription =>
      'Wird lokal für eine grobe Kalorienschätzung gespeichert und in lokale Sicherungen aufgenommen.';

  @override
  String get bodyWeightEnabled => 'Kalorien schätzen';

  @override
  String get bodyWeightEnabledDescription =>
      'Gib dein Gewicht an, um Kalorien beim Radfahren, Gehen und Laufen zu schätzen.';

  @override
  String get kilograms => 'kg';

  @override
  String get estimatedCalories => 'Geschätzte Kalorien';

  @override
  String get kilocalories => 'kcal';

  @override
  String get calorieEstimateDescription =>
      'Grobe Schätzung der Gesamtenergie bei mittlerer Belastung anhand von Bewegungszeit und Gewicht. Der tatsächliche Verbrauch variiert.';

  @override
  String get fuelCosts => 'Kraftstoff und Fahrzeugkosten';

  @override
  String get fuelLogEmpty => 'Noch keine Kraftstoff- oder Fahrzeugkosten';

  @override
  String get fuelLogDescription =>
      'Erfasse Kraftstoff und die damit gefahrene Strecke. Bei reiner Wartung bleiben Kraftstoff und Strecke null. Gespeicherte Fahrten dienen als Fahrtenbuch. Währungen bleiben getrennt; es erfolgt keine Umrechnung.';

  @override
  String get fuelAddEntry => 'Eintrag hinzufügen';

  @override
  String get fuelEditEntry => 'Eintrag bearbeiten';

  @override
  String get fuelDeleteEntry => 'Eintrag löschen';

  @override
  String get fuelDeleteConfirmation =>
      'Diesen Kraftstoff- und Kosteneintrag löschen?';

  @override
  String get fuelEntryDate => 'Datum';

  @override
  String get fuelDistance => 'Gefahrene Strecke';

  @override
  String get fuelVolume => 'Verbrauchter Kraftstoff';

  @override
  String get fuelVolumeUnit => 'Kraftstoffeinheit';

  @override
  String get fuelDistanceUnit => 'Streckeneinheit';

  @override
  String get fuelLiters => 'L';

  @override
  String get fuelUsGallons => 'US-Gallonen';

  @override
  String get fuelCost => 'Kraftstoffkosten';

  @override
  String get fuelOtherCost => 'Sonstige Fahrzeugkosten';

  @override
  String get fuelCurrency => 'Währungscode';

  @override
  String get fuelCurrencyHint => 'Drei Buchstaben, etwa USD oder AED';

  @override
  String get fuelNote => 'Notiz (optional)';

  @override
  String get fuelSaveEntry => 'Eintrag speichern';

  @override
  String get fuelValidation =>
      'Gib gültige Zahlen ein. Kraftstoff und Strecke müssen positiv sein oder bei reiner Wartung mit sonstigen Kosten beide null. Kosten dürfen nicht negativ sein. Verwende einen Währungscode aus drei Buchstaben und höchstens 500 Zeichen als Notiz.';

  @override
  String get fuelSaved => 'Eintrag gespeichert';

  @override
  String get fuelDeleted => 'Eintrag gelöscht';

  @override
  String get fuelTotalCost => 'Gesamte Fahrzeugkosten';

  @override
  String get fuelConsumption => 'Kraftstoffverbrauch';

  @override
  String get fuelLoggedDistance => 'Erfasste Strecke';

  @override
  String get fuelCostPerDistance => 'Kosten pro erfasster Strecke';

  @override
  String get fuelNoConsumption =>
      'Erfasse Kraftstoff und Strecke, um den Verbrauch zu berechnen';

  @override
  String get fuelLitersPer100Kilometers => 'L/100 km';

  @override
  String get fuelMilesPerUsGallon => 'mi/US-Gallone';

  @override
  String get fuelMileageLog => 'Fahrtenbuch';

  @override
  String fuelAmountPerDistance(String amount, String unit) {
    return '$amount/$unit';
  }

  @override
  String get focusedDisplay => 'Fokussierte Anzeige';

  @override
  String get exitFocusedDisplay => 'Fokussierte Anzeige verlassen';

  @override
  String get settingsSections => 'Einstellungsbereiche';

  @override
  String get allSettings => 'Alle Einstellungen';

  @override
  String get allTrips => 'Alle Fahrten';

  @override
  String get activeTrips => 'Laufend';

  @override
  String get finishedTrips => 'Abgeschlossene Fahrten';

  @override
  String get filterDates => 'Datum filtern';

  @override
  String get clearFilters => 'Filter löschen';

  @override
  String get previousPage => 'Vorherige Seite';

  @override
  String get nextPage => 'Nächste Seite';

  @override
  String historyPage(String page) {
    return 'Seite $page';
  }

  @override
  String get historyNoMatches => 'Keine Fahrten entsprechen diesen Filtern.';

  @override
  String get loadRegionalMap => 'Regionale Karte laden';

  @override
  String get removeRegionalMap => 'Regionale Karte entfernen';

  @override
  String get regionalMapDisclosure =>
      'Nur lokale GeoJSON-Linien (bis 5 MB). Verwenden Sie zulässige Daten mit Quellenangabe. Die Ebene bleibt nur bei geöffnetem Fahrtbildschirm im Speicher und wird nicht gespeichert oder gesichert.';

  @override
  String get regionalMapFailure =>
      'Die regionale Karte konnte nicht geladen werden. Wählen Sie eine gültige GeoJSON-FeatureCollection mit LineString- oder MultiLineString-Geometrie.';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get termsAndConditions => 'Allgemeine Geschäftsbedingungen';

  @override
  String get readOnlyWebPage =>
      'Schreibgeschützte Seite. Links und Formulare sind deaktiviert.';

  @override
  String get webPageLoadError =>
      'Die Seite konnte nicht geladen werden. Prüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String regionalMapSource(String source) {
    return 'Regionale Karte: $source';
  }
}
