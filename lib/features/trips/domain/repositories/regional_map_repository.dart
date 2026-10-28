import '../../../../core/error/result.dart';
import '../entities/regional_map.dart';

/// Explicit local document selection; cancellation returns a successful null.
abstract interface class RegionalMapRepository {
  Future<Result<RegionalMap?>> pick();
}
