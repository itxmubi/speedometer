import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/gauge_style.dart';
import '../providers/speedometer_controller.dart';
import '../providers/speedometer_providers.dart';
import '../providers/speedometer_state.dart';
import 'analog_gauge.dart';
import 'gauge_mode_control.dart';
import 'gps_status_badge.dart';
import 'speedometer_format.dart';
import 'unit_selector.dart';

/// The main instrument, with narrow subscriptions for live GPS updates.
class GaugePanel extends StatelessWidget {
  const GaugePanel({this.focused = false, super.key});
  final bool focused;

  @override
  Widget build(BuildContext context) {
    if (focused) return const _LiveGauge(focused: true);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            GaugeModeControl(),
            SizedBox(height: AppSpacing.lg),
            GpsStatusBadge(),
            SizedBox(height: AppSpacing.lg),
            _LiveGauge(),
          ],
        ),
      ),
    );
  }
}

class _LiveGauge extends ConsumerWidget {
  const _LiveGauge({this.focused = false});
  final bool focused;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (reading, preferences, status) = ref.watch(
      speedometerControllerProvider.select(
        (state) => (state.reading, state.preferences, state.status),
      ),
    );
    final l10n = AppLocalizations.of(context);
    final scheme =
        preferences.gaugeStyle == GaugeStyle.hud && preferences.nightHud
        ? AppTheme.forPreferences(
            dark: true,
            accentIndex: preferences.accentColorIndex,
            nightHud: true,
          ).colorScheme
        : Theme.of(context).colorScheme;
    final unit = SpeedometerFormat.unit(preferences.unit, l10n);
    final speed = preferences.unit.fromMetersPerSecond(
      reading?.speedMetersPerSecond ?? 0,
    );
    final speedText = reading == null
        ? l10n.unavailableValue
        : SpeedometerFormat.number(speed, l10n);
    final limit = preferences.unit.fromMetersPerSecond(
      preferences.speedLimitMetersPerSecond,
    );
    final overLimit = ref.watch(isOverLimitProvider);
    final range = preferences.unit.fromMetersPerSecond(
      preferences.gaugeRangeMetersPerSecond,
    );
    final color = overLimit ? scheme.error : scheme.primary;
    final semanticLabel = l10n.speedSemantics(speedText, unit);
    final readout = _NumericReadout(
      value: speedText,
      semanticLabel: semanticLabel,
      color: color,
      style: preferences.gaugeStyle,
    );
    final Widget instrument;
    if (preferences.gaugeStyle == GaugeStyle.analog) {
      instrument = AnalogGauge(
        speed: speed,
        limit: preferences.limitEnabled ? limit : null,
        range: range,
        labels: [
          for (
            var index = 0;
            index <= AppMetrics.dialTickCount;
            index += AppMetrics.dialMajorInterval
          )
            SpeedometerFormat.number(
              range * index / AppMetrics.dialTickCount,
              l10n,
            ),
        ],
        semanticLabel: semanticLabel,
        overLimit: overLimit,
        child: readout,
      );
    } else {
      instrument = ColoredBox(
        color: preferences.gaugeStyle == GaugeStyle.hud && preferences.nightHud
            ? scheme.surface
            : Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: focused ? 0 : AppMetrics.gaugeHeight,
            ),
            child: Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(
                  preferences.gaugeStyle == GaugeStyle.hud &&
                          preferences.mirroredHud
                      ? -1
                      : 1,
                  1,
                  1,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    readout,
                    if (preferences.gaugeStyle == GaugeStyle.hud) ...[
                      Text(
                        unit,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: scheme.primary),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _HudDetails(color: scheme.primary),
                    ] else if (focused)
                      Text(
                        unit,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: scheme.primary),
                      )
                    else
                      const UnitSelector(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!focused)
          Text(
            l10n.currentSpeed,
            textAlign: TextAlign.center,
            style: AppTypography.eyebrow.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        instrument,
        if (focused && preferences.gaugeStyle == GaugeStyle.analog)
          Text(
            unit,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: scheme.primary),
          ),
        if (!focused && preferences.gaugeStyle == GaugeStyle.analog)
          const Center(child: UnitSelector()),
        if (!focused && preferences.gaugeStyle == GaugeStyle.hud)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.mirrorHud),
            value: preferences.mirroredHud,
            onChanged: (value) {
              ref
                  .read(speedometerControllerProvider.notifier)
                  .setMirrored(value);
            },
          ),
        if (preferences.limitEnabled) ...[
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            liveRegion: overLimit,
            label: overLimit ? l10n.overLimitSemantics : null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: overLimit
                    ? scheme.errorContainer
                    : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadii.small),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.xs,
                  children: [
                    Icon(
                      overLimit
                          ? Icons.warning_amber_rounded
                          : Icons.speed_rounded,
                      size: AppMetrics.smallIconSize,
                      color: overLimit
                          ? scheme.onErrorContainer
                          : scheme.onSurfaceVariant,
                    ),
                    Text(
                      overLimit
                          ? l10n.overLimit
                          : l10n.limitValue(
                              SpeedometerFormat.number(limit, l10n),
                              unit,
                            ),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: overLimit
                            ? scheme.onErrorContainer
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        if (!focused)
          Text(
            switch (status) {
              TrackingStatus.idle => l10n.startHint,
              TrackingStatus.starting => l10n.searchingHint,
              TrackingStatus.tracking =>
                reading == null ? l10n.searchingHint : l10n.trackingHint,
              TrackingStatus.paused => l10n.pausedHint,
              TrackingStatus.failure => l10n.startHint,
            },
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
      ],
    );
  }
}

class _NumericReadout extends StatelessWidget {
  const _NumericReadout({
    required this.value,
    required this.semanticLabel,
    required this.color,
    required this.style,
  });

  final String value;
  final String semanticLabel;
  final Color color;
  final GaugeStyle style;

  @override
  Widget build(BuildContext context) {
    final typography = switch (style) {
      GaugeStyle.digital => AppTypography.speed,
      GaugeStyle.analog => AppTypography.analogSpeed,
      GaugeStyle.hud => AppTypography.hudSpeed,
    };
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(value, style: typography.copyWith(color: color)),
      ),
    );
  }
}

class _HudDetails extends ConsumerWidget {
  const _HudDetails({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final (p, compass, distance) = ref.watch(
      speedometerControllerProvider.select(
        (s) => (s.preferences, s.compassHeadingDegrees, s.trip.distanceMeters),
      ),
    );
    final time = p.hudShowTime
        ? ref.watch(dashboardTimeProvider).asData?.value
        : null;
    final values = <Widget>[
      if (p.hudShowTime)
        _HudValue(
          icon: Icons.schedule_rounded,
          label: l10n.timeLabel,
          value: time == null
              ? l10n.unavailableValue
              : DateFormat.Hm(l10n.localeName).format(time),
          color: color,
        ),
      if (p.hudShowCompass)
        _HudValue(
          icon: Icons.explore_outlined,
          label: l10n.compass,
          value: compass == null
              ? l10n.unavailableValue
              : l10n.headingValue(SpeedometerFormat.number(compass, l10n)),
          color: color,
        ),
      if (p.hudShowTrip)
        _HudValue(
          icon: Icons.route_rounded,
          label: l10n.tripDistance,
          value: l10n.measurementValue(
            SpeedometerFormat.number(
              p.unit.distanceFromMeters(distance),
              l10n,
              decimals: 2,
            ),
            SpeedometerFormat.distanceUnit(p.unit, l10n),
          ),
          color: color,
        ),
    ];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: values,
    );
  }
}

class _HudValue extends StatelessWidget {
  const _HudValue({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: $value',
    excludeSemantics: true,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppMetrics.smallIconSize, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: color),
        ),
      ],
    ),
  );
}
