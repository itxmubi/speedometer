import '../../../../core/error/result.dart';
import '../entities/offline_land_polygon.dart';
import '../repositories/offline_map_repository.dart';

/// Loads coarse offline land outlines through the replaceable map boundary.
final class LoadOfflineMapUseCase {
  const LoadOfflineMapUseCase(this._repository);
  final OfflineMapRepository _repository;
  Future<Result<List<OfflineLandPolygon>>> call() => _repository.loadLand();
}
