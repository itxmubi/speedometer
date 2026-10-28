import '../../../../core/error/result.dart';
import '../repositories/device_repository.dart';

/// WatchCompass through the injected device boundary.
final class WatchCompassUseCase {
  const WatchCompassUseCase(this._repository);
  final DeviceRepository _repository;
  Stream<Result<double>> call() => _repository.compass();
}
