import '../entities/trip_history_query.dart';
import '../../../../core/error/result.dart';
import '../entities/recorded_trip.dart';
import '../repositories/trip_repository.dart';

/// Observes the local source of truth.
final class WatchTripsUseCase {
  const WatchTripsUseCase(this._repository);
  final TripRepository _repository;

  Stream<Result<List<RecordedTrip>>> call({TripHistoryQuery? query}) =>
      _repository.watchTrips(query: query);
}
