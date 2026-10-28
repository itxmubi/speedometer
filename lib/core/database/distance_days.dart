import 'package:drift/drift.dart';

/// Daily calibrated deltas outlive deleted trips, preserving the odometer.
class DistanceDays extends Table {
  TextColumn get localDay => text()();
  RealColumn get meters => real()();

  @override
  Set<Column<Object>> get primaryKey => {localDay};
}
