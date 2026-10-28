import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/result.dart';
import '../../data/repositories/local_regional_map_repository.dart';
import '../../domain/entities/regional_map.dart';
import '../../domain/repositories/regional_map_repository.dart';
import '../../domain/usecases/load_regional_map_use_case.dart';

final regionalMapRepositoryProvider = Provider<RegionalMapRepository>(
  (ref) => const LocalRegionalMapRepository(),
);
final loadRegionalMapUseCaseProvider = Provider<LoadRegionalMapUseCase>(
  (ref) => LoadRegionalMapUseCase(ref.watch(regionalMapRepositoryProvider)),
);

/// Each detail screen owns its import; leaving releases regional data from memory.
final regionalMapControllerProvider = AsyncNotifierProvider.autoDispose
    .family<RegionalMapController, RegionalMap?, String>(
      RegionalMapController.new,
    );

class RegionalMapController extends AsyncNotifier<RegionalMap?> {
  RegionalMapController(this.tripId);
  final String tripId;
  @override
  Future<RegionalMap?> build() async => null;
  Future<void> load() async {
    if (state.isLoading) return;
    final previous = state.asData?.value;
    state = const AsyncLoading();
    final result = await ref.read(loadRegionalMapUseCaseProvider)();
    if (!ref.mounted) return;
    state = switch (result) {
      Success(:final value) => AsyncData(value ?? previous),
      Error(:final failure) => AsyncError(failure, StackTrace.empty),
    };
  }

  void clear() {
    if (!state.isLoading) state = const AsyncData(null);
  }
}
