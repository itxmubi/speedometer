import '../../../../core/error/result.dart';
import '../repositories/device_repository.dart';
import '../entities/display_preferences.dart';

/// ApplyDeviceSettings through the injected device boundary.
final class ApplyDeviceSettingsUseCase {
  const ApplyDeviceSettingsUseCase(this._repository);
  final DeviceRepository _repository;
  Future<Result<void>> call(
    DisplayPreferences preferences, {
    required bool awake,
  }) => _repository.applySettings(preferences, awake: awake);
}
