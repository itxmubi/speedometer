import '../../../../core/error/result.dart';
import '../repositories/backup_repository.dart';
import '../entities/display_preferences.dart';

/// RestoreBackup through validated local storage boundaries.
final class RestoreBackupUseCase {
  const RestoreBackupUseCase(this._repository);
  final BackupRepository _repository;
  Future<Result<DisplayPreferences?>> call() => _repository.restore();
}
