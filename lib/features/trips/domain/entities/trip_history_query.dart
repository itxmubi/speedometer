/// Bounded history query; end date is exclusive and dates represent local days.
final class TripHistoryQuery {
  const TripHistoryQuery({this.page = 0, this.from, this.before, this.active});
  static const pageSize = 20;
  final int page;
  final DateTime? from;
  final DateTime? before;

  /// Null includes all records; true selects active, false completed trips.
  final bool? active;
  int get offset => page * pageSize;

  /// Inclusive final local day, using calendar arithmetic across DST changes.
  DateTime? get through {
    final end = before;
    return end == null ? null : DateTime(end.year, end.month, end.day - 1);
  }

  TripHistoryQuery atPage(int value) => TripHistoryQuery(
    page: value < 0 ? 0 : value,
    from: from,
    before: before,
    active: active,
  );
}
