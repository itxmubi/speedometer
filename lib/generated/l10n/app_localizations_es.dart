// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Velocímetro';

  @override
  String get appTagline => 'PRECISO. PRIVADO. GRATIS.';

  @override
  String get dashboardTitle => 'Panel en directo';

  @override
  String get dashboardSubtitle => 'Más claridad en cada trayecto.';

  @override
  String get settings => 'Ajustes';

  @override
  String get backToDashboard => 'Volver al panel';

  @override
  String get digital => 'Digital';

  @override
  String get analog => 'Analógico';

  @override
  String get hud => 'HUD';

  @override
  String get displayMode => 'Modo de visualización';

  @override
  String get currentSpeed => 'VELOCIDAD ACTUAL';

  @override
  String get speedUnit => 'Unidad de velocidad';

  @override
  String get unitKilometers => 'km/h';

  @override
  String get unitMiles => 'mi/h';

  @override
  String get unitMeters => 'm/s';

  @override
  String get unitKnots => 'kn';

  @override
  String get unitKilometersFull => 'Kilómetros por hora';

  @override
  String get unitMilesFull => 'Millas por hora';

  @override
  String get unitMetersFull => 'Metros por segundo';

  @override
  String get unitKnotsFull => 'Nudos';

  @override
  String get kilometers => 'km';

  @override
  String get miles => 'mi';

  @override
  String get nauticalMiles => 'mn';

  @override
  String get meters => 'm';

  @override
  String get gpsStandby => 'GPS en espera';

  @override
  String get gpsSearching => 'Buscando señal GPS';

  @override
  String get gpsLive => 'GPS conectado';

  @override
  String get gpsPaused => 'GPS en pausa';

  @override
  String get gpsUnavailable => 'GPS no disponible';

  @override
  String accuracyValue(String value) {
    return 'Precisión de ±$value m';
  }

  @override
  String speedSemantics(String value, String unit) {
    return 'Velocidad actual: $value $unit';
  }

  @override
  String get startPrompt => 'Cuando quieras';

  @override
  String get startHint => 'Inicia un viaje para ver tu velocidad GPS.';

  @override
  String get searchingHint =>
      'Una vista despejada del cielo ayuda al GPS a localizarte.';

  @override
  String get pausedHint => 'El viaje está en pausa. Continúa cuando quieras.';

  @override
  String get trackingHint =>
      'GPS activo. Usa los controles del viaje o la notificación para detenerlo.';

  @override
  String get thisTrip => 'Este viaje';

  @override
  String get sessionOnly => 'Viaje local · se guarda al finalizar';

  @override
  String get tripDistance => 'DISTANCIA';

  @override
  String get averageSpeed => 'VELOCIDAD MEDIA';

  @override
  String get topSpeed => 'VELOCIDAD MÁXIMA';

  @override
  String get tripDuration => 'DURACIÓN';

  @override
  String get movingAverage => 'Media en movimiento';

  @override
  String get movingTime => 'Tiempo en movimiento';

  @override
  String get altitude => 'Altitud';

  @override
  String get heading => 'Rumbo';

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
  String get startTrip => 'Iniciar viaje';

  @override
  String get pauseTrip => 'Pausar viaje';

  @override
  String get resumeTrip => 'Continuar viaje';

  @override
  String get startingTrip => 'Conectando…';

  @override
  String get resetTrip => 'Reiniciar viaje';

  @override
  String get resetTitle => '¿Empezar de nuevo?';

  @override
  String get resetMessage =>
      'Esto detiene el seguimiento y descarta el viaje actual. Se conservan los viajes anteriores, el odómetro total y las distancias por período.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get reset => 'Reiniciar';

  @override
  String get privacyFooter => 'Sin conexión. Sin cuenta. Sin subidas.';

  @override
  String get safeDriving =>
      'Configura antes de moverte. Mantén la atención en la carretera.';

  @override
  String get speedLimit => 'Límite de velocidad';

  @override
  String limitValue(String value, String unit) {
    return 'LÍMITE $value $unit';
  }

  @override
  String get overLimit => 'Has superado tu límite';

  @override
  String get overLimitSemantics =>
      'Aviso: has superado el límite seleccionado.';

  @override
  String get mirrorHud => 'Reflejar HUD';

  @override
  String get mirrorHudSubtitle =>
      'Invierte la lectura para reflejarla en el parabrisas.';

  @override
  String get hudHint =>
      'Lectura clara de un vistazo. Coloca el teléfono de forma segura antes de moverte.';

  @override
  String get displaySettings => 'Tu pantalla';

  @override
  String get displaySettingsDescription => 'Adapta el panel a tu gusto.';

  @override
  String get simpleView => 'Vista sencilla';

  @override
  String get simpleViewSubtitle => 'Céntrate en la velocidad actual.';

  @override
  String get darkMode => 'Apariencia oscura';

  @override
  String get darkModeSubtitle => 'Una pantalla más suave para viajar de noche.';

  @override
  String get warningSettings => 'Avisos de velocidad';

  @override
  String get warningSettingsDescription =>
      'Elige un límite personal y los avisos que prefieras.';

  @override
  String get enableWarning => 'Activar aviso de velocidad';

  @override
  String get enableWarningSubtitle =>
      'Avisa al superar el límite seleccionado y su margen.';

  @override
  String get warningScope =>
      'Sonido, vibración y voz son opcionales. Los avisos son una ayuda; mantén la atención en la carretera. Los ajustes de sonido y el hardware pueden afectar a las alertas.';

  @override
  String get decreaseLimit => 'Reducir límite de velocidad';

  @override
  String get increaseLimit => 'Aumentar límite de velocidad';

  @override
  String get privacySettings => 'Privacidad desde el diseño';

  @override
  String get privacySettingsDescription =>
      'Tu ubicación permite medir la velocidad en este dispositivo. No se suben datos de ubicación ni de viajes.';

  @override
  String get foregroundDisclosure =>
      'El GPS solo se inicia al tocar Iniciar viaje. Con el seguimiento en segundo plano activado, una notificación visible mantiene el seguimiento al salir y ofrece un botón Detener. Los viajes y las rutas precisas opcionales permanecen en este dispositivo hasta que los elimines o exportes un archivo. Sin cuenta ni subidas automáticas.';

  @override
  String get precisionDisclaimer =>
      'Las lecturas GPS pueden variar según la señal. Esta app es una ayuda, no sustituye al velocímetro del vehículo.';

  @override
  String get permissionEyebrow => 'TODO LISTO PARA EMPEZAR';

  @override
  String get permissionTitle => 'Tu viaje.\nTu privacidad.';

  @override
  String get permissionDescription =>
      'Una lectura clara de tu velocidad empieza con el GPS del teléfono.';

  @override
  String get permissionLocationTitle => 'Ubicación con un propósito';

  @override
  String get permissionLocationBody =>
      'La ubicación precisa permite leer la velocidad del GPS y medir la distancia del viaje.';

  @override
  String get permissionOfflineTitle => 'Siempre en tu dispositivo';

  @override
  String get permissionOfflineBody =>
      'Sin cuenta, subidas automáticas ni necesidad de internet. Los viajes y rutas precisas opcionales se guardan en este dispositivo. Puedes desactivar las rutas, exportar una copia local o eliminar tus datos en Ajustes.';

  @override
  String get permissionControlTitle => 'Tú tienes el control';

  @override
  String get permissionControlBody =>
      'El GPS se inicia al tocar Iniciar viaje. Una notificación visible puede mantener el seguimiento con la app minimizada y ofrece un botón Detener. Configura el segundo plano, las rutas y los avisos en Ajustes.';

  @override
  String get permissionContinue => 'Ir al panel';

  @override
  String get permissionRequestHint =>
      'Pediremos permiso de ubicación al iniciar el primer viaje.';

  @override
  String get failurePermissionDenied =>
      'Se necesita permiso de ubicación para mostrar la velocidad GPS. Toca Iniciar viaje para reintentarlo.';

  @override
  String get failurePermissionDeniedForever =>
      'La ubicación está desactivada para esta app. Activa la ubicación precisa en sus ajustes para iniciar un viaje.';

  @override
  String get failureLocationDisabled =>
      'La ubicación del dispositivo está desactivada. Actívala para obtener la velocidad GPS.';

  @override
  String get failureLocationUnavailable =>
      'Aún no hay una lectura GPS fiable. Reinténtalo con una vista despejada del cielo.';

  @override
  String get failureUnsupported =>
      'Esta plataforma no admite seguimiento GPS. Puedes previsualizar el panel y los ajustes de pantalla.';

  @override
  String get failureStorage =>
      'No se pudieron leer o guardar tus datos locales. Inténtalo de nuevo.';

  @override
  String get failureUnexpected =>
      'Algo interrumpió el viaje. Inténtalo de nuevo.';

  @override
  String get openAppSettings => 'Abrir ajustes de la app';

  @override
  String get openLocationSettings => 'Activar ubicación';

  @override
  String get dismissError => 'Cerrar mensaje';

  @override
  String get preferencesLoadFailure =>
      'No se pudieron cargar tus ajustes guardados.';

  @override
  String get retry => 'Reintentar';

  @override
  String get continueWithDefaults => 'Continuar con ajustes predeterminados';

  @override
  String get loadingPreferences => 'Preparando tu panel…';

  @override
  String get startupTitle => 'Un viaje más claro empieza aquí.';

  @override
  String get keepAwake => 'Mantener pantalla encendida';

  @override
  String get keepAwakeDescription =>
      'Evita que la pantalla se apague mientras sigues un viaje con el panel visible.';

  @override
  String get brightness => 'Brillo de pantalla';

  @override
  String get systemBrightness => 'Usar brillo del sistema';

  @override
  String get brightnessDescription =>
      'Solo cambia esta app. Al salir vuelve el brillo del sistema.';

  @override
  String get accentColor => 'Color del instrumento';

  @override
  String get colorLime => 'Lima';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorCyan => 'Cian';

  @override
  String get colorAmber => 'Ámbar';

  @override
  String get colorRose => 'Rosado';

  @override
  String get colorLavender => 'Lavanda';

  @override
  String get colorMint => 'Menta';

  @override
  String get colorOrange => 'Naranja';

  @override
  String get colorWhite => 'Blanco';

  @override
  String get colorPink => 'Rosa';

  @override
  String get leftHanded => 'Diseño para zurdos';

  @override
  String get leftHandedDescription =>
      'Coloca el instrumento a la izquierda en diseños anchos.';

  @override
  String get gaugeRange => 'Rango completo del indicador';

  @override
  String get nightHud => 'HUD de máximo contraste';

  @override
  String get nightHudDescription =>
      'Usa un HUD negro puro con lectura brillante para conducir de noche.';

  @override
  String get hudContent => 'Información del HUD';

  @override
  String get hudTime => 'Mostrar hora';

  @override
  String get hudCompass => 'Mostrar brújula';

  @override
  String get hudTrip => 'Mostrar distancia del viaje';

  @override
  String get soundAlert => 'Aviso sonoro';

  @override
  String get vibrationAlert => 'Aviso por vibración';

  @override
  String get voiceAlert => 'Aviso de voz';

  @override
  String get alertVolume => 'Volumen del aviso';

  @override
  String get alertOffset => 'Margen de aviso sobre el límite';

  @override
  String get alertOffsetDescription =>
      'El aviso se activa al superar tu límite más este margen.';

  @override
  String get calibration => 'Calibración de distancia';

  @override
  String get calibrationDescription =>
      'Ajusta las mediciones futuras para coincidir con un odómetro de referencia. La velocidad GPS y las distancias ya guardadas no cambian.';

  @override
  String get language => 'Idioma';

  @override
  String get systemLanguage => 'Idioma del sistema';

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
  String get trackingSettings => 'Seguimiento y grabación';

  @override
  String get autoRecordTrips => 'Guardar viajes automáticamente';

  @override
  String get autoRecordTripsDescription =>
      'Guarda cada sesión que inicies expresamente. Finaliza el viaje para añadirlo al historial. El GPS nunca se inicia solo.';

  @override
  String get recordRoute => 'Guardar ruta precisa';

  @override
  String get recordRouteDescription =>
      'Guarda localmente los puntos GPS aceptados y las coordenadas de inicio y fin para el mapa, la reproducción y la exportación GPX. Desactívalo para guardar solo estadísticas y muestras de velocidad. Las rutas existentes se conservan hasta eliminarlas.';

  @override
  String get backgroundTracking => 'Continuar al minimizar';

  @override
  String get backgroundTrackingDescription =>
      'Tras tocar Iniciar viaje, una notificación visible del servicio de ubicación mantiene el GPS activo fuera de la app. Usa Detener para finalizar la grabación. No se pide permiso de ubicación en segundo plano.';

  @override
  String get economyGps => 'GPS de bajo consumo';

  @override
  String get economyGpsDescription =>
      'Solicita una posición cada 3 segundos aproximadamente en lugar de cada segundo. La precisión y la respuesta dependen del dispositivo.';

  @override
  String get overlaySettings => 'Velocímetro flotante';

  @override
  String get overlayDescription =>
      'Muestra la velocidad sobre otras apps durante el viaje. Arrastra para mover y usa la esquina para cambiar el tamaño.';

  @override
  String get enableOverlay => 'Mostrar velocímetro flotante';

  @override
  String get disableOverlay => 'Ocultar velocímetro flotante';

  @override
  String get overlayPermissionTitle => '¿Permitir el velocímetro flotante?';

  @override
  String get overlayPermissionBody =>
      'Android necesita permiso para mostrar la velocidad sobre apps de navegación y otras apps. La ventana solo muestra la velocidad y el aviso de esta app; no lee contenido de otras apps. Puedes ocultarla aquí o detener el viaje desde la notificación.';

  @override
  String get openOverlaySettings => 'Permitir mostrar sobre otras apps';

  @override
  String get continueAction => 'Continuar';

  @override
  String get backupSettings => 'Copia local y datos';

  @override
  String get backupDescription =>
      'Las copias incluyen ajustes, peso opcional, viajes, rutas precisas, combustible y gastos del vehículo. Compártelas solo con personas y aplicaciones de confianza. No hay subidas automáticas.';

  @override
  String get exportBackup => 'Exportar copia local';

  @override
  String get restoreBackup => 'Restaurar copia local';

  @override
  String get restoreBackupTitle => '¿Restaurar una copia?';

  @override
  String get restoreBackupMessage =>
      'Una copia válida reemplaza los viajes, odómetro, combustible, gastos y ajustes de este dispositivo. Exporta una copia antes para conservar tus datos. El seguimiento se detiene antes de restaurar.';

  @override
  String get deleteAllData => 'Eliminar todos los datos locales';

  @override
  String get deleteAllDataTitle => '¿Eliminar todos los datos locales?';

  @override
  String get deleteAllDataMessage =>
      'Esto detiene el seguimiento y elimina viajes, rutas precisas, odómetro, combustible, gastos y ajustes de este dispositivo. Los archivos exportados no se eliminan.';

  @override
  String get deleteAction => 'Eliminar';

  @override
  String get resetPreferences => 'Restablecer ajustes';

  @override
  String get resetPreferencesTitle => '¿Restablecer ajustes?';

  @override
  String get resetPreferencesMessage =>
      'Restaura los ajustes predeterminados de pantalla, avisos y grabación. Los viajes guardados y el odómetro se conservan.';

  @override
  String get odometer => 'Odómetro total';

  @override
  String get todayDistance => 'Hoy';

  @override
  String get weekDistance => 'Esta semana';

  @override
  String get monthDistance => 'Este mes';

  @override
  String get compass => 'Brújula del dispositivo';

  @override
  String get compassUnavailable => 'Brújula no disponible en este dispositivo';

  @override
  String get courseOverGround => 'Rumbo GPS sobre el terreno';

  @override
  String get tripHistory => 'Historial de viajes';

  @override
  String get finishTrip => 'Finalizar y guardar viaje';

  @override
  String get platformUnsupported => 'Este dispositivo no admite esta función.';

  @override
  String get invalidBackup =>
      'La copia seleccionada no es válida o no es compatible.';

  @override
  String get storageMessage =>
      'No se pudieron leer o guardar tus datos locales. Inténtalo de nuevo.';

  @override
  String get warningSpoken =>
      'Has superado el límite de velocidad seleccionado.';

  @override
  String get notificationTitle => 'Seguimiento del velocímetro';

  @override
  String get notificationStop => 'Detener';

  @override
  String get nativePaused => 'Seguimiento en pausa';

  @override
  String get nativeTracking => 'Seguimiento activo';

  @override
  String get overlayPermissionMessage =>
      'Permite que el velocímetro aparezca sobre otras apps; después vuelve y activa la ventana flotante.';

  @override
  String get backupRestored => 'Se ha restaurado tu copia.';

  @override
  String get sessionRecordingOff =>
      'Guardado desactivado · el odómetro permanece en este dispositivo';

  @override
  String get timeLabel => 'Hora';

  @override
  String get tripHistoryEmpty => 'Tus viajes aparecerán aquí';

  @override
  String get tripHistoryEmptyDescription =>
      'Inicia un viaje en el panel y finalízalo para conservar las estadísticas y la ruta opcional en este dispositivo.';

  @override
  String get tripDetail => 'Detalles del viaje';

  @override
  String get tripNotFound => 'Este viaje ya no está disponible.';

  @override
  String get tripInProgress => 'En curso';

  @override
  String get tripFinished => 'Finalizado';

  @override
  String get deleteTrip => 'Eliminar viaje';

  @override
  String get deleteTripTitle => '¿Eliminar este viaje?';

  @override
  String get deleteTripMessage =>
      'Esto elimina permanentemente las estadísticas y la ruta guardada de este dispositivo. El odómetro total y las distancias por período se conservan. No se eliminan los archivos exportados.';

  @override
  String get tripRoute => 'Ruta grabada';

  @override
  String get tripRouteDescription =>
      'Mapa sin conexión con contornos terrestres aproximados. Pellizca para ampliar y arrastra para explorar. No incluye calles. Los cortes indican pausas o períodos sin ruta guardada.';

  @override
  String get tripNoRoute =>
      'No se guardó ninguna ruta. Las muestras de velocidad y estadísticas siguen disponibles.';

  @override
  String get tripStartPoint => 'Primer punto guardado';

  @override
  String get tripEndPoint => 'Último punto guardado';

  @override
  String get tripSpeedGraph => 'Velocidad a lo largo del tiempo';

  @override
  String get tripSpeedGraphDescription =>
      'Las muestras de velocidad se muestran según el tiempo transcurrido del viaje. Los huecos separan pausas e intervalos sin GPS.';

  @override
  String get tripNoSamples => 'No se grabaron muestras GPS aceptadas.';

  @override
  String get tripReplay => 'Reproducción de ruta';

  @override
  String get tripReplayPlay => 'Reproducir ruta';

  @override
  String get tripReplayPause => 'Pausar reproducción';

  @override
  String get tripReplayProgress => 'Posición de reproducción';

  @override
  String get tripReplayDescription =>
      'La reproducción sigue las muestras guardadas. Los segmentos discontinuos y marcadores de aviso identifican muestras por encima del límite seleccionado al grabar.';

  @override
  String get tripOverLimitLegend =>
      'Marcadores de aviso: por encima del límite';

  @override
  String get tripExportGpx => 'Compartir ruta GPX';

  @override
  String get tripExportCsv => 'Compartir muestras CSV';

  @override
  String get tripShareSummary => 'Compartir resumen del viaje';

  @override
  String get tripExportDisclosure =>
      'Las exportaciones pueden incluir coordenadas precisas guardadas. Compártelas solo con personas y apps de confianza.';

  @override
  String get tripChartSemantics => 'Gráfico de velocidad grabada';

  @override
  String get tripRouteSemantics =>
      'Ruta guardada con marcadores de inicio, fin y reproducción';

  @override
  String tripSummaryText(
    String date,
    String distance,
    String duration,
    String average,
    String maximum,
  ) {
    return 'Viaje del $date\nDistancia: $distance\nDuración: $duration\nMedia: $average\nVelocidad máxima: $maximum';
  }

  @override
  String tripSamplePosition(String position, String total) {
    return 'Muestra $position de $total';
  }

  @override
  String tripSampleTime(String time) {
    return 'Grabado a las $time';
  }

  @override
  String get tripBasemapAttribution =>
      'Contornos terrestres: Natural Earth (dominio público). Mapa global aproximado, sin calles.';

  @override
  String get activitySettings => 'Actividad';

  @override
  String get activityDescription =>
      'Cada actividad recuerda su unidad, estilo de indicador y rango.';

  @override
  String get activityMode => 'Modo de actividad';

  @override
  String get activityCar => 'Coche';

  @override
  String get activityCycling => 'Ciclismo';

  @override
  String get activityWalking => 'Caminar';

  @override
  String get activityRunning => 'Correr';

  @override
  String get activityBoating => 'Navegación';

  @override
  String get activityLocked =>
      'Finaliza o reinicia el viaje actual antes de cambiar la actividad o el peso.';

  @override
  String get bodyWeight => 'Peso corporal';

  @override
  String get bodyWeightDescription =>
      'Se guarda localmente para estimar calorías. Se incluye en las copias de seguridad locales.';

  @override
  String get bodyWeightEnabled => 'Estimar calorías';

  @override
  String get bodyWeightEnabledDescription =>
      'Añade tu peso para estimar las calorías al pedalear, caminar y correr.';

  @override
  String get kilograms => 'kg';

  @override
  String get estimatedCalories => 'Calorías estimadas';

  @override
  String get kilocalories => 'kcal';

  @override
  String get calorieEstimateDescription =>
      'Estimación aproximada de energía total a esfuerzo moderado, según el tiempo en movimiento y el peso. El consumo real varía.';

  @override
  String get fuelCosts => 'Combustible y costes del vehículo';

  @override
  String get fuelLogEmpty => 'Aún no hay gastos de combustible o del vehículo';

  @override
  String get fuelLogDescription =>
      'Registra el combustible y la distancia recorrida con él. Para mantenimiento, deja combustible y distancia en cero. Usa los viajes guardados como registro de kilometraje. Los totales por moneda se mantienen separados, sin tipos de cambio.';

  @override
  String get fuelAddEntry => 'Añadir registro';

  @override
  String get fuelEditEntry => 'Editar registro';

  @override
  String get fuelDeleteEntry => 'Eliminar registro';

  @override
  String get fuelDeleteConfirmation =>
      '¿Eliminar este registro de combustible y gastos?';

  @override
  String get fuelEntryDate => 'Fecha';

  @override
  String get fuelDistance => 'Distancia recorrida';

  @override
  String get fuelVolume => 'Combustible usado';

  @override
  String get fuelVolumeUnit => 'Unidad de combustible';

  @override
  String get fuelDistanceUnit => 'Unidad de distancia';

  @override
  String get fuelLiters => 'L';

  @override
  String get fuelUsGallons => 'gal EE. UU.';

  @override
  String get fuelCost => 'Coste del combustible';

  @override
  String get fuelOtherCost => 'Otros gastos del vehículo';

  @override
  String get fuelCurrency => 'Código de moneda';

  @override
  String get fuelCurrencyHint => 'Tres letras, como USD o AED';

  @override
  String get fuelNote => 'Nota (opcional)';

  @override
  String get fuelSaveEntry => 'Guardar registro';

  @override
  String get fuelValidation =>
      'Introduce números válidos. El combustible y la distancia deben ser positivos, o ambos cero para mantenimiento con otros gastos. Los costes no pueden ser negativos. Usa un código de moneda de tres letras y una nota de hasta 500 caracteres.';

  @override
  String get fuelSaved => 'Registro guardado';

  @override
  String get fuelDeleted => 'Registro eliminado';

  @override
  String get fuelTotalCost => 'Gastos totales del vehículo';

  @override
  String get fuelConsumption => 'Consumo de combustible';

  @override
  String get fuelLoggedDistance => 'Distancia registrada';

  @override
  String get fuelCostPerDistance => 'Coste por distancia registrada';

  @override
  String get fuelNoConsumption =>
      'Añade combustible y distancia para calcular el consumo';

  @override
  String get fuelLitersPer100Kilometers => 'L/100 km';

  @override
  String get fuelMilesPerUsGallon => 'mi/gal EE. UU.';

  @override
  String get fuelMileageLog => 'Registro de kilometraje';

  @override
  String fuelAmountPerDistance(String amount, String unit) {
    return '$amount/$unit';
  }

  @override
  String get focusedDisplay => 'Vista enfocada';

  @override
  String get exitFocusedDisplay => 'Salir de la vista enfocada';

  @override
  String get settingsSections => 'Secciones de ajustes';

  @override
  String get allSettings => 'Todos los ajustes';

  @override
  String get allTrips => 'Todos los viajes';

  @override
  String get activeTrips => 'En curso';

  @override
  String get finishedTrips => 'Viajes finalizados';

  @override
  String get filterDates => 'Filtrar fechas';

  @override
  String get clearFilters => 'Borrar filtros';

  @override
  String get previousPage => 'Página anterior';

  @override
  String get nextPage => 'Página siguiente';

  @override
  String historyPage(String page) {
    return 'Página $page';
  }

  @override
  String get historyNoMatches => 'Ningún viaje coincide con estos filtros.';

  @override
  String get loadRegionalMap => 'Cargar mapa regional';

  @override
  String get removeRegionalMap => 'Eliminar mapa regional';

  @override
  String get regionalMapDisclosure =>
      'Solo líneas GeoJSON locales (hasta 5 MB). Usa datos autorizados con su fuente. La capa permanece en memoria mientras esta pantalla esté abierta; no se guarda ni se incluye en las copias de seguridad.';

  @override
  String get regionalMapFailure =>
      'No se pudo cargar el mapa regional. Elige una FeatureCollection GeoJSON válida con geometría LineString o MultiLineString.';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsAndConditions => 'Términos y condiciones';

  @override
  String get readOnlyWebPage =>
      'Página de solo lectura. Los enlaces y formularios están desactivados.';

  @override
  String get webPageLoadError =>
      'No se pudo cargar la página. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String regionalMapSource(String source) {
    return 'Mapa regional: $source';
  }
}
