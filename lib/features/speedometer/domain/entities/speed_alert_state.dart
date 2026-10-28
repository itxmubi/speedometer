/// Immutable cooldown and hysteresis state for optional speed alerts.
final class SpeedAlertState {
  const SpeedAlertState({this.lastAlertAt, this.armed = true});
  final DateTime? lastAlertAt;
  final bool armed;
}
