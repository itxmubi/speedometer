import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/speed_unit.dart';
import '../providers/speedometer_controller.dart';
import 'speedometer_format.dart';

/// A compact unit menu shared by the dashboard and preferences screen.
class UnitSelector extends ConsumerWidget {
  const UnitSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final unit = ref.watch(
      speedometerControllerProvider.select((state) => state.preferences.unit),
    );
    return PopupMenuButton<SpeedUnit>(
      tooltip: l10n.speedUnit,
      initialValue: unit,
      onSelected: (unit) {
        ref.read(speedometerControllerProvider.notifier).setUnit(unit);
      },
      itemBuilder: (context) => [
        for (final unit in SpeedUnit.values)
          PopupMenuItem(
            value: unit,
            child: Text(SpeedometerFormat.unitName(unit, l10n)),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              SpeedometerFormat.unit(unit, l10n),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: AppSpacing.xxs),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }
}
