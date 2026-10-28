import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/repositories/preferences_repository.dart';

/// In-memory settings boundary; never invokes preferences plugins in tests.
class FakePreferencesRepository implements PreferencesRepository {
  FakePreferencesRepository({this.preferences = const DisplayPreferences()});

  DisplayPreferences preferences;

  @override
  Future<Result<DisplayPreferences>> load() async => Success(preferences);

  @override
  Future<Result<void>> save(DisplayPreferences value) async {
    preferences = value;
    return const Success(null);
  }
}
