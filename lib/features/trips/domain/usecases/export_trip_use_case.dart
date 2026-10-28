import '../../../../core/error/result.dart';
import '../repositories/trip_repository.dart';
import '../entities/trip_export_format.dart';

/// Coordinates one local trip action through its domain contract.
final class ExportTripUseCase {
  const ExportTripUseCase(this._repository);
  final TripRepository _repository;

  Future<Result<String>> call(String id, TripExportFormat format) =>
      _repository.exportTrip(id, format);
}
