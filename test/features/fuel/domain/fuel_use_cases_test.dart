import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/fuel/domain/entities/fuel_distance_unit.dart';
import 'package:speedometer/features/fuel/domain/entities/fuel_entry.dart';
import 'package:speedometer/features/fuel/domain/entities/fuel_volume_unit.dart';
import 'package:speedometer/features/fuel/domain/repositories/fuel_repository.dart';
import 'package:speedometer/features/fuel/domain/usecases/delete_fuel_entry_use_case.dart';
import 'package:speedometer/features/fuel/domain/usecases/save_fuel_entry_use_case.dart';
import 'package:speedometer/features/fuel/domain/usecases/summarize_fuel_use_case.dart';
import 'package:speedometer/features/fuel/domain/usecases/watch_fuel_entries_use_case.dart';

void main() {
  test(
    'weighted consumption uses total distance instead of averaging rates',
    () {
      final summaries = const SummarizeFuelUseCase()([
        entry(distance: 100000, liters: 10, fuelCost: 20),
        entry(distance: 300000, liters: 15, fuelCost: 30, otherCost: 10),
      ]);
      final summary = summaries.single;
      expect(summary.distanceMeters, 400000);
      expect(summary.fuelLiters, 25);
      expect(summary.litersPer100Kilometers, 6.25);
      expect(summary.totalCost, 60);
      expect(summary.costPerKilometer, 0.15);
      expect(summary.costPerMile, closeTo(0.2414016, 1e-9));
      expect(summary.milesPerUsGallon, closeTo(37.6343, 0.001));
    },
  );

  test('keeps currencies separate and includes maintenance without fuel', () {
    final summaries = const SummarizeFuelUseCase()([
      entry(currency: 'USD'),
      entry(
        distance: 0,
        liters: 0,
        fuelCost: 0,
        otherCost: 100,
        currency: 'AED',
      ),
    ]);
    expect(summaries.map((summary) => summary.currencyCode), ['AED', 'USD']);
    expect(summaries.first.totalCost, 100);
    expect(summaries.first.litersPer100Kilometers, isNull);
    expect(summaries.first.milesPerUsGallon, isNull);
    expect(summaries.first.costPerKilometer, isNull);
    expect(summaries.first.costPerMile, isNull);
  });

  test('US gallon and mile conversion roundtrips known measures', () {
    expect(FuelVolumeUnit.usGallons.toLiters(1), 3.785411784);
    expect(FuelVolumeUnit.usGallons.fromLiters(3.785411784), 1);
    expect(FuelDistanceUnit.miles.toMeters(1), 1609.344);
    expect(FuelDistanceUnit.miles.fromMeters(1609.344), 1);
  });

  final invalid = <String, FuelEntry>{
    'missing paired distance': entry(distance: 0),
    'missing paired fuel': entry(liters: 0),
    'negative distance': entry(distance: -1),
    'negative fuel': entry(liters: -1),
    'negative fuel cost': entry(fuelCost: -1),
    'negative maintenance cost': entry(otherCost: -1),
    'nonfinite distance': entry(distance: double.infinity),
    'nonfinite fuel': entry(liters: double.nan),
    'nonfinite cost': entry(fuelCost: double.infinity),
    'unbounded volume': entry(liters: 1e10),
    'invalid currency': entry(currency: 'US'),
    'lowercase currency': entry(currency: 'usd'),
    'invalid id': entry(id: ''),
    'long note': entry(note: List.filled(501, 'x').join()),
    'pre-epoch date': entry(date: DateTime.utc(1969)),
    'empty maintenance': entry(distance: 0, liters: 0, fuelCost: 0),
  };
  for (final item in invalid.entries) {
    test('rejects ${item.key} before calling repository', () async {
      final repository = _Repository();
      expect(
        await SaveFuelEntryUseCase(repository)(item.value),
        isA<Error<void>>(),
      );
      expect(repository.saved, isEmpty);
      expect(const SummarizeFuelUseCase()([item.value]), isEmpty);
    });
  }

  test(
    'saves, observes and deletes through domain repository contracts',
    () async {
      final repository = _Repository();
      final valid = entry(id: 'id');
      expect(
        await SaveFuelEntryUseCase(repository)(valid),
        isA<Success<void>>(),
      );
      expect(repository.saved, [valid]);
      final observed = await WatchFuelEntriesUseCase(repository)().first;
      expect((observed as Success<List<FuelEntry>>).value, [valid]);
      expect(
        await DeleteFuelEntryUseCase(repository)('id'),
        isA<Success<void>>(),
      );
      expect(repository.saved, isEmpty);
    },
  );
}

FuelEntry entry({
  String? id,
  double distance = 100000,
  double liters = 10,
  double fuelCost = 20,
  double otherCost = 0,
  String currency = 'USD',
  String note = '',
  DateTime? date,
}) => FuelEntry(
  id: id,
  occurredAt: date ?? DateTime.utc(2026, 10, 22),
  distanceMeters: distance,
  fuelLiters: liters,
  fuelCost: fuelCost,
  otherCost: otherCost,
  currencyCode: currency,
  note: note,
);

final class _Repository implements FuelRepository {
  final saved = <FuelEntry>[];

  @override
  Future<Result<void>> saveEntry(FuelEntry entry) async {
    saved.add(entry);
    return const Success(null);
  }

  @override
  Future<Result<void>> deleteEntry(String id) async {
    saved.removeWhere((entry) => entry.id == id);
    return const Success(null);
  }

  @override
  Stream<Result<List<FuelEntry>>> watchEntries() =>
      Stream.value(Success(saved));
}
