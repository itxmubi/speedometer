/// Public-domain geographic land rings; pairs contain latitude then longitude.
final class OfflineLandPolygon {
  OfflineLandPolygon(Iterable<Iterable<(double, double)>> rings)
    : rings = List.unmodifiable(
        rings.map((ring) => List<(double, double)>.unmodifiable(ring)),
      );

  final List<List<(double, double)>> rings;
}
