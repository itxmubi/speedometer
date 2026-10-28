import '../../../../core/error/result.dart';
import '../repositories/fuel_repository.dart';

/// Removes only the selected expense without changing the trip odometer.
final class DeleteFuelEntryUseCase {
  const DeleteFuelEntryUseCase(this._repository);
  final FuelRepository _repository;

  Future<Result<void>> call(String id) => _repository.deleteEntry(id);
}
