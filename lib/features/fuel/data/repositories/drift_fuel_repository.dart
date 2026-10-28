import 'dart:math';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/fuel_entry.dart';
import '../../domain/repositories/fuel_repository.dart';
import '../models/fuel_entry_mapper.dart';

/// Transactional local expense persistence with privacy-safe failures.
final class DriftFuelRepository implements FuelRepository {
  DriftFuelRepository(this._database, {Logger logger = const Logger()})
    : _logger = logger;

  final AppDatabase _database;
  final Logger _logger;
  final Random _random = Random.secure();

  @override
  Stream<Result<List<FuelEntry>>> watchEntries() async* {
    try {
      final query = _database.select(_database.fuelRecords)
        ..orderBy([
          (table) => OrderingTerm.desc(table.occurredAtMs),
          (table) => OrderingTerm.desc(table.id),
        ]);
      await for (final rows in query.watch()) {
        yield Success(List.unmodifiable(rows.map(FuelEntryMapper.toEntity)));
      }
    } on Object {
      _logger.error('fuel_watch_failed');
      yield const Error(Failure(FailureKind.storage));
    }
  }

  @override
  Future<Result<void>> saveEntry(FuelEntry entry) => _guard(() async {
    if (!entry.isValid) {
      throw const FormatException('Invalid fuel entry');
    }
    final id =
        entry.id ??
        List.generate(
          16,
          (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
        ).join();
    await _database
        .into(_database.fuelRecords)
        .insertOnConflictUpdate(FuelEntryMapper.toCompanion(entry, id));
  });

  @override
  Future<Result<void>> deleteEntry(String id) => _guard(() async {
    await (_database.delete(
      _database.fuelRecords,
    )..where((table) => table.id.equals(id))).go();
  });

  Future<Result<void>> _guard(Future<void> Function() operation) async {
    try {
      await operation();
      return const Success(null);
    } on Object {
      _logger.error('fuel_storage_operation_failed');
      return const Error(Failure(FailureKind.storage));
    }
  }
}
