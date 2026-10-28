import '../../../../core/error/result.dart';
import '../repositories/location_repository.dart';

/// Opens permission settings after the user chooses to recover access.
final class OpenAppSettingsUseCase {
  /// Uses the injected platform-independent location contract.
  const OpenAppSettingsUseCase(this._repository);

  final LocationRepository _repository;

  /// Requests the app's system settings screen.
  Future<Result<void>> call() => _repository.openAppSettings();
}
