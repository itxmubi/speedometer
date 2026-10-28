import '../../../../core/error/result.dart';
import '../repositories/trip_repository.dart';

/// Removes a session record without changing lifetime/calendar distance totals.
final class DiscardTripUseCase {
  const DiscardTripUseCase(this._repository);
  final TripRepository _repository;
  Future<Result<void>> call(String id) => _repository.discardTrip(id);
}
