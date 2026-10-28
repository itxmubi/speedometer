import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../speedometer/domain/entities/speed_unit.dart';
import '../../domain/entities/track_point.dart';
import 'trip_format.dart';

/// Speed versus sample time, without bridging pauses or unreliable GPS gaps.
class TripSpeedChart extends StatelessWidget {
  const TripSpeedChart({required this.points, required this.unit, super.key});
  final List<TrackPoint> points;
  final SpeedUnit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final maxSpeed = points.fold(
      0.0,
      (value, point) => max(value, point.speedMetersPerSecond),
    );
    final span = points.isEmpty
        ? Duration.zero
        : points.last.timestamp.difference(points.first.timestamp);
    return Semantics(
      label: l10n.tripChartSemantics,
      image: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(TripFormat.speed(maxSpeed, unit, l10n)),
          SizedBox(
            height: AppMetrics.gaugeHeight,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _SpeedPainter(
                  points,
                  maxSpeed,
                  Theme.of(context).colorScheme,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(TripFormat.duration(Duration.zero, l10n)),
              Text(TripFormat.duration(span, l10n)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpeedPainter extends CustomPainter {
  const _SpeedPainter(this.points, this.maxSpeed, this.colors);
  final List<TrackPoint> points;
  final double maxSpeed;
  final ColorScheme colors;
  static const _maximumGap = Duration(seconds: 10);
  static const _maximumPaintedSamples = 2000;

  @override
  void paint(Canvas canvas, Size size) {
    final margin = AppSpacing.sm;
    final area = Rect.fromLTWH(
      margin,
      margin,
      max(0, size.width - margin * 2),
      max(0, size.height - margin * 2),
    );
    final axis = Paint()
      ..color = colors.outlineVariant
      ..strokeWidth = AppMetrics.gaugeTickStroke;
    canvas.drawLine(area.topLeft, area.bottomLeft, axis);
    canvas.drawLine(area.bottomLeft, area.bottomRight, axis);
    if (points.isEmpty) {
      return;
    }
    final firstTime = points.first.timestamp.millisecondsSinceEpoch;
    final span = max(
      1,
      points.last.timestamp.millisecondsSinceEpoch - firstTime,
    );
    final ceiling = max(1.0, maxSpeed);
    final paint = Paint()
      ..strokeWidth = AppMetrics.gaugeNeedleStroke
      ..strokeCap = StrokeCap.round;
    final stride = max(1, (points.length / _maximumPaintedSamples).ceil());
    TrackPoint? previous;
    Offset? priorPosition;
    var breakBefore = false;
    var overLimit = false;
    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final priorSample = index == 0 ? null : points[index - 1];
      breakBefore =
          breakBefore ||
          priorSample == null ||
          priorSample.segment != point.segment ||
          point.timestamp.difference(priorSample.timestamp) > _maximumGap;
      overLimit = overLimit || point.overLimit;
      if (index % stride != 0 && index != points.length - 1) {
        continue;
      }
      final position = Offset(
        area.left +
            area.width *
                (point.timestamp.millisecondsSinceEpoch - firstTime) /
                span,
        area.bottom - area.height * point.speedMetersPerSecond / ceiling,
      );
      final prior = previous;
      if (prior != null &&
          priorPosition != null &&
          prior.segment == point.segment &&
          !breakBefore) {
        paint.color = overLimit ? colors.error : colors.primary;
        canvas.drawLine(priorPosition, position, paint);
      } else {
        canvas.drawCircle(
          position,
          AppSpacing.xxs,
          Paint()..color = colors.primary,
        );
      }
      if (overLimit) {
        canvas.drawCircle(
          position,
          AppSpacing.xxs,
          Paint()..color = colors.error,
        );
      }
      previous = point;
      priorPosition = position;
      breakBefore = false;
      overLimit = false;
    }
  }

  @override
  bool shouldRepaint(_SpeedPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.colors != colors;
}
