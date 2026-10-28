import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/display_preferences.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../datasources/preferences_data_source.dart';
import '../models/display_preferences_model.dart';

/// Persists small preferences and translates platform or decoding failures.
final class LocalPreferencesRepository implements PreferencesRepository {
  /// Receives a wrapped preferences store and a privacy-safe logger.
  const LocalPreferencesRepository(
    this._dataSource, {
    Logger logger = const Logger(),
  }) : _logger = logger;

  final PreferencesDataSource _dataSource;
  final Logger _logger;

  @override
  Future<Result<DisplayPreferences>> load() async {
    try {
      final model = await _dataSource.read();
      return Success(model?.toEntity() ?? const DisplayPreferences());
    } catch (_) {
      // Plugin errors and corrupt documents can contain private payloads.
      _logger.error('preferences_load_failed');
      return const Error(Failure(FailureKind.storage));
    }
  }

  @override
  Future<Result<void>> save(DisplayPreferences preferences) async {
    try {
      await _dataSource.write(DisplayPreferencesModel.fromEntity(preferences));
      return const Success(null);
    } catch (_) {
      _logger.error('preferences_save_failed');
      return const Error(Failure(FailureKind.storage));
    }
  }
}
