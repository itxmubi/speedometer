import '../../../../core/error/result.dart';
import '../repositories/device_repository.dart';

/// InspectTrackingState through the injected device boundary.
final class InspectTrackingStateUseCase {
  const InspectTrackingStateUseCase(this._repository);
  final DeviceRepository _repository;
  Future<Result<bool>> call() => _repository.isTracking();
}
