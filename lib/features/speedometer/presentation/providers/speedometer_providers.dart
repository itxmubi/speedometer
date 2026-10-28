import '../../../trips/domain/usecases/discard_trip_use_case.dart';
import '../../../activities/domain/usecases/estimate_activity_calories_use_case.dart';
import '../../../activities/domain/usecases/select_activity_use_case.dart';
import '../../../../core/platform/device_services.dart';
import '../../../../core/platform/method_channel_device_services.dart';
import '../../data/datasources/native_location_data_source.dart';
import '../../data/repositories/platform_device_repository.dart';
import '../../data/repositories/local_backup_repository.dart';
import '../../domain/repositories/device_repository.dart';
import '../../domain/repositories/backup_repository.dart';
import '../../../trips/domain/repositories/trip_repository.dart';
import '../../../trips/domain/repositories/trip_file_repository.dart';
import '../../../trips/domain/usecases/start_trip_use_case.dart';
import '../../../trips/domain/usecases/checkpoint_trip_use_case.dart';
import '../../../trips/domain/usecases/finish_trip_use_case.dart';
import '../../../trips/domain/usecases/get_active_trip_use_case.dart';
import '../../../trips/domain/usecases/watch_trip_totals_use_case.dart';
import '../../../trips/domain/usecases/delete_trip_use_case.dart';
import '../../domain/usecases/apply_device_settings_use_case.dart';
import '../../domain/usecases/issue_speed_alert_use_case.dart';
import '../../domain/usecases/update_tracking_display_use_case.dart';
import '../../domain/usecases/watch_compass_use_case.dart';
import '../../domain/usecases/check_overlay_permission_use_case.dart';
import '../../domain/usecases/set_overlay_use_case.dart';
import '../../domain/usecases/request_overlay_permission_use_case.dart';
import '../../domain/usecases/watch_tracking_status_use_case.dart';
import '../../domain/usecases/inspect_tracking_state_use_case.dart';
import '../../domain/usecases/evaluate_speed_alert_use_case.dart';
import '../../domain/usecases/export_backup_use_case.dart';
import '../../domain/usecases/restore_backup_use_case.dart';
import '../../domain/usecases/clear_local_data_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import 'package:speedometer/generated/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/logger.dart';
import '../../data/datasources/location_data_source.dart';
import '../../data/datasources/geolocator_location_data_source.dart';
import '../../data/datasources/preferences_data_source.dart';
import '../../data/repositories/geolocator_location_repository.dart';
import '../../data/repositories/local_preferences_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../../domain/usecases/evaluate_speed_limit_use_case.dart';
import '../../domain/usecases/load_preferences_use_case.dart';
import '../../domain/usecases/open_app_settings_use_case.dart';
import '../../domain/usecases/open_location_settings_use_case.dart';
import '../../domain/usecases/prepare_location_use_case.dart';
import '../../domain/usecases/save_preferences_use_case.dart';
import '../../domain/usecases/update_trip_use_case.dart';
import '../../domain/usecases/watch_speed_use_case.dart';
import 'speedometer_controller.dart';

/// Shared dependency with no user data in log messages.
final loggerProvider = Provider<Logger>((ref) => const Logger());

/// Platform boundary, replaceable with a fake in tests.
final locationDataSourceProvider = Provider<LocationDataSource>(
  (ref) => NativeLocationDataSource(
    ref.watch(deviceServicesProvider),
    const GeolocatorLocationDataSource(),
  ),
);

/// Location repository dependency.
final locationRepositoryProvider = Provider<LocationRepository>(
  (ref) => GeolocatorLocationRepository(
    ref.watch(locationDataSourceProvider),
    logger: ref.watch(loggerProvider),
  ),
);

/// Only small display settings are stored in preferences.
final preferencesDataSourceProvider = Provider<PreferencesDataSource>(
  (ref) => PreferencesDataSource(SharedPreferencesAsync()),
);

/// Display settings repository dependency.
final preferencesRepositoryProvider = Provider<PreferencesRepository>(
  (ref) => LocalPreferencesRepository(
    ref.watch(preferencesDataSourceProvider),
    logger: ref.watch(loggerProvider),
  ),
);

final loadPreferencesUseCaseProvider = Provider<LoadPreferencesUseCase>(
  (ref) => LoadPreferencesUseCase(ref.watch(preferencesRepositoryProvider)),
);
final savePreferencesUseCaseProvider = Provider<SavePreferencesUseCase>(
  (ref) => SavePreferencesUseCase(ref.watch(preferencesRepositoryProvider)),
);
final prepareLocationUseCaseProvider = Provider<PrepareLocationUseCase>(
  (ref) => PrepareLocationUseCase(ref.watch(locationRepositoryProvider)),
);
final watchSpeedUseCaseProvider = Provider<WatchSpeedUseCase>(
  (ref) => WatchSpeedUseCase(ref.watch(locationRepositoryProvider)),
);
final updateTripUseCaseProvider = Provider<UpdateTripUseCase>(
  (ref) => const UpdateTripUseCase(),
);

/// Activity choices and estimation remain pure domain actions.
final selectActivityUseCaseProvider = Provider<SelectActivityUseCase>(
  (ref) => const SelectActivityUseCase(),
);
final estimateActivityCaloriesUseCaseProvider =
    Provider<EstimateActivityCaloriesUseCase>(
      (ref) => const EstimateActivityCaloriesUseCase(),
    );

/// Only accepted moving intervals contribute; no timer or sensor is started.
final activityCaloriesProvider = Provider<double?>((ref) {
  final (mode, weight, movingTime) = ref.watch(
    speedometerControllerProvider.select(
      (state) => (
        state.preferences.activityMode,
        state.preferences.bodyWeightKilograms,
        state.trip.movingTime,
      ),
    ),
  );
  return ref.watch(estimateActivityCaloriesUseCaseProvider)(
    mode: mode,
    weightKilograms: weight,
    movingTime: movingTime,
  );
});

final openAppSettingsUseCaseProvider = Provider<OpenAppSettingsUseCase>(
  (ref) => OpenAppSettingsUseCase(ref.watch(locationRepositoryProvider)),
);
final openLocationSettingsUseCaseProvider =
    Provider<OpenLocationSettingsUseCase>(
      (ref) =>
          OpenLocationSettingsUseCase(ref.watch(locationRepositoryProvider)),
    );

/// Domain speed warning dependency.
final evaluateSpeedLimitUseCaseProvider = Provider<EvaluateSpeedLimitUseCase>(
  (ref) => const EvaluateSpeedLimitUseCase(),
);

/// Updates only when speed or the manual limit changes.
final isOverLimitProvider = Provider<bool>((ref) {
  final (speed, limit, enabled) = ref.watch(
    speedometerControllerProvider.select(
      (state) => (
        state.reading?.speedMetersPerSecond ?? 0.0,
        state.preferences.speedLimitMetersPerSecond +
            state.preferences.alertOffsetMetersPerSecond,
        state.preferences.limitEnabled,
      ),
    ),
  );
  return ref.watch(evaluateSpeedLimitUseCaseProvider)(
    speedMetersPerSecond: speed,
    limitMetersPerSecond: limit,
    enabled: enabled,
  );
});

/// Application composition must supply the durable trips implementation.
final sessionTripRepositoryProvider = Provider<TripRepository>(
  (ref) => throw StateError(
    'TripRepository must be injected by application composition',
  ),
);

/// Application composition supplies platform document actions.
final tripFilesRepositoryProvider = Provider<TripFileRepository>(
  (ref) => throw StateError(
    'TripFileRepository must be injected by application composition',
  ),
);
final deviceServicesProvider = Provider<DeviceServices>(
  (ref) => const MethodChannelDeviceServices(),
);
final deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => PlatformDeviceRepository(ref.watch(deviceServicesProvider)),
);
final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => LocalBackupRepository(
    ref.watch(sessionTripRepositoryProvider),
    ref.watch(tripFilesRepositoryProvider),
    ref.watch(preferencesRepositoryProvider),
    logger: ref.watch(loggerProvider),
  ),
);

/// Injectable wall clock for deterministic timestamps and visual clock tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);
final dashboardTimeProvider = StreamProvider.autoDispose<DateTime>((
  ref,
) async* {
  final now = ref.watch(clockProvider);
  yield now();
  yield* Stream<DateTime>.periodic(const Duration(seconds: 1), (_) => now());
});
final dashboardLocalizationsProvider =
    Provider.family<AppLocalizations, String?>((ref, locale) {
      final system = PlatformDispatcher.instance.locale.languageCode;
      return lookupAppLocalizations(
        Locale(
          locale ??
              (AppLocalizations.supportedLocales.any(
                    (l) => l.languageCode == system,
                  )
                  ? system
                  : 'en'),
        ),
      );
    });
final startTripUseCaseProvider = Provider<StartTripUseCase>(
  (ref) => StartTripUseCase(ref.watch(sessionTripRepositoryProvider)),
);
final checkpointTripUseCaseProvider = Provider<CheckpointTripUseCase>(
  (ref) => CheckpointTripUseCase(ref.watch(sessionTripRepositoryProvider)),
);
final finishTripUseCaseProvider = Provider<FinishTripUseCase>(
  (ref) => FinishTripUseCase(ref.watch(sessionTripRepositoryProvider)),
);
final getActiveTripUseCaseProvider = Provider<GetActiveTripUseCase>(
  (ref) => GetActiveTripUseCase(ref.watch(sessionTripRepositoryProvider)),
);
final watchTripTotalsUseCaseProvider = Provider<WatchTripTotalsUseCase>(
  (ref) => WatchTripTotalsUseCase(ref.watch(sessionTripRepositoryProvider)),
);
final deleteTripUseCaseProvider = Provider<DeleteTripUseCase>(
  (ref) => DeleteTripUseCase(ref.watch(sessionTripRepositoryProvider)),
);
final applyDeviceSettingsUseCaseProvider = Provider<ApplyDeviceSettingsUseCase>(
  (ref) => ApplyDeviceSettingsUseCase(ref.watch(deviceRepositoryProvider)),
);
final issueSpeedAlertUseCaseProvider = Provider<IssueSpeedAlertUseCase>(
  (ref) => IssueSpeedAlertUseCase(ref.watch(deviceRepositoryProvider)),
);
final updateTrackingDisplayUseCaseProvider =
    Provider<UpdateTrackingDisplayUseCase>(
      (ref) =>
          UpdateTrackingDisplayUseCase(ref.watch(deviceRepositoryProvider)),
    );
final watchCompassUseCaseProvider = Provider<WatchCompassUseCase>(
  (ref) => WatchCompassUseCase(ref.watch(deviceRepositoryProvider)),
);
final checkOverlayPermissionUseCaseProvider =
    Provider<CheckOverlayPermissionUseCase>(
      (ref) =>
          CheckOverlayPermissionUseCase(ref.watch(deviceRepositoryProvider)),
    );
final setOverlayUseCaseProvider = Provider<SetOverlayUseCase>(
  (ref) => SetOverlayUseCase(ref.watch(deviceRepositoryProvider)),
);
final requestOverlayPermissionUseCaseProvider =
    Provider<RequestOverlayPermissionUseCase>(
      (ref) =>
          RequestOverlayPermissionUseCase(ref.watch(deviceRepositoryProvider)),
    );
final watchTrackingStatusUseCaseProvider = Provider<WatchTrackingStatusUseCase>(
  (ref) => WatchTrackingStatusUseCase(ref.watch(deviceRepositoryProvider)),
);
final inspectTrackingStateUseCaseProvider =
    Provider<InspectTrackingStateUseCase>(
      (ref) => InspectTrackingStateUseCase(ref.watch(deviceRepositoryProvider)),
    );
final exportBackupUseCaseProvider = Provider<ExportBackupUseCase>(
  (ref) => ExportBackupUseCase(ref.watch(backupRepositoryProvider)),
);
final restoreBackupUseCaseProvider = Provider<RestoreBackupUseCase>(
  (ref) => RestoreBackupUseCase(ref.watch(backupRepositoryProvider)),
);
final evaluateSpeedAlertUseCaseProvider = Provider<EvaluateSpeedAlertUseCase>(
  (ref) => const EvaluateSpeedAlertUseCase(),
);
final clearLocalDataUseCaseProvider = Provider<ClearLocalDataUseCase>(
  (ref) => ClearLocalDataUseCase(
    ref.watch(sessionTripRepositoryProvider),
    ref.watch(preferencesRepositoryProvider),
  ),
);

final discardTripUseCaseProvider = Provider<DiscardTripUseCase>(
  (ref) => DiscardTripUseCase(ref.watch(sessionTripRepositoryProvider)),
);
