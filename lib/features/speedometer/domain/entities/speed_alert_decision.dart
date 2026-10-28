import 'speed_alert_state.dart';

/// One deterministic alert decision and its replacement state.
final class SpeedAlertDecision {
  const SpeedAlertDecision({required this.shouldAlert, required this.state});
  final bool shouldAlert;
  final SpeedAlertState state;
}
