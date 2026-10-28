import '../../../../core/error/result.dart';
import '../repositories/location_repository.dart';

/// Prepares foreground location after the user accepts its explanation.
final class PrepareLocationUseCase {
  /// Uses the injected platform-independent location contract.
  const PrepareLocationUseCase(this._repository);

  final LocationRepository _repository;

  /// Resolves permission and device-service availability.
  Future<Result<void>> call() => _repository.prepare();
}
