import '../../../../core/error/result.dart';
import '../entities/display_preferences.dart';
import '../repositories/preferences_repository.dart';

/// Saves an immutable snapshot of the user's settings.
final class SavePreferencesUseCase {
  /// Receives the settings repository through dependency injection.
  const SavePreferencesUseCase(this._repository);

  final PreferencesRepository _repository;

  /// Persists [preferences] or returns a typed storage failure.
  Future<Result<void>> call(DisplayPreferences preferences) =>
      _repository.save(preferences);
}
