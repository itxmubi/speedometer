import '../../../../core/error/result.dart';
import '../repositories/trip_repository.dart';

/// Coordinates one local trip action through its domain contract.
final class StartTripUseCase {
  const StartTripUseCase(this._repository);
  final TripRepository _repository;

  Future<Result<String>> call(DateTime startedAt) =>
      _repository.startTrip(startedAt);
}
