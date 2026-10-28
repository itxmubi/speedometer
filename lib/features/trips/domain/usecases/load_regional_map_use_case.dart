import '../../../../core/error/result.dart';
import '../entities/regional_map.dart';
import '../repositories/regional_map_repository.dart';

/// Imports regional detail only after an explicit user action.
final class LoadRegionalMapUseCase {
  const LoadRegionalMapUseCase(this._repository);
  final RegionalMapRepository _repository;
  Future<Result<RegionalMap?>> call() => _repository.pick();
}
