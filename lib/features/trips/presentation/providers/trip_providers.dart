import 'trip_history_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../../core/database/database_providers.dart';
import '../../../../core/error/result.dart';
import '../../../speedometer/domain/entities/speed_unit.dart';
import '../../data/repositories/drift_trip_repository.dart';
import '../../data/repositories/bundled_offline_map_repository.dart';
import '../../domain/entities/offline_land_polygon.dart';
import '../../domain/repositories/offline_map_repository.dart';
import '../../domain/usecases/load_offline_map_use_case.dart';
import '../../data/repositories/platform_trip_file_repository.dart';
import '../../domain/entities/recorded_trip.dart';
import '../../domain/entities/trip_totals.dart';
import '../../domain/repositories/trip_file_repository.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../domain/usecases/delete_trip_use_case.dart';
import '../../domain/usecases/get_trip_use_case.dart';
import '../../domain/usecases/share_trip_document_use_case.dart';
import '../../domain/usecases/share_trip_summary_use_case.dart';
import '../../domain/usecases/watch_trip_totals_use_case.dart';
import '../../domain/usecases/watch_trips_use_case.dart';
import 'trip_action_controller.dart';

/// App-wide local persistence, overridable by the composition root and tests.
final tripRepositoryProvider = Provider<TripRepository>(
  (ref) => DriftTripRepository(ref.watch(appDatabaseProvider)),
);

final tripFileRepositoryProvider = Provider<TripFileRepository>(
  (ref) => const PlatformTripFileRepository(),
);

/// The composition root binds this to the dashboard's chosen display unit.
final tripSpeedUnitProvider = Provider<SpeedUnit>(
  (ref) => SpeedUnit.kilometersPerHour,
);

final watchTripsUseCaseProvider = Provider<WatchTripsUseCase>(
  (ref) => WatchTripsUseCase(ref.watch(tripRepositoryProvider)),
);
final watchTripTotalsUseCaseProvider = Provider<WatchTripTotalsUseCase>(
  (ref) => WatchTripTotalsUseCase(ref.watch(tripRepositoryProvider)),
);
final getTripUseCaseProvider = Provider<GetTripUseCase>(
  (ref) => GetTripUseCase(ref.watch(tripRepositoryProvider)),
);
final deleteTripUseCaseProvider = Provider<DeleteTripUseCase>(
  (ref) => DeleteTripUseCase(ref.watch(tripRepositoryProvider)),
);
final shareTripDocumentUseCaseProvider = Provider<ShareTripDocumentUseCase>(
  (ref) => ShareTripDocumentUseCase(
    ref.watch(tripRepositoryProvider),
    ref.watch(tripFileRepositoryProvider),
  ),
);
final shareTripSummaryUseCaseProvider = Provider<ShareTripSummaryUseCase>(
  (ref) => ShareTripSummaryUseCase(ref.watch(tripFileRepositoryProvider)),
);

final tripHistoryProvider = StreamProvider.autoDispose<List<RecordedTrip>>((
  ref,
) async* {
  await for (final result in ref.watch(watchTripsUseCaseProvider)(
    query: ref.watch(tripHistoryQueryProvider),
  )) {
    switch (result) {
      case Success(:final value):
        yield value;
      case Error(:final failure):
        throw failure;
    }
  }
});

/// Totals are app-wide because the live dashboard and history observe them.
final tripTotalsProvider = StreamProvider<TripTotals>((ref) async* {
  await for (final result in ref.watch(watchTripTotalsUseCaseProvider)()) {
    switch (result) {
      case Success(:final value):
        yield value;
      case Error(:final failure):
        throw failure;
    }
  }
});

final tripDetailProvider = FutureProvider.autoDispose
    .family<RecordedTrip?, String>((ref, id) async {
      // Invalidation on a checkpoint refreshes an open active-trip detail screen.
      ref.watch(tripHistoryProvider);
      return switch (await ref.watch(getTripUseCaseProvider)(id)) {
        Success(:final value) => value,
        Error(:final failure) => throw failure,
      };
    });

final tripActionControllerProvider =
    AsyncNotifierProvider.autoDispose<TripActionController, void>(
      TripActionController.new,
    );

final offlineMapRepositoryProvider = Provider<OfflineMapRepository>(
  (ref) => BundledOfflineMapRepository(PlatformAssetBundle()),
);
final loadOfflineMapUseCaseProvider = Provider<LoadOfflineMapUseCase>(
  (ref) => LoadOfflineMapUseCase(ref.watch(offlineMapRepositoryProvider)),
);
final offlineLandProvider =
    FutureProvider.autoDispose<List<OfflineLandPolygon>>(
      (ref) async => switch (await ref.watch(loadOfflineMapUseCaseProvider)()) {
        Success(:final value) => value,
        Error(:final failure) => throw failure,
      },
    );
