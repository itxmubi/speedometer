import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/speedometer_controller.dart';
import '../providers/speedometer_providers.dart';
import 'activity_mode_label.dart';
import 'speedometer_format.dart';
import 'trip_stat_card.dart';

/// Current trip figures, persistent distance totals and sensor details.
class TripStatsPanel extends ConsumerWidget {
  const TripStatsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final (trip, unit, totals, compass, saveTrips) = ref.watch(
      speedometerControllerProvider.select(
        (state) => (
          state.trip,
          state.preferences.unit,
          state.totals,
          state.compassHeadingDegrees,
          state.preferences.autoRecordTrips,
        ),
      ),
    );
    final speedUnit = SpeedometerFormat.unit(unit, l10n);
    final distanceUnit = SpeedometerFormat.distanceUnit(unit, l10n);
    final mode = ref.watch(
      speedometerControllerProvider.select(
        (state) => state.preferences.activityMode,
      ),
    );
    final calories = ref.watch(activityCaloriesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.thisTrip, style: theme.textTheme.titleLarge),
        Text(ActivityModeLabel.text(mode, l10n)),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          saveTrips ? l10n.sessionOnly : l10n.sessionRecordingOff,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _StatRow(
          first: TripStatCard(
            label: l10n.tripDistance,
            value: SpeedometerFormat.number(
              unit.distanceFromMeters(trip.distanceMeters),
              l10n,
              decimals: 2,
            ),
            unit: distanceUnit,
            icon: Icons.route_rounded,
          ),
          second: TripStatCard(
            label: l10n.tripDuration,
            value: SpeedometerFormat.duration(trip.elapsed, l10n),
            unit: '',
            icon: Icons.timer_outlined,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _StatRow(
          first: TripStatCard(
            label: l10n.averageSpeed,
            value: SpeedometerFormat.speed(
              trip.averageSpeedMetersPerSecond,
              unit,
              l10n,
            ),
            unit: speedUnit,
            icon: Icons.equalizer_rounded,
          ),
          second: TripStatCard(
            label: l10n.topSpeed,
            value: SpeedometerFormat.speed(
              trip.maxSpeedMetersPerSecond,
              unit,
              l10n,
            ),
            unit: speedUnit,
            icon: Icons.north_east_rounded,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (calories != null) ...[
          TripStatCard(
            label: l10n.estimatedCalories,
            value: SpeedometerFormat.number(calories, l10n),
            unit: l10n.kilocalories,
            icon: Icons.local_fire_department_outlined,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.calorieEstimateDescription,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _DetailRow(
                  label: l10n.movingAverage,
                  value: l10n.measurementValue(
                    SpeedometerFormat.speed(
                      trip.movingAverageSpeedMetersPerSecond,
                      unit,
                      l10n,
                    ),
                    speedUnit,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _DetailRow(
                  label: l10n.movingTime,
                  value: SpeedometerFormat.duration(trip.movingTime, l10n),
                ),
                const Divider(),
                _DetailRow(
                  label: l10n.altitude,
                  value: switch (trip.lastReading?.altitudeMeters) {
                    final altitude? => l10n.measurementValue(
                      SpeedometerFormat.number(altitude, l10n),
                      l10n.meters,
                    ),
                    null => l10n.unavailableValue,
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                _DetailRow(
                  label: l10n.courseOverGround,
                  value: switch (trip.lastReading?.headingDegrees) {
                    final heading? => l10n.headingValue(
                      SpeedometerFormat.number(heading, l10n),
                    ),
                    null => l10n.unavailableValue,
                  },
                ),
                const Divider(),
                _DetailRow(
                  label: l10n.compass,
                  value: compass == null
                      ? l10n.compassUnavailable
                      : l10n.headingValue(
                          SpeedometerFormat.number(compass, l10n),
                        ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TripStatCard(
          label: l10n.odometer,
          value: SpeedometerFormat.number(
            unit.distanceFromMeters(totals.odometerMeters),
            l10n,
            decimals: 2,
          ),
          unit: distanceUnit,
          icon: Icons.all_inclusive_rounded,
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _DetailRow(
                  label: l10n.todayDistance,
                  value: l10n.measurementValue(
                    SpeedometerFormat.number(
                      unit.distanceFromMeters(totals.todayMeters),
                      l10n,
                      decimals: 2,
                    ),
                    distanceUnit,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _DetailRow(
                  label: l10n.weekDistance,
                  value: l10n.measurementValue(
                    SpeedometerFormat.number(
                      unit.distanceFromMeters(totals.weekMeters),
                      l10n,
                      decimals: 2,
                    ),
                    distanceUnit,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _DetailRow(
                  label: l10n.monthDistance,
                  value: l10n.measurementValue(
                    SpeedometerFormat.number(
                      unit.distanceFromMeters(totals.monthMeters),
                      l10n,
                      decimals: 2,
                    ),
                    distanceUnit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.first, required this.second});

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    // Text scaling can turn two compact instrument cards into a vertical pair.
    final stackCards =
        MediaQuery.textScalerOf(context).scale(1) >
        AppMetrics.largeTextThreshold;
    if (stackCards) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          first,
          const SizedBox(height: AppSpacing.sm),
          second,
        ],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: first),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: second),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: AppSpacing.xxs,
      spacing: AppSpacing.md,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(value, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
