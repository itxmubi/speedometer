import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/trip_history_query.dart';

/// Screen-scoped history navigation resets pagination when filters change.
final tripHistoryQueryProvider =
    NotifierProvider.autoDispose<TripHistoryController, TripHistoryQuery>(
      TripHistoryController.new,
    );

class TripHistoryController extends Notifier<TripHistoryQuery> {
  @override
  TripHistoryQuery build() => const TripHistoryQuery();
  void page(int value) => state = state.atPage(value);
  void status(bool? active) => state = TripHistoryQuery(
    from: state.from,
    before: state.before,
    active: active,
  );
  void dates(DateTime from, DateTime through) => state = TripHistoryQuery(
    from: DateTime(from.year, from.month, from.day),
    before: DateTime(through.year, through.month, through.day + 1),
    active: state.active,
  );
  void clear() => state = const TripHistoryQuery();
}
