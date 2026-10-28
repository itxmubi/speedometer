import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../domain/entities/track_point.dart';
import '../../domain/entities/offline_land_polygon.dart';
import 'route_node.dart';

/// Cached local geographic projection with no tile requests or network dependency.
final class RouteGeometry {
  RouteGeometry._(
    this.nodes,
    this._centerLatitude,
    this._centerLongitude,
    this._extent,
    this._longitudeScale,
  );

  factory RouteGeometry(List<TrackPoint> points) {
    final coordinates = points.where((point) => point.hasCoordinates).toList();
    if (coordinates.isEmpty) return RouteGeometry._(const [], 0, 0, 1, 1);
    final originLongitude = coordinates.first.longitude ?? 0;
    final latitudeMean =
        coordinates.fold(0.0, (sum, point) => sum + (point.latitude ?? 0)) /
        coordinates.length;
    final scale = max(0.01, cos(latitudeMean * _degreesToRadians).abs());
    final stride = max(1, (points.length / _maximumPaintedSamples).ceil());
    final raw = <RouteNode>[];
    var breakBefore = false;
    var overLimit = false;
    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final previous = index == 0 ? null : points[index - 1];
      breakBefore =
          breakBefore ||
          previous == null ||
          previous.segment != point.segment ||
          !previous.hasCoordinates ||
          !point.hasCoordinates ||
          point.timestamp.difference(previous.timestamp) > _maximumGap;
      overLimit = overLimit || point.overLimit;
      final next = index + 1 < points.length ? points[index + 1] : null;
      // Keep both sides of privacy, pause and GPS gaps when simplifying. A
      // short recorded section must not disappear between stride samples.
      final boundary =
          previous == null ||
          next == null ||
          previous.hasCoordinates != point.hasCoordinates ||
          next.hasCoordinates != point.hasCoordinates ||
          previous.segment != point.segment ||
          next.segment != point.segment ||
          point.timestamp.difference(previous.timestamp) > _maximumGap ||
          next.timestamp.difference(point.timestamp) > _maximumGap;
      if (index % stride != 0 && !boundary) {
        continue;
      }
      final lat = point.latitude;
      final lon = point.longitude;
      if (lat == null || lon == null) {
        raw.add(RouteNode(null, index, point.segment, overLimit, true));
      } else {
        final longitude = ((lon - originLongitude + 540) % 360) - 180;
        raw.add(
          RouteNode(
            Offset(longitude * scale, -lat),
            index,
            point.segment,
            overLimit,
            breakBefore,
          ),
        );
      }
      breakBefore = false;
      overLimit = false;
    }
    final available = raw
        .map((node) => node.position)
        .whereType<Offset>()
        .toList();
    if (available.isEmpty) return RouteGeometry._(const [], 0, 0, 1, 1);
    final minX = available.map((point) => point.dx).reduce(min);
    final minY = available.map((point) => point.dy).reduce(min);
    final maxX = available.map((point) => point.dx).reduce(max);
    final maxY = available.map((point) => point.dy).reduce(max);
    final extent = max(maxX - minX, maxY - minY);
    // One stationary sample still gets a useful, small geographic viewport.
    final denominator = extent == 0
        ? _stationaryViewportDegrees
        : extent * _viewportPadding;
    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;
    final nodes = raw
        .map(
          (node) => RouteNode(
            node.position == null
                ? null
                : Offset(
                    ((node.position?.dx ?? 0) - centerX) / denominator + 0.5,
                    ((node.position?.dy ?? 0) - centerY) / denominator + 0.5,
                  ),
            node.originalIndex,
            node.segment,
            node.overLimit,
            node.breakBefore,
          ),
        )
        .toList(growable: false);
    return RouteGeometry._(
      nodes,
      -centerY,
      originLongitude + centerX / scale,
      denominator,
      scale,
    );
  }

  static const _maximumPaintedSamples = 2000;
  static const _maximumGap = Duration(seconds: 10);
  static const _degreesToRadians = pi / 180;
  static const _stationaryViewportDegrees = 0.001;
  static const _viewportPadding = 1.1;
  final List<RouteNode> nodes;
  final double _centerLatitude;
  final double _centerLongitude;
  final double _extent;
  final double _longitudeScale;

  List<Path> projectLand(List<OfflineLandPolygon> polygons) => polygons
      .map((polygon) {
        final path = Path()..fillType = PathFillType.evenOdd;
        for (final ring in polygon.rings) {
          double? previousLongitude;
          for (var index = 0; index < ring.length; index++) {
            final coordinate = ring[index];
            var longitude =
                ((coordinate.$2 - _centerLongitude + 540) % 360) - 180;
            final previous = previousLongitude;
            if (previous != null) {
              while (longitude - previous > 180) {
                longitude -= 360;
              }
              while (longitude - previous < -180) {
                longitude += 360;
              }
            }
            previousLongitude = longitude;
            final x = longitude * _longitudeScale / _extent + 0.5;
            final y = (_centerLatitude - coordinate.$1) / _extent + 0.5;
            if (index == 0) {
              path.moveTo(x, y);
            } else {
              path.lineTo(x, y);
            }
          }
          path.close();
        }
        return path;
      })
      .toList(growable: false);

  /// Projects independent regional road lines, preserving dateline continuity.
  List<Path> projectLines(List<List<(double, double)>> lines) => lines
      .map((line) {
        final path = Path();
        double? previousLongitude;
        for (var index = 0; index < line.length; index++) {
          final coordinate = line[index];
          var longitude =
              ((coordinate.$2 - _centerLongitude + 540) % 360) - 180;
          final previous = previousLongitude;
          if (previous != null) {
            while (longitude - previous > 180) {
              longitude -= 360;
            }
            while (longitude - previous < -180) {
              longitude += 360;
            }
          }
          previousLongitude = longitude;
          final x = longitude * _longitudeScale / _extent + 0.5;
          final y = (_centerLatitude - coordinate.$1) / _extent + 0.5;
          if (index == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        return path;
      })
      .toList(growable: false);

  double latitudeAt(double fraction) =>
      (_centerLatitude - (fraction - 0.5) * _extent).clamp(-90, 90);
  double longitudeAt(double fraction) =>
      ((_centerLongitude + (fraction - 0.5) * _extent / _longitudeScale + 540) %
          360) -
      180;
}
