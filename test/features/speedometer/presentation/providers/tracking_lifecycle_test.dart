import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/database/app_database.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';
import 'package:speedometer/features/speedometer/domain/entities/tracking_display.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_controller.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_providers.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_state.dart';
import 'package:speedometer/features/trips/data/repositories/drift_trip_repository.dart';
import 'package:speedometer/features/trips/domain/repositories/trip_file_repository.dart';

import '../../../../support/fake_device_repository.dart';
import '../../../../support/fake_location_repository.dart';
import '../../../../support/fake_preferences_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'alerts and saved fixes continue in background until notification Stop',
    () async {
      final harness = _Harness(
        const DisplayPreferences(
          hasDisclosureConsent: true,
          keepAwake: true,
          limitEnabled: true,
          speedLimitMetersPerSecond: 10,
          alertOffsetMetersPerSecond: 2,
          soundAlert: true,
          vibrationAlert: true,
          voiceAlert: true,
        ),
      );
      addTearDown(harness.close);
      await harness.ready();
      expect(harness.location.prepareCalls, 0);
      await harness.controller.start();
      harness.device.nativeStatus.add(true);
      await harness.emit(14, seconds: 0);
      harness.device.overlayGranted = true;
      await harness.controller.enableOverlay();

      expect(harness.device.alertCalls, 1);
      expect(harness.device.displays.last.overLimit, isTrue);
      expect(harness.device.overlayEnabled, isTrue);
      await harness.controller.setAppVisible(false);
      await harness.emit(15, seconds: 1);

      expect(harness.location.readings.hasListener, isTrue);
      expect(harness.state.status, TrackingStatus.tracking);
      expect(harness.device.awake.last, isFalse);
      expect(harness.device.displays.last.speedMetersPerSecond, 15);
      expect(
        harness.device.alertCalls,
        1,
        reason: 'Alert cooldown prevents a burst',
      );

      harness.device.nativeStatus.add(false);
      await pumpEventQueue();
      expect(harness.state.status, TrackingStatus.paused);
      expect(harness.location.readings.hasListener, isFalse);
      expect(harness.state.overlayEnabled, isFalse);
      expect(harness.device.displays.last.speedMetersPerSecond, isNull);
      await harness.controller.finish();
      final saved = (await harness.trips.watchTrips().first).valueOrNull;
      expect(saved, hasLength(1));
      final detail = (await harness.trips.getTrip(
        saved?.single.id ?? '',
      )).valueOrNull;
      expect(detail?.points, hasLength(2));
      expect(detail?.points.every((point) => point.overLimit), isTrue);
      expect(detail?.stats.elapsed, const Duration(seconds: 1));
    },
  );

  test(
    'foreground-only mode pauses and an explicit resume never bridges the gap',
    () async {
      final harness = _Harness(
        const DisplayPreferences(
          hasDisclosureConsent: true,
          backgroundTracking: false,
        ),
      );
      addTearDown(harness.close);
      await harness.ready();
      await harness.controller.start();
      await harness.emit(10, seconds: 0);
      await harness.emit(10, seconds: 1);
      final distance = harness.state.trip.distanceMeters;

      await harness.controller.setAppVisible(false);
      expect(harness.state.status, TrackingStatus.paused);
      expect(harness.location.readings.hasListener, isFalse);
      await harness.controller.setAppVisible(true);
      expect(harness.state.status, TrackingStatus.paused);
      expect(harness.location.prepareCalls, 1);
      await harness.controller.start();
      await harness.emit(10, seconds: 60);
      expect(harness.state.trip.distanceMeters, distance);
      await harness.emit(10, seconds: 61);
      expect(harness.state.trip.elapsed, const Duration(seconds: 2));
      await harness.controller.finish();
      final id =
          (await harness.trips.watchTrips().first).valueOrNull?.single.id;
      final saved = (await harness.trips.getTrip(id ?? '')).valueOrNull;
      expect(saved?.points.map((point) => point.segment).toSet(), hasLength(2));
    },
  );

  test(
    'local backup restores settings and trips while keeping GPS stopped',
    () async {
      final harness = _Harness(
        const DisplayPreferences(
          hasDisclosureConsent: true,
          recordRoute: false,
        ),
      );
      addTearDown(harness.close);
      await harness.ready();
      await harness.controller.start();
      await harness.emit(10, seconds: 0);
      await harness.emit(10, seconds: 1);
      await harness.controller.exportBackup();
      final backup = harness.files.document;
      expect(backup, isNotNull);
      await harness.controller.setUnit(SpeedUnit.milesPerHour);
      harness.files.picked = backup;

      await harness.controller.restoreBackup();

      expect(harness.state.failure, isNull);
      expect(harness.state.preferences.unit, SpeedUnit.kilometersPerHour);
      expect(harness.state.status, isNot(TrackingStatus.tracking));
      expect(harness.location.readings.hasListener, isFalse);
      final trips = (await harness.trips.watchTrips().first).valueOrNull;
      expect(trips, hasLength(1));
      final detail = (await harness.trips.getTrip(
        trips?.single.id ?? '',
      )).valueOrNull;
      expect(detail?.points, hasLength(2));
      expect(detail?.points.every((point) => !point.hasCoordinates), isTrue);

      await harness.controller.deleteAllData();
      expect((await harness.trips.watchTrips().first).valueOrNull, isEmpty);
      expect(
        (await harness.trips.watchTotals().first).valueOrNull?.odometerMeters,
        0,
      );
      expect(harness.preferences.preferences.hasDisclosureConsent, isFalse);
      expect(harness.location.readings.hasListener, isFalse);
    },
  );

  test('invalid backup leaves saved trips and preferences intact', () async {
    final harness = _Harness(
      const DisplayPreferences(hasDisclosureConsent: true),
    );
    addTearDown(harness.close);
    await harness.ready();
    await harness.controller.start();
    await harness.emit(10, seconds: 0);
    await harness.emit(10, seconds: 1);
    await harness.controller.finish();
    final before = (await harness.trips.watchTrips().first).valueOrNull;
    harness.files.picked = '{"format":"untrusted"}';

    await harness.controller.restoreBackup();

    expect(harness.state.failure, isNotNull);
    expect(
      (await harness.trips.watchTrips().first).valueOrNull?.single.id,
      before?.single.id,
    );
    expect(harness.preferences.preferences.hasDisclosureConsent, isTrue);
    expect(harness.location.readings.hasListener, isFalse);
  });
}

class _Harness {
  _Harness(DisplayPreferences initial) {
    preferences = FakePreferencesRepository(preferences: initial);
    trips = DriftTripRepository(database, now: () => now);
    container = ProviderContainer(
      overrides: [
        locationRepositoryProvider.overrideWithValue(location),
        preferencesRepositoryProvider.overrideWithValue(preferences),
        deviceRepositoryProvider.overrideWithValue(device),
        sessionTripRepositoryProvider.overrideWithValue(trips),
        tripFilesRepositoryProvider.overrideWithValue(files),
        clockProvider.overrideWithValue(() => now),
      ],
    );
  }

  final database = AppDatabase(NativeDatabase.memory());
  final location = FakeLocationRepository();
  final device = _Device();
  final files = _Files();
  late final FakePreferencesRepository preferences;
  late final DriftTripRepository trips;
  late final ProviderContainer container;
  DateTime now = DateTime.utc(2026, 10, 22);
  SpeedometerController get controller =>
      container.read(speedometerControllerProvider.notifier);
  SpeedometerState get state => container.read(speedometerControllerProvider);

  Future<void> ready() async {
    final initialized = Completer<void>();
    final subscription = container.listen(speedometerControllerProvider, (
      _,
      next,
    ) {
      if (!next.isLoadingPreferences && !initialized.isCompleted) {
        initialized.complete();
      }
    }, fireImmediately: true);
    await initialized.future;
    await pumpEventQueue();
    subscription.close();
  }

  Future<void> emit(double speed, {required int seconds}) async {
    now = DateTime.utc(2026, 10, 22).add(Duration(seconds: seconds));
    location.readings.add(
      Success(
        SpeedReading(
          speedMetersPerSecond: speed,
          accuracyMeters: 3,
          latitude: 25 + seconds * 0.00001,
          longitude: 55,
          timestamp: now,
        ),
      ),
    );
    await pumpEventQueue();
  }

  Future<void> close() async {
    await controller.pause();
    container.dispose();
    await location.dispose();
    await device.nativeStatus.close();
    await database.close();
  }
}

class _Device extends FakeDeviceRepository {
  final nativeStatus = StreamController<bool>.broadcast();
  final displays = <TrackingDisplay>[];
  final awake = <bool>[];

  @override
  Stream<bool> trackingStatus() => nativeStatus.stream;

  @override
  Future<Result<void>> update(TrackingDisplay display) async {
    displays.add(display);
    return const Success(null);
  }

  @override
  Future<Result<void>> applySettings(
    DisplayPreferences preferences, {
    required bool awake,
  }) async {
    this.awake.add(awake && preferences.keepAwake);
    return const Success(null);
  }
}

class _Files implements TripFileRepository {
  String? document;
  String? picked;
  @override
  Future<Result<String?>> pickBackup() async => Success(picked);
  @override
  Future<Result<void>> shareDocument({
    required String filename,
    required String mimeType,
    required String contents,
    required String subject,
  }) async {
    document = contents;
    return const Success(null);
  }

  @override
  Future<Result<void>> shareText(String text) async => const Success(null);
}

extension _ResultValue<T> on Result<T> {
  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Error() => null,
  };
}
