import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/logger.dart';
import '../../../trips/domain/repositories/trip_repository.dart';
import '../../../trips/domain/entities/recorded_trip.dart';
import '../../../trips/domain/repositories/trip_file_repository.dart';
import '../../domain/entities/display_preferences.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../models/display_preferences_model.dart';

/// Validates an entire local document before restoring trips/settings.
final class LocalBackupRepository implements BackupRepository {
  const LocalBackupRepository(
    this._trips,
    this._files,
    this._preferences, {
    Logger logger = const Logger(),
  }) : _logger = logger;
  final TripRepository _trips;
  final TripFileRepository _files;
  final PreferencesRepository _preferences;
  final Logger _logger;
  @override
  Future<Result<void>> export(
    DisplayPreferences preferences, {
    required String subject,
  }) async {
    try {
      final result = await _trips.exportBackup(
        settingsJson: DisplayPreferencesModel.fromEntity(preferences).toJson(),
      );
      return switch (result) {
        Error(:final failure) => Error(failure),
        Success(:final value) => await _files.shareDocument(
          filename: 'speedometer-backup.json',
          mimeType: 'application/json',
          contents: value,
          subject: subject,
        ),
      };
    } catch (_) {
      _logger.error('backup_export_failed');
      return const Error(Failure(FailureKind.storage));
    }
  }

  @override
  Future<Result<DisplayPreferences?>> restore() async {
    try {
      final picked = await _files.pickBackup();
      if (picked case Error(:final failure)) return Error(failure);
      final contents = (picked as Success<String?>).value;
      if (contents == null) return const Success(null);
      final inspected = await _trips.inspectBackupSettings(contents);
      if (inspected case Error(:final failure)) return Error(failure);
      final settings = (inspected as Success<String?>).value;
      final restored = settings == null
          ? null
          : DisplayPreferencesModel.fromJson(settings).toEntity();
      final oldResult = await _preferences.load();
      if (oldResult case Error(:final failure)) return Error(failure);
      final old = (oldResult as Success<DisplayPreferences>).value;
      final activeResult = await _trips.getActiveTrip();
      if (activeResult case Error(:final failure)) return Error(failure);
      final active = (activeResult as Success<RecordedTrip?>).value;
      if (active != null) {
        final ended = await _trips.finishTrip(
          active.id,
          active.startedAt.add(active.stats.elapsed),
        );
        if (ended case Error(:final failure)) return Error(failure);
      }
      if (restored != null) {
        final saved = await _preferences.save(restored);
        if (saved case Error(:final failure)) return Error(failure);
      }
      final imported = await _trips.restoreBackup(contents);
      if (imported case Error(:final failure)) {
        // Drift imports atomically. Preferences use compensation across stores.
        if (restored != null) {
          final rollback = await _preferences.save(old);
          if (rollback is Error<void>) {
            _logger.error('backup_preferences_rollback_failed');
          }
        }
        return Error(failure);
      }
      return Success(restored ?? old);
    } catch (_) {
      _logger.error('backup_restore_invalid');
      return const Error(Failure(FailureKind.storage));
    }
  }
}
