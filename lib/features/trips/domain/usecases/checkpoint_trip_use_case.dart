import '../../../../core/error/result.dart';
import '../../../speedometer/domain/entities/speed_reading.dart';
import '../../../speedometer/domain/entities/trip_stats.dart';
import '../repositories/trip_repository.dart';

/// Commits accepted statistics and an optional privacy-filtered speed sample.
final class CheckpointTripUseCase {
  const CheckpointTripUseCase(this._repository);
  final TripRepository _repository;

  Future<Result<void>> call({
    required String id,
    required TripStats stats,
    required SpeedReading? reading,
    required bool recordRoute,
    required bool overLimit,
    required bool paused,
  }) => _repository.checkpointTrip(
    id: id,
    stats: stats,
    reading: reading,
    recordRoute: recordRoute,
    overLimit: overLimit,
    paused: paused,
  );
}
