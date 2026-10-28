import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/app/app.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_controller.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_providers.dart';

import 'fake_device_repository.dart';
import 'fake_location_repository.dart';
import 'fake_preferences_repository.dart';
import 'fake_trip_repository.dart';

/// Runs the same critical app flow on the host and Android integration binding.
/// Platform fakes deliberately avoid collecting a tester's real coordinates.
void registerTrackingFlows() {
  testWidgets(
    'disclosure, explicit start, alert, background, pause, and reset',
    (tester) async {
      final location = FakeLocationRepository();
      final device = FakeDeviceRepository();
      final preferences = FakePreferencesRepository(
        preferences: const DisplayPreferences(
          limitEnabled: true,
          speedLimitMetersPerSecond: 8,
          soundAlert: true,
        ),
      );
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await location.dispose();
      });
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            locationRepositoryProvider.overrideWithValue(location),
            sessionTripRepositoryProvider.overrideWithValue(
              FakeTripRepository(),
            ),
            deviceRepositoryProvider.overrideWithValue(device),
            preferencesRepositoryProvider.overrideWithValue(preferences),
            clockProvider.overrideWithValue(() => DateTime.utc(2026, 10, 22)),
          ],
          child: const SpeedometerApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(location.prepareCalls, 0);
      expect(device.alertCalls, 0);
      await _tap(tester, 'Continue to dashboard');
      expect(location.prepareCalls, 0);
      await _tap(tester, 'Start trip');
      location.readings.add(Success(_reading(10, 0)));
      await tester.pumpAndSettle();
      expect(find.text('36'), findsWidgets);
      expect(device.alertCalls, 1);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(SpeedometerApp)),
      );
      final controller = container.read(speedometerControllerProvider.notifier);
      await controller.setAppVisible(false);
      expect(location.readings.hasListener, isTrue);
      location.readings.add(Success(_reading(11, 1)));
      await tester.pumpAndSettle();
      expect(device.alertCalls, 1, reason: 'Warnings respect the cooldown');
      expect(
        container.read(speedometerControllerProvider).trip.movingTime,
        const Duration(seconds: 1),
      );
      await controller.setAppVisible(true);

      await _tap(tester, 'Pause trip');
      expect(location.readings.hasListener, isFalse);
      await _tap(tester, 'Reset trip');
      await tester.tap(find.text('Reset').last);
      await tester.pumpAndSettle();
      expect(find.text('Start trip'), findsOneWidget);
      expect(
        container.read(speedometerControllerProvider).activeTripId,
        isNull,
      );
    },
  );
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.pumpAndSettle();
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

SpeedReading _reading(double speed, int seconds) => SpeedReading(
  speedMetersPerSecond: speed,
  accuracyMeters: 3,
  altitudeMeters: 20,
  headingDegrees: 90,
  latitude: 25,
  longitude: 55,
  timestamp: DateTime.utc(2026, 10, 22).add(Duration(seconds: seconds)),
);
