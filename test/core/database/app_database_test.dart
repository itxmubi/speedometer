import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/database/app_database.dart';

import 'generated/schema.dart';

void main() {
  test(
    'fresh version two database matches its exported schema snapshot',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final verifier = SchemaVerifier(GeneratedHelper());
      try {
        await verifier.migrateAndValidate(database, 2);
        final version = await database
            .customSelect('PRAGMA user_version')
            .getSingle();
        expect(version.read<int>('user_version'), 2);
      } finally {
        await database.close();
      }
    },
  );

  test('version one migration preserves trips, route samples and odometer', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final schema = await verifier.schemaAt(1);
    schema.rawDatabase.execute(
      "INSERT INTO trip_records (id, started_at_ms, distance_meters) VALUES ('test', 1, 123)",
    );
    schema.rawDatabase.execute(
      "INSERT INTO trip_points (trip_id, timestamp_ms, speed, segment, over_limit) VALUES ('test', 1, 10, 0, 0)",
    );
    schema.rawDatabase.execute(
      "INSERT INTO distance_days (local_day, meters) VALUES ('2026-10-21', 123)",
    );
    final database = AppDatabase(schema.newConnection());
    try {
      await verifier.migrateAndValidate(database, 2);
      expect(
        (await database.select(database.tripRecords).getSingle())
            .distanceMeters,
        123,
      );
      expect(
        (await database.select(database.tripPoints).getSingle()).speed,
        10,
      );
      expect(
        (await database.select(database.distanceDays).getSingle()).meters,
        123,
      );
      expect(await database.select(database.fuelRecords).get(), isEmpty);
      await database
          .into(database.fuelRecords)
          .insert(
            FuelRecordsCompanion.insert(
              id: 'fuel',
              occurredAtMs: 1,
              distanceMeters: 1000,
              fuelLiters: 1,
              fuelCost: 2,
              otherCost: 0,
              currencyCode: 'AED',
            ),
          );
      expect(
        (await database.select(database.fuelRecords).getSingle()).fuelLiters,
        1,
      );
      await database.delete(database.tripRecords).go();
      expect(await database.select(database.tripPoints).get(), isEmpty);
      final foreignKeys = await database
          .customSelect('PRAGMA foreign_keys')
          .getSingle();
      expect(foreignKeys.read<int>('foreign_keys'), 1);
    } finally {
      await database.close();
    }
  });

  test(
    'unknown older schema fails safely rather than dropping stored tables',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      try {
        await expectLater(
          database.migration.onUpgrade(Migrator(database), -1, 1),
          throwsStateError,
        );
      } finally {
        await database.close();
      }
    },
  );
}
