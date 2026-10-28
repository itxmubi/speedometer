import '../../../speedometer/domain/entities/display_preferences.dart';
import '../entities/activity_display_defaults.dart';
import '../entities/activity_mode.dart';

/// Remembers outgoing instrument choices and restores the selected activity.
final class SelectActivityUseCase {
  const SelectActivityUseCase();

  DisplayPreferences call({
    required DisplayPreferences preferences,
    required ActivityMode mode,
    required bool hasActiveTrip,
  }) {
    // A paused/recovered session still belongs to its original activity.
    if (hasActiveTrip || mode == preferences.activityMode) return preferences;
    final saved = preferences.activityDisplays.withMode(
      preferences.activityMode,
      ActivityDisplayDefaults(
        unit: preferences.unit,
        gaugeStyle: preferences.gaugeStyle,
        gaugeRangeMetersPerSecond: preferences.gaugeRangeMetersPerSecond,
      ),
    );
    final selected = saved.forMode(mode);
    return preferences.copyWith(
      activityMode: mode,
      activityDisplays: saved,
      unit: selected.unit,
      gaugeStyle: selected.gaugeStyle,
      gaugeRangeMetersPerSecond: selected.gaugeRangeMetersPerSecond,
    );
  }
}
