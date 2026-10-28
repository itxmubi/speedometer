import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/trip_export_format.dart';
import 'trip_providers.dart';

/// Screen-scoped actions translate typed results into explicit loading/error state.
final class TripActionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> deleteTrip(String id) =>
      _perform(() => ref.read(deleteTripUseCaseProvider)(id));
  Future<bool> shareDocument(
    String id,
    TripExportFormat format,
    String subject,
  ) => _perform(
    () => ref.read(shareTripDocumentUseCaseProvider)(id, format, subject),
  );
  Future<bool> shareSummary(String text) =>
      _perform(() => ref.read(shareTripSummaryUseCaseProvider)(text));

  Future<bool> _perform(Future<Result<void>> Function() action) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final result = await action();
    if (!ref.mounted) return false;
    switch (result) {
      case Success():
        state = const AsyncData(null);
        return true;
      case Error(:final failure):
        state = AsyncError(failure, StackTrace.current);
        return false;
    }
  }
}
