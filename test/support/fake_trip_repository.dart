import 'package:speedometer/features/trips/domain/entities/trip_history_query.dart';
import 'dart:math' as math;
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/domain/entities/trip_stats.dart';
import 'package:speedometer/features/trips/domain/entities/recorded_trip.dart';
import 'package:speedometer/features/trips/domain/entities/trip_totals.dart';
import 'package:speedometer/features/trips/domain/entities/trip_export_format.dart';
import 'package:speedometer/features/trips/domain/repositories/trip_repository.dart';

/// Minimal deterministic fake for dashboard flows; storage tests use real Drift.
class FakeTripRepository implements TripRepository {
  final records = <String, RecordedTrip>{};
  int nextId = 0;
  double odometer = 0;
  @override
  Future<Result<String>> startTrip(DateTime startedAt) async {
    for (final trip in records.values) {
      if (trip.isActive) return Success(trip.id);
    }
    final id = 'trip-${nextId++}';
    records[id] = RecordedTrip(
      id: id,
      startedAt: startedAt,
      stats: const TripStats(),
    );
    return Success(id);
  }

  @override
  Future<Result<void>> checkpointTrip({
    required String id,
    required TripStats stats,
    required SpeedReading? reading,
    required bool recordRoute,
    required bool overLimit,
    required bool paused,
  }) async {
    final old = records[id];
    if (old == null) return const Success(null);
    odometer += math.max(0, stats.distanceMeters - old.stats.distanceMeters);
    records[id] = RecordedTrip(
      id: id,
      startedAt: old.startedAt,
      stats: stats,
      isPaused: paused,
      endedAt: old.endedAt,
    );
    return const Success(null);
  }

  @override
  Future<Result<void>> finishTrip(String id, DateTime endedAt) async {
    final old = records[id];
    if (old != null) {
      records[id] = RecordedTrip(
        id: id,
        startedAt: old.startedAt,
        stats: old.stats,
        endedAt: endedAt,
      );
    }
    return const Success(null);
  }

  @override
  Stream<Result<List<RecordedTrip>>> watchTrips({TripHistoryQuery? query}) =>
      Stream.value(Success(records.values.toList()));
  @override
  Stream<Result<TripTotals>> watchTotals() =>
      Stream.value(Success(TripTotals(odometerMeters: odometer)));
  @override
  Future<Result<RecordedTrip?>> getTrip(String id) async =>
      Success(records[id]);
  @override
  Future<Result<RecordedTrip?>> getActiveTrip() async {
    for (final trip in records.values) {
      if (trip.isActive) return Success(trip);
    }
    return const Success(null);
  }

  @override
  Future<Result<void>> deleteTrip(String id) async {
    records.remove(id);
    return const Success(null);
  }

  @override
  Future<Result<String>> exportTrip(String id, TripExportFormat format) async =>
      const Success('');
  @override
  Future<Result<String>> exportBackup({String? settingsJson}) async =>
      const Success('{}');
  @override
  Future<Result<String?>> restoreBackup(String contents) async =>
      const Success(null);
  @override
  Future<Result<String?>> inspectBackupSettings(String contents) async =>
      const Success(null);
  @override
  Future<Result<void>> discardTrip(String id) => deleteTrip(id);

  @override
  Future<Result<void>> deleteAllTrips() async {
    records.clear();
    return const Success(null);
  }

  @override
  Future<Result<void>> clearAllData() async {
    records.clear();
    odometer = 0;
    return const Success(null);
  }
}
