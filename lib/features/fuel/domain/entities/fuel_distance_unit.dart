/// Explicit units for the distance associated with a fuel interval.
enum FuelDistanceUnit {
  kilometers(1000),
  miles(1609.344);

  const FuelDistanceUnit(this.metersPerUnit);
  final double metersPerUnit;

  double toMeters(double value) => value * metersPerUnit;
  double fromMeters(double value) => value / metersPerUnit;
}
