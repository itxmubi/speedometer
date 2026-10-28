import '../../../../core/error/result.dart';
import '../repositories/device_repository.dart';

/// CheckOverlayPermission through the injected device boundary.
final class CheckOverlayPermissionUseCase {
  const CheckOverlayPermissionUseCase(this._repository);
  final DeviceRepository _repository;
  Future<Result<bool>> call() => _repository.canOverlay();
}
