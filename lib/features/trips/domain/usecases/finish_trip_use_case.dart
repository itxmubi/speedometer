import '../../../../core/error/result.dart';
import '../repositories/trip_repository.dart';

/// Coordinates one local trip action through its domain contract.
final class FinishTripUseCase {
  const FinishTripUseCase(this._repository);
  final TripRepository _repository;

  Future<Result<void>> call(String id, DateTime endedAt) =>
      _repository.finishTrip(id, endedAt);
}
