import '../../../../core/error/result.dart';
import '../entities/display_preferences.dart';

/// Local document backup actions, with validation before any database changes.
abstract interface class BackupRepository {
  Future<Result<void>> export(
    DisplayPreferences preferences, {
    required String subject,
  });
  Future<Result<DisplayPreferences?>> restore();
}
