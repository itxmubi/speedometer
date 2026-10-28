import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/core/utils/logger.dart';
import 'package:speedometer/features/speedometer/data/datasources/preferences_data_source.dart';
import 'package:speedometer/features/speedometer/data/models/display_preferences_model.dart';
import 'package:speedometer/features/speedometer/data/repositories/local_preferences_repository.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';

void main() {
  group('LocalPreferencesRepository', () {
    late _FakePreferencesDataSource source;
    late _RecordingLogger logger;
    late LocalPreferencesRepository repository;

    setUp(() {
      source = _FakePreferencesDataSource();
      logger = _RecordingLogger();
      repository = LocalPreferencesRepository(source, logger: logger);
    });

    test('returns defaults when the device has no saved preferences', () async {
      final result = await repository.load();

      expect(result, isA<Success<DisplayPreferences>>());
      if (result case Success(:final value)) {
        expect(value, const DisplayPreferences());
      }
      expect(logger.events, isEmpty);
    });

    test('loads the entity and persists a replacement snapshot', () async {
      const preferences = DisplayPreferences(unit: SpeedUnit.milesPerHour);

      expect(await repository.save(preferences), isA<Success<void>>());
      final result = await repository.load();

      if (result case Success(:final value)) {
        expect(value, preferences);
      } else {
        fail('Expected saved preferences');
      }
      expect(logger.events, isEmpty);
    });

    test(
      'translates read failures without logging private error text',
      () async {
        source.readError = const FormatException('private invalid document');

        final result = await repository.load();

        expect(result, isA<Error<DisplayPreferences>>());
        if (result case Error(:final failure)) {
          expect(failure.kind, FailureKind.storage);
        }
        expect(logger.events, ['preferences_load_failed']);
      },
    );

    test('translates write failures without leaking plugin errors', () async {
      source.writeError = StateError('private plugin failure');

      final result = await repository.save(const DisplayPreferences());

      expect(result, isA<Error<void>>());
      if (result case Error(:final failure)) {
        expect(failure.kind, FailureKind.storage);
      }
      expect(logger.events, ['preferences_save_failed']);
    });

    test('rejects invalid manual limits before writing storage', () async {
      final result = await repository.save(
        const DisplayPreferences(speedLimitMetersPerSecond: -1),
      );

      expect(result, isA<Error<void>>());
      expect(source.saved, isNull);
      expect(logger.events, ['preferences_save_failed']);
    });
  });
}

class _FakePreferencesDataSource implements PreferencesDataSource {
  DisplayPreferencesModel? saved;
  Object? readError;
  Object? writeError;

  @override
  Future<DisplayPreferencesModel?> read() async {
    final error = readError;
    if (error != null) throw error;
    return saved;
  }

  @override
  Future<void> write(DisplayPreferencesModel preferences) async {
    final error = writeError;
    if (error != null) throw error;
    saved = preferences;
  }
}

class _RecordingLogger implements Logger {
  final List<String> events = [];

  @override
  void error(String event) => events.add(event);
}
