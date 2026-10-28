import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_metrics.dart';
import '../../../../core/theme/app_typography.dart';

/// A repaint-isolated instrument dial, including a selected speed-limit marker.
class AnalogGauge extends StatelessWidget {
  const AnalogGauge({
    required this.speed,
    required this.limit,
    required this.range,
    required this.labels,
    required this.overLimit,
    required this.semanticLabel,
    required this.child,
    super.key,
  });

  final double speed;
  final double? limit;
  final double range;
  final List<String> labels;
  final bool overLimit;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: RepaintBoundary(
          child: AspectRatio(
            aspectRatio: AppMetrics.analogAspectRatio,
            child: CustomPaint(
              painter: _DialPainter(
                speed: speed,
                limit: limit,
                range: range,
                labels: labels,
                overLimit: overLimit,
                accent: colors.primary,
                track: colors.outlineVariant,
                text: colors.onSurfaceVariant,
                warning: colors.error,
                textDirection: Directionality.of(context),
              ),
              child: Align(alignment: Alignment.bottomCenter, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.speed,
    required this.limit,
    required this.range,
    required this.labels,
    required this.overLimit,
    required this.accent,
    required this.track,
    required this.text,
    required this.warning,
    required this.textDirection,
  });

  final double speed;
  final double? limit;
  final double range;
  final List<String> labels;
  final bool overLimit;
  final Color accent;
  final Color track;
  final Color text;
  final Color warning;
  final TextDirection textDirection;

  static const _fullCircle = 2 * math.pi;
  static const _start = _fullCircle * AppMetrics.dialStartFraction;
  static const _sweep = _fullCircle * AppMetrics.dialSweepFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height * AppMetrics.dialCenterYFactor,
    );
    final radius = size.width * AppMetrics.dialRadiusFactor;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppMetrics.gaugeStroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawArc(rect, _start, _sweep, false, paint);
    paint.color = overLimit ? warning : accent;
    canvas.drawArc(
      rect,
      _start,
      _sweep * (speed / range).clamp(0, 1),
      false,
      paint,
    );
    _paintTicks(canvas, center, radius);
    if (limit case final limit?) {
      final angle = _start + _sweep * (limit / range).clamp(0, 1);
      paint
        ..color = warning
        ..strokeWidth = AppMetrics.gaugeNeedleStroke;
      canvas.drawLine(
        _point(center, radius * AppMetrics.tickMajorFactor, angle),
        _point(center, radius, angle),
        paint,
      );
    }
    final angle = _start + _sweep * (speed / range).clamp(0, 1);
    paint
      ..color = overLimit ? warning : accent
      ..strokeWidth = AppMetrics.gaugeNeedleStroke;
    canvas.drawLine(
      center,
      _point(center, radius * AppMetrics.needleRadiusFactor, angle),
      paint,
    );
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, AppMetrics.gaugeCenterRadius, paint);
  }

  void _paintTicks(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = text
      ..strokeWidth = AppMetrics.gaugeTickStroke;
    for (var index = 0; index <= AppMetrics.dialTickCount; index++) {
      final angle = _start + _sweep * index / AppMetrics.dialTickCount;
      final major = index % AppMetrics.dialMajorInterval == 0;
      canvas.drawLine(
        _point(center, radius * AppMetrics.tickOuterFactor, angle),
        _point(
          center,
          radius *
              (major ? AppMetrics.tickMajorFactor : AppMetrics.tickMinorFactor),
          angle,
        ),
        paint,
      );
      if (major) {
        final label = TextPainter(
          text: TextSpan(
            text: labels[index ~/ AppMetrics.dialMajorInterval],
            style: AppTypography.dialLabel.copyWith(color: text),
          ),
          textDirection: textDirection,
        )..layout();
        final position = _point(
          center,
          radius * AppMetrics.tickLabelFactor,
          angle,
        );
        label.paint(
          canvas,
          position - Offset(label.width / 2, label.height / 2),
        );
      }
    }
  }

  Offset _point(Offset center, double radius, double angle) =>
      center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);

  @override
  bool shouldRepaint(_DialPainter oldDelegate) =>
      speed != oldDelegate.speed ||
      limit != oldDelegate.limit ||
      range != oldDelegate.range ||
      overLimit != oldDelegate.overLimit ||
      accent != oldDelegate.accent ||
      track != oldDelegate.track ||
      text != oldDelegate.text ||
      warning != oldDelegate.warning ||
      textDirection != oldDelegate.textDirection ||
      labels.toString() != oldDelegate.labels.toString();
}
