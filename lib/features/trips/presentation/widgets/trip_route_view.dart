import '../providers/regional_map_controller.dart';
import '../../domain/entities/regional_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/offline_land_polygon.dart';
import '../providers/trip_providers.dart';
import 'route_geometry.dart';
import 'route_node.dart';
import 'trip_format.dart';

/// Pan/zoom offline route diagram with recorded pause and privacy gaps preserved.
class TripRouteView extends ConsumerStatefulWidget {
  const TripRouteView({
    required this.geometry,
    this.tripId = '',
    required this.selectedIndex,
    super.key,
  });
  final String tripId;
  final RouteGeometry geometry;
  final int selectedIndex;

  @override
  ConsumerState<TripRouteView> createState() => _TripRouteViewState();
}

class _TripRouteViewState extends ConsumerState<TripRouteView> {
  List<OfflineLandPolygon> _polygons = const [];
  List<Path> _land = const [];
  RegionalMap? _regional;
  List<Path> _roads = const [];

  @override
  void initState() {
    super.initState();
    ref.listenManual(offlineLandProvider, (previous, next) {
      if (next case AsyncData(:final value)) {
        final paths = widget.geometry.projectLand(value);
        setState(() {
          _polygons = value;
          _land = paths;
        });
      }
    }, fireImmediately: true);
  }

  @override
  void didUpdateWidget(TripRouteView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.geometry != widget.geometry) {
      _land = widget.geometry.projectLand(_polygons);
      _roads = widget.geometry.projectLines(_regional?.lines ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final map = ref.watch(offlineLandProvider);
    final regional = ref.watch(regionalMapControllerProvider(widget.tripId));
    final data = regional.asData?.value;
    if (!identical(data, _regional)) {
      _regional = data;
      _roads = widget.geometry.projectLines(data?.lines ?? []);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: l10n.tripRouteSemantics,
          image: true,
          child: SizedBox(
            height: AppMetrics.gaugeHeight,
            child: ClipRect(
              child: InteractiveViewer(
                minScale: 0.001,
                maxScale: 12,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                clipBehavior: Clip.none,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _RoutePainter(
                      widget.geometry,
                      widget.selectedIndex,
                      colors,
                      Theme.of(context).textTheme.labelSmall,
                      l10n,
                      Directionality.of(context),
                      _land,
                      _roads,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.tripBasemapAttribution,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (data != null)
          Text(
            l10n.regionalMapSource(data.attribution),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (regional.hasError) Text(l10n.regionalMapFailure),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.file_open_outlined),
              label: Text(l10n.loadRegionalMap),
              onPressed: regional.isLoading
                  ? null
                  : () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l10n.loadRegionalMap),
                          content: Text(l10n.regionalMapDisclosure),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(l10n.cancel),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(l10n.continueAction),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true && context.mounted) {
                        await ref
                            .read(
                              regionalMapControllerProvider(
                                widget.tripId,
                              ).notifier,
                            )
                            .load();
                      }
                    },
            ),
            if (data != null)
              TextButton(
                onPressed: () => ref
                    .read(regionalMapControllerProvider(widget.tripId).notifier)
                    .clear(),
                child: Text(l10n.removeRegionalMap),
              ),
          ],
        ),
        if (map.hasError)
          TextButton(
            onPressed: () => ref.invalidate(offlineLandProvider),
            child: Text(l10n.retry),
          ),
      ],
    );
  }
}

class _RoutePainter extends CustomPainter {
  const _RoutePainter(
    this.geometry,
    this.selectedIndex,
    this.colors,
    this.labelStyle,
    this.l10n,
    this.direction,
    this.land,
    this.roads,
  );
  final RouteGeometry geometry;
  final int selectedIndex;
  final ColorScheme colors;
  final TextStyle? labelStyle;
  final AppLocalizations l10n;
  final TextDirection direction;
  final List<Path> land;
  final List<Path> roads;
  static const _gridDivisions = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide - AppSpacing.xl * 2;
    final origin = Offset((size.width - side) / 2, (size.height - side) / 2);
    canvas.drawColor(colors.surfaceContainerLowest, BlendMode.srcOver);
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.scale(side);
    final fill = Paint()..color = colors.surfaceContainerHigh;
    final border = Paint()
      ..color = colors.outlineVariant
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppMetrics.gaugeTickStroke / side;
    for (final path in land) {
      canvas.drawPath(path, fill);
      canvas.drawPath(path, border);
    }
    final road = Paint()
      ..color = colors.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppMetrics.gaugeTickStroke / side;
    for (final path in roads) {
      canvas.drawPath(path, road);
    }
    canvas.restore();
    _grid(canvas, origin, side);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppMetrics.gaugeNeedleStroke
      ..strokeCap = StrokeCap.round;
    RouteNode? previous;
    Offset? first;
    Offset? last;
    Offset? selected;
    for (final node in geometry.nodes) {
      final normalized = node.position;
      if (normalized == null) {
        previous = null;
        if (node.originalIndex <= selectedIndex) {
          selected = null;
        }
        continue;
      }
      final position = origin + normalized * side;
      first ??= position;
      last = position;
      if (node.originalIndex <= selectedIndex) {
        selected = position;
      }
      final prior = previous;
      if (prior != null && prior.segment == node.segment && !node.breakBefore) {
        final start = origin + (prior.position ?? normalized) * side;
        line.color = node.overLimit
            ? colors.error
            : node.originalIndex <= selectedIndex
            ? colors.primary
            : colors.outlineVariant;
        if (node.overLimit) {
          _dashedLine(canvas, start, position, line);
        } else {
          canvas.drawLine(start, position, line);
        }
      }
      if (node.overLimit) {
        canvas.drawCircle(
          position,
          AppSpacing.xxs,
          Paint()..color = colors.error,
        );
      }
      previous = node;
    }
    if (first != null) {
      canvas.drawCircle(first, AppSpacing.xs, Paint()..color = colors.tertiary);
    }
    if (last != null) {
      canvas.drawRect(
        Rect.fromCenter(
          center: last,
          width: AppSpacing.sm,
          height: AppSpacing.sm,
        ),
        Paint()..color = colors.secondary,
      );
    }
    if (selected != null) {
      canvas.drawCircle(
        selected,
        AppSpacing.sm,
        Paint()..color = colors.surface,
      );
      canvas.drawCircle(
        selected,
        AppSpacing.xs,
        Paint()..color = colors.primary,
      );
    }
  }

  void _grid(Canvas canvas, Offset origin, double side) {
    final paint = Paint()
      ..color = colors.outlineVariant
      ..strokeWidth = AppMetrics.gaugeTickStroke;
    for (var index = 0; index <= _gridDivisions; index++) {
      final fraction = index / _gridDivisions;
      final x = origin.dx + side * fraction;
      final y = origin.dy + side * fraction;
      canvas.drawLine(Offset(x, origin.dy), Offset(x, origin.dy + side), paint);
      canvas.drawLine(Offset(origin.dx, y), Offset(origin.dx + side, y), paint);
      _label(
        canvas,
        '${TripFormat.number(geometry.longitudeAt(fraction), l10n, decimals: 4)}°',
        Offset(x, origin.dy + side + AppSpacing.xxs),
      );
      _label(
        canvas,
        '${TripFormat.number(geometry.latitudeAt(fraction), l10n, decimals: 4)}°',
        Offset(AppSpacing.xxs, y),
      );
    }
  }

  void _label(Canvas canvas, String text, Offset position) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: labelStyle?.copyWith(color: colors.onSurfaceVariant),
      ),
      textDirection: direction,
    )..layout();
    painter.paint(canvas, position);
  }

  void _dashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final vector = end - start;
    final distance = vector.distance;
    if (distance == 0) return;
    final direction = vector / distance;
    for (var offset = 0.0; offset < distance; offset += AppSpacing.md) {
      final next = (offset + AppSpacing.xs).clamp(0.0, distance);
      canvas.drawLine(
        start + direction * offset,
        start + direction * next,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_RoutePainter oldDelegate) =>
      oldDelegate.geometry != geometry ||
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.colors != colors ||
      oldDelegate.land != land ||
      oldDelegate.roads != roads ||
      oldDelegate.l10n.localeName != l10n.localeName ||
      oldDelegate.direction != direction;
}
