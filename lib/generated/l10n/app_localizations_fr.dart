// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Compteur de vitesse';

  @override
  String get appTagline => 'PRÉCIS. PRIVÉ. GRATUIT.';

  @override
  String get dashboardTitle => 'Tableau de bord en direct';

  @override
  String get dashboardSubtitle => 'Plus de clarté à chaque trajet.';

  @override
  String get settings => 'Réglages';

  @override
  String get backToDashboard => 'Retour au tableau de bord';

  @override
  String get digital => 'Numérique';

  @override
  String get analog => 'Analogique';

  @override
  String get hud => 'HUD';

  @override
  String get displayMode => 'Mode d’affichage';

  @override
  String get currentSpeed => 'VITESSE ACTUELLE';

  @override
  String get speedUnit => 'Unité de vitesse';

  @override
  String get unitKilometers => 'km/h';

  @override
  String get unitMiles => 'mi/h';

  @override
  String get unitMeters => 'm/s';

  @override
  String get unitKnots => 'nd';

  @override
  String get unitKilometersFull => 'Kilomètres par heure';

  @override
  String get unitMilesFull => 'Miles par heure';

  @override
  String get unitMetersFull => 'Mètres par seconde';

  @override
  String get unitKnotsFull => 'Nœuds';

  @override
  String get kilometers => 'km';

  @override
  String get miles => 'mi';

  @override
  String get nauticalMiles => 'M';

  @override
  String get meters => 'm';

  @override
  String get gpsStandby => 'GPS en veille';

  @override
  String get gpsSearching => 'Recherche du signal GPS';

  @override
  String get gpsLive => 'GPS connecté';

  @override
  String get gpsPaused => 'GPS en pause';

  @override
  String get gpsUnavailable => 'GPS indisponible';

  @override
  String accuracyValue(String value) {
    return 'Précision de ±$value m';
  }

  @override
  String speedSemantics(String value, String unit) {
    return 'Vitesse actuelle : $value $unit';
  }

  @override
  String get startPrompt => 'À vous de partir';

  @override
  String get startHint => 'Démarrez un trajet pour voir votre vitesse GPS.';

  @override
  String get searchingHint => 'Un ciel dégagé facilite la réception GPS.';

  @override
  String get pausedHint =>
      'Votre trajet est en pause. Reprenez quand vous le souhaitez.';

  @override
  String get trackingHint =>
      'Le GPS est actif. Utilisez les commandes du trajet ou la notification pour arrêter.';

  @override
  String get thisTrip => 'Ce trajet';

  @override
  String get sessionOnly => 'Trajet local · enregistré à la fin';

  @override
  String get tripDistance => 'DISTANCE';

  @override
  String get averageSpeed => 'VITESSE MOYENNE';

  @override
  String get topSpeed => 'VITESSE MAXIMALE';

  @override
  String get tripDuration => 'DURÉE';

  @override
  String get movingAverage => 'Moyenne en mouvement';

  @override
  String get movingTime => 'Temps en mouvement';

  @override
  String get altitude => 'Altitude';

  @override
  String get heading => 'Cap';

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
  String get startTrip => 'Démarrer un trajet';

  @override
  String get pauseTrip => 'Mettre en pause';

  @override
  String get resumeTrip => 'Reprendre le trajet';

  @override
  String get startingTrip => 'Connexion…';

  @override
  String get resetTrip => 'Réinitialiser le trajet';

  @override
  String get resetTitle => 'Repartir de zéro ?';

  @override
  String get resetMessage =>
      'Le suivi s’arrête et le trajet actuel est abandonné. Les trajets précédents, le compteur kilométrique total et les totaux par période sont conservés.';

  @override
  String get cancel => 'Annuler';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get privacyFooter => 'Hors ligne. Sans compte. Sans envoi de données.';

  @override
  String get safeDriving =>
      'Réglez l’application avant de partir. Gardez les yeux sur la route.';

  @override
  String get speedLimit => 'Limite de vitesse';

  @override
  String limitValue(String value, String unit) {
    return 'LIMITE $value $unit';
  }

  @override
  String get overLimit => 'Limite de vitesse dépassée';

  @override
  String get overLimitSemantics =>
      'Attention : vous dépassez la limite choisie.';

  @override
  String get mirrorHud => 'Inverser le HUD';

  @override
  String get mirrorHudSubtitle =>
      'Inversez l’affichage pour le reflet sur le pare-brise.';

  @override
  String get hudHint =>
      'Une lecture claire en un coup d’œil. Placez votre téléphone en sécurité avant de partir.';

  @override
  String get displaySettings => 'Votre affichage';

  @override
  String get displaySettingsDescription =>
      'Adaptez le tableau de bord à vos préférences.';

  @override
  String get simpleView => 'Vue simplifiée';

  @override
  String get simpleViewSubtitle =>
      'Concentrez-vous sur votre vitesse actuelle.';

  @override
  String get darkMode => 'Apparence sombre';

  @override
  String get darkModeSubtitle =>
      'Un affichage plus doux pour les trajets de nuit.';

  @override
  String get warningSettings => 'Alertes de vitesse';

  @override
  String get warningSettingsDescription =>
      'Choisissez votre limite et vos alertes.';

  @override
  String get enableWarning => 'Activer l’alerte de vitesse';

  @override
  String get enableWarningSubtitle =>
      'Avertir au-delà de la limite choisie et de la marge.';

  @override
  String get warningScope =>
      'Le son, la vibration et la voix sont facultatifs. Les alertes sont une aide ; restez attentif à la route. Les réglages sonores et le matériel peuvent affecter les alertes sonores et tactiles.';

  @override
  String get decreaseLimit => 'Réduire la limite';

  @override
  String get increaseLimit => 'Augmenter la limite';

  @override
  String get privacySettings => 'La confidentialité par conception';

  @override
  String get privacySettingsDescription =>
      'Votre position sert au compteur de cet appareil. Aucune donnée de position ou de trajet n’est envoyée.';

  @override
  String get foregroundDisclosure =>
      'Le GPS démarre uniquement quand vous touchez Démarrer un trajet. Si le suivi en arrière-plan est activé, une notification visible maintient le suivi hors de l’application et propose un bouton Arrêter. Les trajets et les itinéraires précis facultatifs restent sur cet appareil jusqu’à leur suppression ou leur exportation. Sans compte ni envoi automatique.';

  @override
  String get precisionDisclaimer =>
      'Les mesures GPS varient selon le signal. Cette application est une aide et ne remplace pas le compteur du véhicule.';

  @override
  String get permissionEyebrow => 'PRÉPARONS VOTRE DÉPART';

  @override
  String get permissionTitle => 'Votre trajet.\nVotre vie privée.';

  @override
  String get permissionDescription =>
      'Une lecture claire de votre vitesse commence par le GPS de votre téléphone.';

  @override
  String get permissionLocationTitle => 'La position, pour une raison précise';

  @override
  String get permissionLocationBody =>
      'La position précise permet de lire la vitesse du GPS et de mesurer la distance parcourue.';

  @override
  String get permissionOfflineTitle => 'Toujours sur votre appareil';

  @override
  String get permissionOfflineBody =>
      'Sans compte, sans envoi automatique et sans connexion internet. Les trajets et les itinéraires précis facultatifs sont enregistrés sur cet appareil. Désactivez les itinéraires, exportez une sauvegarde locale ou supprimez vos données dans Réglages.';

  @override
  String get permissionControlTitle => 'Vous gardez le contrôle';

  @override
  String get permissionControlBody =>
      'Le GPS démarre quand vous touchez Démarrer un trajet. Une notification visible peut maintenir le suivi quand l’application est réduite et propose un bouton Arrêter. Réglez le suivi en arrière-plan, les itinéraires et les alertes dans Réglages.';

  @override
  String get permissionContinue => 'Accéder au tableau de bord';

  @override
  String get permissionRequestHint =>
      'L’autorisation de localisation sera demandée au premier trajet.';

  @override
  String get failurePermissionDenied =>
      'L’autorisation de localisation est nécessaire pour afficher la vitesse GPS. Touchez Démarrer un trajet pour réessayer.';

  @override
  String get failurePermissionDeniedForever =>
      'L’accès à la position est désactivé pour cette application. Activez la position précise dans ses paramètres pour démarrer un trajet.';

  @override
  String get failureLocationDisabled =>
      'La localisation de l’appareil est désactivée. Activez-la pour obtenir votre vitesse GPS.';

  @override
  String get failureLocationUnavailable =>
      'Aucune mesure GPS fiable pour le moment. Réessayez avec une vue dégagée du ciel.';

  @override
  String get failureUnsupported =>
      'Le suivi GPS n’est pas pris en charge sur cette plateforme. Le tableau de bord et les réglages d’affichage restent consultables.';

  @override
  String get failureStorage =>
      'Impossible de lire ou d’enregistrer vos données locales. Réessayez.';

  @override
  String get failureUnexpected =>
      'Un problème a interrompu le trajet. Réessayez.';

  @override
  String get openAppSettings => 'Ouvrir les paramètres de l’application';

  @override
  String get openLocationSettings => 'Activer la localisation';

  @override
  String get dismissError => 'Fermer le message';

  @override
  String get preferencesLoadFailure =>
      'Impossible de charger vos réglages enregistrés.';

  @override
  String get retry => 'Réessayer';

  @override
  String get continueWithDefaults => 'Continuer avec les réglages par défaut';

  @override
  String get loadingPreferences => 'Préparation de votre tableau de bord…';

  @override
  String get startupTitle => 'Un trajet plus clair commence ici.';

  @override
  String get keepAwake => 'Garder l’écran allumé';

  @override
  String get keepAwakeDescription =>
      'Empêchez la veille pendant le suivi lorsque le tableau de bord est visible.';

  @override
  String get brightness => 'Luminosité de l’écran';

  @override
  String get systemBrightness => 'Utiliser la luminosité du système';

  @override
  String get brightnessDescription =>
      'Seule cette application est modifiée. La luminosité du système revient en la quittant.';

  @override
  String get accentColor => 'Couleur de l’instrument';

  @override
  String get colorLime => 'Vert citron';

  @override
  String get colorBlue => 'Bleu';

  @override
  String get colorCyan => 'Cyan';

  @override
  String get colorAmber => 'Ambre';

  @override
  String get colorRose => 'Rose';

  @override
  String get colorLavender => 'Lavande';

  @override
  String get colorMint => 'Menthe';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorWhite => 'Blanc';

  @override
  String get colorPink => 'Rose vif';

  @override
  String get leftHanded => 'Disposition pour gaucher';

  @override
  String get leftHandedDescription =>
      'Placez l’instrument à gauche dans les vues larges.';

  @override
  String get gaugeRange => 'Plage complète du cadran';

  @override
  String get nightHud => 'HUD à contraste maximal';

  @override
  String get nightHudDescription =>
      'Utilisez un HUD noir pur avec une lecture lumineuse pour la nuit.';

  @override
  String get hudContent => 'Informations du HUD';

  @override
  String get hudTime => 'Afficher l’heure';

  @override
  String get hudCompass => 'Afficher la boussole';

  @override
  String get hudTrip => 'Afficher la distance du trajet';

  @override
  String get soundAlert => 'Alerte sonore';

  @override
  String get vibrationAlert => 'Alerte par vibration';

  @override
  String get voiceAlert => 'Alerte vocale';

  @override
  String get alertVolume => 'Volume des alertes';

  @override
  String get alertOffset => 'Marge d’alerte au-dessus de la limite';

  @override
  String get alertOffsetDescription =>
      'L’alerte commence à votre limite augmentée de cette marge.';

  @override
  String get calibration => 'Étalonnage de la distance';

  @override
  String get calibrationDescription =>
      'Ajustez les futures mesures selon un compteur kilométrique de référence. La vitesse GPS et les distances déjà enregistrées restent inchangées.';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Langue du système';

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
  String get trackingSettings => 'Suivi et enregistrement';

  @override
  String get autoRecordTrips => 'Enregistrer automatiquement les trajets';

  @override
  String get autoRecordTripsDescription =>
      'Enregistrez chaque session que vous démarrez explicitement. Terminez le trajet pour l’ajouter à l’historique. Le GPS ne démarre jamais automatiquement.';

  @override
  String get recordRoute => 'Enregistrer l’itinéraire précis';

  @override
  String get recordRouteDescription =>
      'Conservez localement les coordonnées de départ et d’arrivée et les points GPS acceptés pour la carte, la relecture et l’export GPX. Désactivez pour ne garder que statistiques et vitesses. Les itinéraires existants restent jusqu’à leur suppression.';

  @override
  String get backgroundTracking => 'Continuer en arrière-plan';

  @override
  String get backgroundTrackingDescription =>
      'Après Démarrer un trajet, une notification visible du service de localisation maintient le GPS actif hors de l’application. Utilisez Arrêter pour terminer. Aucune autorisation de localisation en arrière-plan n’est demandée.';

  @override
  String get economyGps => 'GPS économe en batterie';

  @override
  String get economyGpsDescription =>
      'Demande une position environ toutes les 3 secondes au lieu d’une seconde. La précision et la réactivité dépendent de votre appareil.';

  @override
  String get overlaySettings => 'Compteur flottant';

  @override
  String get overlayDescription =>
      'Affichez la vitesse sur les autres applications pendant un trajet. Faites glisser pour déplacer et utilisez la poignée d’angle pour redimensionner.';

  @override
  String get enableOverlay => 'Afficher le compteur flottant';

  @override
  String get disableOverlay => 'Masquer le compteur flottant';

  @override
  String get overlayPermissionTitle => 'Autoriser le compteur flottant ?';

  @override
  String get overlayPermissionBody =>
      'Android demande une autorisation pour afficher la vitesse au-dessus de la navigation et des autres applications. La fenêtre n’affiche que la vitesse et les alertes de cette application ; elle ne lit pas le contenu des autres applications. Masquez-la ici ou arrêtez le trajet dans la notification.';

  @override
  String get openOverlaySettings =>
      'Autoriser l’affichage sur les autres applications';

  @override
  String get continueAction => 'Continuer';

  @override
  String get backupSettings => 'Sauvegarde locale et données';

  @override
  String get backupDescription =>
      'Les sauvegardes comprennent réglages, poids facultatif, trajets, parcours précis, carburant et frais du véhicule. Partagez-les uniquement avec des personnes et applications de confiance. Aucun envoi automatique.';

  @override
  String get exportBackup => 'Exporter une sauvegarde locale';

  @override
  String get restoreBackup => 'Restaurer une sauvegarde locale';

  @override
  String get restoreBackupTitle => 'Restaurer une sauvegarde ?';

  @override
  String get restoreBackupMessage =>
      'Une sauvegarde valide remplace trajets, compteur, carburant, frais et réglages sur cet appareil. Exportez une sauvegarde pour conserver vos données. Le suivi s’arrête avant la restauration.';

  @override
  String get deleteAllData => 'Supprimer toutes les données locales';

  @override
  String get deleteAllDataTitle => 'Supprimer toutes les données locales ?';

  @override
  String get deleteAllDataMessage =>
      'Le suivi s’arrête et les trajets, parcours précis, compteur, carburant, frais et réglages de cet appareil sont supprimés. Les fichiers déjà exportés sont conservés.';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get resetPreferences => 'Réinitialiser les réglages';

  @override
  String get resetPreferencesTitle => 'Réinitialiser les réglages ?';

  @override
  String get resetPreferencesMessage =>
      'Rétablit les réglages d’affichage, d’alerte et d’enregistrement par défaut. Les trajets enregistrés et le compteur kilométrique sont conservés.';

  @override
  String get odometer => 'Compteur kilométrique total';

  @override
  String get todayDistance => 'Aujourd’hui';

  @override
  String get weekDistance => 'Cette semaine';

  @override
  String get monthDistance => 'Ce mois-ci';

  @override
  String get compass => 'Boussole de l’appareil';

  @override
  String get compassUnavailable => 'Boussole indisponible sur cet appareil';

  @override
  String get courseOverGround => 'Route suivie au sol par GPS';

  @override
  String get tripHistory => 'Historique des trajets';

  @override
  String get finishTrip => 'Terminer et enregistrer le trajet';

  @override
  String get platformUnsupported =>
      'Cet appareil ne prend pas en charge cette fonction.';

  @override
  String get invalidBackup =>
      'La sauvegarde sélectionnée est invalide ou incompatible.';

  @override
  String get storageMessage =>
      'Impossible de lire ou d’enregistrer vos données locales. Réessayez.';

  @override
  String get warningSpoken => 'Vous dépassez la limite de vitesse choisie.';

  @override
  String get notificationTitle => 'Suivi du compteur de vitesse';

  @override
  String get notificationStop => 'Arrêter';

  @override
  String get nativePaused => 'Suivi en pause';

  @override
  String get nativeTracking => 'Suivi actif';

  @override
  String get overlayPermissionMessage =>
      'Autorisez le compteur à s’afficher sur les autres applications, puis revenez activer la fenêtre flottante.';

  @override
  String get backupRestored => 'Votre sauvegarde a été restaurée.';

  @override
  String get sessionRecordingOff =>
      'Enregistrement désactivé · compteur conservé sur cet appareil';

  @override
  String get timeLabel => 'Heure';

  @override
  String get tripHistoryEmpty => 'Vos trajets apparaîtront ici';

  @override
  String get tripHistoryEmptyDescription =>
      'Démarrez un trajet sur le tableau de bord, puis terminez-le pour conserver les statistiques et l’itinéraire facultatif sur cet appareil.';

  @override
  String get tripDetail => 'Détails du trajet';

  @override
  String get tripNotFound => 'Ce trajet n’est plus disponible.';

  @override
  String get tripInProgress => 'En cours';

  @override
  String get tripFinished => 'Terminé';

  @override
  String get deleteTrip => 'Supprimer le trajet';

  @override
  String get deleteTripTitle => 'Supprimer ce trajet ?';

  @override
  String get deleteTripMessage =>
      'Les statistiques et l’itinéraire enregistré sont définitivement supprimés de cet appareil. Le compteur total et les totaux par période sont conservés. Les fichiers exportés ne sont pas supprimés.';

  @override
  String get tripRoute => 'Itinéraire enregistré';

  @override
  String get tripRouteDescription =>
      'Carte hors ligne avec contours terrestres simplifiés. Pincez pour zoomer et faites glisser pour explorer. Les rues ne sont pas incluses. Les coupures indiquent des pauses ou des périodes sans itinéraire enregistré.';

  @override
  String get tripNoRoute =>
      'Aucun itinéraire enregistré. Les vitesses et les statistiques restent disponibles.';

  @override
  String get tripStartPoint => 'Premier point enregistré';

  @override
  String get tripEndPoint => 'Dernier point enregistré';

  @override
  String get tripSpeedGraph => 'Vitesse au fil du temps';

  @override
  String get tripSpeedGraphDescription =>
      'Les vitesses sont représentées selon le temps écoulé du trajet. Les interruptions séparent les pauses et les périodes sans GPS.';

  @override
  String get tripNoSamples => 'Aucune mesure GPS acceptée n’a été enregistrée.';

  @override
  String get tripReplay => 'Relecture de l’itinéraire';

  @override
  String get tripReplayPlay => 'Lire l’itinéraire';

  @override
  String get tripReplayPause => 'Mettre la relecture en pause';

  @override
  String get tripReplayProgress => 'Position de lecture';

  @override
  String get tripReplayDescription =>
      'La relecture suit les mesures enregistrées. Les segments en pointillés et les repères d’alerte indiquent les vitesses au-dessus de la limite choisie pendant l’enregistrement.';

  @override
  String get tripOverLimitLegend =>
      'Repères d’alerte : limite choisie dépassée';

  @override
  String get tripExportGpx => 'Partager l’itinéraire GPX';

  @override
  String get tripExportCsv => 'Partager les mesures CSV';

  @override
  String get tripShareSummary => 'Partager le résumé du trajet';

  @override
  String get tripExportDisclosure =>
      'Les exports peuvent inclure des coordonnées précises enregistrées. Partagez-les uniquement avec des personnes et applications de confiance.';

  @override
  String get tripChartSemantics => 'Graphique de la vitesse enregistrée';

  @override
  String get tripRouteSemantics =>
      'Itinéraire enregistré avec repères de départ, d’arrivée et de lecture';

  @override
  String tripSummaryText(
    String date,
    String distance,
    String duration,
    String average,
    String maximum,
  ) {
    return 'Trajet du $date\nDistance : $distance\nDurée : $duration\nMoyenne : $average\nVitesse maximale : $maximum';
  }

  @override
  String tripSamplePosition(String position, String total) {
    return 'Mesure $position sur $total';
  }

  @override
  String tripSampleTime(String time) {
    return 'Enregistré à $time';
  }

  @override
  String get tripBasemapAttribution =>
      'Contours terrestres : Natural Earth (domaine public). Fond de carte mondial simplifié, sans rues.';

  @override
  String get activitySettings => 'Activité';

  @override
  String get activityDescription =>
      'Chaque activité mémorise son unité, son cadran et sa plage.';

  @override
  String get activityMode => 'Mode d’activité';

  @override
  String get activityCar => 'Voiture';

  @override
  String get activityCycling => 'Vélo';

  @override
  String get activityWalking => 'Marche';

  @override
  String get activityRunning => 'Course';

  @override
  String get activityBoating => 'Navigation';

  @override
  String get activityLocked =>
      'Terminez ou réinitialisez le trajet avant de changer d’activité ou de poids.';

  @override
  String get bodyWeight => 'Poids corporel';

  @override
  String get bodyWeightDescription =>
      'Conservé localement pour estimer les calories. Inclus dans les sauvegardes locales.';

  @override
  String get bodyWeightEnabled => 'Estimer les calories';

  @override
  String get bodyWeightEnabledDescription =>
      'Ajoutez votre poids pour estimer les calories à vélo, à pied et en course.';

  @override
  String get kilograms => 'kg';

  @override
  String get estimatedCalories => 'Calories estimées';

  @override
  String get kilocalories => 'kcal';

  @override
  String get calorieEstimateDescription =>
      'Estimation approximative de l’énergie totale à effort modéré, selon le temps en mouvement et le poids. La dépense réelle varie.';

  @override
  String get fuelCosts => 'Carburant et frais du véhicule';

  @override
  String get fuelLogEmpty => 'Aucun plein ni frais enregistré';

  @override
  String get fuelLogDescription =>
      'Enregistrez le carburant et la distance parcourue avec celui-ci. Pour l’entretien seul, laissez carburant et distance à zéro. Les trajets conservés servent de carnet kilométrique. Les devises restent séparées, sans conversion.';

  @override
  String get fuelAddEntry => 'Ajouter une entrée';

  @override
  String get fuelEditEntry => 'Modifier l’entrée';

  @override
  String get fuelDeleteEntry => 'Supprimer l’entrée';

  @override
  String get fuelDeleteConfirmation =>
      'Supprimer cette entrée de carburant et de frais ?';

  @override
  String get fuelEntryDate => 'Date';

  @override
  String get fuelDistance => 'Distance parcourue';

  @override
  String get fuelVolume => 'Carburant utilisé';

  @override
  String get fuelVolumeUnit => 'Unité de carburant';

  @override
  String get fuelDistanceUnit => 'Unité de distance';

  @override
  String get fuelLiters => 'L';

  @override
  String get fuelUsGallons => 'gal US';

  @override
  String get fuelCost => 'Coût du carburant';

  @override
  String get fuelOtherCost => 'Autres frais du véhicule';

  @override
  String get fuelCurrency => 'Code devise';

  @override
  String get fuelCurrencyHint => 'Trois lettres, par exemple USD ou AED';

  @override
  String get fuelNote => 'Note (facultative)';

  @override
  String get fuelSaveEntry => 'Enregistrer';

  @override
  String get fuelValidation =>
      'Saisissez des nombres valides. Le carburant et la distance doivent être positifs, ou tous deux nuls pour un entretien avec d’autres frais. Les coûts doivent être positifs ou nuls. Utilisez un code devise de trois lettres et une note de 500 caractères maximum.';

  @override
  String get fuelSaved => 'Entrée enregistrée';

  @override
  String get fuelDeleted => 'Entrée supprimée';

  @override
  String get fuelTotalCost => 'Frais totaux du véhicule';

  @override
  String get fuelConsumption => 'Consommation de carburant';

  @override
  String get fuelLoggedDistance => 'Distance enregistrée';

  @override
  String get fuelCostPerDistance => 'Coût par distance enregistrée';

  @override
  String get fuelNoConsumption =>
      'Ajoutez carburant et distance pour calculer la consommation';

  @override
  String get fuelLitersPer100Kilometers => 'L/100 km';

  @override
  String get fuelMilesPerUsGallon => 'mi/gal US';

  @override
  String get fuelMileageLog => 'Carnet kilométrique';

  @override
  String fuelAmountPerDistance(String amount, String unit) {
    return '$amount/$unit';
  }

  @override
  String get focusedDisplay => 'Affichage épuré';

  @override
  String get exitFocusedDisplay => 'Quitter l’affichage épuré';

  @override
  String get settingsSections => 'Sections des réglages';

  @override
  String get allSettings => 'Tous les réglages';

  @override
  String get allTrips => 'Tous les trajets';

  @override
  String get activeTrips => 'En cours';

  @override
  String get finishedTrips => 'Trajets terminés';

  @override
  String get filterDates => 'Filtrer les dates';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get previousPage => 'Page précédente';

  @override
  String get nextPage => 'Page suivante';

  @override
  String historyPage(String page) {
    return 'Page $page';
  }

  @override
  String get historyNoMatches => 'Aucun trajet ne correspond à ces filtres.';

  @override
  String get loadRegionalMap => 'Charger une carte régionale';

  @override
  String get removeRegionalMap => 'Supprimer la carte régionale';

  @override
  String get regionalMapDisclosure =>
      'Lignes GeoJSON locales uniquement (5 Mo maximum). Utilisez des données autorisées avec leur source. La couche reste en mémoire pendant l’ouverture de cet écran ; elle n’est ni enregistrée ni sauvegardée.';

  @override
  String get regionalMapFailure =>
      'Impossible de charger la carte régionale. Choisissez une FeatureCollection GeoJSON valide avec une géométrie LineString ou MultiLineString.';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get readOnlyWebPage =>
      'Page en lecture seule. Les liens et les formulaires sont désactivés.';

  @override
  String get webPageLoadError =>
      'Impossible de charger la page. Vérifiez votre connexion et réessayez.';

  @override
  String regionalMapSource(String source) {
    return 'Carte régionale : $source';
  }
}
