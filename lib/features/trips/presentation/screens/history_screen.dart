import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/trip_providers.dart';
import '../providers/trip_history_controller.dart';
import '../../domain/entities/trip_history_query.dart';
import '../widgets/trip_format.dart';

/// Local history observes the database and never starts location collection.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final trips = ref.watch(tripHistoryProvider);
    final unit = ref.watch(tripSpeedUnitProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tripHistory)),
      body: Column(
        children: [
          const _HistoryFilters(),
          Expanded(
            child: trips.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.failureStorage),
                      TextButton(
                        onPressed: () => ref.invalidate(tripHistoryProvider),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              ),
              data: (items) => items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.route_rounded),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              ref.watch(tripHistoryQueryProvider).from !=
                                          null ||
                                      ref
                                              .watch(tripHistoryQueryProvider)
                                              .active !=
                                          null ||
                                      ref.watch(tripHistoryQueryProvider).page >
                                          0
                                  ? l10n.historyNoMatches
                                  : l10n.tripHistoryEmpty,
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.tripHistoryEmptyDescription,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: items.length.clamp(
                        0,
                        TripHistoryQuery.pageSize,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (context, index) {
                        final trip = items[index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(AppSpacing.md),
                            leading: Icon(
                              trip.isActive
                                  ? Icons.pause_circle_outline_rounded
                                  : Icons.route_rounded,
                            ),
                            title: Text(TripFormat.date(trip.startedAt, l10n)),
                            subtitle: Text(
                              [
                                TripFormat.distance(
                                  trip.stats.distanceMeters,
                                  unit,
                                  l10n,
                                ),
                                TripFormat.duration(trip.stats.elapsed, l10n),
                                if (trip.isActive) l10n.tripInProgress,
                              ].join(' · '),
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () =>
                                context.push(AppRoutes.tripDetail(trip.id)),
                          ),
                        );
                      },
                    ),
            ),
          ),
          _HistoryPages(
            hasNext:
                (trips.asData?.value.length ?? 0) > TripHistoryQuery.pageSize,
          ),
        ],
      ),
    );
  }
}

class _HistoryFilters extends ConsumerWidget {
  const _HistoryFilters();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(tripHistoryQueryProvider);
    final controller = ref.read(tripHistoryQueryProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<int>(
            key: ValueKey(query.active),
            initialValue: query.active == null
                ? 0
                : query.active == true
                ? 1
                : 2,
            isExpanded: true,
            decoration: InputDecoration(labelText: l10n.tripHistory),
            items: [
              DropdownMenuItem(value: 0, child: Text(l10n.allTrips)),
              DropdownMenuItem(value: 1, child: Text(l10n.activeTrips)),
              DropdownMenuItem(value: 2, child: Text(l10n.finishedTrips)),
            ],
            onChanged: (value) =>
                controller.status(value == 0 ? null : value == 1),
          ),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.date_range_rounded),
                label: Text(l10n.filterDates),
                onPressed: () async {
                  final now = DateTime.now();
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1970),
                    lastDate: DateTime(now.year + 1),
                    initialDateRange: query.from == null
                        ? null
                        : DateTimeRange(
                            start: query.from ?? now,
                            end: query.through ?? now,
                          ),
                  );
                  if (range != null && context.mounted) {
                    controller.dates(range.start, range.end);
                  }
                },
              ),
              if (query.from != null || query.active != null || query.page > 0)
                TextButton(
                  onPressed: controller.clear,
                  child: Text(l10n.clearFilters),
                ),
            ],
          ),
          if (query.from != null)
            Text(
              '${TripFormat.date(query.from ?? DateTime(1970), l10n)} – '
              '${TripFormat.date(query.through ?? DateTime(1970), l10n)}',
            ),
        ],
      ),
    );
  }
}

class _HistoryPages extends ConsumerWidget {
  const _HistoryPages({required this.hasNext});
  final bool hasNext;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final page = ref.watch(tripHistoryQueryProvider).page;
    final busy = ref.watch(tripHistoryProvider).isLoading;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.sm,
          children: [
            IconButton(
              tooltip: l10n.previousPage,
              onPressed: busy || page == 0
                  ? null
                  : () => ref
                        .read(tripHistoryQueryProvider.notifier)
                        .page(page - 1),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Text(
              l10n.historyPage(TripFormat.number((page + 1).toDouble(), l10n)),
            ),
            IconButton(
              tooltip: l10n.nextPage,
              onPressed: busy || !hasNext
                  ? null
                  : () => ref
                        .read(tripHistoryQueryProvider.notifier)
                        .page(page + 1),
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
