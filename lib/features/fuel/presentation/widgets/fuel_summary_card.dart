import 'package:flutter/material.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/fuel_distance_unit.dart';
import '../../domain/entities/fuel_summary.dart';
import 'fuel_format.dart';

/// Currency groups stay visually separate because no rates are assumed.
class FuelSummaryCard extends StatelessWidget {
  const FuelSummaryCard({required this.summary, required this.unit, super.key});

  final FuelSummary summary;
  final FuelDistanceUnit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final consumption = unit == FuelDistanceUnit.kilometers
        ? summary.litersPer100Kilometers
        : summary.milesPerUsGallon;
    final consumptionUnit = unit == FuelDistanceUnit.kilometers
        ? l10n.fuelLitersPer100Kilometers
        : l10n.fuelMilesPerUsGallon;
    final cost = unit == FuelDistanceUnit.kilometers
        ? summary.costPerKilometer
        : summary.costPerMile;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              summary.currencyCode,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.fuelTotalCost,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              FuelFormat.money(summary.totalCost, summary.currencyCode, l10n),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.fuelConsumption,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              consumption == null
                  ? l10n.fuelNoConsumption
                  : l10n.measurementValue(
                      FuelFormat.number(consumption, l10n),
                      consumptionUnit,
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.fuelLoggedDistance,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              l10n.measurementValue(
                FuelFormat.number(
                  unit.fromMeters(summary.distanceMeters),
                  l10n,
                ),
                FuelFormat.distanceUnit(unit, l10n),
              ),
            ),
            if (cost != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.fuelCostPerDistance,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                l10n.fuelAmountPerDistance(
                  FuelFormat.money(cost, summary.currencyCode, l10n),
                  FuelFormat.distanceUnit(unit, l10n),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
