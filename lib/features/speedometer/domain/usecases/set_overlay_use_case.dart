import '../../../../core/error/result.dart';
import '../repositories/device_repository.dart';

/// SetOverlay through the injected device boundary.
final class SetOverlayUseCase {
  const SetOverlayUseCase(this._repository);
  final DeviceRepository _repository;
  Future<Result<void>> call(bool enabled) => _repository.setOverlay(enabled);
}
