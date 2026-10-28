import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fuel_distance_unit.dart';
import '../../domain/entities/fuel_entry.dart';
import '../providers/fuel_providers.dart';
import '../widgets/fuel_entry_dialog.dart';
import '../widgets/fuel_entry_tile.dart';
import '../widgets/fuel_format.dart';
import '../widgets/fuel_summary_card.dart';

/// Fuel and operating costs are entered locally without GPS or network access.
class FuelScreen extends ConsumerStatefulWidget {
  const FuelScreen({this.onOpenMileageLog, super.key});

  final VoidCallback? onOpenMileageLog;

  @override
  ConsumerState<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends ConsumerState<FuelScreen> {
  var _unit = FuelDistanceUnit.kilometers;

  Future<void> _edit([FuelEntry? entry]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => FuelEntryDialog(distanceUnit: _unit, entry: entry),
    );
    if (!mounted || saved != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).fuelSaved)),
    );
  }

  Future<void> _delete(FuelEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.fuelDeleteEntry),
        content: Text(l10n.fuelDeleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.fuelDeleteEntry),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    final id = entry.id;
    if (id == null) return;
    final deleted = await ref
        .read(fuelActionControllerProvider.notifier)
        .delete(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(deleted ? l10n.fuelDeleted : l10n.failureStorage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(fuelEntriesProvider);
    final summaries = ref.watch(fuelSummariesProvider).value ?? [];
    final action = ref.watch(fuelActionControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.fuelCosts)),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.failureStorage),
              TextButton(
                onPressed: () => ref.invalidate(fuelEntriesProvider),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
        data: (items) => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: 1 + summaries.length + (items.isEmpty ? 1 : items.length),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.fuelLogDescription),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      FilledButton.icon(
                        onPressed: action.isLoading ? null : _edit,
                        icon: const Icon(Icons.add_rounded),
                        label: Text(l10n.fuelAddEntry),
                      ),
                      if (widget.onOpenMileageLog != null)
                        OutlinedButton.icon(
                          onPressed: widget.onOpenMileageLog,
                          icon: const Icon(Icons.route_rounded),
                          label: Text(l10n.fuelMileageLog),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<FuelDistanceUnit>(
                    isExpanded: true,
                    initialValue: _unit,
                    decoration: InputDecoration(
                      labelText: l10n.fuelDistanceUnit,
                    ),
                    items: [
                      for (final unit in FuelDistanceUnit.values)
                        DropdownMenuItem(
                          value: unit,
                          child: Text(FuelFormat.distanceUnit(unit, l10n)),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _unit = value);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              );
            }
            if (index <= summaries.length) {
              return FuelSummaryCard(
                summary: summaries[index - 1],
                unit: _unit,
              );
            }
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(l10n.fuelLogEmpty, textAlign: TextAlign.center),
              );
            }
            final entry = items[index - summaries.length - 1];
            return FuelEntryTile(
              entry: entry,
              unit: _unit,
              onEdit: action.isLoading ? null : () => _edit(entry),
              onDelete: action.isLoading ? null : () => _delete(entry),
            );
          },
        ),
      ),
    );
  }
}
