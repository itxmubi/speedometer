/// Display units; speeds and distances remain in SI units in domain state.
enum SpeedUnit {
  kilometersPerHour,
  milesPerHour,
  metersPerSecond,
  knots;

  static const double _metersPerKilometer = 1000;
  static const double _metersPerMile = 1609.344;
  static const double _metersPerNauticalMile = 1852;
  static const double _secondsPerHour = 3600;

  /// Converts an internal speed to this display unit.
  double fromMetersPerSecond(double value) => switch (this) {
    kilometersPerHour => value * _secondsPerHour / _metersPerKilometer,
    milesPerHour => value * _secondsPerHour / _metersPerMile,
    metersPerSecond => value,
    knots => value * _secondsPerHour / _metersPerNauticalMile,
  };

  /// Converts distance to kilometers, miles, meters, or nautical miles.
  double distanceFromMeters(double value) => switch (this) {
    kilometersPerHour => value / _metersPerKilometer,
    milesPerHour => value / _metersPerMile,
    metersPerSecond => value,
    knots => value / _metersPerNauticalMile,
  };

  /// Whether the display unit belongs to the imperial road-distance system.
  bool get usesMiles => this == milesPerHour;
}
