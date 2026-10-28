/// Aggregates one currency without assuming an exchange rate.
final class FuelSummary {
  const FuelSummary({
    required this.currencyCode,
    required this.distanceMeters,
    required this.fuelLiters,
    required this.fuelCost,
    required this.otherCost,
  });

  final String currencyCode;
  final double distanceMeters;
  final double fuelLiters;
  final double fuelCost;
  final double otherCost;

  double get totalCost => fuelCost + otherCost;
  double? get litersPer100Kilometers =>
      distanceMeters > 0 ? fuelLiters / distanceMeters * 100000 : null;
  double? get milesPerUsGallon => fuelLiters > 0
      ? distanceMeters / 1609.344 / (fuelLiters / 3.785411784)
      : null;
  double? get costPerKilometer =>
      distanceMeters > 0 ? totalCost / distanceMeters * 1000 : null;
  double? get costPerMile =>
      distanceMeters > 0 ? totalCost / distanceMeters * 1609.344 : null;
}
