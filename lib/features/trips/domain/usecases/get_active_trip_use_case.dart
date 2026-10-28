import '../../../../core/error/result.dart';
import '../repositories/trip_repository.dart';
import '../entities/recorded_trip.dart';

/// Coordinates one local trip action through its domain contract.
final class GetActiveTripUseCase {
  const GetActiveTripUseCase(this._repository);
  final TripRepository _repository;

  Future<Result<RecordedTrip?>> call() => _repository.getActiveTrip();
}
