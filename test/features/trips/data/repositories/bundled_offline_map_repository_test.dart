import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/trips/data/repositories/bundled_offline_map_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final ring = [
    [55, 25],
    [56, 25],
    [55, 26],
    [55, 25],
  ];

  String geoJson(Object? coordinates, {String geometry = 'Polygon'}) =>
      jsonEncode({
        'type': 'FeatureCollection',
        'features': [
          {
            'type': 'Feature',
            'geometry': {'type': geometry, 'coordinates': coordinates},
          },
        ],
      });

  test(
    'decodes longitude-first coordinates into immutable latitude pairs',
    () async {
      final assets = _MapAssets(geoJson([ring]));
      final result = await BundledOfflineMapRepository(assets).loadLand();
      switch (result) {
        case Success(:final value):
          expect(value.single.rings.single.first, (25.0, 55.0));
          expect(() => value.single.rings.clear(), throwsUnsupportedError);
          expect(
            () => value.single.rings.single.clear(),
            throwsUnsupportedError,
          );
        case Error():
          fail('Valid bundled geometry should load');
      }
      expect(assets.requested, BundledOfflineMapRepository.assetPath);
    },
  );

  final invalidSources = <String, String>{
    'malformed JSON': '{',
    'wrong collection type': '{"type":"Point","features":[]}',
    'missing features': '{"type":"FeatureCollection"}',
    'wrong feature type': jsonEncode({
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Point',
          'geometry': {
            'type': 'Polygon',
            'coordinates': [ring],
          },
        },
      ],
    }),
    'unsupported geometry': geoJson([ring], geometry: 'LineString'),
    'missing rings': geoJson([]),
    'short ring': geoJson([
      [
        [55, 25],
      ],
    ]),
    'unclosed ring': geoJson([
      [
        [55, 25],
        [56, 25],
        [55, 26],
        [56, 26],
      ],
    ]),
    'invalid longitude': geoJson([
      [
        [181, 25],
        [56, 25],
        [55, 26],
        [181, 25],
      ],
    ]),
    'invalid latitude': geoJson([
      [
        [55, 91],
        [56, 25],
        [55, 26],
        [55, 91],
      ],
    ]),
    'nonnumeric coordinate': geoJson([
      [
        ['55', 25],
        [56, 25],
        [55, 26],
        ['55', 25],
      ],
    ]),
    'incomplete coordinate': geoJson([
      [
        [55],
        [56, 25],
        [55, 26],
        [55],
      ],
    ]),
  };
  for (final entry in invalidSources.entries) {
    test('returns a storage failure for ${entry.key}', () async {
      final result = await BundledOfflineMapRepository(
        _MapAssets(entry.value),
      ).loadLand();
      expect(result, isA<Error<Object?>>());
      if (result case Error(:final failure)) {
        expect(failure.kind, FailureKind.storage);
      }
    });
  }

  test('asset loading errors become a storage failure', () async {
    final result = await BundledOfflineMapRepository(
      _MapAssets(null),
    ).loadLand();
    expect(result, isA<Error<Object?>>());
  });

  test('the actual bundled basemap satisfies parser validation', () async {
    final result = await BundledOfflineMapRepository(rootBundle).loadLand();
    switch (result) {
      case Success(:final value):
        expect(value, isNotEmpty);
        expect(value.every((polygon) => polygon.rings.isNotEmpty), isTrue);
      case Error():
        fail('The bundled map asset should load');
    }
  });
}

class _MapAssets extends CachingAssetBundle {
  _MapAssets(this.source);
  final String? source;
  String? requested;

  @override
  Future<ByteData> load(String key) async {
    requested = key;
    final contents = source;
    if (contents == null) {
      throw StateError('Unavailable asset');
    }
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(contents)));
  }
}
