import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../speedometer/domain/entities/speed_unit.dart';
import '../../domain/entities/recorded_trip.dart';
import '../../domain/entities/track_point.dart';
import '../../domain/entities/trip_export_format.dart';
import '../providers/trip_providers.dart';
import '../widgets/trip_format.dart';
import '../widgets/trip_replay.dart';
import '../widgets/trip_speed_chart.dart';

/// Statistics, optional route replay, graph and explicit portable sharing.
class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({required this.tripId, super.key});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final trip = ref.watch(tripDetailProvider(tripId));
    final unit = ref.watch(tripSpeedUnitProvider);
    ref.listen(tripActionControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.failureStorage)));
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tripDetail)),
      body: trip.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.failureStorage),
              TextButton(
                onPressed: () => ref.invalidate(tripDetailProvider(tripId)),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (value) => value == null
            ? Center(child: Text(l10n.tripNotFound))
            : _TripContent(trip: value, unit: unit),
      ),
    );
  }
}

class _TripContent extends ConsumerWidget {
  const _TripContent({required this.trip, required this.unit});
  final RecordedTrip trip;
  final SpeedUnit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final busy = ref.watch(tripActionControllerProvider).isLoading;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppMetrics.contentMaxWidth),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text(
              TripFormat.date(trip.startedAt, l10n),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(trip.isActive ? l10n.tripInProgress : l10n.tripFinished),
            const SizedBox(height: AppSpacing.md),
            _TripStatistics(trip: trip, unit: unit),
            const SizedBox(height: AppSpacing.lg),
            _TripSection(
              title: l10n.tripRoute,
              description: l10n.tripRouteDescription,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.tripReplayDescription),
                  const SizedBox(height: AppSpacing.sm),
                  TripReplay(trip: trip, unit: unit),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(child: Text(l10n.tripOverLimitLegend)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _TripSection(
              title: l10n.tripSpeedGraph,
              description: l10n.tripSpeedGraphDescription,
              child: trip.points.isEmpty
                  ? Text(l10n.tripNoSamples)
                  : TripSpeedChart(points: trip.points, unit: unit),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.tripExportDisclosure),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                OutlinedButton.icon(
                  onPressed: busy
                      ? null
                      : () => ref
                            .read(tripActionControllerProvider.notifier)
                            .shareDocument(
                              trip.id,
                              TripExportFormat.gpx,
                              l10n.tripDetail,
                            ),
                  icon: const Icon(Icons.route_rounded),
                  label: Text(l10n.tripExportGpx),
                ),
                OutlinedButton.icon(
                  onPressed: busy
                      ? null
                      : () => ref
                            .read(tripActionControllerProvider.notifier)
                            .shareDocument(
                              trip.id,
                              TripExportFormat.csv,
                              l10n.tripDetail,
                            ),
                  icon: const Icon(Icons.table_chart_outlined),
                  label: Text(l10n.tripExportCsv),
                ),
                OutlinedButton.icon(
                  onPressed: busy
                      ? null
                      : () => ref
                            .read(tripActionControllerProvider.notifier)
                            .shareSummary(
                              l10n.tripSummaryText(
                                TripFormat.date(trip.startedAt, l10n),
                                TripFormat.distance(
                                  trip.stats.distanceMeters,
                                  unit,
                                  l10n,
                                ),
                                TripFormat.duration(trip.stats.elapsed, l10n),
                                TripFormat.speed(
                                  trip.stats.averageSpeedMetersPerSecond,
                                  unit,
                                  l10n,
                                ),
                                TripFormat.speed(
                                  trip.stats.maxSpeedMetersPerSecond,
                                  unit,
                                  l10n,
                                ),
                              ),
                            ),
                  icon: const Icon(Icons.share_outlined),
                  label: Text(l10n.tripShareSummary),
                ),
                TextButton.icon(
                  onPressed: busy || trip.isActive
                      ? null
                      : () => _delete(context, ref, l10n),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(l10n.deleteTrip),
                ),
              ],
            ),
            if (busy) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTripTitle),
        content: Text(l10n.deleteTripMessage),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            child: Text(l10n.deleteAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final deleted = await ref
        .read(tripActionControllerProvider.notifier)
        .deleteTrip(trip.id);
    if (deleted && context.mounted) context.pop();
  }
}

class _TripSection extends StatelessWidget {
  const _TripSection({
    required this.title,
    required this.description,
    required this.child,
  });
  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(description),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    ),
  );
}

class _TripStatistics extends StatelessWidget {
  const _TripStatistics({required this.trip, required this.unit});
  final RecordedTrip trip;
  final SpeedUnit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _Statistic(
              label: l10n.tripDistance,
              value: TripFormat.distance(trip.stats.distanceMeters, unit, l10n),
            ),
            _Statistic(
              label: l10n.tripDuration,
              value: TripFormat.duration(trip.stats.elapsed, l10n),
            ),
            _Statistic(
              label: l10n.movingTime,
              value: TripFormat.duration(trip.stats.movingTime, l10n),
            ),
            _Statistic(
              label: l10n.averageSpeed,
              value: TripFormat.speed(
                trip.stats.averageSpeedMetersPerSecond,
                unit,
                l10n,
              ),
            ),
            _Statistic(
              label: l10n.movingAverage,
              value: TripFormat.speed(
                trip.stats.movingAverageSpeedMetersPerSecond,
                unit,
                l10n,
              ),
            ),
            _Statistic(
              label: l10n.topSpeed,
              value: TripFormat.speed(
                trip.stats.maxSpeedMetersPerSecond,
                unit,
                l10n,
              ),
            ),
            _Statistic(
              label: l10n.tripStartPoint,
              value: _coordinate(trip.startPoint, l10n),
            ),
            _Statistic(
              label: l10n.tripEndPoint,
              value: _coordinate(trip.endPoint, l10n),
            ),
          ],
        ),
      ),
    );
  }

  String _coordinate(TrackPoint? point, AppLocalizations l10n) {
    if (point == null) return l10n.unavailableValue;
    return '${TripFormat.number(point.latitude ?? 0, l10n, decimals: 6)}, ${TripFormat.number(point.longitude ?? 0, l10n, decimals: 6)}';
  }
}

class _Statistic extends StatelessWidget {
  const _Statistic({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xxs,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    ),
  );
}
