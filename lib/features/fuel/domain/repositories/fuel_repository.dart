import '../../../../core/error/result.dart';
import '../entities/fuel_entry.dart';

/// Local fuel and expense log, independent of location collection.
abstract interface class FuelRepository {
  Stream<Result<List<FuelEntry>>> watchEntries();
  Future<Result<void>> saveEntry(FuelEntry entry);
  Future<Result<void>> deleteEntry(String id);
}
