// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'عداد السرعة';

  @override
  String get appTagline => 'دقيق. خاص. مجاني.';

  @override
  String get dashboardTitle => 'لوحة القيادة المباشرة';

  @override
  String get dashboardSubtitle => 'وضوح أكبر في كل رحلة.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get backToDashboard => 'العودة إلى لوحة القيادة';

  @override
  String get digital => 'رقمي';

  @override
  String get analog => 'تناظري';

  @override
  String get hud => 'العرض على الزجاج';

  @override
  String get displayMode => 'وضع العرض';

  @override
  String get currentSpeed => 'السرعة الحالية';

  @override
  String get speedUnit => 'وحدة السرعة';

  @override
  String get unitKilometers => 'كم/س';

  @override
  String get unitMiles => 'ميل/س';

  @override
  String get unitMeters => 'م/ث';

  @override
  String get unitKnots => 'عقدة';

  @override
  String get unitKilometersFull => 'كيلومتر في الساعة';

  @override
  String get unitMilesFull => 'ميل في الساعة';

  @override
  String get unitMetersFull => 'متر في الثانية';

  @override
  String get unitKnotsFull => 'عقدة';

  @override
  String get kilometers => 'كم';

  @override
  String get miles => 'ميل';

  @override
  String get nauticalMiles => 'ميل بحري';

  @override
  String get meters => 'م';

  @override
  String get gpsStandby => 'GPS في وضع الاستعداد';

  @override
  String get gpsSearching => 'جارٍ البحث عن إشارة GPS';

  @override
  String get gpsLive => 'GPS متصل';

  @override
  String get gpsPaused => 'GPS متوقف مؤقتًا';

  @override
  String get gpsUnavailable => 'GPS غير متاح';

  @override
  String accuracyValue(String value) {
    return 'الدقة ±$value م';
  }

  @override
  String speedSemantics(String value, String unit) {
    return 'السرعة الحالية $value $unit';
  }

  @override
  String get startPrompt => 'جاهز عندما تكون مستعدًا';

  @override
  String get startHint => 'ابدأ رحلة لعرض سرعتك المباشرة عبر GPS.';

  @override
  String get searchingHint =>
      'تساعد رؤية السماء بوضوح جهاز GPS على تحديد موقعك.';

  @override
  String get pausedHint => 'رحلتك متوقفة مؤقتًا. تابع عندما تكون مستعدًا.';

  @override
  String get trackingHint =>
      'GPS نشط. استخدم أدوات الرحلة أو الإشعار لإيقاف التتبع.';

  @override
  String get thisTrip => 'هذه الرحلة';

  @override
  String get sessionOnly => 'رحلة محلية · تُحفظ عند الانتهاء';

  @override
  String get tripDistance => 'المسافة';

  @override
  String get averageSpeed => 'متوسط السرعة';

  @override
  String get topSpeed => 'السرعة القصوى';

  @override
  String get tripDuration => 'المدة';

  @override
  String get movingAverage => 'المتوسط أثناء الحركة';

  @override
  String get movingTime => 'وقت الحركة';

  @override
  String get altitude => 'الارتفاع';

  @override
  String get heading => 'الاتجاه';

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
  String get startTrip => 'بدء رحلة';

  @override
  String get pauseTrip => 'إيقاف الرحلة مؤقتًا';

  @override
  String get resumeTrip => 'متابعة الرحلة';

  @override
  String get startingTrip => 'جارٍ الاتصال…';

  @override
  String get resetTrip => 'إعادة ضبط الرحلة';

  @override
  String get resetTitle => 'هل تريد البدء من جديد؟';

  @override
  String get resetMessage =>
      'سيؤدي هذا إلى إيقاف التتبع وتجاهل الرحلة الحالية. تبقى الرحلات المحفوظة السابقة وعداد المسافة الكلي وإجماليات المسافة للفترات الزمنية.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get privacyFooter => 'يعمل دون إنترنت. دون حساب. دون رفع بيانات.';

  @override
  String get safeDriving =>
      'اضبط الإعدادات قبل التحرك. أبقِ انتباهك على الطريق.';

  @override
  String get speedLimit => 'حد السرعة';

  @override
  String limitValue(String value, String unit) {
    return 'الحد $value $unit';
  }

  @override
  String get overLimit => 'تجاوزت حد السرعة المحدد';

  @override
  String get overLimitSemantics => 'تحذير: تجاوزت حد السرعة الذي حددته.';

  @override
  String get mirrorHud => 'عكس العرض على الزجاج';

  @override
  String get mirrorHudSubtitle => 'اعكس القراءة لتنعكس على الزجاج الأمامي.';

  @override
  String get hudHint => 'عرض واضح وسريع القراءة. ضع هاتفك بأمان قبل التحرك.';

  @override
  String get displaySettings => 'شاشتك';

  @override
  String get displaySettingsDescription => 'خصص لوحة القيادة بما يناسبك.';

  @override
  String get simpleView => 'عرض مبسط';

  @override
  String get simpleViewSubtitle => 'ركز على سرعتك الحالية.';

  @override
  String get darkMode => 'المظهر الداكن';

  @override
  String get darkModeSubtitle => 'عرض أهدأ لرحلات الليل.';

  @override
  String get warningSettings => 'تحذيرات السرعة';

  @override
  String get warningSettingsDescription =>
      'اختر حدًا شخصيًا والتحذيرات التي تفضلها.';

  @override
  String get enableWarning => 'تفعيل تحذير السرعة';

  @override
  String get enableWarningSubtitle => 'عرض تحذير عند تجاوز الحد المحدد وهامشه.';

  @override
  String get warningScope =>
      'الصوت والاهتزاز والنطق خيارات اختيارية. التحذير وسيلة مساعدة؛ أبقِ انتباهك على الطريق. قد تؤثر إعدادات الصوت ومكونات الجهاز في التحذيرات الصوتية والاهتزازية.';

  @override
  String get decreaseLimit => 'خفض حد السرعة';

  @override
  String get increaseLimit => 'زيادة حد السرعة';

  @override
  String get privacySettings => 'الخصوصية أساس التصميم';

  @override
  String get privacySettingsDescription =>
      'يُستخدم موقعك لتشغيل عداد السرعة على هذا الجهاز. لا تُرفع بيانات الموقع أو الرحلات.';

  @override
  String get foregroundDisclosure =>
      'يبدأ GPS فقط عند الضغط على بدء رحلة. عند تفعيل التتبع في الخلفية، يواصل إشعار ظاهر التتبع بعد مغادرة التطبيق ويوفر زر إيقاف. تبقى الرحلات والمسارات الدقيقة الاختيارية على هذا الجهاز حتى تحذفها أو تصدر ملفًا بنفسك. دون حساب أو رفع تلقائي.';

  @override
  String get precisionDisclaimer =>
      'قد تختلف قراءات GPS حسب ظروف الإشارة. هذا التطبيق وسيلة مساعدة ولا يحل محل عداد سرعة مركبتك.';

  @override
  String get permissionEyebrow => 'لنستعد للانطلاق';

  @override
  String get permissionTitle => 'رحلتك.\nخصوصيتك.';

  @override
  String get permissionDescription =>
      'تبدأ قراءة سرعتك بوضوح باستخدام GPS في هاتفك.';

  @override
  String get permissionLocationTitle => 'الموقع لغرض محدد';

  @override
  String get permissionLocationBody =>
      'يتيح الموقع الدقيق قراءة السرعة التي يوفرها GPS وقياس مسافة رحلتك.';

  @override
  String get permissionOfflineTitle => 'دائمًا على جهازك';

  @override
  String get permissionOfflineBody =>
      'دون حساب أو رفع تلقائي أو حاجة إلى الإنترنت. تُحفظ الرحلات والمسارات الدقيقة الاختيارية على هذا الجهاز. يمكنك تعطيل حفظ المسارات أو تصدير نسخة احتياطية محلية أو حذف بياناتك من الإعدادات.';

  @override
  String get permissionControlTitle => 'أنت المتحكم';

  @override
  String get permissionControlBody =>
      'يبدأ GPS عند الضغط على بدء رحلة. يمكن لإشعار ظاهر مواصلة التتبع عند تصغير التطبيق ويتضمن زر إيقاف. تحكم في التتبع بالخلفية وتسجيل المسار والتحذيرات من الإعدادات.';

  @override
  String get permissionContinue => 'المتابعة إلى لوحة القيادة';

  @override
  String get permissionRequestHint => 'سنطلب إذن الموقع عند بدء رحلتك الأولى.';

  @override
  String get failurePermissionDenied =>
      'يلزم إذن الموقع لعرض سرعة GPS. اضغط على بدء رحلة للمحاولة مجددًا.';

  @override
  String get failurePermissionDeniedForever =>
      'الوصول إلى الموقع معطل لهذا التطبيق. فعّل الموقع الدقيق في إعدادات التطبيق لبدء رحلة.';

  @override
  String get failureLocationDisabled =>
      'خدمة الموقع على جهازك معطلة. شغلها لعرض سرعتك عبر GPS.';

  @override
  String get failureLocationUnavailable =>
      'لا تتوفر قراءة GPS موثوقة بعد. حاول مجددًا في مكان تظهر فيه السماء بوضوح.';

  @override
  String get failureUnsupported =>
      'تتبع GPS غير مدعوم على هذه المنصة. يمكنك معاينة لوحة القيادة وإعدادات العرض.';

  @override
  String get failureStorage =>
      'تعذرت قراءة بياناتك المحلية أو حفظها. يرجى المحاولة مجددًا.';

  @override
  String get failureUnexpected =>
      'حدث ما أدى إلى مقاطعة الرحلة. يرجى المحاولة مجددًا.';

  @override
  String get openAppSettings => 'فتح إعدادات التطبيق';

  @override
  String get openLocationSettings => 'تشغيل الموقع';

  @override
  String get dismissError => 'إغلاق الرسالة';

  @override
  String get preferencesLoadFailure => 'تعذر تحميل إعداداتك المحفوظة.';

  @override
  String get retry => 'المحاولة مجددًا';

  @override
  String get continueWithDefaults => 'المتابعة بالإعدادات الافتراضية';

  @override
  String get loadingPreferences => 'جارٍ تجهيز لوحة القيادة…';

  @override
  String get startupTitle => 'تبدأ رحلة أوضح من هنا.';

  @override
  String get keepAwake => 'إبقاء الشاشة مضاءة';

  @override
  String get keepAwakeDescription =>
      'منع سكون الشاشة أثناء التتبع ولوحة القيادة ظاهرة.';

  @override
  String get brightness => 'سطوع الشاشة';

  @override
  String get systemBrightness => 'استخدام سطوع النظام';

  @override
  String get brightnessDescription =>
      'يؤثر في هذا التطبيق فقط. يعود سطوع النظام عند مغادرته.';

  @override
  String get accentColor => 'لون العداد';

  @override
  String get colorLime => 'ليموني';

  @override
  String get colorBlue => 'أزرق';

  @override
  String get colorCyan => 'سماوي';

  @override
  String get colorAmber => 'كهرماني';

  @override
  String get colorRose => 'وردي محمر';

  @override
  String get colorLavender => 'خزامي';

  @override
  String get colorMint => 'نعناعي';

  @override
  String get colorOrange => 'برتقالي';

  @override
  String get colorWhite => 'أبيض';

  @override
  String get colorPink => 'وردي';

  @override
  String get leftHanded => 'تخطيط لليد اليسرى';

  @override
  String get leftHandedDescription =>
      'ضع العداد على اليسار في التخطيطات الواسعة.';

  @override
  String get gaugeRange => 'النطاق الكامل للعداد';

  @override
  String get nightHud => 'عرض زجاجي بأقصى تباين';

  @override
  String get nightHudDescription =>
      'استخدم خلفية سوداء تمامًا مع قراءة ساطعة للقيادة الليلية.';

  @override
  String get hudContent => 'معلومات العرض على الزجاج';

  @override
  String get hudTime => 'إظهار الوقت';

  @override
  String get hudCompass => 'إظهار البوصلة';

  @override
  String get hudTrip => 'إظهار مسافة الرحلة';

  @override
  String get soundAlert => 'تحذير صوتي';

  @override
  String get vibrationAlert => 'تحذير بالاهتزاز';

  @override
  String get voiceAlert => 'تحذير منطوق';

  @override
  String get alertVolume => 'مستوى صوت التحذير';

  @override
  String get alertOffset => 'هامش التحذير فوق الحد';

  @override
  String get alertOffsetDescription =>
      'يبدأ التحذير عند حدك المحدد مضافًا إليه هذا الهامش.';

  @override
  String get calibration => 'معايرة المسافة';

  @override
  String get calibrationDescription =>
      'اضبط قياسات المسافة المستقبلية لتطابق عداد مسافة مرجعيًا. تبقى سرعة GPS والمسافات المسجلة سابقًا دون تغيير.';

  @override
  String get language => 'اللغة';

  @override
  String get systemLanguage => 'لغة النظام';

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
  String get trackingSettings => 'التتبع والتسجيل';

  @override
  String get autoRecordTrips => 'حفظ الرحلات تلقائيًا';

  @override
  String get autoRecordTripsDescription =>
      'احفظ كل جلسة تبدأها بنفسك. أنهِ الرحلة لإضافتها إلى السجل. لا يبدأ GPS تلقائيًا أبدًا.';

  @override
  String get recordRoute => 'حفظ المسار الدقيق';

  @override
  String get recordRouteDescription =>
      'احتفظ بإحداثيات البداية والنهاية ونقاط GPS المقبولة محليًا للخريطة وإعادة العرض وتصدير GPX. عطّل الخيار لحفظ الإحصاءات وعينات السرعة فقط. تبقى المسارات الحالية حتى تحذفها.';

  @override
  String get backgroundTracking => 'المتابعة عند التصغير';

  @override
  String get backgroundTrackingDescription =>
      'بعد الضغط على بدء رحلة، يُبقي إشعار ظاهر لخدمة الموقع GPS نشطًا خارج التطبيق. استخدم زر الإيقاف لإنهاء التسجيل. لا يُطلب إذن الموقع في الخلفية.';

  @override
  String get economyGps => 'GPS موفر للبطارية';

  @override
  String get economyGpsDescription =>
      'اطلب قراءة موقع كل 3 ثوانٍ تقريبًا بدلًا من كل ثانية. تعتمد الدقة وسرعة الاستجابة على جهازك.';

  @override
  String get overlaySettings => 'عداد السرعة العائم';

  @override
  String get overlayDescription =>
      'اعرض السرعة فوق التطبيقات الأخرى أثناء الرحلة. اسحب للتحريك واستخدم مقبض الزاوية لتغيير الحجم.';

  @override
  String get enableOverlay => 'إظهار عداد السرعة العائم';

  @override
  String get disableOverlay => 'إخفاء عداد السرعة العائم';

  @override
  String get overlayPermissionTitle => 'هل تسمح بعداد السرعة العائم؟';

  @override
  String get overlayPermissionBody =>
      'يحتاج Android إلى إذن لعرض قراءة السرعة فوق تطبيقات الملاحة والتطبيقات الأخرى. تعرض النافذة سرعة هذا التطبيق وحالة التحذير فقط ولا تقرأ محتوى التطبيقات الأخرى. يمكنك إخفاؤها هنا أو إيقاف الرحلة من الإشعار.';

  @override
  String get openOverlaySettings => 'السماح بالظهور فوق التطبيقات الأخرى';

  @override
  String get continueAction => 'متابعة';

  @override
  String get backupSettings => 'النسخ الاحتياطي المحلي والبيانات';

  @override
  String get backupDescription =>
      'تشمل النسخ الاحتياطية الإعدادات والوزن الاختياري والرحلات والمسارات الدقيقة وسجلات الوقود وتكاليف المركبة. شاركها فقط مع جهات وتطبيقات تثق بها. لا تُرفع أي بيانات تلقائيًا.';

  @override
  String get exportBackup => 'تصدير نسخة احتياطية محلية';

  @override
  String get restoreBackup => 'استعادة نسخة احتياطية محلية';

  @override
  String get restoreBackupTitle => 'هل تريد استعادة نسخة احتياطية؟';

  @override
  String get restoreBackupMessage =>
      'تستبدل النسخة الصالحة الرحلات وعداد المسافة وسجلات الوقود والتكاليف والإعدادات على هذا الجهاز. صدّر نسخة أولًا للاحتفاظ ببياناتك. يتوقف التتبع قبل الاستعادة.';

  @override
  String get deleteAllData => 'حذف جميع البيانات المحلية';

  @override
  String get deleteAllDataTitle => 'هل تريد حذف جميع البيانات المحلية؟';

  @override
  String get deleteAllDataMessage =>
      'يتوقف التتبع وتُحذف الرحلات والمسارات الدقيقة وعداد المسافة وسجلات الوقود والتكاليف والإعدادات من هذا الجهاز. لا تُحذف الملفات المصدّرة سابقًا.';

  @override
  String get deleteAction => 'حذف';

  @override
  String get resetPreferences => 'إعادة ضبط الإعدادات';

  @override
  String get resetPreferencesTitle => 'هل تريد إعادة ضبط الإعدادات؟';

  @override
  String get resetPreferencesMessage =>
      'استعد إعدادات العرض والتحذير والتسجيل الافتراضية. ستبقى الرحلات المحفوظة وعداد المسافة.';

  @override
  String get odometer => 'عداد المسافة الكلي';

  @override
  String get todayDistance => 'اليوم';

  @override
  String get weekDistance => 'هذا الأسبوع';

  @override
  String get monthDistance => 'هذا الشهر';

  @override
  String get compass => 'بوصلة الجهاز';

  @override
  String get compassUnavailable => 'البوصلة غير متاحة على هذا الجهاز';

  @override
  String get courseOverGround => 'اتجاه الحركة عبر GPS';

  @override
  String get tripHistory => 'سجل الرحلات';

  @override
  String get finishTrip => 'إنهاء الرحلة وحفظها';

  @override
  String get platformUnsupported => 'هذا الجهاز لا يدعم هذه الميزة.';

  @override
  String get invalidBackup =>
      'النسخة الاحتياطية المحددة غير صالحة أو غير متوافقة.';

  @override
  String get storageMessage =>
      'تعذرت قراءة بياناتك المحلية أو حفظها. يرجى المحاولة مجددًا.';

  @override
  String get warningSpoken => 'لقد تجاوزت حد السرعة الذي حددته.';

  @override
  String get notificationTitle => 'تتبع عداد السرعة';

  @override
  String get notificationStop => 'إيقاف';

  @override
  String get nativePaused => 'التتبع متوقف مؤقتًا';

  @override
  String get nativeTracking => 'التتبع نشط';

  @override
  String get overlayPermissionMessage =>
      'اسمح لعداد السرعة بالظهور فوق التطبيقات الأخرى، ثم ارجع وفعّل النافذة العائمة.';

  @override
  String get backupRestored => 'تمت استعادة نسختك الاحتياطية.';

  @override
  String get sessionRecordingOff =>
      'حفظ الرحلات معطل · يبقى عداد المسافة على هذا الجهاز';

  @override
  String get timeLabel => 'الوقت';

  @override
  String get tripHistoryEmpty => 'ستظهر رحلاتك هنا';

  @override
  String get tripHistoryEmptyDescription =>
      'ابدأ رحلة من لوحة القيادة ثم أنهها لحفظ الإحصاءات والمسار الاختياري على هذا الجهاز.';

  @override
  String get tripDetail => 'تفاصيل الرحلة';

  @override
  String get tripNotFound => 'لم تعد هذه الرحلة متاحة.';

  @override
  String get tripInProgress => 'قيد التنفيذ';

  @override
  String get tripFinished => 'مكتملة';

  @override
  String get deleteTrip => 'حذف الرحلة';

  @override
  String get deleteTripTitle => 'هل تريد حذف هذه الرحلة؟';

  @override
  String get deleteTripMessage =>
      'سيؤدي هذا إلى حذف إحصاءات الرحلة ومسارها المحفوظ من هذا الجهاز نهائيًا. يبقى عداد المسافة الكلي وإجماليات المسافة للفترات الزمنية. لن تُحذف الملفات المصدّرة.';

  @override
  String get tripRoute => 'المسار المسجل';

  @override
  String get tripRouteDescription =>
      'خريطة دون إنترنت مع حدود تقريبية لليابسة. استخدم إصبعين للتكبير واسحب للاستكشاف. لا تتضمن شوارع. تشير الفجوات إلى توقفات مؤقتة أو فترات لم يُحفظ فيها المسار.';

  @override
  String get tripNoRoute =>
      'لم يُحفظ مسار. لا تزال عينات السرعة والإحصاءات متاحة.';

  @override
  String get tripStartPoint => 'أول نقطة محفوظة';

  @override
  String get tripEndPoint => 'آخر نقطة محفوظة';

  @override
  String get tripSpeedGraph => 'السرعة مع مرور الوقت';

  @override
  String get tripSpeedGraphDescription =>
      'تُعرض عينات السرعة مقابل الوقت المنقضي من الرحلة. تفصل الفجوات بين التوقفات المؤقتة وفترات انقطاع GPS.';

  @override
  String get tripNoSamples => 'لم تُسجل عينات GPS مقبولة.';

  @override
  String get tripReplay => 'إعادة عرض المسار';

  @override
  String get tripReplayPlay => 'تشغيل إعادة عرض المسار';

  @override
  String get tripReplayPause => 'إيقاف إعادة العرض مؤقتًا';

  @override
  String get tripReplayProgress => 'موضع إعادة العرض';

  @override
  String get tripReplayDescription =>
      'تتبع إعادة العرض العينات المحفوظة. تحدد المقاطع المتقطعة وعلامات التحذير العينات التي تجاوزت حد السرعة المحدد أثناء التسجيل.';

  @override
  String get tripOverLimitLegend => 'علامات التحذير: أعلى من الحد المحدد';

  @override
  String get tripExportGpx => 'مشاركة المسار بصيغة GPX';

  @override
  String get tripExportCsv => 'مشاركة العينات بصيغة CSV';

  @override
  String get tripShareSummary => 'مشاركة ملخص الرحلة';

  @override
  String get tripExportDisclosure =>
      'قد تتضمن الملفات المصدرة إحداثيات دقيقة محفوظة. شاركها فقط مع أشخاص وتطبيقات تثق بهم.';

  @override
  String get tripChartSemantics => 'رسم بياني للسرعة المسجلة';

  @override
  String get tripRouteSemantics =>
      'مسار محفوظ مع علامات البداية والنهاية وموضع إعادة العرض';

  @override
  String tripSummaryText(
    String date,
    String distance,
    String duration,
    String average,
    String maximum,
  ) {
    return 'رحلة بتاريخ $date\nالمسافة: $distance\nالمدة: $duration\nالمتوسط: $average\nالسرعة القصوى: $maximum';
  }

  @override
  String tripSamplePosition(String position, String total) {
    return 'العينة $position من $total';
  }

  @override
  String tripSampleTime(String time) {
    return 'سُجلت في $time';
  }

  @override
  String get tripBasemapAttribution =>
      'حدود اليابسة: Natural Earth (ملك عام). خريطة عالمية تقريبية دون شوارع.';

  @override
  String get activitySettings => 'النشاط';

  @override
  String get activityDescription => 'يحتفظ كل نشاط بوحدته ونمط عداده ونطاقه.';

  @override
  String get activityMode => 'وضع النشاط';

  @override
  String get activityCar => 'سيارة';

  @override
  String get activityCycling => 'ركوب الدراجة';

  @override
  String get activityWalking => 'المشي';

  @override
  String get activityRunning => 'الجري';

  @override
  String get activityBoating => 'الإبحار';

  @override
  String get activityLocked =>
      'أنهِ الرحلة الحالية أو أعد ضبطها قبل تغيير النشاط أو الوزن.';

  @override
  String get bodyWeight => 'وزن الجسم';

  @override
  String get bodyWeightDescription =>
      'يُحفظ محليًا لتقدير تقريبي للسعرات، ويُضمّن في النسخ الاحتياطية المحلية.';

  @override
  String get bodyWeightEnabled => 'تقدير السعرات الحرارية';

  @override
  String get bodyWeightEnabledDescription =>
      'أضف وزنك لتقدير السعرات أثناء ركوب الدراجة والمشي والجري.';

  @override
  String get kilograms => 'كغ';

  @override
  String get estimatedCalories => 'السعرات الحرارية المقدّرة';

  @override
  String get kilocalories => 'سعرة حرارية';

  @override
  String get calorieEstimateDescription =>
      'تقدير تقريبي لإجمالي الطاقة عند جهد معتدل استنادًا إلى وقت الحركة والوزن. يختلف الاستهلاك الفعلي.';

  @override
  String get fuelCosts => 'الوقود وتكاليف المركبة';

  @override
  String get fuelLogEmpty => 'لا توجد سجلات للوقود أو تكاليف المركبة بعد';

  @override
  String get fuelLogDescription =>
      'سجّل الوقود والمسافة التي قطعها. للصيانة فقط، اترك الوقود والمسافة صفرًا. استخدم الرحلات المحفوظة كسجل للمسافات. تُجمع كل عملة على حدة دون تطبيق أسعار صرف.';

  @override
  String get fuelAddEntry => 'إضافة سجل';

  @override
  String get fuelEditEntry => 'تعديل السجل';

  @override
  String get fuelDeleteEntry => 'حذف السجل';

  @override
  String get fuelDeleteConfirmation => 'هل تريد حذف سجل الوقود والتكاليف هذا؟';

  @override
  String get fuelEntryDate => 'التاريخ';

  @override
  String get fuelDistance => 'المسافة المقطوعة';

  @override
  String get fuelVolume => 'الوقود المستهلك';

  @override
  String get fuelVolumeUnit => 'وحدة الوقود';

  @override
  String get fuelDistanceUnit => 'وحدة المسافة';

  @override
  String get fuelLiters => 'لتر';

  @override
  String get fuelUsGallons => 'غالون أمريكي';

  @override
  String get fuelCost => 'تكلفة الوقود';

  @override
  String get fuelOtherCost => 'تكاليف المركبة الأخرى';

  @override
  String get fuelCurrency => 'رمز العملة';

  @override
  String get fuelCurrencyHint => 'ثلاثة أحرف مثل USD أو AED';

  @override
  String get fuelNote => 'ملاحظة (اختيارية)';

  @override
  String get fuelSaveEntry => 'حفظ السجل';

  @override
  String get fuelValidation =>
      'أدخل أرقامًا صحيحة. يجب أن يكون الوقود والمسافة موجبين، أو كليهما صفرًا للصيانة مع تكاليف أخرى. لا يمكن أن تكون التكاليف سالبة. استخدم رمز عملة من ثلاثة أحرف وملاحظة لا تتجاوز 500 حرف.';

  @override
  String get fuelSaved => 'تم حفظ السجل';

  @override
  String get fuelDeleted => 'تم حذف السجل';

  @override
  String get fuelTotalCost => 'إجمالي تكاليف المركبة';

  @override
  String get fuelConsumption => 'استهلاك الوقود';

  @override
  String get fuelLoggedDistance => 'المسافة المسجلة';

  @override
  String get fuelCostPerDistance => 'التكلفة لكل مسافة مسجلة';

  @override
  String get fuelNoConsumption => 'أضف الوقود والمسافة لحساب الاستهلاك';

  @override
  String get fuelLitersPer100Kilometers => 'لتر/١٠٠ كم';

  @override
  String get fuelMilesPerUsGallon => 'ميل/غالون أمريكي';

  @override
  String get fuelMileageLog => 'سجل مسافات الرحلات';

  @override
  String fuelAmountPerDistance(String amount, String unit) {
    return '$amount/$unit';
  }

  @override
  String get focusedDisplay => 'عرض مركّز';

  @override
  String get exitFocusedDisplay => 'الخروج من العرض المركّز';

  @override
  String get settingsSections => 'أقسام الإعدادات';

  @override
  String get allSettings => 'كل الإعدادات';

  @override
  String get allTrips => 'كل الرحلات';

  @override
  String get activeTrips => 'قيد التسجيل';

  @override
  String get finishedTrips => 'الرحلات المكتملة';

  @override
  String get filterDates => 'تصفية التواريخ';

  @override
  String get clearFilters => 'مسح عوامل التصفية';

  @override
  String get previousPage => 'الصفحة السابقة';

  @override
  String get nextPage => 'الصفحة التالية';

  @override
  String historyPage(String page) {
    return 'الصفحة $page';
  }

  @override
  String get historyNoMatches => 'لا توجد رحلات تطابق عوامل التصفية.';

  @override
  String get loadRegionalMap => 'تحميل خريطة إقليمية';

  @override
  String get removeRegionalMap => 'إزالة الخريطة الإقليمية';

  @override
  String get regionalMapDisclosure =>
      'خطوط GeoJSON محلية فقط (حتى 5 ميغابايت). اختر بيانات مسموحًا باستخدامها مع ذكر مصدرها. تبقى الطبقة في الذاكرة أثناء فتح شاشة الرحلة فقط ولا تُحفظ أو تُضمّن في النسخ الاحتياطية.';

  @override
  String get regionalMapFailure =>
      'تعذر تحميل الخريطة الإقليمية. اختر FeatureCollection صالحة بصيغة GeoJSON بهندسة LineString أو MultiLineString.';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get readOnlyWebPage => 'صفحة للقراءة فقط. الروابط والنماذج معطّلة.';

  @override
  String get webPageLoadError =>
      'تعذر تحميل الصفحة. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String regionalMapSource(String source) {
    return 'الخريطة الإقليمية: $source';
  }
}
