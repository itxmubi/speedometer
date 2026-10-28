import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/trips/domain/entities/offline_land_polygon.dart';
import 'package:speedometer/features/trips/presentation/widgets/route_geometry.dart';

import '../../trip_fixtures.dart';

void main() {
  test(
    'regional lines cross the dateline locally without joining separate roads',
    () {
      final geometry = RouteGeometry([
        sample(longitude: 179.9),
        sample(seconds: 1, longitude: -179.9),
      ]);
      final paths = geometry.projectLines([
        [(25, 179.9), (25, -179.9)],
        [(25.01, 179.9), (25.02, 179.95)],
      ]);
      expect(paths, hasLength(2));
      expect(paths.first.getBounds().width, lessThan(1));
      expect(paths.first.computeMetrics().single.isClosed, false);
    },
  );

  test('empty and private-only samples have no drawable route', () {
    expect(RouteGeometry([]).nodes, isEmpty);
    expect(
      RouteGeometry([sample(latitude: null, longitude: null)]).nodes,
      isEmpty,
    );
  });

  test('stationary and polar samples project to finite centered positions', () {
    for (final latitude in [25.0, 90.0, -90.0]) {
      final geometry = RouteGeometry([sample(latitude: latitude)]);
      expect(geometry.nodes.single.position, const Offset(0.5, 0.5));
      expect(geometry.latitudeAt(0.5), latitude);
      for (final fraction in [0.0, 0.5, 1.0]) {
        expect(geometry.latitudeAt(fraction), inInclusiveRange(-90, 90));
        expect(geometry.longitudeAt(fraction), inInclusiveRange(-180, 180));
      }
    }
  });

  test('crossing the date line keeps a local longitude viewport', () {
    final geometry = RouteGeometry([
      sample(longitude: 179.9),
      sample(seconds: 5, longitude: -179.9),
    ]);
    expect(geometry.nodes.first.position?.dx, closeTo(0.04545, 0.0001));
    expect(geometry.nodes.last.position?.dx, closeTo(0.95455, 0.0001));
    expect(geometry.longitudeAt(0.5).abs(), closeTo(180, 0.0001));
    final land = geometry.projectLand([
      OfflineLandPolygon([
        [
          (24.9, 179.8),
          (25.1, 179.8),
          (25.1, -179.8),
          (24.9, -179.8),
          (24.9, 179.8),
        ],
      ]),
    ]);
    expect(land.single.getBounds().width, lessThan(2));
    expect(land.single.contains(const Offset(0.5, 0.5)), isTrue);
  });

  test('privacy, pause and unreliable GPS boundaries break route segments', () {
    final geometry = RouteGeometry([
      sample(),
      sample(seconds: 1, latitude: null, longitude: null),
      sample(seconds: 2, latitude: 25.001),
      sample(seconds: 3, latitude: 25.002, segment: 1),
      sample(seconds: 20, latitude: 25.003, segment: 1),
      sample(seconds: 21, latitude: 25.004, segment: 1),
    ]);
    expect(geometry.nodes[1].position, isNull);
    expect(geometry.nodes.map((node) => node.breakBefore), [
      true,
      true,
      true,
      true,
      true,
      false,
    ]);
  });

  test('simplification keeps short recorded sections and skipped warnings', () {
    final points = List.generate(
      6000,
      (index) => sample(
        seconds: index,
        latitude: index == 1 ? 25 : null,
        longitude: index == 1 ? 55 : null,
        overLimit: index == 4,
      ),
    );
    final geometry = RouteGeometry(points);
    expect(
      geometry.nodes
          .where((node) => node.position != null)
          .single
          .originalIndex,
      1,
    );
    expect(geometry.nodes.any((node) => node.overLimit), isTrue);
    expect(geometry.nodes.last.originalIndex, points.length - 1);
  });

  test('land polygon holes remain unfilled', () {
    final geometry = RouteGeometry([sample(latitude: 0, longitude: 0)]);
    final path = geometry.projectLand([
      OfflineLandPolygon([
        [(-1, -1), (-1, 1), (1, 1), (1, -1), (-1, -1)],
        [(-0.1, -0.1), (-0.1, 0.1), (0.1, 0.1), (0.1, -0.1), (-0.1, -0.1)],
      ]),
    ]).single;
    expect(path.contains(const Offset(0.5, 0.5)), isFalse);
    expect(path.contains(const Offset(200, 0.5)), isTrue);
  });
}
