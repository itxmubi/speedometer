import '../../../../core/error/result.dart';
import '../entities/offline_land_polygon.dart';

/// Optional bundled geographic context; no internet service or device location.
abstract interface class OfflineMapRepository {
  Future<Result<List<OfflineLandPolygon>>> loadLand();
}
