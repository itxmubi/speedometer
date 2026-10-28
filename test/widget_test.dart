import 'package:speedometer/features/speedometer/presentation/screens/speedometer_screen.dart';
import 'support/fake_trip_repository.dart';
import 'support/fake_device_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/app/app.dart';
import 'package:speedometer/core/error/failure.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/gauge_style.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_providers.dart';

import 'support/fake_location_repository.dart';
import 'support/fake_preferences_repository.dart';

void main() {
  late FakeLocationRepository location;
  late FakePreferencesRepository preferences;

  setUp(() {
    location = FakeLocationRepository();
    preferences = FakePreferencesRepository();
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    bool consent = true,
    DisplayPreferences? initialDisplayPreferences,
    Size size = const Size(420, 920),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    preferences.preferences =
        initialDisplayPreferences ??
        DisplayPreferences(hasDisclosureConsent: consent);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationRepositoryProvider.overrideWithValue(location),
          sessionTripRepositoryProvider.overrideWithValue(FakeTripRepository()),
          deviceRepositoryProvider.overrideWithValue(FakeDeviceRepository()),
          preferencesRepositoryProvider.overrideWithValue(preferences),
        ],
        child: const SpeedometerApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> cleanup(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await location.dispose();
  }

  testWidgets('disclosure precedes OS permission and does not start GPS', (
    tester,
  ) async {
    await pumpApp(tester, consent: false);
    expect(find.text('Your journey.\nYour privacy.'), findsOneWidget);
    expect(location.prepareCalls, 0);
    await tester.ensureVisible(find.text('Continue to dashboard'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue to dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Live dashboard'), findsOneWidget);
    expect(location.prepareCalls, 0);
    await cleanup(tester);
  });

  testWidgets('start displays Doppler speed, pause clears live reading', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.ensureVisible(find.text('Start trip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start trip'));
    await tester.pumpAndSettle();
    expect(location.prepareCalls, 1);
    location.readings.add(
      Success(
        SpeedReading(
          speedMetersPerSecond: 10,
          accuracyMeters: 3,
          altitudeMeters: 22,
          headingDegrees: 90,
          latitude: 25,
          longitude: 55,
          timestamp: DateTime.utc(2026, 10, 21),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('36'), findsWidgets);
    expect(find.text('GPS connected'), findsOneWidget);
    await tester.ensureVisible(find.text('Pause trip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pause trip'));
    await tester.pumpAndSettle();
    expect(find.text('GPS paused'), findsOneWidget);
    expect(location.readings.hasListener, isFalse);
    await cleanup(tester);
  });

  testWidgets('permanently denied location offers system settings', (
    tester,
  ) async {
    location.prepareResult = const Error(
      Failure(FailureKind.permissionDeniedForever),
    );
    await pumpApp(tester);
    await tester.ensureVisible(find.text('Start trip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start trip'));
    await tester.pumpAndSettle();
    expect(find.text('Open app settings'), findsOneWidget);
    expect(
      find.textContaining('Location access is turned off'),
      findsOneWidget,
    );
    await cleanup(tester);
  });

  for (final size in [
    const Size(320, 640),
    const Size(900, 420),
    const Size(1024, 1366),
  ]) {
    testWidgets('dashboard fits $size with large system text', (tester) async {
      await pumpApp(tester, size: size, textScale: 2);
      expect(tester.takeException(), isNull);
      await cleanup(tester);
    });
  }

  for (final style in [GaugeStyle.analog, GaugeStyle.hud]) {
    testWidgets('${style.name} fits a small phone with large system text', (
      tester,
    ) async {
      await pumpApp(
        tester,
        size: const Size(320, 640),
        textScale: 2,
        initialDisplayPreferences: DisplayPreferences(
          hasDisclosureConsent: true,
          gaugeStyle: style,
          mirroredHud: style == GaugeStyle.hud,
          limitEnabled: true,
        ),
      );
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.text('Start trip'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start trip'));
      await tester.pumpAndSettle();
      location.readings.add(
        Success(
          SpeedReading(
            speedMetersPerSecond: 10,
            accuracyMeters: 3,
            latitude: 25,
            longitude: 55,
            timestamp: DateTime.utc(2026, 10, 21),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('36'), findsWidgets);
      expect(tester.takeException(), isNull);
      await cleanup(tester);
    });
  }

  testWidgets('settings fit a small phone with large system text', (
    tester,
  ) async {
    await pumpApp(tester, size: const Size(320, 640), textScale: 2);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Enable speed warning'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enable speed warning'));
    await tester.pumpAndSettle();
    expect(preferences.preferences.limitEnabled, isTrue);
    await tester.scrollUntilVisible(
      find.text('Privacy, by design'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await cleanup(tester);
  });

  testWidgets('disclosure fits a small phone with large system text', (
    tester,
  ) async {
    await pumpApp(
      tester,
      consent: false,
      size: const Size(320, 640),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Continue to dashboard'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue to dashboard'));
    await tester.pumpAndSettle();
    expect(find.text('Live dashboard'), findsOneWidget);
    expect(location.prepareCalls, 0);
    expect(tester.takeException(), isNull);
    await cleanup(tester);
  });

  testWidgets(
    'focused display navigates, pauses and finishes a trip before the first fix',
    (tester) async {
      await pumpApp(tester);
      await tester.ensureVisible(find.text('Focused display'));
      await tester.tap(find.text('Focused display'));
      await tester.pumpAndSettle();
      expect(find.text('Live dashboard'), findsNothing);
      await tester.tap(find.text('Start trip'));
      await tester.pumpAndSettle();
      expect(find.text('Finish and save trip').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Pause trip'));
      await tester.pumpAndSettle();
      expect(find.text('Resume trip').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Finish and save trip'));
      await tester.pumpAndSettle();
      expect(find.text('Start trip').hitTestable(), findsOneWidget);
      await tester.tap(find.byTooltip('Exit focused display'));
      await tester.pumpAndSettle();
      expect(find.byType(SpeedometerScreen), findsOneWidget);
      await cleanup(tester);
    },
  );

  testWidgets('settings and gauge controls remain usable', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Your display'), findsOneWidget);
    await tester.tap(find.text('Simple view'));
    await tester.pumpAndSettle();
    expect(preferences.preferences.simpleView, isTrue);
    await cleanup(tester);
  });
}
