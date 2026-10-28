import 'package:drift/drift.dart';

/// Stored cumulative statistics; each checkpoint commits with its distance delta.
class TripRecords extends Table {
  TextColumn get id => text()();
  IntColumn get startedAtMs => integer()();
  IntColumn get endedAtMs => integer().nullable()();
  RealColumn get distanceMeters => real().withDefault(const Constant(0))();
  RealColumn get maxSpeed => real().withDefault(const Constant(0))();
  IntColumn get elapsedUs => integer().withDefault(const Constant(0))();
  IntColumn get movingUs => integer().withDefault(const Constant(0))();
  BoolColumn get paused => boolean().withDefault(const Constant(true))();
  IntColumn get segment => integer().withDefault(const Constant(0))();
  IntColumn get lastPointMs => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
