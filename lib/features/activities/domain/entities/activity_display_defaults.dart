import '../../../speedometer/domain/entities/gauge_style.dart';
import '../../../speedometer/domain/entities/speed_unit.dart';

/// Saved instrument choices for one activity, always expressed in SI internally.
final class ActivityDisplayDefaults {
  const ActivityDisplayDefaults({
    this.unit = SpeedUnit.kilometersPerHour,
    this.gaugeStyle = GaugeStyle.digital,
    this.gaugeRangeMetersPerSecond = 200 / 3.6,
  });

  final SpeedUnit unit;
  final GaugeStyle gaugeStyle;
  final double gaugeRangeMetersPerSecond;

  /// Prevents invalid imported settings from reaching a gauge.
  bool get isValid =>
      gaugeRangeMetersPerSecond.isFinite &&
      gaugeRangeMetersPerSecond >= 1 &&
      gaugeRangeMetersPerSecond <= 200;

  @override
  bool operator ==(Object other) =>
      other is ActivityDisplayDefaults &&
      unit == other.unit &&
      gaugeStyle == other.gaugeStyle &&
      gaugeRangeMetersPerSecond == other.gaugeRangeMetersPerSecond;

  @override
  int get hashCode => Object.hash(unit, gaugeStyle, gaugeRangeMetersPerSecond);
}
