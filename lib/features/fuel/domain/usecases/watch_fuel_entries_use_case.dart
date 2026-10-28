import '../../../../core/error/result.dart';
import '../entities/fuel_entry.dart';
import '../repositories/fuel_repository.dart';

/// Observes the local log without requesting any platform permissions.
final class WatchFuelEntriesUseCase {
  const WatchFuelEntriesUseCase(this._repository);
  final FuelRepository _repository;

  Stream<Result<List<FuelEntry>>> call() => _repository.watchEntries();
}
