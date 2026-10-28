import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'distance_days.dart';
import 'fuel_records.dart';
import 'trip_points.dart';
import 'trip_records.dart';

part 'app_database.g.dart';

/// Versioned on-device source of truth, opened on a background isolate.
@DriftDatabase(tables: [TripRecords, TripPoints, DistanceDays, FuelRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.open() => AppDatabase(
    LazyDatabase(() async {
      final directory = await getApplicationSupportDirectory();
      return NativeDatabase.createInBackground(
        File('${directory.path}/speedometer.sqlite'),
      );
    }),
  );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from == 1 && to == 2) {
        await migrator.createTable(fuelRecords);
      } else {
        throw StateError('Unsupported database migration');
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
