/// An explicit fuel interval or a maintenance-only expense, in base units.
final class FuelEntry {
  const FuelEntry({
    this.id,
    required this.occurredAt,
    required this.distanceMeters,
    required this.fuelLiters,
    required this.fuelCost,
    required this.otherCost,
    required this.currencyCode,
    this.note = '',
  });

  final String? id;
  final DateTime occurredAt;
  final double distanceMeters;
  final double fuelLiters;
  final double fuelCost;
  final double otherCost;
  final String currencyCode;
  final String note;

  double get totalCost => fuelCost + otherCost;

  /// Fuel and distance describe the same interval; maintenance needs neither.
  bool get isValid {
    final hasInterval = distanceMeters > 0 && fuelLiters > 0;
    final maintenanceOnly =
        distanceMeters == 0 &&
        fuelLiters == 0 &&
        fuelCost == 0 &&
        otherCost > 0;
    return (id == null ||
            RegExp(r'^[a-zA-Z0-9_-]{1,100}$').hasMatch(id ?? '')) &&
        occurredAt.millisecondsSinceEpoch >= 0 &&
        occurredAt.millisecondsSinceEpoch <= 253402300799999 &&
        distanceMeters.isFinite &&
        distanceMeters <= 1e12 &&
        fuelLiters.isFinite &&
        fuelLiters <= 1e9 &&
        fuelCost.isFinite &&
        fuelCost >= 0 &&
        fuelCost <= 1e12 &&
        otherCost.isFinite &&
        otherCost >= 0 &&
        otherCost <= 1e12 &&
        RegExp(r'^[A-Z]{3}$').hasMatch(currencyCode) &&
        note.length <= 500 &&
        (hasInterval || maintenanceOnly);
  }
}
