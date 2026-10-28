import '../../../../core/error/result.dart';
import '../repositories/trip_file_repository.dart';
import '../repositories/trip_repository.dart';
import '../entities/trip_export_format.dart';

/// Creates a local export only after an explicit sharing request.
final class ShareTripDocumentUseCase {
  const ShareTripDocumentUseCase(this._trips, this._files);
  final TripRepository _trips;
  final TripFileRepository _files;

  Future<Result<void>> call(
    String id,
    TripExportFormat format,
    String subject,
  ) async {
    final result = await _trips.exportTrip(id, format);
    return switch (result) {
      Success(:final value) => _files.shareDocument(
        filename: 'trip_$id.${format.name}',
        mimeType: format == TripExportFormat.gpx
            ? 'application/gpx+xml'
            : 'text/csv',
        contents: value,
        subject: subject,
      ),
      Error(:final failure) => Error(failure),
    };
  }
}
