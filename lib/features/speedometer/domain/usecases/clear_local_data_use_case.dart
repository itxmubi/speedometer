import '../../../trips/domain/entities/recorded_trip.dart';
import '../../../../core/error/result.dart';
import '../../../trips/domain/repositories/trip_repository.dart';
import '../entities/display_preferences.dart';
import '../repositories/preferences_repository.dart';

/// Clears durable trips/odometer and then resets local display preferences.
final class ClearLocalDataUseCase {
  const ClearLocalDataUseCase(this._trips, this._preferences);
  final TripRepository _trips;
  final PreferencesRepository _preferences;
  Future<Result<void>> call() async {
    final active = await _trips.getActiveTrip();
    if (active case Error(:final failure)) return Error(failure);
    final trip = (active as Success<RecordedTrip?>).value;
    if (trip != null) {
      final ended = await _trips.finishTrip(
        trip.id,
        trip.startedAt.add(trip.stats.elapsed),
      );
      if (ended is Error<void>) return ended;
    }
    final result = await _trips.clearAllData();
    if (result is Error<void>) return result;
    return _preferences.save(const DisplayPreferences());
  }
}
