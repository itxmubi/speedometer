import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/app/app.dart';
import 'package:speedometer/core/database/app_database.dart';
import 'package:speedometer/core/database/database_providers.dart';
import 'package:speedometer/features/fuel/presentation/screens/fuel_screen.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_providers.dart';
import 'package:speedometer/features/speedometer/presentation/screens/settings_screen.dart';
import 'package:speedometer/features/trips/presentation/providers/trip_providers.dart';
import 'package:speedometer/features/trips/presentation/screens/history_screen.dart';

import 'support/fake_device_repository.dart';
import 'support/fake_location_repository.dart';
import 'support/fake_preferences_repository.dart';
import 'support/fake_trip_repository.dart';

void main() {
  testWidgets(
    'Settings opens fuel tracking and its mileage link opens history without GPS',
    (tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      final location = FakeLocationRepository();
      final trips = FakeTripRepository();
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox.shrink());
        await location.dispose();
        await database.close();
      });
      // Open SQLite before pumping to keep this test independent of plugin paths.
      await database.customSelect('SELECT 1').get();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(database),
            locationRepositoryProvider.overrideWithValue(location),
            deviceRepositoryProvider.overrideWithValue(FakeDeviceRepository()),
            preferencesRepositoryProvider.overrideWithValue(
              FakePreferencesRepository(
                preferences: const DisplayPreferences(
                  hasDisclosureConsent: true,
                ),
              ),
            ),
            sessionTripRepositoryProvider.overrideWithValue(trips),
            tripRepositoryProvider.overrideWithValue(trips),
          ],
          child: const SpeedometerApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      final fuelLink = find.text('Fuel and vehicle costs');
      await tester.scrollUntilVisible(fuelLink, 400);
      await tester.pumpAndSettle();
      await tester.tap(fuelLink);
      await tester.pumpAndSettle();

      expect(find.byType(FuelScreen), findsOneWidget);
      expect(find.text('No fuel or vehicle costs yet'), findsOneWidget);
      await tester.ensureVisible(find.text('Trip mileage log'));
      await tester.tap(find.text('Trip mileage log'));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(FuelScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(location.prepareCalls, 0);
      expect(location.readings.hasListener, isFalse);
    },
  );
}
