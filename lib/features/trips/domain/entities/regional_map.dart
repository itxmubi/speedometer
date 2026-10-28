/// User-supplied geographic lines with required source attribution.
final class RegionalMap {
  RegionalMap({
    required this.attribution,
    required Iterable<Iterable<(double, double)>> lines,
  }) : lines = List.unmodifiable(
         lines.map((line) => List<(double, double)>.unmodifiable(line)),
       );
  final String attribution;

  /// Latitude/longitude pairs. Each line is independent, never bridged to another.
  final List<List<(double, double)>> lines;
}
