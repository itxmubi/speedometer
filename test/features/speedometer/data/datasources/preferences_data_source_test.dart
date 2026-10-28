import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speedometer/features/speedometer/data/datasources/preferences_data_source.dart';
import 'package:speedometer/features/speedometer/data/models/display_preferences_model.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';

void main() {
  group('PreferencesDataSource', () {
    test(
      'missing preferences returns null without creating a document',
      () async {
        final storage = _FakeSharedPreferencesAsync();
        final source = PreferencesDataSource(storage);

        expect(await source.read(), isNull);
        expect(storage.documents, isEmpty);
      },
    );

    test(
      'writes a single versioned key and reads the saved snapshot',
      () async {
        final storage = _FakeSharedPreferencesAsync()
          ..documents['another.feature.setting'] = 'preserve';
        final source = PreferencesDataSource(storage);
        const preferences = DisplayPreferences(unit: SpeedUnit.knots);

        await source.write(DisplayPreferencesModel.fromEntity(preferences));
        final restored = await source.read();

        expect(restored?.toEntity(), preferences);
        expect(storage.documents.keys, {
          'another.feature.setting',
          PreferencesDataSource.storageKey,
        });
        expect(storage.documents['another.feature.setting'], 'preserve');
      },
    );

    test('corrupt preferences are surfaced to the repository', () async {
      final storage = _FakeSharedPreferencesAsync()
        ..documents[PreferencesDataSource.storageKey] = 'broken';
      final source = PreferencesDataSource(storage);

      await expectLater(source.read(), throwsFormatException);
    });
  });
}

class _FakeSharedPreferencesAsync implements SharedPreferencesAsync {
  final Map<String, String> documents = {};

  @override
  Future<String?> getString(String key) async => documents[key];

  @override
  Future<void> setString(String key, String value) async {
    documents[key] = value;
  }

  @override
  Object? noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
