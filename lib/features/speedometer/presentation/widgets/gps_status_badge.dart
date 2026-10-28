import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/speedometer_controller.dart';
import '../providers/speedometer_state.dart';
import 'speedometer_format.dart';

/// Text and icon convey GPS availability without relying on color alone.
class GpsStatusBadge extends ConsumerWidget {
  const GpsStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final (status, accuracy) = ref.watch(
      speedometerControllerProvider.select(
        (state) => (state.status, state.reading?.accuracyMeters),
      ),
    );
    final text = switch (status) {
      TrackingStatus.idle => l10n.gpsStandby,
      TrackingStatus.starting => l10n.gpsSearching,
      TrackingStatus.tracking =>
        accuracy == null ? l10n.gpsSearching : l10n.gpsLive,
      TrackingStatus.paused => l10n.gpsPaused,
      TrackingStatus.failure => l10n.gpsUnavailable,
    };
    final active = status == TrackingStatus.tracking && accuracy != null;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  active
                      ? Icons.gps_fixed_rounded
                      : Icons.gps_not_fixed_rounded,
                  size: AppMetrics.smallIconSize,
                  color: active
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(child: Text(text, style: theme.textTheme.labelMedium)),
              ],
            ),
          ),
        ),
        if (active)
          Text(
            l10n.accuracyValue(SpeedometerFormat.number(accuracy, l10n)),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
