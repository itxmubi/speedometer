import '../../../../core/error/result.dart';
import '../repositories/device_repository.dart';

/// RequestOverlayPermission through the injected device boundary.
final class RequestOverlayPermissionUseCase {
  const RequestOverlayPermissionUseCase(this._repository);
  final DeviceRepository _repository;
  Future<Result<void>> call() => _repository.requestOverlay();
}
