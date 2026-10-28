import 'package:flutter/material.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../speedometer/domain/entities/speed_unit.dart';
import '../../domain/entities/recorded_trip.dart';
import '../../domain/entities/track_point.dart';
import 'route_geometry.dart';
import 'trip_format.dart';
import 'trip_route_view.dart';

/// Screen-owned replay animation: twenty recorded seconds per playback second.
class TripReplay extends StatefulWidget {
  const TripReplay({required this.trip, required this.unit, super.key});
  final RecordedTrip trip;
  final SpeedUnit unit;

  @override
  State<TripReplay> createState() => _TripReplayState();
}

class _TripReplayState extends State<TripReplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation;
  late RouteGeometry _geometry;
  static const _playbackSpeed = 20;

  @override
  void initState() {
    super.initState();
    _geometry = RouteGeometry(widget.trip.points);
    _animation = AnimationController(
      vsync: this,
      duration: _duration(widget.trip.points),
    );
  }

  @override
  void didUpdateWidget(TripReplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trip != widget.trip) {
      _animation.stop();
      _animation.value = 0;
      _animation.duration = _duration(widget.trip.points);
      _geometry = RouteGeometry(widget.trip.points);
    }
  }

  Duration _duration(List<TrackPoint> points) {
    final span = points.isEmpty
        ? 0
        : points.last.timestamp
              .difference(points.first.timestamp)
              .inMilliseconds;
    return Duration(
      milliseconds: (span ~/ _playbackSpeed).clamp(1000, 86400000),
    );
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final points = widget.trip.points;
    if (points.isEmpty) {
      return Text(l10n.tripNoSamples);
    }
    if (_geometry.nodes.isEmpty) {
      return Text(l10n.tripNoRoute);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final index = _sampleIndex(points, _animation.value);
        final point = points[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TripRouteView(
              tripId: widget.trip.id,
              geometry: _geometry,
              selectedIndex: index,
            ),
            Row(
              children: [
                IconButton.filledTonal(
                  tooltip: _animation.isAnimating
                      ? l10n.tripReplayPause
                      : l10n.tripReplayPlay,
                  onPressed: () {
                    if (_animation.isAnimating) {
                      setState(_animation.stop);
                    } else {
                      if (_animation.isCompleted) {
                        _animation.value = 0;
                      }
                      setState(() {
                        _animation.forward();
                      });
                    }
                  },
                  icon: Icon(
                    _animation.isAnimating
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _animation.value,
                    semanticFormatterCallback: (value) =>
                        l10n.tripSamplePosition(
                          TripFormat.number(
                            _sampleIndex(points, value) + 1,
                            l10n,
                            decimals: 0,
                          ),
                          TripFormat.number(points.length, l10n, decimals: 0),
                        ),
                    label: l10n.tripReplayProgress,
                    onChanged: (value) {
                      _animation.stop();
                      _animation.value = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(l10n.tripSampleTime(TripFormat.date(point.timestamp, l10n))),
            Text(
              TripFormat.speed(point.speedMetersPerSecond, widget.unit, l10n),
            ),
            if (point.overLimit)
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(child: Text(l10n.overLimit)),
                ],
              ),
          ],
        );
      },
    );
  }

  int _sampleIndex(List<TrackPoint> points, double fraction) {
    final first = points.first.timestamp.millisecondsSinceEpoch;
    final span = points.last.timestamp.millisecondsSinceEpoch - first;
    final target = first + span * fraction;
    var low = 0;
    var high = points.length - 1;
    while (low < high) {
      final middle = (low + high + 1) ~/ 2;
      if (points[middle].timestamp.millisecondsSinceEpoch <= target) {
        low = middle;
      } else {
        high = middle - 1;
      }
    }
    return low;
  }
}
