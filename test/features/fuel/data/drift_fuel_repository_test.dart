import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/database/app_database.dart';
import 'package:speedometer/core/error/failure.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/fuel/data/repositories/drift_fuel_repository.dart';
import 'package:speedometer/features/fuel/domain/entities/fuel_entry.dart';

void main() {
  late AppDatabase database;
  late DriftFuelRepository repository;
  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DriftFuelRepository(database);
  });
  tearDown(() => database.close());

  test(
    'persists explicit units, cost, note and UTC date with generated ID',
    () async {
      expect(await repository.saveEntry(entry()), isA<Success<void>>());
      final result = await repository.watchEntries().first;
      final saved = (result as Success<List<FuelEntry>>).value.single;
      expect(saved.id, isNotEmpty);
      expect(saved.occurredAt, DateTime.utc(2026, 10, 22));
      expect(saved.distanceMeters, 100000);
      expect(saved.fuelLiters, 5);
      expect(saved.fuelCost, 15);
      expect(saved.otherCost, 7);
      expect(saved.currencyCode, 'AED');
      expect(saved.note, 'Tyres');
    },
  );

  test('updates same ID and deletion leaves other entries intact', () async {
    await repository.saveEntry(entry(id: 'first'));
    await repository.saveEntry(entry(id: 'second'));
    await repository.saveEntry(entry(id: 'first', cost: 30));
    var rows =
        (await repository.watchEntries().first as Success<List<FuelEntry>>)
            .value;
    expect(rows, hasLength(2));
    expect(rows.singleWhere((entry) => entry.id == 'first').fuelCost, 30);
    expect(await repository.deleteEntry('first'), isA<Success<void>>());
    rows = (await repository.watchEntries().first as Success<List<FuelEntry>>)
        .value;
    expect(rows.single.id, 'second');
  });

  test('invalid entries never write partial data', () async {
    expect(
      await repository.saveEntry(entry(cost: double.nan)),
      isA<Error<void>>(),
    );
    expect(
      (await repository.watchEntries().first as Success<List<FuelEntry>>).value,
      isEmpty,
    );
  });

  test('database errors translate to a privacy-safe storage failure', () async {
    await database.customStatement('DROP TABLE fuel_records');
    final result = await repository.saveEntry(entry());
    expect((result as Error<void>).failure, const Failure(FailureKind.storage));
    final watched = await repository.watchEntries().first;
    expect(
      (watched as Error<List<FuelEntry>>).failure,
      const Failure(FailureKind.storage),
    );
  });
}

FuelEntry entry({String? id, double cost = 15}) => FuelEntry(
  id: id,
  occurredAt: DateTime.utc(2026, 10, 22),
  distanceMeters: 100000,
  fuelLiters: 5,
  fuelCost: cost,
  otherCost: 7,
  currencyCode: 'AED',
  note: 'Tyres',
);
