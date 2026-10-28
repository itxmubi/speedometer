import '../../../../core/error/result.dart';
import '../repositories/device_repository.dart';
import '../entities/display_preferences.dart';

/// IssueSpeedAlert through the injected device boundary.
final class IssueSpeedAlertUseCase {
  const IssueSpeedAlertUseCase(this._repository);
  final DeviceRepository _repository;
  Future<Result<void>> call(
    DisplayPreferences preferences, {
    required String message,
    required String languageTag,
  }) => _repository.alert(
    preferences,
    message: message,
    languageTag: languageTag,
  );
}
