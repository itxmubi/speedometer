import '../../../speedometer/domain/entities/speed_unit.dart';
import 'activity_display_defaults.dart';
import 'activity_mode.dart';

/// Immutable choices for every activity, without exposing a mutable collection.
final class ActivityDisplayPreferences {
  const ActivityDisplayPreferences({
    this.car = const ActivityDisplayDefaults(),
    this.cycling = const ActivityDisplayDefaults(
      gaugeRangeMetersPerSecond: 60 / 3.6,
    ),
    this.walking = const ActivityDisplayDefaults(
      gaugeRangeMetersPerSecond: 12 / 3.6,
    ),
    this.running = const ActivityDisplayDefaults(
      gaugeRangeMetersPerSecond: 30 / 3.6,
    ),
    this.boating = const ActivityDisplayDefaults(
      unit: SpeedUnit.knots,
      gaugeRangeMetersPerSecond: 60 * 1852 / 3600,
    ),
  });

  final ActivityDisplayDefaults car;
  final ActivityDisplayDefaults cycling;
  final ActivityDisplayDefaults walking;
  final ActivityDisplayDefaults running;
  final ActivityDisplayDefaults boating;

  /// Retrieves a mode's remembered unit, style and range.
  ActivityDisplayDefaults forMode(ActivityMode mode) => switch (mode) {
    ActivityMode.car => car,
    ActivityMode.cycling => cycling,
    ActivityMode.walking => walking,
    ActivityMode.running => running,
    ActivityMode.boating => boating,
  };

  /// Replaces one mode without modifying any earlier settings snapshot.
  ActivityDisplayPreferences withMode(
    ActivityMode mode,
    ActivityDisplayDefaults value,
  ) => ActivityDisplayPreferences(
    car: mode == ActivityMode.car ? value : car,
    cycling: mode == ActivityMode.cycling ? value : cycling,
    walking: mode == ActivityMode.walking ? value : walking,
    running: mode == ActivityMode.running ? value : running,
    boating: mode == ActivityMode.boating ? value : boating,
  );

  bool get isValid =>
      ActivityMode.values.every((mode) => forMode(mode).isValid);

  @override
  bool operator ==(Object other) =>
      other is ActivityDisplayPreferences &&
      ActivityMode.values.every((mode) => forMode(mode) == other.forMode(mode));

  @override
  int get hashCode => Object.hash(car, cycling, walking, running, boating);
}
