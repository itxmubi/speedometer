import 'package:drift/drift.dart';

import 'trip_records.dart';

/// Accepted sample history, with nullable coordinates for the route privacy toggle.
class TripPoints extends Table {
  TextColumn get tripId =>
      text().references(TripRecords, #id, onDelete: KeyAction.cascade)();
  IntColumn get timestampMs => integer()();
  RealColumn get speed => real()();
  IntColumn get segment => integer()();
  BoolColumn get overLimit => boolean()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get accuracy => real().nullable()();
  RealColumn get altitude => real().nullable()();
  RealColumn get heading => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {tripId, timestampMs};
}
