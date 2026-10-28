import '../entities/trip_history_query.dart';
import '../../../../core/error/result.dart';
import '../../../speedometer/domain/entities/speed_reading.dart';
import '../../../speedometer/domain/entities/trip_stats.dart';
import '../entities/recorded_trip.dart';
import '../entities/trip_export_format.dart';
import '../entities/trip_totals.dart';

/// Local trip persistence. Deleting history never reduces the lifetime odometer.
abstract interface class TripRepository {
  Future<Result<String>> startTrip(DateTime startedAt);
  Future<Result<void>> checkpointTrip({
    required String id,
    required TripStats stats,
    required SpeedReading? reading,
    required bool recordRoute,
    required bool overLimit,
    required bool paused,
  });
  Future<Result<void>> finishTrip(String id, DateTime endedAt);
  Stream<Result<List<RecordedTrip>>> watchTrips({TripHistoryQuery? query});
  Stream<Result<TripTotals>> watchTotals();
  Future<Result<RecordedTrip?>> getTrip(String id);
  Future<Result<RecordedTrip?>> getActiveTrip();
  Future<Result<void>> deleteTrip(String id);

  /// Discards an active or finished record atomically, retaining distance totals.
  Future<Result<void>> discardTrip(String id);
  Future<Result<String>> exportTrip(String id, TripExportFormat format);
  Future<Result<String>> exportBackup({String? settingsJson});
  Future<Result<String?>> restoreBackup(String contents);
  Future<Result<String?>> inspectBackupSettings(String contents);
  Future<Result<void>> deleteAllTrips();
  Future<Result<void>> clearAllData();
}
