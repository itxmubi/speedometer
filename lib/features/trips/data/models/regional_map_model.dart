import 'dart:convert';
import '../../domain/entities/regional_map.dart';

/// Bounded GeoJSON parser. Foreign attribution member is mandatory for display.
abstract final class RegionalMapModel {
  static const maxBytes = 5 * 1024 * 1024;
  static const maxPoints = 50000;
  static const maxFeatures = 2000;
  static RegionalMap decode(String source) {
    if (source.length > maxBytes || utf8.encode(source).length > maxBytes) {
      throw const FormatException('Regional map too large');
    }
    final Object? root = jsonDecode(source);
    if (root is! Map<String, Object?> || root['type'] != 'FeatureCollection') {
      throw const FormatException('Invalid regional map');
    }
    final attribution = root['attribution'];
    final features = root['features'];
    if (attribution is! String ||
        attribution.trim().isEmpty ||
        attribution.length > 240 ||
        features is! List<Object?> ||
        features.isEmpty ||
        features.length > maxFeatures) {
      throw const FormatException('Missing attribution or features');
    }
    var count = 0;
    final lines = <List<(double, double)>>[];
    void addLine(Object? coordinates) {
      if (coordinates is! List<Object?> || coordinates.length < 2) {
        throw const FormatException('Invalid line');
      }
      count += coordinates.length;
      if (count > maxPoints) throw const FormatException('Too many points');
      lines.add(
        coordinates
            .map((point) {
              if (point is! List<Object?> || point.length < 2) {
                throw const FormatException('Invalid coordinate');
              }
              final lon = point[0];
              final lat = point[1];
              if (lon is! num ||
                  lat is! num ||
                  !lon.isFinite ||
                  !lat.isFinite ||
                  lon.abs() > 180 ||
                  lat.abs() > 90) {
                throw const FormatException('Invalid coordinate');
              }
              return (lat.toDouble(), lon.toDouble());
            })
            .toList(growable: false),
      );
    }

    for (final feature in features) {
      if (feature is! Map<String, Object?> || feature['type'] != 'Feature') {
        throw const FormatException('Invalid feature');
      }
      final geometry = feature['geometry'];
      if (geometry is! Map<String, Object?>) {
        throw const FormatException('Invalid geometry');
      }
      if (geometry['type'] == 'LineString') {
        addLine(geometry['coordinates']);
      } else if (geometry['type'] == 'MultiLineString') {
        final coordinates = geometry['coordinates'];
        if (coordinates is! List<Object?> || coordinates.isEmpty) {
          throw const FormatException('Invalid multiline');
        }
        for (final line in coordinates) {
          addLine(line);
        }
      } else {
        throw const FormatException('Unsupported geometry');
      }
    }
    return RegionalMap(attribution: attribution.trim(), lines: lines);
  }
}
