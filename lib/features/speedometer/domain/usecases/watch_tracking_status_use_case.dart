import '../repositories/device_repository.dart';

/// WatchTrackingStatus through the injected device boundary.
final class WatchTrackingStatusUseCase {
  const WatchTrackingStatusUseCase(this._repository);
  final DeviceRepository _repository;
  Stream<bool> call() => _repository.trackingStatus();
}
