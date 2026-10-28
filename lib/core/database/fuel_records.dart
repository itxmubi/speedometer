import 'package:drift/drift.dart';

/// Fuel intervals and maintenance costs remain entirely on the device.
class FuelRecords extends Table {
  TextColumn get id => text()();
  IntColumn get occurredAtMs => integer()();
  RealColumn get distanceMeters => real()();
  RealColumn get fuelLiters => real()();
  RealColumn get fuelCost => real()();
  RealColumn get otherCost => real()();
  TextColumn get currencyCode => text()();
  TextColumn get note => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
