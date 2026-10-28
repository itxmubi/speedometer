import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/error/result.dart';
import '../../data/repositories/drift_fuel_repository.dart';
import '../../domain/entities/fuel_entry.dart';
import '../../domain/entities/fuel_summary.dart';
import '../../domain/repositories/fuel_repository.dart';
import '../../domain/usecases/delete_fuel_entry_use_case.dart';
import '../../domain/usecases/save_fuel_entry_use_case.dart';
import '../../domain/usecases/summarize_fuel_use_case.dart';
import '../../domain/usecases/watch_fuel_entries_use_case.dart';
import 'fuel_action_controller.dart';

/// Shared persistence allows backup and deletion to include every local feature.
final fuelRepositoryProvider = Provider<FuelRepository>(
  (ref) => DriftFuelRepository(ref.watch(appDatabaseProvider)),
);

final watchFuelEntriesUseCaseProvider = Provider<WatchFuelEntriesUseCase>(
  (ref) => WatchFuelEntriesUseCase(ref.watch(fuelRepositoryProvider)),
);
final saveFuelEntryUseCaseProvider = Provider<SaveFuelEntryUseCase>(
  (ref) => SaveFuelEntryUseCase(ref.watch(fuelRepositoryProvider)),
);
final deleteFuelEntryUseCaseProvider = Provider<DeleteFuelEntryUseCase>(
  (ref) => DeleteFuelEntryUseCase(ref.watch(fuelRepositoryProvider)),
);
final summarizeFuelUseCaseProvider = Provider<SummarizeFuelUseCase>(
  (ref) => const SummarizeFuelUseCase(),
);

final fuelEntriesProvider = StreamProvider.autoDispose<List<FuelEntry>>(
  (ref) => ref
      .watch(watchFuelEntriesUseCaseProvider)()
      .map(
        (result) => switch (result) {
          Success(:final value) => value,
          Error(:final failure) => throw failure,
        },
      ),
  // Expected storage failures have an explicit Retry action on this screen.
  retry: (retryCount, error) => null,
);

final fuelSummariesProvider =
    Provider.autoDispose<AsyncValue<List<FuelSummary>>>(
      (ref) => ref
          .watch(fuelEntriesProvider)
          .whenData(
            (entries) => ref.watch(summarizeFuelUseCaseProvider)(entries),
          ),
    );

final fuelActionControllerProvider =
    AsyncNotifierProvider.autoDispose<FuelActionController, void>(
      FuelActionController.new,
    );

/// Injectable clock keeps date defaults deterministic in presentation tests.
final fuelNowProvider = Provider<DateTime Function()>((ref) => DateTime.now);
