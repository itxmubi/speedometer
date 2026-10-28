import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/trips/data/models/regional_map_model.dart';

Map<String, Object?> document({
  Object? geometry,
  String? attribution = 'Example roads, CC0',
}) => {
  'type': 'FeatureCollection',
  'attribution': ?attribution,
  'features': [
    {
      'type': 'Feature',
      'geometry':
          geometry ??
          {
            'type': 'LineString',
            'coordinates': [
              [55, 25],
              [55.01, 25.01],
            ],
          },
    },
  ],
};
void main() {
  test('imports attributed independent lines in latitude/longitude order', () {
    final model = RegionalMapModel.decode(
      jsonEncode(
        document(
          geometry: {
            'type': 'MultiLineString',
            'coordinates': [
              [
                [55, 25],
                [55.01, 25.01],
              ],
              [
                [56, 26],
                [56.01, 26.01],
              ],
            ],
          },
        ),
      ),
    );
    expect(model.lines.length, 2);
    expect(model.lines.first.first, (25.0, 55.0));
    expect(model.attribution, 'Example roads, CC0');
    expect(() => model.lines.first.add((0, 0)), throwsUnsupportedError);
  });
  test(
    'rejects invalid input, missing attribution, polygons and out-of-bounds points',
    () {
      for (final source in [
        'not json',
        '{}',
        jsonEncode(document(attribution: null)),
        jsonEncode(document(attribution: ' ')),
        jsonEncode(
          document(geometry: {'type': 'Polygon', 'coordinates': <Object?>[]}),
        ),
        jsonEncode(
          document(
            geometry: {
              'type': 'LineString',
              'coordinates': [
                [181, 25],
                [55, 25],
              ],
            },
          ),
        ),
        jsonEncode(
          document(
            geometry: {'type': 'MultiLineString', 'coordinates': <Object?>[]},
          ),
        ),
        jsonEncode(
          document(
            geometry: {
              'type': 'LineString',
              'coordinates': [
                [55, 25],
              ],
            },
          ),
        ),
      ]) {
        expect(() => RegionalMapModel.decode(source), throwsFormatException);
      }
    },
  );
  test('rejects documents exceeding byte, feature and point budgets', () {
    expect(
      () => RegionalMapModel.decode(' ' * (RegionalMapModel.maxBytes + 1)),
      throwsFormatException,
    );
    final many = document()
      ..['features'] = List.filled(RegionalMapModel.maxFeatures + 1, {
        'type': 'Feature',
      });
    expect(
      () => RegionalMapModel.decode(jsonEncode(many)),
      throwsFormatException,
    );
    final points = document(
      geometry: {
        'type': 'LineString',
        'coordinates': List.filled(RegionalMapModel.maxPoints + 1, [55, 25]),
      },
    );
    expect(
      () => RegionalMapModel.decode(jsonEncode(points)),
      throwsFormatException,
    );
  });
}
