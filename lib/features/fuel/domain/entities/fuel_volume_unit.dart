/// US gallons are labelled explicitly, avoiding imperial-gallon ambiguity.
enum FuelVolumeUnit {
  liters(1),
  usGallons(3.785411784);

  const FuelVolumeUnit(this.litersPerUnit);
  final double litersPerUnit;

  double toLiters(double value) => value * litersPerUnit;
  double fromLiters(double value) => value / litersPerUnit;
}
