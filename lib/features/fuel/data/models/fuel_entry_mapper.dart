import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/fuel_entry.dart';

/// Converts database rows only within the data boundary.
abstract final class FuelEntryMapper {
  static FuelEntry toEntity(FuelRecord row) => FuelEntry(
    id: row.id,
    occurredAt: DateTime.fromMillisecondsSinceEpoch(
      row.occurredAtMs,
      isUtc: true,
    ),
    distanceMeters: row.distanceMeters,
    fuelLiters: row.fuelLiters,
    fuelCost: row.fuelCost,
    otherCost: row.otherCost,
    currencyCode: row.currencyCode,
    note: row.note,
  );

  static FuelRecordsCompanion toCompanion(FuelEntry entry, String id) =>
      FuelRecordsCompanion.insert(
        id: id,
        occurredAtMs: entry.occurredAt.millisecondsSinceEpoch,
        distanceMeters: entry.distanceMeters,
        fuelLiters: entry.fuelLiters,
        fuelCost: entry.fuelCost,
        otherCost: entry.otherCost,
        currencyCode: entry.currencyCode,
        note: Value(entry.note),
      );
}
