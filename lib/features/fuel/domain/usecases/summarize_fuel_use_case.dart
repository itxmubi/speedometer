import '../entities/fuel_entry.dart';
import '../entities/fuel_summary.dart';

/// Uses summed fuel and distance, so short intervals never skew the average.
final class SummarizeFuelUseCase {
  const SummarizeFuelUseCase();

  List<FuelSummary> call(List<FuelEntry> entries) {
    final summaries = <String, FuelSummary>{};
    for (final entry in entries.where((entry) => entry.isValid)) {
      final previous = summaries[entry.currencyCode];
      summaries[entry.currencyCode] = FuelSummary(
        currencyCode: entry.currencyCode,
        distanceMeters: (previous?.distanceMeters ?? 0) + entry.distanceMeters,
        fuelLiters: (previous?.fuelLiters ?? 0) + entry.fuelLiters,
        fuelCost: (previous?.fuelCost ?? 0) + entry.fuelCost,
        otherCost: (previous?.otherCost ?? 0) + entry.otherCost,
      );
    }
    final currencies = summaries.keys.toList()..sort();
    return List.unmodifiable(
      currencies.map((code) => summaries[code]).nonNulls,
    );
  }
}
