import 'package:flutter/material.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fuel_distance_unit.dart';
import '../../domain/entities/fuel_entry.dart';
import 'fuel_format.dart';

/// Exposes edit and delete with labelled actions and scalable text.
class FuelEntryTile extends StatelessWidget {
  const FuelEntryTile({
    required this.entry,
    required this.unit,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final FuelEntry entry;
  final FuelDistanceUnit unit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              FuelFormat.date(entry.occurredAt, l10n),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(FuelFormat.money(entry.totalCost, entry.currencyCode, l10n)),
            if (entry.distanceMeters > 0)
              Text(
                [
                  l10n.measurementValue(
                    FuelFormat.number(
                      unit.fromMeters(entry.distanceMeters),
                      l10n,
                    ),
                    FuelFormat.distanceUnit(unit, l10n),
                  ),
                  l10n.measurementValue(
                    FuelFormat.number(entry.fuelLiters, l10n),
                    l10n.fuelLiters,
                  ),
                ].join(' · '),
              ),
            if (entry.note.isNotEmpty) Text(entry.note),
            Wrap(
              spacing: AppSpacing.xs,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.fuelEditEntry),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: Text(l10n.fuelDeleteEntry),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
