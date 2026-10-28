import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../entities/fuel_entry.dart';
import '../repositories/fuel_repository.dart';

/// Rejects invalid input before any persistence operation.
final class SaveFuelEntryUseCase {
  const SaveFuelEntryUseCase(this._repository);
  final FuelRepository _repository;

  Future<Result<void>> call(FuelEntry entry) async {
    if (!entry.isValid) {
      return const Error(Failure(FailureKind.unexpected));
    }
    return _repository.saveEntry(entry);
  }
}
