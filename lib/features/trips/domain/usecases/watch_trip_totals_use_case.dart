import '../../../../core/error/result.dart';
import '../entities/trip_totals.dart';
import '../repositories/trip_repository.dart';

/// Observes the local source of truth.
final class WatchTripTotalsUseCase {
  const WatchTripTotalsUseCase(this._repository);
  final TripRepository _repository;

  Stream<Result<TripTotals>> call() => _repository.watchTotals();
}
