import '../../../../core/error/result.dart';
import '../repositories/device_repository.dart';
import '../entities/tracking_display.dart';

/// UpdateTrackingDisplay through the injected device boundary.
final class UpdateTrackingDisplayUseCase {
  const UpdateTrackingDisplayUseCase(this._repository);
  final DeviceRepository _repository;
  Future<Result<void>> call(TrackingDisplay display) =>
      _repository.update(display);
}
