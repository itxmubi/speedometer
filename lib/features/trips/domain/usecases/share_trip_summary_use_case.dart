import '../../../../core/error/result.dart';
import '../repositories/trip_file_repository.dart';

/// Shares localized summary text prepared by the presentation formatter.
final class ShareTripSummaryUseCase {
  const ShareTripSummaryUseCase(this._files);
  final TripFileRepository _files;

  Future<Result<void>> call(String text) => _files.shareText(text);
}
