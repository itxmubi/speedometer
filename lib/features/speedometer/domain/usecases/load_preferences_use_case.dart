import '../../../../core/error/result.dart';
import '../entities/display_preferences.dart';
import '../repositories/preferences_repository.dart';

/// Loads the user's saved display and disclosure choices.
final class LoadPreferencesUseCase {
  /// Receives the settings repository through dependency injection.
  const LoadPreferencesUseCase(this._repository);

  final PreferencesRepository _repository;

  /// Returns persisted settings or a typed storage failure.
  Future<Result<DisplayPreferences>> call() => _repository.load();
}
