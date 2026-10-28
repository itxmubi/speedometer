import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/error/failure.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/repositories/preferences_repository.dart';
import 'package:speedometer/features/speedometer/domain/usecases/load_preferences_use_case.dart';
import 'package:speedometer/features/speedometer/domain/usecases/save_preferences_use_case.dart';

void main() {
  test(
    'load delegates to the repository and preserves typed failures',
    () async {
      final repository = _FakePreferencesRepository();
      final load = LoadPreferencesUseCase(repository);

      expect(await load(), same(repository.loadResult));
      expect(repository.loadCalls, 1);

      repository.loadResult = const Error(Failure(FailureKind.storage));
      expect(await load(), same(repository.loadResult));
    },
  );

  test(
    'save passes the settings snapshot and preserves typed results',
    () async {
      final repository = _FakePreferencesRepository();
      final save = SavePreferencesUseCase(repository);
      const preferences = DisplayPreferences(simpleView: true);

      expect(await save(preferences), same(repository.saveResult));
      expect(repository.saved, same(preferences));

      repository.saveResult = const Error(Failure(FailureKind.storage));
      expect(await save(preferences), same(repository.saveResult));
    },
  );
}

class _FakePreferencesRepository implements PreferencesRepository {
  Result<DisplayPreferences> loadResult = const Success(DisplayPreferences());
  Result<void> saveResult = const Success(null);
  int loadCalls = 0;
  DisplayPreferences? saved;

  @override
  Future<Result<DisplayPreferences>> load() async {
    loadCalls += 1;
    return loadResult;
  }

  @override
  Future<Result<void>> save(DisplayPreferences preferences) async {
    saved = preferences;
    return saveResult;
  }
}
