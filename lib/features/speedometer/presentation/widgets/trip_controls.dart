import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/speedometer_controller.dart';
import '../providers/speedometer_state.dart';
import 'failure_notice.dart';

/// Explicit controls for starting, pausing, resuming, and clearing a trip.
class TripControls extends ConsumerWidget {
  const TripControls({this.compact = false, super.key});
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final (status, hasTrip, saveTrips, busy) = ref.watch(
      speedometerControllerProvider.select(
        (state) => (
          state.status,
          state.activeTripId != null ||
              state.trip.elapsed > Duration.zero ||
              state.trip.lastReading != null ||
              state.trip.maxSpeedMetersPerSecond > 0 ||
              state.trip.distanceMeters > 0,
          state.preferences.autoRecordTrips,
          state.isBusy,
        ),
      ),
    );
    final starting = status == TrackingStatus.starting;
    final tracking = status == TrackingStatus.tracking;
    final label = switch (status) {
      TrackingStatus.starting => l10n.startingTrip,
      TrackingStatus.tracking => l10n.pauseTrip,
      TrackingStatus.paused => l10n.resumeTrip,
      TrackingStatus.idle || TrackingStatus.failure => l10n.startTrip,
    };
    if (compact) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FailureNotice(),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.icon(
                onPressed: starting || busy
                    ? null
                    : () {
                        final controller = ref.read(
                          speedometerControllerProvider.notifier,
                        );
                        if (tracking) {
                          controller.pause();
                        } else {
                          controller.start();
                        }
                      },
                icon: Icon(
                  tracking ? Icons.pause_rounded : Icons.play_arrow_rounded,
                ),
                label: Text(label),
              ),
              if (hasTrip)
                OutlinedButton.icon(
                  onPressed: starting || busy
                      ? null
                      : () => ref
                            .read(speedometerControllerProvider.notifier)
                            .finish(),
                  icon: const Icon(Icons.stop_rounded),
                  label: Text(
                    saveTrips ? l10n.finishTrip : l10n.notificationStop,
                  ),
                ),
            ],
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const FailureNotice(),
        FilledButton.icon(
          onPressed: starting || busy
              ? null
              : () {
                  final controller = ref.read(
                    speedometerControllerProvider.notifier,
                  );
                  if (tracking) {
                    controller.pause();
                  } else {
                    controller.start();
                  }
                },
          icon: starting
              ? const SizedBox.square(
                  dimension: AppSpacing.lg,
                  child: CircularProgressIndicator(
                    strokeWidth: AppMetrics.gaugeTickStroke,
                  ),
                )
              : Icon(tracking ? Icons.pause_rounded : Icons.play_arrow_rounded),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(label),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (hasTrip && !starting) ...[
          OutlinedButton.icon(
            onPressed: busy
                ? null
                : () =>
                      ref.read(speedometerControllerProvider.notifier).finish(),
            icon: const Icon(Icons.stop_rounded),
            label: Text(saveTrips ? l10n.finishTrip : l10n.notificationStop),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextButton.icon(
          onPressed: !hasTrip || starting || busy
              ? null
              : () => _confirmReset(context, ref),
          icon: const Icon(Icons.restart_alt_rounded),
          label: Text(l10n.resetTrip),
        ),
      ],
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetTitle),
        content: Text(l10n.resetMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(speedometerControllerProvider.notifier).reset();
  }
}
