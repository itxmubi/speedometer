import '../../../../core/error/result.dart';
import '../repositories/backup_repository.dart';
import '../entities/display_preferences.dart';

/// ExportBackup through validated local storage boundaries.
final class ExportBackupUseCase {
  const ExportBackupUseCase(this._repository);
  final BackupRepository _repository;
  Future<Result<void>> call(
    DisplayPreferences preferences, {
    required String subject,
  }) => _repository.export(preferences, subject: subject);
}
