import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/offline_land_polygon.dart';
import '../../domain/repositories/offline_map_repository.dart';

/// Bundled Natural Earth land outlines; decode happens outside the UI isolate.
final class BundledOfflineMapRepository implements OfflineMapRepository {
  const BundledOfflineMapRepository(
    this._assets, {
    Logger logger = const Logger(),
  }) : _logger = logger;
  final AssetBundle _assets;
  final Logger _logger;
  static const assetPath = 'assets/maps/ne_110m_land.geojson';

  @override
  Future<Result<List<OfflineLandPolygon>>> loadLand() async {
    try {
      final source = await _assets.loadString(assetPath);
      return Success(await _decodeOffThread(source));
    } on Object {
      _logger.error('offline_basemap_load_failed');
      return const Error(Failure(FailureKind.storage));
    }
  }

  static Future<List<OfflineLandPolygon>> _decodeOffThread(String source) =>
      Isolate.run(() => _decode(source));

  static List<OfflineLandPolygon> _decode(String source) {
    final Object? root = jsonDecode(source);
    if (root is! Map<String, Object?> ||
        root['type'] != 'FeatureCollection' ||
        root['features'] is! List<Object?>) {
      throw const FormatException('Invalid geographic asset');
    }
    final features = root['features'] as List<Object?>;
    return features
        .map((feature) {
          if (feature is! Map<String, Object?> ||
              feature['type'] != 'Feature' ||
              feature['geometry'] is! Map<String, Object?>) {
            throw const FormatException('Invalid geographic asset');
          }
          final geometry = feature['geometry'] as Map<String, Object?>;
          if (geometry['type'] != 'Polygon' ||
              geometry['coordinates'] is! List<Object?>) {
            throw const FormatException('Invalid geographic asset');
          }
          final rings = geometry['coordinates'] as List<Object?>;
          if (rings.isEmpty) {
            throw const FormatException('Missing polygon rings');
          }
          return OfflineLandPolygon(
            rings.map((ring) {
              if (ring is! List<Object?> || ring.length < 4) {
                throw const FormatException('Invalid ring');
              }
              final coordinates = ring
                  .map((coordinate) {
                    if (coordinate is! List<Object?> || coordinate.length < 2) {
                      throw const FormatException('Invalid point');
                    }
                    final lon = coordinate[0];
                    final lat = coordinate[1];
                    if (lon is! num ||
                        lat is! num ||
                        !lon.isFinite ||
                        !lat.isFinite ||
                        lon.abs() > 180 ||
                        lat.abs() > 90) {
                      throw const FormatException('Invalid point');
                    }
                    return (lat.toDouble(), lon.toDouble());
                  })
                  .toList(growable: false);
              if (coordinates.first != coordinates.last) {
                throw const FormatException('Unclosed ring');
              }
              return coordinates;
            }),
          );
        })
        .toList(growable: false);
  }
}
