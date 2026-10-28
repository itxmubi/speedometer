import 'dart:async';
import 'package:speedometer/features/trips/domain/entities/trip_history_query.dart';
import 'package:speedometer/features/trips/domain/entities/trip_totals.dart';
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/database/app_database.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/fuel/data/repositories/drift_fuel_repository.dart';
import 'package:speedometer/features/fuel/domain/entities/fuel_entry.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/domain/entities/trip_stats.dart';
import 'package:speedometer/features/trips/data/repositories/drift_trip_repository.dart';
import 'package:speedometer/features/trips/domain/entities/trip_export_format.dart';
import 'package:speedometer/features/trips/domain/repositories/trip_repository.dart';

void main() {
  late AppDatabase database;
  late DriftTripRepository repository;
  final start = DateTime(2026, 10, 21, 12);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftTripRepository(database, now: () => start);
  });
  tearDown(() => database.close());

  for (final boundary in [
    DateTime(2026, 11, 1),
    DateTime(2026, 11, 2),
    DateTime(2027, 1, 1),
  ]) {
    test('calendar totals roll over without writes at $boundary', () async {
      var now = boundary.subtract(const Duration(seconds: 1));
      final ticks = StreamController<void>();
      final store = DriftTripRepository(
        database,
        now: () => now,
        calendarTicks: () => ticks.stream,
      );
      final id = value(await store.startTrip(now));
      await checkpoint(store, id, now, distance: 100);
      final values = <TripTotals>[];
      final first = Completer<void>();
      final rolled = Completer<void>();
      final subscription = store.watchTotals().listen((result) {
        values.add(value(result));
        if (!first.isCompleted) {
          first.complete();
        } else if (!rolled.isCompleted) {
          rolled.complete();
        }
      });
      await first.future;
      expect(values.last.todayMeters, 100);
      now = boundary;
      ticks.add(null);
      await rolled.future;
      expect(values.last.todayMeters, 0);
      expect(values.last.odometerMeters, 100);
      if (boundary.weekday == DateTime.monday) {
        expect(values.last.weekMeters, 0);
      }
      if (boundary.day == 1) expect(values.last.monthMeters, 0);
      await subscription.cancel();
      expect(ticks.hasListener, false);
      await ticks.close();
    });
  }

  test(
    'discard removes active record and points but retains odometer',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 100);
      expect(await repository.discardTrip(id), isA<Success<void>>());
      expect(value(await repository.getTrip(id)), isNull);
      expect(await database.select(database.tripPoints).get(), isEmpty);
      expect(value(await repository.watchTotals().first).odometerMeters, 100);
      expect(await repository.discardTrip(id), isA<Success<void>>());
    },
  );

  test(
    'history pages are bounded and date/status filters apply before paging',
    () async {
      for (var i = 0; i < 45; i++) {
        final at = start.add(Duration(minutes: i));
        final id = value(await repository.startTrip(at));
        await repository.finishTrip(id, at);
      }
      final first = value(
        await repository.watchTrips(query: const TripHistoryQuery()).first,
      );
      final second = value(
        await repository
            .watchTrips(query: const TripHistoryQuery(page: 1))
            .first,
      );
      expect(first.length, TripHistoryQuery.pageSize + 1);
      expect(second.length, TripHistoryQuery.pageSize + 1);
      expect(
        first
            .take(20)
            .map((t) => t.id)
            .toSet()
            .intersection(second.take(20).map((t) => t.id).toSet()),
        isEmpty,
      );
      final range = value(
        await repository
            .watchTrips(
              query: TripHistoryQuery(
                from: start.add(const Duration(minutes: 10)),
                before: start.add(const Duration(minutes: 15)),
                active: false,
              ),
            )
            .first,
      );
      expect(range.length, 5);
      expect(
        value(
          await repository
              .watchTrips(query: const TripHistoryQuery(active: true))
              .first,
        ),
        isEmpty,
      );
    },
  );

  test(
    'commits checkpoint and odometer delta atomically and idempotently',
    () async {
      final id = value(await repository.startTrip(start));
      expect(value(await repository.startTrip(start)), id);
      await checkpoint(repository, id, start, distance: 100);
      await checkpoint(repository, id, start, distance: 100);
      final trip = value(await repository.getTrip(id));
      expect(trip?.stats.distanceMeters, 100);
      expect(trip?.points.length, 1);
      final totals = value(await repository.watchTotals().first);
      expect(totals.odometerMeters, 100);
      expect(totals.todayMeters, 100);
      expect(totals.weekMeters, 100);
      expect(totals.monthMeters, 100);
    },
  );

  test(
    'ignores stale checkpoints without rolling statistics backward',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 200);
      await checkpoint(
        repository,
        id,
        start.add(const Duration(seconds: 1)),
        distance: 50,
      );
      expect(value(await repository.getTrip(id))?.stats.distanceMeters, 200);
      expect(value(await repository.watchTotals().first).odometerMeters, 200);
    },
  );

  test(
    'saves graph samples without any location when route recording is off',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 10, recordRoute: false);
      final trip = value(await repository.getTrip(id));
      expect(trip?.startPoint, isNull);
      final point = trip?.points.single;
      expect(point?.speedMetersPerSecond, 10);
      expect(point?.latitude, isNull);
      expect(point?.longitude, isNull);
      expect(point?.accuracyMeters, isNull);
      expect(point?.altitudeMeters, isNull);
      expect(point?.headingDegrees, isNull);
    },
  );

  test(
    'splits route segments across pauses and never records paused samples',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 10);
      await checkpoint(
        repository,
        id,
        start.add(const Duration(seconds: 1)),
        distance: 10,
        paused: true,
      );
      await checkpoint(
        repository,
        id,
        start.add(const Duration(seconds: 2)),
        distance: 20,
      );
      final trip = value(await repository.getTrip(id));
      expect(trip?.points.length, 2);
      expect(trip?.points.first.segment, 0);
      expect(trip?.points.last.segment, 1);
      final gpx = value(await repository.exportTrip(id, TripExportFormat.gpx));
      expect('<trkseg>'.allMatches(gpx).length, 2);
    },
  );

  test(
    'individual history deletion preserves lifetime and calendar totals',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 30);
      await repository.finishTrip(id, start);
      expect(await repository.deleteTrip(id), isA<Success<void>>());
      expect(value(await repository.getTrip(id)), isNull);
      expect(value(await repository.watchTotals().first).odometerMeters, 30);
      expect(value(await repository.watchTrips().first), isEmpty);
    },
  );

  test(
    'rejects deleting an active trip and clearing data while recording',
    () async {
      final id = value(await repository.startTrip(start));
      expect(await repository.deleteTrip(id), isA<Error<void>>());
      expect(await repository.deleteAllTrips(), isA<Error<void>>());
      expect(await repository.clearAllData(), isA<Error<void>>());
    },
  );

  test(
    'full data reset intentionally removes odometer as well as history',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 30);
      await repository.finishTrip(id, start);
      await repository.clearAllData();
      expect(value(await repository.watchTotals().first).odometerMeters, 0);
      expect(value(await repository.watchTrips().first), isEmpty);
    },
  );

  test(
    'sorts history newest first and retains start and end coordinates',
    () async {
      final first = value(await repository.startTrip(start));
      await checkpoint(repository, first, start, distance: 20);
      await repository.finishTrip(first, start);
      final next = start.add(const Duration(days: 1));
      final second = value(await repository.startTrip(next));
      await checkpoint(repository, second, next, distance: 50);
      final rows = value(await repository.watchTrips().first);
      expect(rows.map((trip) => trip.id), [second, first]);
      final detail = value(await repository.getTrip(first));
      expect(detail?.startPoint?.latitude, 25);
      expect(detail?.endPoint?.longitude, 55);
    },
  );

  test(
    'calendar totals use local day, Monday week, and month boundaries',
    () async {
      final previousMonth = DateTime(2026, 9, 30, 12);
      final previousWeek = DateTime(2026, 10, 18, 12);
      final currentWeek = DateTime(2026, 10, 19, 12);
      for (final date in [previousMonth, previousWeek, currentWeek, start]) {
        final id = value(await repository.startTrip(date));
        await checkpoint(repository, id, date, distance: 100);
        await repository.finishTrip(id, date);
      }
      final totals = value(await repository.watchTotals().first);
      expect(totals.odometerMeters, 400);
      expect(totals.monthMeters, 300);
      expect(totals.weekMeters, 200);
      expect(totals.todayMeters, 100);
    },
  );

  test(
    'backup roundtrips all samples, preserved ledger and opaque settings',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 100, overLimit: true);
      await repository.finishTrip(id, start);
      final backup = value(
        await repository.exportBackup(settingsJson: '{"unit":"mph"}'),
      );
      expect(
        value(await repository.inspectBackupSettings(backup)),
        '{"unit":"mph"}',
      );
      await repository.clearAllData();
      expect(value(await repository.restoreBackup(backup)), '{"unit":"mph"}');
      final trip = value(await repository.getTrip(id));
      expect(trip?.points.single.overLimit, isTrue);
      expect(trip?.points.single.latitude, 25);
      expect(value(await repository.watchTotals().first).odometerMeters, 100);
    },
  );

  test(
    'corrupt and future-version backup leave existing data unchanged',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 100);
      await repository.finishTrip(id, start);
      final backup = value(await repository.exportBackup());
      for (final contents in [
        '{broken',
        backup.replaceFirst('"version":2', '"version":3'),
      ]) {
        expect(await repository.restoreBackup(contents), isA<Error<String?>>());
        expect(value(await repository.getTrip(id))?.stats.distanceMeters, 100);
        expect(value(await repository.watchTotals().first).odometerMeters, 100);
      }
    },
  );

  test(
    'fuel backup roundtrips with trips and full reset clears fuel',
    () async {
      final fuel = DriftFuelRepository(database);
      await fuel.saveEntry(
        FuelEntry(
          occurredAt: start,
          distanceMeters: 120000,
          fuelLiters: 10,
          fuelCost: 30,
          otherCost: 5,
          currencyCode: 'AED',
          note: 'Service',
        ),
      );
      final original = value(await fuel.watchEntries().first).single;
      final backup = value(await repository.exportBackup());
      await repository.clearAllData();
      expect(value(await fuel.watchEntries().first), isEmpty);
      expect(await repository.restoreBackup(backup), isA<Success<String?>>());
      final restored = value(await fuel.watchEntries().first).single;
      expect(restored.id, original.id);
      expect(restored.distanceMeters, 120000);
      expect(restored.fuelLiters, 10);
      expect(restored.fuelCost, 30);
      expect(restored.otherCost, 5);
      expect(restored.currencyCode, 'AED');
      expect(restored.note, 'Service');
    },
  );

  test(
    'legacy version one backup restores without inventing fuel data',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 100);
      await repository.finishTrip(id, start);
      final legacy =
          jsonDecode(value(await repository.exportBackup()))
              as Map<String, Object?>;
      legacy['version'] = 1;
      legacy['databaseSchema'] = 1;
      legacy.remove('fuelEntries');
      expect(
        await repository.restoreBackup(jsonEncode(legacy)),
        isA<Success<String?>>(),
      );
      expect(value(await repository.getTrip(id))?.stats.distanceMeters, 100);
      expect(await database.select(database.fuelRecords).get(), isEmpty);
    },
  );

  test(
    'invalid and duplicate fuel entries reject restore without deleting data',
    () async {
      final fuel = DriftFuelRepository(database);
      await fuel.saveEntry(
        FuelEntry(
          occurredAt: start,
          distanceMeters: 1000,
          fuelLiters: 1,
          fuelCost: 2,
          otherCost: 0,
          currencyCode: 'USD',
        ),
      );
      final backup = value(await repository.exportBackup());
      for (final field in [
        'liters',
        'distance',
        'currency',
        'id',
        'time',
        'note',
      ]) {
        final invalid = jsonDecode(backup) as Map<String, Object?>;
        final entries = invalid['fuelEntries'] as List<Object?>;
        final entry = entries.single as Map<String, Object?>;
        entry[field] = switch (field) {
          'currency' => 'BAD CODE',
          'id' => '',
          'note' => List.filled(501, 'a').join(),
          _ => -1,
        };
        expect(
          await repository.restoreBackup(jsonEncode(invalid)),
          isA<Error<String?>>(),
        );
        expect(value(await fuel.watchEntries().first).single.fuelLiters, 1);
      }
      final duplicate = jsonDecode(backup) as Map<String, Object?>;
      final entries = duplicate['fuelEntries'] as List<Object?>;
      entries.add(entries.single);
      expect(
        await repository.restoreBackup(jsonEncode(duplicate)),
        isA<Error<String?>>(),
      );
      expect(value(await fuel.watchEntries().first), hasLength(1));
    },
  );

  test('duplicate IDs and invalid coordinates reject whole backup', () async {
    final id = value(await repository.startTrip(start));
    await checkpoint(repository, id, start, distance: 100);
    await repository.finishTrip(id, start);
    final backup = value(await repository.exportBackup());
    final duplicate = jsonDecode(backup) as Map<String, Object?>;
    final trips = duplicate['trips'] as List<Object?>;
    trips.add(trips.single);
    expect(
      await repository.restoreBackup(jsonEncode(duplicate)),
      isA<Error<String?>>(),
    );
    final invalidCoordinates = backup.replaceFirst('"lat":25.0', '"lat":200.0');
    expect(
      await repository.restoreBackup(invalidCoordinates),
      isA<Error<String?>>(),
    );
    expect(value(await repository.getTrip(id))?.points.length, 1);
  });

  test(
    'invalid negative statistics cause no partial point or ledger writes',
    () async {
      final id = value(await repository.startTrip(start));
      final result = await repository.checkpointTrip(
        id: id,
        stats: const TripStats(distanceMeters: -5),
        reading: reading(start),
        recordRoute: true,
        overLimit: false,
        paused: false,
      );
      expect(result, isA<Error<void>>());
      expect(value(await repository.getTrip(id))?.points, isEmpty);
      expect(value(await repository.watchTotals().first).odometerMeters, 0);
    },
  );

  test(
    'restoring active backup resets its pause and route anchor safely',
    () async {
      final id = value(await repository.startTrip(start));
      await checkpoint(repository, id, start, distance: 100);
      final backup = value(await repository.exportBackup());
      await repository.finishTrip(id, start);
      await repository.restoreBackup(backup);
      final active = value(await repository.getActiveTrip());
      expect(active?.id, id);
      expect(active?.isPaused, isTrue);
      expect(active?.stats.lastReading, isNull);
      await checkpoint(
        repository,
        id,
        start.add(const Duration(seconds: 2)),
        distance: 110,
      );
      expect(value(await repository.getTrip(id))?.points.last.segment, 1);
    },
  );

  test(
    'real SQLite reopen recovers the last committed unfinished trip',
    () async {
      final directory = await Directory.systemTemp.createTemp('trip_restart_');
      final file = File('${directory.path}/trip.sqlite');
      var diskDatabase = AppDatabase(NativeDatabase(file));
      var diskRepository = DriftTripRepository(diskDatabase, now: () => start);
      try {
        final id = value(await diskRepository.startTrip(start));
        await checkpoint(diskRepository, id, start, distance: 123);
        await diskDatabase.close();
        diskDatabase = AppDatabase(NativeDatabase(file));
        diskRepository = DriftTripRepository(diskDatabase, now: () => start);
        final recovered = value(await diskRepository.getActiveTrip());
        expect(recovered?.id, id);
        expect(recovered?.stats.distanceMeters, 123);
        expect(recovered?.stats.lastReading, isNull);
        expect(recovered?.points.length, 1);
        expect(
          value(await diskRepository.watchTotals().first).odometerMeters,
          123,
        );
      } finally {
        await diskDatabase.close();
        await directory.delete(recursive: true);
      }
    },
  );
}

T value<T>(Result<T> result) => switch (result) {
  Success(:final value) => value,
  Error() => throw StateError('Expected success'),
};

SpeedReading reading(DateTime at) => SpeedReading(
  speedMetersPerSecond: 10,
  accuracyMeters: 5,
  latitude: 25,
  longitude: 55,
  altitudeMeters: 10,
  headingDegrees: 90,
  timestamp: at,
);

Future<void> checkpoint(
  TripRepository repository,
  String id,
  DateTime at, {
  required double distance,
  bool recordRoute = true,
  bool paused = false,
  bool overLimit = false,
}) async {
  final result = await repository.checkpointTrip(
    id: id,
    stats: TripStats(
      distanceMeters: distance,
      maxSpeedMetersPerSecond: 10,
      elapsed: const Duration(seconds: 10),
      movingTime: const Duration(seconds: 10),
    ),
    reading: reading(at),
    recordRoute: recordRoute,
    overLimit: overLimit,
    paused: paused,
  );
  expect(result, isA<Success<void>>());
}
