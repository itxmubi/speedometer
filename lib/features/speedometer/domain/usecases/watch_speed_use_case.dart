import '../../../../core/error/result.dart';
import '../entities/speed_reading.dart';
import '../repositories/location_repository.dart';

/// Observes validated, device-reported speed while foreground tracking runs.
final class WatchSpeedUseCase {
  /// Uses the injected platform-independent location contract.
  const WatchSpeedUseCase(this._repository);

  final LocationRepository _repository;

  /// Starts a new cancellable location stream.
  Stream<Result<SpeedReading>> call() => _repository.watch();
}
