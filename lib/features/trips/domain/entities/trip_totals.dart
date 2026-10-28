/// Lifetime calibrated distance and local-calendar period totals.
final class TripTotals {
  const TripTotals({
    this.odometerMeters = 0,
    this.todayMeters = 0,
    this.weekMeters = 0,
    this.monthMeters = 0,
  });

  final double odometerMeters;
  final double todayMeters;
  final double weekMeters;
  final double monthMeters;
}
