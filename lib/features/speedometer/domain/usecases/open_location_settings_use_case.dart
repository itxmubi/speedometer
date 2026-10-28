import '../../../../core/error/result.dart';
import '../repositories/location_repository.dart';

/// Opens device settings after the user chooses to enable location services.
final class OpenLocationSettingsUseCase {
  /// Uses the injected platform-independent location contract.
  const OpenLocationSettingsUseCase(this._repository);

  final LocationRepository _repository;

  /// Requests the device's location settings screen.
  Future<Result<void>> call() => _repository.openLocationSettings();
}
