import '../../domain/entities/trip_history_query.dart';
import 'dart:async';
import '../datasources/local_calendar_ticks.dart';
import 'dart:isolate';
import 'dart:math';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/logger.dart';
import '../../../speedometer/domain/entities/speed_reading.dart';
import '../../../speedometer/domain/entities/trip_stats.dart';
import '../../domain/entities/recorded_trip.dart';
import '../../domain/entities/track_point.dart';
import '../../domain/entities/trip_export_format.dart';
import '../../domain/entities/trip_totals.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../domain/usecases/encode_trip_use_case.dart';
import '../models/trip_backup_model.dart';
import '../models/backup_fuel_mapper.dart';
import '../models/trip_mapper.dart';

/// Transactional SQLite storage. Every delta and its cumulative checkpoint commit together.
final class DriftTripRepository implements TripRepository {
  DriftTripRepository(
    this._database, {
    Logger logger = const Logger(),
    DateTime Function()? now,
    Stream<void> Function()? calendarTicks,
  }) : _logger = logger,
       _now = now ?? DateTime.now,
       _calendarTicks = calendarTicks;

  final AppDatabase _database;
  final Logger _logger;
  final DateTime Function() _now;
  final Stream<void> Function()? _calendarTicks;
  final Random _random = Random.secure();

  @override
  Future<Result<String>> startTrip(DateTime startedAt) => _guard(
    () => _database.transaction(() async {
      final active = await _activeRow();
      if (active != null) return active.id;
      final suffix = List.generate(
        12,
        (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();
      final id = '${startedAt.millisecondsSinceEpoch}_$suffix';
      await _database
          .into(_database.tripRecords)
          .insert(
            TripRecordsCompanion.insert(
              id: id,
              startedAtMs: startedAt.millisecondsSinceEpoch,
            ),
          );
      return id;
    }),
  );

  @override
  Future<Result<void>> checkpointTrip({
    required String id,
    required TripStats stats,
    required SpeedReading? reading,
    required bool recordRoute,
    required bool overLimit,
    required bool paused,
  }) => _guard(
    () => _database.transaction(() async {
      _validateStats(stats);
      final row = await _row(id);
      if (row == null || row.endedAtMs != null) {
        throw StateError('Missing active trip');
      }
      // Old asynchronous callbacks must never roll back an already committed checkpoint.
      if (stats.distanceMeters < row.distanceMeters ||
          stats.elapsed.inMicroseconds < row.elapsedUs ||
          stats.movingTime.inMicroseconds < row.movingUs) {
        return;
      }
      final delta = stats.distanceMeters - row.distanceMeters;
      final segment = row.segment + ((!row.paused && paused) ? 1 : 0);
      final timestamp = reading?.timestamp.millisecondsSinceEpoch;
      final insertPoint =
          !paused &&
          reading != null &&
          timestamp != null &&
          timestamp >= row.startedAtMs &&
          (row.lastPointMs == null ||
              timestamp > (row.lastPointMs ?? timestamp));
      if (insertPoint) {
        _validateReading(reading);
        await _database
            .into(_database.tripPoints)
            .insert(
              TripPointsCompanion.insert(
                tripId: id,
                timestampMs: timestamp,
                speed: reading.speedMetersPerSecond,
                segment: segment,
                overLimit: overLimit,
                latitude: Value(recordRoute ? reading.latitude : null),
                longitude: Value(recordRoute ? reading.longitude : null),
                accuracy: Value(recordRoute ? reading.accuracyMeters : null),
                altitude: Value(recordRoute ? reading.altitudeMeters : null),
                heading: Value(recordRoute ? reading.headingDegrees : null),
              ),
            );
      }
      await (_database.update(
        _database.tripRecords,
      )..where((table) => table.id.equals(id))).write(
        TripRecordsCompanion(
          distanceMeters: Value(stats.distanceMeters),
          maxSpeed: Value(max(row.maxSpeed, stats.maxSpeedMetersPerSecond)),
          elapsedUs: Value(stats.elapsed.inMicroseconds),
          movingUs: Value(stats.movingTime.inMicroseconds),
          paused: Value(paused),
          segment: Value(segment),
          lastPointMs: insertPoint ? Value(timestamp) : const Value.absent(),
        ),
      );
      if (delta > 0) {
        final day = _localDay(reading?.timestamp ?? _now());
        final existing = await (_database.select(
          _database.distanceDays,
        )..where((table) => table.localDay.equals(day))).getSingleOrNull();
        await _database
            .into(_database.distanceDays)
            .insertOnConflictUpdate(
              DistanceDaysCompanion.insert(
                localDay: day,
                meters: (existing?.meters ?? 0) + delta,
              ),
            );
      }
    }),
  );

  @override
  Future<Result<void>> finishTrip(String id, DateTime endedAt) => _guard(
    () => _database.transaction(() async {
      final row = await _row(id);
      if (row == null) throw StateError('Missing trip');
      if (row.endedAtMs != null) return;
      final end = max(
        endedAt.millisecondsSinceEpoch,
        max(row.startedAtMs, row.lastPointMs ?? row.startedAtMs),
      );
      await (_database.update(
        _database.tripRecords,
      )..where((table) => table.id.equals(id))).write(
        TripRecordsCompanion(endedAtMs: Value(end), paused: const Value(true)),
      );
    }),
  );

  @override
  Stream<Result<List<RecordedTrip>>> watchTrips({
    TripHistoryQuery? query,
  }) async* {
    try {
      final request = _database.select(_database.tripRecords)
        ..orderBy([
          (table) => OrderingTerm.desc(table.startedAtMs),
          (table) => OrderingTerm.desc(table.id),
        ]);
      if (query != null) {
        final from = query.from;
        final before = query.before;
        if (from != null) {
          request.where(
            (t) =>
                t.startedAtMs.isBiggerOrEqualValue(from.millisecondsSinceEpoch),
          );
        }
        if (before != null) {
          request.where(
            (t) =>
                t.startedAtMs.isSmallerThanValue(before.millisecondsSinceEpoch),
          );
        }
        if (query.active == true) request.where((t) => t.endedAtMs.isNull());
        if (query.active == false) {
          request.where((t) => t.endedAtMs.isNotNull());
        }
        request.limit(TripHistoryQuery.pageSize + 1, offset: query.offset);
      }
      await for (final rows in request.watch()) {
        yield Success(rows.map(TripMapper.toEntity).toList(growable: false));
      }
    } on Object {
      _logger.error('trips_watch_failed');
      yield const Error(Failure(FailureKind.storage));
    }
  }

  @override
  Stream<Result<TripTotals>> watchTotals() {
    // Keep the latest ledger in memory: calendar rollover needs no database write.
    return Stream<Result<TripTotals>>.multi((sink) {
      List<DistanceDay>? latest;
      void emit() {
        final rows = latest;
        if (rows != null) sink.add(Success(_totalsFor(rows)));
      }

      void fail(Object error, StackTrace stack) {
        _logger.error('trip_totals_watch_failed');
        sink.add(const Error(Failure(FailureKind.storage)));
      }

      final database = _database.select(_database.distanceDays).watch().listen((
        rows,
      ) {
        latest = rows;
        emit();
      }, onError: fail);
      final calendar = (_calendarTicks?.call() ?? localCalendarTicks(_now))
          .listen((_) => emit(), onError: fail);
      sink.onCancel = () async {
        await Future.wait([database.cancel(), calendar.cancel()]);
      };
    });
  }

  TripTotals _totalsFor(List<DistanceDay> rows) {
    final now = _now().toLocal();
    final day = _localDay(now);
    final week = _localDay(
      DateTime(now.year, now.month, now.day - now.weekday + DateTime.monday),
    );
    final month = _localDay(DateTime(now.year, now.month));
    var total = 0.0;
    var today = 0.0;
    var thisWeek = 0.0;
    var thisMonth = 0.0;
    for (final row in rows) {
      total += row.meters;
      if (row.localDay == day) today += row.meters;
      if (row.localDay.compareTo(week) >= 0 &&
          row.localDay.compareTo(day) <= 0) {
        thisWeek += row.meters;
      }
      if (row.localDay.compareTo(month) >= 0 &&
          row.localDay.compareTo(day) <= 0) {
        thisMonth += row.meters;
      }
    }
    return TripTotals(
      odometerMeters: total,
      todayMeters: today,
      weekMeters: thisWeek,
      monthMeters: thisMonth,
    );
  }

  @override
  Future<Result<RecordedTrip?>> getTrip(String id) => _guard(() async {
    final row = await _row(id);
    return row == null ? null : _detail(row);
  });

  @override
  Future<Result<RecordedTrip?>> getActiveTrip() => _guard(() async {
    final row = await _activeRow();
    return row == null ? null : _detail(row);
  });

  @override
  Future<Result<void>> deleteTrip(String id) => _guard(
    () => _database.transaction(() async {
      final row = await _row(id);
      if (row?.endedAtMs == null && row != null) {
        throw StateError('Trip is active');
      }
      await (_database.delete(
        _database.tripRecords,
      )..where((table) => table.id.equals(id))).go();
    }),
  );

  @override
  Future<Result<void>> discardTrip(String id) => _guard(
    () => _database.transaction(() async {
      await (_database.delete(
        _database.tripRecords,
      )..where((table) => table.id.equals(id))).go();
    }),
  );

  @override
  Future<Result<void>> deleteAllTrips() => _guard(
    () => _database.transaction(() async {
      if (await _activeRow() != null) throw StateError('Trip is active');
      await _database.delete(_database.tripPoints).go();
      await _database.delete(_database.tripRecords).go();
    }),
  );

  @override
  Future<Result<void>> clearAllData() => _guard(
    () => _database.transaction(() async {
      if (await _activeRow() != null) throw StateError('Trip is active');
      await _database.delete(_database.tripPoints).go();
      await _database.delete(_database.tripRecords).go();
      await _database.delete(_database.distanceDays).go();
      await _database.delete(_database.fuelRecords).go();
    }),
  );

  @override
  Future<Result<String>> exportTrip(String id, TripExportFormat format) =>
      _guard(() async {
        final row = await _row(id);
        if (row == null) throw StateError('Missing trip');
        final trip = await _detail(row);
        return _encodeOffThread(trip, format);
      });

  @override
  Future<Result<String>> exportBackup({String? settingsJson}) =>
      _guard(() async {
        final model = await _database.transaction(() async {
          final rows = await _database.select(_database.tripRecords).get();
          final trips = <RecordedTrip>[];
          for (final row in rows) {
            trips.add(await _detail(row));
          }
          final days = await _database.select(_database.distanceDays).get();
          final fuel = await _database.select(_database.fuelRecords).get();
          return TripBackupModel(
            trips: trips,
            days: {for (final row in days) row.localDay: row.meters},
            settingsJson: settingsJson,
            fuelEntries: fuel.map(BackupFuelMapper.toEntity).toList(),
          );
        });
        final encoded = await Isolate.run(model.encode);
        if (encoded.length > TripBackupModel.maxBytes) {
          throw StateError('Backup exceeds size limit');
        }
        return encoded;
      });

  @override
  Future<Result<String?>> inspectBackupSettings(String contents) =>
      _guard(() async {
        final model = await _decodeOffThread(contents);
        return model.settingsJson;
      });

  @override
  Future<Result<String?>> restoreBackup(String contents) => _guard(() async {
    final model = await _decodeOffThread(contents);
    await _database.transaction(() async {
      if (await _activeRow() != null) throw StateError('Trip is active');
      await _database.delete(_database.tripPoints).go();
      await _database.delete(_database.tripRecords).go();
      await _database.delete(_database.distanceDays).go();
      await _database.delete(_database.fuelRecords).go();
      await _database.batch((batch) {
        for (final trip in model.trips) {
          batch.insert(
            _database.tripRecords,
            TripRecordsCompanion.insert(
              id: trip.id,
              startedAtMs: trip.startedAt.millisecondsSinceEpoch,
              endedAtMs: Value(trip.endedAt?.millisecondsSinceEpoch),
              distanceMeters: Value(trip.stats.distanceMeters),
              maxSpeed: Value(trip.stats.maxSpeedMetersPerSecond),
              elapsedUs: Value(trip.stats.elapsed.inMicroseconds),
              movingUs: Value(trip.stats.movingTime.inMicroseconds),
              // Restored active trips have no GPS anchor and begin a new route segment.
              paused: const Value(true),
              segment: Value(
                trip.points.isEmpty ? 0 : trip.points.last.segment + 1,
              ),
              lastPointMs: Value(
                trip.points.isEmpty
                    ? null
                    : trip.points.last.timestamp.millisecondsSinceEpoch,
              ),
            ),
          );
          for (final point in trip.points) {
            batch.insert(_database.tripPoints, _pointCompanion(trip.id, point));
          }
        }
        for (final entry in model.days.entries) {
          batch.insert(
            _database.distanceDays,
            DistanceDaysCompanion.insert(
              localDay: entry.key,
              meters: entry.value,
            ),
          );
        }
        for (final entry in model.fuelEntries) {
          batch.insert(
            _database.fuelRecords,
            BackupFuelMapper.toCompanion(entry),
          );
        }
      });
    });
    return model.settingsJson;
  });

  // Static boundaries prevent an isolate closure capturing the live SQLite connection.
  static Future<String> _encodeOffThread(
    RecordedTrip trip,
    TripExportFormat format,
  ) => Isolate.run(() => const EncodeTripUseCase()(trip, format));
  static Future<TripBackupModel> _decodeOffThread(String contents) =>
      Isolate.run(() => TripBackupModel.decode(contents));

  Future<TripRecord?> _row(String id) => (_database.select(
    _database.tripRecords,
  )..where((table) => table.id.equals(id))).getSingleOrNull();
  Future<TripRecord?> _activeRow() =>
      (_database.select(_database.tripRecords)
            ..where((table) => table.endedAtMs.isNull())
            ..limit(1))
          .getSingleOrNull();

  Future<RecordedTrip> _detail(TripRecord row) async {
    final points =
        await (_database.select(_database.tripPoints)
              ..where((table) => table.tripId.equals(row.id))
              ..orderBy([(table) => OrderingTerm.asc(table.timestampMs)]))
            .get();
    return TripMapper.toEntity(row, points);
  }

  TripPointsCompanion _pointCompanion(String id, TrackPoint point) =>
      TripPointsCompanion.insert(
        tripId: id,
        timestampMs: point.timestamp.millisecondsSinceEpoch,
        speed: point.speedMetersPerSecond,
        segment: point.segment,
        overLimit: point.overLimit,
        latitude: Value(point.latitude),
        longitude: Value(point.longitude),
        accuracy: Value(point.accuracyMeters),
        altitude: Value(point.altitudeMeters),
        heading: Value(point.headingDegrees),
      );

  void _validateStats(TripStats stats) {
    if (!stats.distanceMeters.isFinite ||
        stats.distanceMeters < 0 ||
        !stats.maxSpeedMetersPerSecond.isFinite ||
        stats.maxSpeedMetersPerSecond < 0 ||
        stats.elapsed.isNegative ||
        stats.movingTime.isNegative ||
        stats.movingTime > stats.elapsed) {
      throw const FormatException('Invalid statistics');
    }
  }

  void _validateReading(SpeedReading reading) {
    if (!reading.latitude.isFinite ||
        reading.latitude.abs() > 90 ||
        !reading.longitude.isFinite ||
        reading.longitude.abs() > 180 ||
        !reading.speedMetersPerSecond.isFinite ||
        reading.speedMetersPerSecond < 0 ||
        reading.speedMetersPerSecond > 1000 ||
        !reading.accuracyMeters.isFinite ||
        reading.accuracyMeters < 0) {
      throw const FormatException('Invalid reading');
    }
  }

  String _localDay(DateTime date) {
    final local = date.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }

  Future<Result<T>> _guard<T>(Future<T> Function() operation) async {
    try {
      return Success(await operation());
    } on Object {
      _logger.error('trip_storage_operation_failed');
      return const Error(Failure(FailureKind.storage));
    }
  }
}
