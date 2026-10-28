import '../../../../support/fake_trip_repository.dart';
import '../../../../support/fake_device_repository.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/error/failure.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/core/utils/logger.dart';
import 'package:speedometer/features/activities/domain/entities/activity_mode.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/gauge_style.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';
import 'package:speedometer/features/speedometer/domain/entities/tracking_display.dart';
import 'package:speedometer/features/speedometer/domain/entities/trip_stats.dart';
import 'package:speedometer/features/speedometer/domain/repositories/location_repository.dart';
import 'package:speedometer/features/speedometer/domain/repositories/preferences_repository.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_controller.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_providers.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_state.dart';

void main() {
  group('SpeedometerController', () {
    late _Harness harness;

    setUp(() {
      harness = _Harness();
    });

    tearDown(() async {
      harness.container.dispose();
      await harness.location.close();
    });

    test(
      'reset waits for pending trip creation before discarding it',
      () async {
        await harness.initializeWithConsent();
        final gate = Completer<void>();
        harness.trips.startGate = gate;
        final starting = harness.controller.start();
        await pumpEventQueue();
        final resetting = harness.controller.reset();
        expect(harness.state.isBusy, true);
        gate.complete();
        await Future.wait([starting, resetting]);
        expect(harness.trips.records, isEmpty);
        expect(harness.state.activeTripId, isNull);
        expect(harness.state.status, TrackingStatus.idle);
        expect(harness.location.watchCalls, 0);
      },
    );

    for (final operation in ['reset', 'discard', 'finish', 'checkpoint']) {
      test(
        '$operation failure preserves a paused session and retries successfully',
        () async {
          await harness.initializeWithConsent();
          if (operation == 'discard') {
            await harness.controller.setAutoRecordTrips(false);
          }
          await harness.controller.start();
          harness.location.emit(_reading(seconds: 0, speed: 10));
          harness.location.emit(
            _reading(seconds: 1, speed: 10, longitude: 0.00009),
          );
          await pumpEventQueue();
          final id = harness.state.activeTripId;
          final distance = harness.state.trip.distanceMeters;
          harness.trips.failFinish = operation == 'finish';
          harness.trips.failDiscard =
              operation == 'reset' || operation == 'discard';
          harness.trips.failCheckpoint = operation == 'checkpoint';
          Future<void> complete() => operation == 'reset'
              ? harness.controller.reset()
              : harness.controller.finish();
          await complete();
          expect(harness.state.activeTripId, id);
          expect(harness.state.trip.distanceMeters, distance);
          expect(harness.state.status, TrackingStatus.paused);
          expect(harness.state.isBusy, false);
          expect(harness.state.failure?.kind, FailureKind.storage);
          expect(harness.trips.records[id]?.isActive, true);
          harness.trips.failFinish = false;
          harness.trips.failDiscard = false;
          harness.trips.failCheckpoint = false;
          await complete();
          expect(harness.state.activeTripId, isNull);
          expect(harness.state.failure, isNull);
          expect(harness.state.status, TrackingStatus.idle);
          expect(harness.trips.odometer, distance);
          if (operation == 'reset' || operation == 'discard') {
            expect(harness.trips.records, isEmpty);
          }
        },
      );
    }

    test(
      'live readings update instruments without reapplying device settings',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();
        final before = harness.device.settingsCalls;
        final displaysBefore = harness.device.displayCalls;
        for (var second = 0; second < 5; second++) {
          harness.location.emit(_reading(seconds: second, speed: 10));
          await pumpEventQueue();
        }
        expect(harness.device.settingsCalls, before);
        expect(harness.device.displayCalls, displaysBefore + 5);
        await harness.controller.setEconomyGps(true);
        expect(harness.device.settingsCalls, before + 1);
      },
    );

    test(
      'signal loss while hidden keeps the trip alive and recovery has no bridge',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();
        harness.location.emit(_reading(seconds: 0, speed: 10));
        await pumpEventQueue();
        await harness.controller.setAppVisible(false);
        harness.location.current.add(
          const Error(Failure(FailureKind.locationUnavailable)),
        );
        await pumpEventQueue();
        expect(harness.state.status, TrackingStatus.tracking);
        expect(harness.state.reading, isNull);
        expect(harness.location.cancelCalls, 0);
        harness.location.emit(
          _reading(seconds: 30, speed: 10, longitude: 0.01),
        );
        await pumpEventQueue();
        expect(harness.state.reading, isNotNull);
        expect(harness.state.trip.distanceMeters, 0);
        expect(harness.state.trip.elapsed, Duration.zero);
        expect(harness.state.failure, isNull);
        await harness.controller.pause();
        expect(harness.location.cancelCalls, 1);
      },
    );

    test('disabling background tracking while hidden cancels GPS', () async {
      await harness.initializeWithConsent();
      await harness.controller.start();
      await harness.controller.setAppVisible(false);
      expect(harness.state.status, TrackingStatus.tracking);
      await harness.controller.setBackgroundTracking(false);
      expect(harness.state.status, TrackingStatus.paused);
      expect(harness.location.cancelCalls, 1);
    });

    test(
      'loads settings without accessing GPS or requesting permission',
      () async {
        await harness.initialize();

        expect(harness.state.isLoadingPreferences, isFalse);
        expect(harness.state.status, TrackingStatus.idle);
        expect(harness.preferences.loadCalls, 1);
        expect(harness.location.prepareCalls, 0);
        expect(harness.location.watchCalls, 0);
      },
    );

    test(
      'disposal during platform initialization never inspects a disposed Ref',
      () async {
        final gate = Completer<Result<void>>();
        harness.device.nextSettingsGate = gate;
        harness.container.read(speedometerControllerProvider);
        await harness.device.settingsStarted.future;
        expect(harness.state.isLoadingPreferences, isTrue);

        harness.container.dispose();
        gate.complete(const Success(null));
        await Future<void>.delayed(Duration.zero);

        expect(harness.device.inspectCalls, 0);
        expect(harness.location.prepareCalls, 0);
      },
    );

    test(
      'outdated platform initialization cannot inspect or replace newer settings',
      () async {
        await harness.initialize();
        final initialInspections = harness.device.inspectCalls;
        final gate = Completer<Result<void>>();
        harness.device.nextSettingsGate = gate;
        harness.device.settingsStarted = Completer<void>();
        final older = harness.controller.loadPreferences();
        await harness.device.settingsStarted.future;
        harness.preferences.loadResult = const Success(
          DisplayPreferences(unit: SpeedUnit.knots),
        );

        await harness.controller.loadPreferences();
        gate.complete(const Success(null));
        await older;

        expect(harness.device.inspectCalls, initialInspections + 1);
        expect(harness.state.preferences.unit, SpeedUnit.knots);
      },
    );

    test(
      'activity instruments persist independently and need no GPS',
      () async {
        await harness.initialize();
        await harness.controller.setUnit(SpeedUnit.milesPerHour);
        await harness.controller.setGaugeStyle(GaugeStyle.analog);
        await harness.controller.setGaugeRange(120);
        final carRange = harness.state.preferences.gaugeRangeMetersPerSecond;
        await harness.controller.setActivityMode(ActivityMode.boating);
        expect(harness.state.preferences.unit, SpeedUnit.knots);
        await harness.controller.setGaugeStyle(GaugeStyle.hud);
        await harness.controller.setGaugeRange(40);
        final boatingRange =
            harness.state.preferences.gaugeRangeMetersPerSecond;

        await harness.controller.setActivityMode(ActivityMode.car);
        expect(harness.state.preferences.unit, SpeedUnit.milesPerHour);
        expect(harness.state.preferences.gaugeStyle, GaugeStyle.analog);
        expect(harness.state.preferences.gaugeRangeMetersPerSecond, carRange);
        await harness.controller.setActivityMode(ActivityMode.boating);
        expect(harness.state.preferences.gaugeStyle, GaugeStyle.hud);
        expect(
          harness.state.preferences.gaugeRangeMetersPerSecond,
          boatingRange,
        );
        expect(harness.preferences.saved.last, harness.state.preferences);
        expect(harness.location.prepareCalls, 0);
      },
    );

    test(
      'starting running and paused sessions keep their activity and weight',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.setActivityMode(ActivityMode.cycling);
        await harness.controller.setBodyWeight(70);
        final permission = Completer<Result<void>>();
        harness.location.prepareGate = permission;
        final starting = harness.controller.start();
        await harness.location.prepareStarted.future;
        await harness.controller.setActivityMode(ActivityMode.car);
        await harness.controller.setBodyWeight(100);
        expect(harness.state.preferences.activityMode, ActivityMode.cycling);
        expect(harness.state.preferences.bodyWeightKilograms, 70);
        permission.complete(const Success(null));
        await starting;

        await harness.controller.setActivityMode(ActivityMode.running);
        await harness.controller.setBodyWeight(null);
        await harness.controller.updatePreferences(
          harness.state.preferences.copyWith(activityMode: ActivityMode.car),
        );
        await harness.controller.pause();
        await harness.controller.setActivityMode(ActivityMode.walking);
        expect(harness.state.preferences.activityMode, ActivityMode.cycling);
        expect(harness.state.preferences.bodyWeightKilograms, 70);

        await harness.controller.finish();
        await harness.controller.setActivityMode(ActivityMode.walking);
        await harness.controller.setBodyWeight(null);
        expect(harness.state.preferences.activityMode, ActivityMode.walking);
        expect(harness.state.preferences.bodyWeightKilograms, isNull);
      },
    );

    test(
      'calories derive only from accepted moving time and optional weight',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.setActivityMode(ActivityMode.walking);
        expect(harness.container.read(activityCaloriesProvider), isNull);
        await harness.controller.setBodyWeight(70);
        expect(harness.container.read(activityCaloriesProvider), 0);
        await harness.controller.start();
        harness.location.emit(_reading(seconds: 0, speed: 2));
        harness.location.emit(_reading(seconds: 1, speed: 2));
        expect(
          harness.container.read(activityCaloriesProvider),
          closeTo(3.8 * 70 / 3600, 0.0001),
        );
        await harness.controller.pause();
        await harness.controller.start();
        harness.location.emit(_reading(seconds: 100, speed: 2));
        expect(
          harness.container.read(activityCaloriesProvider),
          closeTo(3.8 * 70 / 3600, 0.0001),
        );
        await harness.controller.reset();
        expect(harness.container.read(activityCaloriesProvider), 0);
      },
    );

    test(
      'requires disclosure and an explicit Start before accessing GPS',
      () async {
        await harness.initialize();

        await harness.controller.start();
        expect(harness.location.prepareCalls, 0);
        await harness.controller.acceptDisclosure();
        expect(harness.state.hasDisclosureConsent, isTrue);
        expect(harness.preferences.saved.last.hasDisclosureConsent, isTrue);
        expect(harness.location.prepareCalls, 0);
        expect(harness.location.watchCalls, 0);

        await harness.controller.start();

        expect(harness.location.prepareCalls, 1);
        expect(harness.location.watchCalls, 1);
        expect(harness.state.status, TrackingStatus.tracking);
      },
    );

    test('does not start while saved preferences are still loading', () async {
      final gate = Completer<Result<DisplayPreferences>>();
      harness.preferences.loadGate = gate;
      harness.container.read(speedometerControllerProvider);
      await harness.container.pump();

      await harness.controller.start();

      expect(harness.state.isLoadingPreferences, isTrue);
      expect(harness.location.prepareCalls, 0);
      gate.complete(
        const Success(DisplayPreferences(hasDisclosureConsent: true)),
      );
      await harness.waitForPreferences();
      expect(harness.state.hasDisclosureConsent, isTrue);
      expect(harness.location.prepareCalls, 0);
    });

    test(
      'a settings read failure supports retry and explicit defaults',
      () async {
        harness.preferences.loadResult = const Error(
          Failure(FailureKind.storage),
        );
        await harness.initialize();

        expect(harness.state.initializationFailed, isTrue);
        expect(harness.state.failure?.kind, FailureKind.storage);
        harness.controller.useDefaultPreferences();
        expect(harness.state.initializationFailed, isFalse);
        expect(harness.state.failure, isNull);
        expect(harness.state.hasDisclosureConsent, isFalse);

        harness.preferences.loadResult = const Success(
          DisplayPreferences(unit: SpeedUnit.knots),
        );
        await harness.controller.loadPreferences();
        expect(harness.state.preferences.unit, SpeedUnit.knots);
        expect(harness.location.prepareCalls, 0);
      },
    );

    test(
      'the latest settings load wins when retries finish out of order',
      () async {
        await harness.initialize();
        final older = Completer<Result<DisplayPreferences>>();
        final newer = Completer<Result<DisplayPreferences>>();
        harness.preferences.loadGate = older;
        final first = harness.controller.loadPreferences();
        harness.preferences.loadGate = newer;
        final second = harness.controller.loadPreferences();

        newer.complete(
          const Success(DisplayPreferences(unit: SpeedUnit.knots)),
        );
        await second;
        older.complete(const Error(Failure(FailureKind.storage)));
        await first;

        expect(harness.state.preferences.unit, SpeedUnit.knots);
        expect(harness.state.isLoadingPreferences, isFalse);
        expect(harness.state.initializationFailed, isFalse);
        expect(harness.state.failure, isNull);
      },
    );

    test(
      'continuing with defaults invalidates an in-flight settings retry',
      () async {
        harness.preferences.loadResult = const Error(
          Failure(FailureKind.storage),
        );
        await harness.initialize();
        final gate = Completer<Result<DisplayPreferences>>();
        harness.preferences.loadGate = gate;
        final retry = harness.controller.loadPreferences();

        harness.controller.useDefaultPreferences();
        await harness.controller.acceptDisclosure();
        await harness.controller.setUnit(SpeedUnit.milesPerHour);
        gate.complete(const Success(DisplayPreferences(unit: SpeedUnit.knots)));
        await retry;

        expect(harness.state.preferences.unit, SpeedUnit.milesPerHour);
        expect(harness.state.hasDisclosureConsent, isTrue);
        expect(harness.state.isLoadingPreferences, isFalse);
        expect(harness.state.initializationFailed, isFalse);
      },
    );

    test(
      'denied permission enters a recoverable failure without a stream',
      () async {
        await harness.initializeWithConsent();
        harness.location.prepareResult = const Error(
          Failure(FailureKind.permissionDenied),
        );

        await harness.controller.start();

        expect(harness.state.status, TrackingStatus.failure);
        expect(harness.state.failure?.kind, FailureKind.permissionDenied);
        expect(harness.location.watchCalls, 0);
        expect(harness.state.reading, isNull);
      },
    );

    test(
      'accepted samples update live speed and in-memory session statistics',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();

        harness.location.emit(_reading(seconds: 0, speed: 10));
        harness.location.emit(
          _reading(seconds: 1, speed: 20, longitude: 0.00009),
        );

        expect(harness.state.reading?.speedMetersPerSecond, 20);
        expect(harness.state.trip.maxSpeedMetersPerSecond, 20);
        expect(harness.state.trip.distanceMeters, closeTo(10, 0.1));
        expect(harness.state.trip.elapsed, const Duration(seconds: 1));
        expect(
          harness.state.trip.averageSpeedMetersPerSecond,
          closeTo(10, 0.1),
        );
        expect(harness.preferences.saved, isEmpty);
      },
    );

    test(
      'pause cancels GPS and resume never bridges the paused interval',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();
        harness.location.emit(_reading(seconds: 0, speed: 10));
        harness.location.emit(
          _reading(seconds: 1, speed: 10, longitude: 0.00009),
        );
        final initialDistance = harness.state.trip.distanceMeters;

        await harness.controller.pause();

        expect(harness.location.cancelCalls, 1);
        expect(harness.state.status, TrackingStatus.paused);
        expect(harness.state.reading, isNull);
        expect(harness.state.trip.lastReading, isNull);
        await harness.controller.start();
        harness.location.emit(
          _reading(seconds: 5, speed: 10, longitude: 0.00018),
        );

        expect(harness.state.trip.distanceMeters, initialDistance);
        expect(harness.state.trip.elapsed, const Duration(seconds: 1));
        harness.location.emit(
          _reading(seconds: 6, speed: 10, longitude: 0.00027),
        );
        expect(
          harness.state.trip.distanceMeters,
          closeTo(initialDistance * 2, 0.01),
        );
        expect(harness.state.trip.elapsed, const Duration(seconds: 2));
      },
    );

    test(
      'reset cancels the active stream and clears the complete session',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();
        harness.location.emit(_reading(seconds: 0, speed: 10));
        harness.location.emit(
          _reading(seconds: 1, speed: 10, longitude: 0.00009),
        );

        await harness.controller.reset();

        expect(harness.location.cancelCalls, 1);
        expect(harness.state.status, TrackingStatus.idle);
        expect(harness.state.reading, isNull);
        expect(harness.state.trip.distanceMeters, 0);
        expect(harness.state.trip.maxSpeedMetersPerSecond, 0);
        expect(harness.state.trip.elapsed, Duration.zero);
        expect(harness.state.trip.lastReading, isNull);
        expect(harness.state.hasDisclosureConsent, isTrue);
      },
    );

    test(
      'Start during a slow reset is blocked until durable completion',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();
        harness.location.emit(_reading(seconds: 0, speed: 10));
        harness.location.emit(
          _reading(seconds: 1, speed: 10, longitude: 0.00009),
        );
        final gate = Completer<void>();
        harness.location.cancelGate = gate;

        final reset = harness.controller.reset();
        expect(harness.state.status, TrackingStatus.paused);
        expect(harness.state.isBusy, true);
        expect(harness.state.trip.distanceMeters, greaterThan(0));
        final start = harness.controller.start();
        await harness.container.pump();

        expect(harness.location.prepareCalls, 1);
        expect(harness.location.watchCalls, 1);
        gate.complete();
        await Future.wait([reset, start]);
        expect(harness.state.status, TrackingStatus.idle);
        await harness.controller.start();

        expect(harness.state.status, TrackingStatus.tracking);
        expect(harness.location.watchCalls, 2);
        expect(harness.state.trip.distanceMeters, 0);
        expect(harness.state.trip.elapsed, Duration.zero);
        await harness.controller.pause();
        expect(harness.location.cancelCalls, 2);
      },
    );

    test(
      'a typed GPS failure cancels tracking and clears stale readings',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();
        harness.location.emit(_reading(seconds: 0, speed: 10));

        harness.location.current.add(
          const Error(Failure(FailureKind.locationDisabled)),
        );
        await harness.container.pump();

        expect(harness.state.status, TrackingStatus.failure);
        expect(harness.state.failure?.kind, FailureKind.locationDisabled);
        expect(harness.state.reading, isNull);
        expect(harness.state.trip.lastReading, isNull);
        expect(harness.location.cancelCalls, 1);
      },
    );

    test(
      'a poor fix clears stale speed and recovers without a new Start',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();
        harness.location.emit(_reading(seconds: 0, speed: 10));
        harness.location.emit(
          _reading(seconds: 1, speed: 10, longitude: 0.00009),
        );
        final initialDistance = harness.state.trip.distanceMeters;

        harness.location.current.add(
          const Error(Failure(FailureKind.locationUnavailable)),
        );

        expect(harness.state.status, TrackingStatus.tracking);
        expect(harness.state.failure?.kind, FailureKind.locationUnavailable);
        expect(harness.state.reading, isNull);
        expect(harness.state.trip.lastReading, isNull);
        expect(harness.location.cancelCalls, 0);
        harness.location.emit(
          _reading(seconds: 4, speed: 10, longitude: 0.00036),
        );

        expect(harness.state.failure, isNull);
        expect(harness.state.reading?.speedMetersPerSecond, 10);
        expect(harness.state.trip.distanceMeters, initialDistance);
        expect(harness.state.trip.elapsed, const Duration(seconds: 1));
        expect(harness.location.watchCalls, 1);
      },
    );

    test('an unexpected stream error becomes a privacy-safe failure', () async {
      await harness.initializeWithConsent();
      await harness.controller.start();

      harness.location.current.addError(StateError('private platform payload'));
      await harness.container.pump();

      expect(harness.state.status, TrackingStatus.failure);
      expect(harness.state.failure?.kind, FailureKind.locationUnavailable);
      expect(harness.location.cancelCalls, 1);
      expect(harness.logger.events, ['unexpected_location_stream_error']);
    });

    test(
      'a completed GPS stream enters failure instead of leaving stale speed',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();
        harness.location.emit(_reading(seconds: 0, speed: 10));

        await harness.location.current.close();
        await harness.container.pump();

        expect(harness.state.status, TrackingStatus.failure);
        expect(harness.state.failure?.kind, FailureKind.locationUnavailable);
        expect(harness.state.reading, isNull);
      },
    );

    test(
      'pause during permission preparation prevents a delayed subscription',
      () async {
        await harness.initializeWithConsent();
        final gate = Completer<Result<void>>();
        harness.location.prepareGate = gate;
        final start = harness.controller.start();
        await harness.location.prepareStarted.future;
        expect(harness.state.status, TrackingStatus.starting);
        expect(harness.location.prepareCalls, 1);

        await harness.controller.pause();
        gate.complete(const Success(null));
        await start;

        expect(harness.state.status, TrackingStatus.paused);
        expect(harness.location.watchCalls, 0);
      },
    );

    test(
      'repeated Start while preparing creates just one permission request',
      () async {
        await harness.initializeWithConsent();
        final gate = Completer<Result<void>>();
        harness.location.prepareGate = gate;
        final first = harness.controller.start();
        await harness.location.prepareStarted.future;

        await harness.controller.start();
        gate.complete(const Success(null));
        await first;

        expect(harness.location.prepareCalls, 1);
        expect(harness.location.watchCalls, 1);
      },
    );

    test(
      'settings choices persist while limits remain in canonical SI units',
      () async {
        await harness.initialize();

        await harness.controller.setUnit(SpeedUnit.milesPerHour);
        await harness.controller.setSpeedLimit(60);
        final canonicalLimit =
            harness.state.preferences.speedLimitMetersPerSecond;
        await harness.controller.setUnit(SpeedUnit.kilometersPerHour);
        await harness.controller.setGaugeStyle(GaugeStyle.hud);
        await harness.controller.setMirrored(true);
        await harness.controller.setSimpleView(true);
        await harness.controller.setDarkMode(false);
        await harness.controller.setLimitEnabled(true);

        expect(canonicalLimit, closeTo(26.8224, 0.0001));
        expect(
          harness.state.preferences.speedLimitMetersPerSecond,
          canonicalLimit,
        );
        expect(harness.preferences.saved.last, harness.state.preferences);
        expect(harness.state.preferences.gaugeStyle, GaugeStyle.hud);
        expect(harness.state.preferences.mirroredHud, isTrue);
        expect(harness.state.preferences.simpleView, isTrue);
        expect(harness.state.preferences.darkMode, isFalse);
        expect(harness.state.preferences.limitEnabled, isTrue);
        expect(harness.location.prepareCalls, 0);
      },
    );

    test(
      'invalid entered limits never replace or persist a valid setting',
      () async {
        await harness.initialize();
        final initial = harness.state.preferences;

        for (final value in [double.nan, double.infinity, -1.0, 0.0, 10000.0]) {
          await harness.controller.setSpeedLimit(value);
        }

        expect(harness.state.preferences, initial);
        expect(harness.preferences.saved, isEmpty);
      },
    );

    test(
      'serial saves preserve the most recent choice during a slow write',
      () async {
        await harness.initialize();
        final gate = Completer<Result<void>>();
        harness.preferences.nextSaveGate = gate;

        final first = harness.controller.setUnit(SpeedUnit.knots);
        final second = harness.controller.setSimpleView(true);
        await harness.container.pump();

        expect(harness.preferences.saved.length, 1);
        gate.complete(const Success(null));
        await Future.wait([first, second]);

        expect(harness.preferences.saved.length, 2);
        expect(harness.preferences.saved.last.unit, SpeedUnit.knots);
        expect(harness.preferences.saved.last.simpleView, isTrue);
        expect(harness.preferences.saved.last, harness.state.preferences);
      },
    );

    test(
      'an older failed save cannot replace the newest successful result',
      () async {
        await harness.initialize();
        final gate = Completer<Result<void>>();
        harness.preferences.nextSaveGate = gate;

        final older = harness.controller.setUnit(SpeedUnit.knots);
        final newest = harness.controller.setSimpleView(true);
        await harness.container.pump();
        gate.complete(const Error(Failure(FailureKind.storage)));
        await Future.wait([older, newest]);

        expect(harness.state.failure, isNull);
        expect(harness.preferences.saved.last, harness.state.preferences);
      },
    );

    test(
      'a failed newest queued save remains visible after an older success',
      () async {
        await harness.initialize();
        final gate = Completer<Result<void>>();
        harness.preferences.nextSaveGate = gate;
        harness.preferences.saveResult = const Error(
          Failure(FailureKind.storage),
        );

        final older = harness.controller.setUnit(SpeedUnit.knots);
        final newest = harness.controller.setSimpleView(true);
        await harness.container.pump();
        gate.complete(const Success(null));
        await Future.wait([older, newest]);

        expect(harness.state.failure?.kind, FailureKind.storage);
        expect(harness.preferences.saved.last, harness.state.preferences);
      },
    );

    test(
      'settings write failures remain recoverable in presentation state',
      () async {
        await harness.initialize();
        harness.preferences.saveResult = const Error(
          Failure(FailureKind.storage),
        );

        await harness.controller.setDarkMode(false);

        expect(harness.state.preferences.darkMode, isFalse);
        expect(harness.state.failure?.kind, FailureKind.storage);
        harness.controller.clearFailure();
        expect(harness.state.failure, isNull);
      },
    );

    test(
      'disposal cancels GPS without requesting additional platform work',
      () async {
        await harness.initializeWithConsent();
        await harness.controller.start();

        harness.container.dispose();

        expect(harness.location.cancelCalls, 1);
        expect(harness.location.prepareCalls, 1);
      },
    );

    test(
      'immediate disposal ignores deferred preference initialization',
      () async {
        harness.container.read(speedometerControllerProvider);

        harness.container.dispose();
        await Future<void>.microtask(() {});

        expect(harness.preferences.loadCalls, 0);
        expect(harness.location.prepareCalls, 0);
      },
    );

    test(
      'settings recovery actions surface failures without starting GPS',
      () async {
        await harness.initializeWithConsent();
        harness.location.appSettingsResult = const Error(
          Failure(FailureKind.unsupported),
        );
        harness.location.locationSettingsResult = const Error(
          Failure(FailureKind.locationDisabled),
        );

        await harness.controller.openAppSettings();
        expect(harness.location.appSettingsCalls, 1);
        expect(harness.state.failure?.kind, FailureKind.unsupported);
        await harness.controller.openLocationSettings();

        expect(harness.location.locationSettingsCalls, 1);
        expect(harness.state.failure?.kind, FailureKind.locationDisabled);
        expect(harness.location.prepareCalls, 0);
        expect(harness.location.watchCalls, 0);
        expect(harness.state.status, TrackingStatus.idle);
      },
    );
  });
}

SpeedReading _reading({
  required int seconds,
  required double speed,
  double longitude = 0,
}) => SpeedReading(
  speedMetersPerSecond: speed,
  accuracyMeters: 3,
  latitude: 0,
  longitude: longitude,
  timestamp: DateTime.utc(2026, 10, 21).add(Duration(seconds: seconds)),
);

class _Harness {
  _Harness() {
    container = ProviderContainer(
      overrides: [
        sessionTripRepositoryProvider.overrideWithValue(trips),
        deviceRepositoryProvider.overrideWithValue(device),
        locationRepositoryProvider.overrideWithValue(location),
        preferencesRepositoryProvider.overrideWithValue(preferences),
        loggerProvider.overrideWithValue(logger),
      ],
    );
  }

  final _FailingTripRepository trips = _FailingTripRepository();
  final _FakeLocationRepository location = _FakeLocationRepository();
  final _GatedDeviceRepository device = _GatedDeviceRepository();
  final _FakePreferencesRepository preferences = _FakePreferencesRepository();
  final _RecordingLogger logger = _RecordingLogger();
  late final ProviderContainer container;

  SpeedometerState get state => container.read(speedometerControllerProvider);

  SpeedometerController get controller =>
      container.read(speedometerControllerProvider.notifier);

  Future<void> initialize() async {
    await waitForPreferences();
  }

  Future<void> waitForPreferences() async {
    final complete = Completer<void>();
    final subscription = container.listen(speedometerControllerProvider, (
      previous,
      next,
    ) {
      if (!next.isLoadingPreferences && !complete.isCompleted) {
        complete.complete();
      }
    }, fireImmediately: true);
    await complete.future;
    subscription.close();
  }

  Future<void> initializeWithConsent() async {
    preferences.loadResult = const Success(
      DisplayPreferences(hasDisclosureConsent: true),
    );
    await initialize();
  }
}

class _GatedDeviceRepository extends FakeDeviceRepository {
  Completer<Result<void>>? nextSettingsGate;
  Completer<void> settingsStarted = Completer<void>();
  int inspectCalls = 0;
  int settingsCalls = 0;
  int displayCalls = 0;

  @override
  Future<Result<void>> update(TrackingDisplay display) async {
    displayCalls++;
    return const Success(null);
  }

  @override
  Future<Result<void>> applySettings(
    DisplayPreferences preferences, {
    required bool awake,
  }) async {
    settingsCalls++;
    final gate = nextSettingsGate;
    nextSettingsGate = null;
    if (!settingsStarted.isCompleted) settingsStarted.complete();
    return gate == null ? const Success(null) : await gate.future;
  }

  @override
  Future<Result<bool>> isTracking() async {
    inspectCalls++;
    return const Success(false);
  }
}

class _FakeLocationRepository implements LocationRepository {
  Result<void> prepareResult = const Success(null);
  Completer<Result<void>>? prepareGate;
  final List<StreamController<Result<SpeedReading>>> _streams = [];
  int prepareCalls = 0;
  int watchCalls = 0;
  int cancelCalls = 0;
  int appSettingsCalls = 0;
  int locationSettingsCalls = 0;
  Result<void> appSettingsResult = const Success(null);
  Result<void> locationSettingsResult = const Success(null);
  Completer<void>? cancelGate;
  final Completer<void> prepareStarted = Completer<void>();

  StreamController<Result<SpeedReading>> get current => _streams.last;

  void emit(SpeedReading reading) => current.add(Success(reading));

  @override
  Future<Result<void>> prepare() async {
    prepareCalls += 1;
    if (!prepareStarted.isCompleted) prepareStarted.complete();
    final gate = prepareGate;
    return gate == null ? prepareResult : await gate.future;
  }

  @override
  Stream<Result<SpeedReading>> watch() {
    watchCalls += 1;
    final stream = StreamController<Result<SpeedReading>>(
      sync: true,
      onCancel: () {
        cancelCalls += 1;
        return cancelGate?.future;
      },
    );
    _streams.add(stream);
    return stream.stream;
  }

  @override
  Future<Result<void>> openAppSettings() async {
    appSettingsCalls += 1;
    return appSettingsResult;
  }

  @override
  Future<Result<void>> openLocationSettings() async {
    locationSettingsCalls += 1;
    return locationSettingsResult;
  }

  Future<void> close() async {
    for (final stream in _streams) {
      await stream.close();
    }
  }
}

class _FakePreferencesRepository implements PreferencesRepository {
  Result<DisplayPreferences> loadResult = const Success(DisplayPreferences());
  Result<void> saveResult = const Success(null);
  Completer<Result<DisplayPreferences>>? loadGate;
  Completer<Result<void>>? nextSaveGate;
  final List<DisplayPreferences> saved = [];
  int loadCalls = 0;

  @override
  Future<Result<DisplayPreferences>> load() async {
    loadCalls += 1;
    final gate = loadGate;
    return gate == null ? loadResult : await gate.future;
  }

  @override
  Future<Result<void>> save(DisplayPreferences preferences) async {
    saved.add(preferences);
    final gate = nextSaveGate;
    nextSaveGate = null;
    return gate == null ? saveResult : await gate.future;
  }
}

class _RecordingLogger implements Logger {
  final List<String> events = [];

  @override
  void error(String event) => events.add(event);
}

class _FailingTripRepository extends FakeTripRepository {
  Completer<void>? startGate;
  @override
  Future<Result<String>> startTrip(DateTime at) async {
    await startGate?.future;
    return super.startTrip(at);
  }

  bool failFinish = false;
  bool failDiscard = false;
  bool failCheckpoint = false;
  static const failure = Error<void>(Failure(FailureKind.storage));
  @override
  Future<Result<void>> finishTrip(String id, DateTime at) =>
      failFinish ? Future.value(failure) : super.finishTrip(id, at);
  @override
  Future<Result<void>> discardTrip(String id) =>
      failDiscard ? Future.value(failure) : super.discardTrip(id);
  @override
  Future<Result<void>> checkpointTrip({
    required String id,
    required TripStats stats,
    required SpeedReading? reading,
    required bool recordRoute,
    required bool overLimit,
    required bool paused,
  }) => failCheckpoint
      ? Future.value(failure)
      : super.checkpointTrip(
          id: id,
          stats: stats,
          reading: reading,
          recordRoute: recordRoute,
          overLimit: overLimit,
          paused: paused,
        );
}
