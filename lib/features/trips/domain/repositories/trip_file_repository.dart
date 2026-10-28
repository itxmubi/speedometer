import '../../../../core/error/result.dart';

/// Platform document boundary; sharing is always an explicit user action.
abstract interface class TripFileRepository {
  Future<Result<String?>> pickBackup();
  Future<Result<void>> shareDocument({
    required String filename,
    required String mimeType,
    required String contents,
    required String subject,
  });
  Future<Result<void>> shareText(String text);
}
