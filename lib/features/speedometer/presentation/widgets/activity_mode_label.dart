import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../activities/domain/entities/activity_mode.dart';

/// Localized names shared by the activity settings and current trip display.
abstract final class ActivityModeLabel {
  static String text(ActivityMode mode, AppLocalizations l10n) =>
      switch (mode) {
        ActivityMode.car => l10n.activityCar,
        ActivityMode.cycling => l10n.activityCycling,
        ActivityMode.walking => l10n.activityWalking,
        ActivityMode.running => l10n.activityRunning,
        ActivityMode.boating => l10n.activityBoating,
      };
}
