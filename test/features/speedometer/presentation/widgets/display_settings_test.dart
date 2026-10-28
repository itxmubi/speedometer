import 'package:speedometer/features/speedometer/presentation/screens/focused_display_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/theme/app_colors.dart';
import 'package:speedometer/core/theme/app_theme.dart';
import 'package:speedometer/features/activities/domain/entities/activity_mode.dart';
import 'package:speedometer/features/activities/domain/usecases/select_activity_use_case.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/gauge_style.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';
import 'package:speedometer/features/speedometer/domain/entities/trip_stats.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_controller.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_providers.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_state.dart';
import 'package:speedometer/features/speedometer/presentation/screens/settings_screen.dart';
import 'package:speedometer/features/speedometer/presentation/screens/speedometer_screen.dart';
import 'package:speedometer/features/speedometer/presentation/widgets/analog_gauge.dart';
import 'package:speedometer/features/speedometer/presentation/widgets/gauge_panel.dart';
import 'package:speedometer/features/speedometer/presentation/widgets/trip_stats_panel.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

void main() {
  Future<void> pumpDisplay(
    WidgetTester tester, {
    required Widget child,
    DisplayPreferences preferences = const DisplayPreferences(),
    String language = 'en',
    double scale = 1,
    Size size = const Size(420, 920),
    _DisplayController? controller,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          speedometerControllerProvider.overrideWith(
            () => controller ?? _DisplayController(preferences),
          ),
          dashboardTimeProvider.overrideWith(
            (ref) => Stream.value(DateTime(2026, 10, 21, 20, 34)),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          locale: Locale(language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final size in [const Size(320, 640), const Size(900, 420)]) {
    for (final language in ['en', 'ar']) {
      testWidgets(
        'focused HUD retains visible controls at $size in $language',
        (tester) async {
          await pumpDisplay(
            tester,
            child: const FocusedDisplayScreen(),
            size: size,
            scale: 2,
            language: language,
            preferences: const DisplayPreferences(
              gaugeStyle: GaugeStyle.hud,
              nightHud: true,
              mirroredHud: true,
            ),
          );
          final l10n = AppLocalizations.of(
            tester.element(find.byType(FocusedDisplayScreen)),
          );
          expect(find.text(l10n.dashboardTitle), findsNothing);
          expect(find.text(l10n.mirrorHud), findsNothing);
          expect(find.text(l10n.startTrip).hitTestable(), findsOneWidget);
          expect(
            find.byTooltip(l10n.exitFocusedDisplay).hitTestable(),
            findsOneWidget,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('settings menu opens a category and returns to all settings', (
    tester,
  ) async {
    await pumpDisplay(tester, child: const SettingsScreen());
    await tester.tap(find.byTooltip('Settings sections'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tracking and recording').last);
    await tester.pumpAndSettle();
    expect(find.text('Save precise route'), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<ActivityMode>), findsNothing);
    await tester.tap(find.byTooltip('Settings sections'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All settings'));
    await tester.pumpAndSettle();
    expect(find.byType(DropdownButtonFormField<ActivityMode>), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'night HUD shows selected time and hardware heading on true black',
    (tester) async {
      await pumpDisplay(
        tester,
        child: const Scaffold(body: SingleChildScrollView(child: GaugePanel())),
        preferences: const DisplayPreferences(
          gaugeStyle: GaugeStyle.hud,
          nightHud: true,
          mirroredHud: true,
        ),
      );
      expect(find.text('20:34'), findsOneWidget);
      expect(find.text('123°'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == AppColors.black,
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'HUD hides all optional content when each preference is disabled',
    (tester) async {
      await pumpDisplay(
        tester,
        child: const Scaffold(body: SingleChildScrollView(child: GaugePanel())),
        preferences: const DisplayPreferences(
          gaugeStyle: GaugeStyle.hud,
          hudShowTime: false,
          hudShowCompass: false,
          hudShowTrip: false,
        ),
      );
      expect(find.text('20:34'), findsNothing);
      expect(find.text('123°'), findsNothing);
    },
  );

  testWidgets(
    'analog range follows canonical preference when displaying miles',
    (tester) async {
      await pumpDisplay(
        tester,
        child: const Scaffold(body: SingleChildScrollView(child: GaugePanel())),
        preferences: const DisplayPreferences(
          unit: SpeedUnit.milesPerHour,
          gaugeStyle: GaugeStyle.analog,
          gaugeRangeMetersPerSecond: 40,
        ),
      );
      final gauge = tester.widget<AnalogGauge>(find.byType(AnalogGauge));
      expect(
        gauge.range,
        closeTo(SpeedUnit.milesPerHour.fromMetersPerSecond(40), 0.001),
      );
    },
  );

  for (final leftHanded in [false, true]) {
    testWidgets(
      'wide dashboard places instrument on selected side ($leftHanded)',
      (tester) async {
        await pumpDisplay(
          tester,
          child: const SpeedometerScreen(),
          size: const Size(1200, 1400),
          preferences: DisplayPreferences(leftHanded: leftHanded),
        );
        final instrumentX = tester.getCenter(find.byType(GaugePanel)).dx;
        final statsX = tester.getCenter(find.byType(TripStatsPanel)).dx;
        expect(instrumentX < statsX, leftHanded);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('settings disclose overlay permission before enabling it', (
    tester,
  ) async {
    final controller = _DisplayController(const DisplayPreferences());
    await pumpDisplay(
      tester,
      child: const SettingsScreen(),
      controller: controller,
    );
    await tester.scrollUntilVisible(
      find.text('Show floating speedometer'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Show floating speedometer'));
    await tester.pumpAndSettle();
    expect(controller.overlayCalls, 0);
    expect(find.text('Allow a floating speedometer?'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(controller.overlayCalls, 1);
  });

  testWidgets(
    'activity selector and optional weight expose the saved choices',
    (tester) async {
      final controller = _DisplayController(const DisplayPreferences());
      await pumpDisplay(
        tester,
        child: const SettingsScreen(),
        controller: controller,
      );
      await tester.tap(find.byType(DropdownButtonFormField<ActivityMode>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Boating').last);
      await tester.pumpAndSettle();
      expect(controller.activityCalls, 1);
      expect(controller.currentPreferences.activityMode, ActivityMode.boating);
      expect(controller.currentPreferences.unit, SpeedUnit.knots);

      await tester.tap(find.text('Estimate calories'));
      await tester.pumpAndSettle();
      expect(controller.weightCalls, 1);
      expect(controller.currentPreferences.bodyWeightKilograms, 70);
      expect(find.text('70.0 kg'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a paused trip disables mode and weight changes with an explanation',
    (tester) async {
      final controller = _DisplayController(
        const DisplayPreferences(
          activityMode: ActivityMode.walking,
          bodyWeightKilograms: 70,
        ),
        activeTripId: 'current',
      );
      await pumpDisplay(
        tester,
        child: const SettingsScreen(),
        controller: controller,
      );
      final picker = tester.widget<DropdownButtonFormField<ActivityMode>>(
        find.byType(DropdownButtonFormField<ActivityMode>),
      );
      expect(picker.onChanged, isNull);
      final toggle = tester.widget<SwitchListTile>(
        find.widgetWithText(SwitchListTile, 'Estimate calories'),
      );
      expect(toggle.onChanged, isNull);
      expect(
        find.text(
          'Finish or reset the current trip before changing activity or weight.',
        ),
        findsOneWidget,
      );
      expect(controller.activityCalls, 0);
      expect(controller.weightCalls, 0);
    },
  );

  testWidgets(
    'walking trip shows rough calories and motorized trips omit them',
    (tester) async {
      await pumpDisplay(
        tester,
        child: const Scaffold(
          body: SingleChildScrollView(child: TripStatsPanel()),
        ),
        controller: _DisplayController(
          const DisplayPreferences(
            activityMode: ActivityMode.walking,
            bodyWeightKilograms: 70,
          ),
          trip: const TripStats(movingTime: Duration(minutes: 30)),
        ),
      );
      expect(find.text('Estimated calories'), findsOneWidget);
      expect(find.text('133'), findsOneWidget);
      expect(find.text('kcal'), findsOneWidget);
      expect(find.text('Walking'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await pumpDisplay(
        tester,
        child: const Scaffold(
          body: SingleChildScrollView(child: TripStatsPanel()),
        ),
        preferences: const DisplayPreferences(bodyWeightKilograms: 70),
      );
      expect(find.text('Estimated calories'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  for (final language in ['en', 'ar']) {
    testWidgets('settings fit small large-text display in $language', (
      tester,
    ) async {
      await pumpDisplay(
        tester,
        child: const SettingsScreen(),
        size: const Size(320, 640),
        scale: 2,
        language: language,
      );
      final context = tester.element(find.byType(SettingsScreen));
      final l10n = AppLocalizations.of(context);
      expect(
        Directionality.of(context),
        language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      );
      for (final text in [
        l10n.keepAwake,
        l10n.gaugeRange,
        l10n.language,
        l10n.enableWarning,
        l10n.recordRoute,
        l10n.overlaySettings,
        l10n.backupSettings,
        l10n.privacySettings,
      ]) {
        await tester.scrollUntilVisible(
          find.text(text),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
}

class _DisplayController extends SpeedometerController {
  _DisplayController(
    this.preferences, {
    this.activeTripId,
    this.trip = const TripStats(),
  });
  final DisplayPreferences preferences;
  final String? activeTripId;
  final TripStats trip;
  int overlayCalls = 0;
  int activityCalls = 0;
  int weightCalls = 0;

  DisplayPreferences get currentPreferences => state.preferences;

  @override
  Future<void> setActivityMode(ActivityMode mode) async {
    activityCalls++;
    state = state.copyWith(
      preferences: const SelectActivityUseCase()(
        preferences: state.preferences,
        mode: mode,
        hasActiveTrip: state.activeTripId != null,
      ),
    );
  }

  @override
  Future<void> setBodyWeight(double? kilograms) async {
    weightCalls++;
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        bodyWeightKilograms: kilograms,
        clearBodyWeight: kilograms == null,
      ),
    );
  }

  @override
  SpeedometerState build() => SpeedometerState(
    preferences: preferences,
    activeTripId: activeTripId,
    trip: trip,
    preferencesLoad: const AsyncData<void>(null),
    compassHeadingDegrees: 123,
    reading: SpeedReading(
      speedMetersPerSecond: 10,
      accuracyMeters: 3,
      latitude: 25,
      longitude: 55,
      timestamp: DateTime.utc(2026, 10, 21),
    ),
  );

  @override
  Future<void> enableOverlay() async => overlayCalls++;
}
