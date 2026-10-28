import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../domain/entities/fuel_entry.dart';
import 'fuel_providers.dart';

/// Coordinates writes while the database stream remains the source of truth.
final class FuelActionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> save(FuelEntry entry) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final result = await ref.read(saveFuelEntryUseCaseProvider)(entry);
    if (!ref.mounted) return false;
    return _complete(result);
  }

  Future<bool> delete(String id) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();
    final result = await ref.read(deleteFuelEntryUseCaseProvider)(id);
    if (!ref.mounted) return false;
    return _complete(result);
  }

  bool _complete(Result<void> result) {
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
