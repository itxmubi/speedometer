import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../fuel/domain/entities/fuel_entry.dart';

/// Backup owns its mapping without depending on another feature's data layer.
abstract final class BackupFuelMapper {
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

  static FuelRecordsCompanion toCompanion(FuelEntry entry) =>
      FuelRecordsCompanion.insert(
        id: entry.id ?? '',
        occurredAtMs: entry.occurredAt.millisecondsSinceEpoch,
        distanceMeters: entry.distanceMeters,
        fuelLiters: entry.fuelLiters,
        fuelCost: entry.fuelCost,
        otherCost: entry.otherCost,
        currencyCode: entry.currencyCode,
        note: Value(entry.note),
      );
}
