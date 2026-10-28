import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/gauge_style.dart';
import '../providers/speedometer_controller.dart';

/// Switches between the three accessible, glanceable instrument views.
class GaugeModeControl extends ConsumerWidget {
  const GaugeModeControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final style = ref.watch(
      speedometerControllerProvider.select(
        (state) => state.preferences.gaugeStyle,
      ),
    );
    return Semantics(
      label: l10n.displayMode,
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          width: constraints.maxWidth,
          child: SegmentedButton<GaugeStyle>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: GaugeStyle.digital,
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                  child: Text(l10n.digital),
                ),
              ),
              ButtonSegment(value: GaugeStyle.analog, label: Text(l10n.analog)),
              ButtonSegment(value: GaugeStyle.hud, label: Text(l10n.hud)),
            ],
            selected: {style},
            onSelectionChanged: (selection) {
              ref
                  .read(speedometerControllerProvider.notifier)
                  .setGaugeStyle(selection.first);
            },
          ),
        ),
      ),
    );
  }
}
