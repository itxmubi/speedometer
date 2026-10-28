import '../entities/display_preferences.dart';
import '../entities/speed_alert_decision.dart';
import '../entities/speed_alert_state.dart';

/// Limits alert repetition and rearms only below a small hysteresis margin.
final class EvaluateSpeedAlertUseCase {
  const EvaluateSpeedAlertUseCase();
  static const cooldown = Duration(seconds: 15);
  static const hysteresisMetersPerSecond = 1.0;
  SpeedAlertDecision call({
    required DisplayPreferences preferences,
    required double speedMetersPerSecond,
    required DateTime now,
    required SpeedAlertState previous,
  }) {
    if (!preferences.limitEnabled ||
        !preferences.hasValidValues ||
        !speedMetersPerSecond.isFinite ||
        !(preferences.soundAlert ||
            preferences.vibrationAlert ||
            preferences.voiceAlert)) {
      return const SpeedAlertDecision(
        shouldAlert: false,
        state: SpeedAlertState(),
      );
    }
    final threshold =
        preferences.speedLimitMetersPerSecond +
        preferences.alertOffsetMetersPerSecond;
    if (speedMetersPerSecond <= threshold - hysteresisMetersPerSecond) {
      return SpeedAlertDecision(
        shouldAlert: false,
        state: SpeedAlertState(lastAlertAt: previous.lastAlertAt),
      );
    }
    final elapsed = previous.lastAlertAt == null
        ? cooldown
        : now.difference(previous.lastAlertAt ?? now);
    final emit = speedMetersPerSecond > threshold && elapsed >= cooldown;
    return SpeedAlertDecision(
      shouldAlert: emit,
      state: emit ? SpeedAlertState(lastAlertAt: now, armed: false) : previous,
    );
  }
}
