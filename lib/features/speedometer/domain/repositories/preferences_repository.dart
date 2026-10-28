import '../../../../core/error/result.dart';
import '../entities/display_preferences.dart';

/// Persists small display settings without storing location or trip data.
abstract interface class PreferencesRepository {
  /// Loads saved preferences, or defaults when there are no saved settings.
  Future<Result<DisplayPreferences>> load();

  /// Saves the complete preferences snapshot.
  Future<Result<void>> save(DisplayPreferences preferences);
}
