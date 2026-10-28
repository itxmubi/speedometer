import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../../../activities/domain/entities/activity_mode.dart';
import '../../domain/entities/display_preferences.dart';
import '../../../trips/domain/entities/recorded_trip.dart';
import '../../../trips/domain/entities/trip_totals.dart';
import '../../domain/entities/gauge_style.dart';
import '../../domain/entities/speed_alert_state.dart';
import '../../domain/entities/speed_reading.dart';
import '../../domain/entities/speed_unit.dart';
import '../../domain/entities/tracking_display.dart';
import '../../domain/entities/trip_stats.dart';
import 'speedometer_providers.dart';
import 'speedometer_state.dart';

/// App-wide session: survives navigation and a user-started foreground service.
final speedometerControllerProvider =
    NotifierProvider<SpeedometerController, SpeedometerState>(
      SpeedometerController.new,
    );

/// Coordinates domain actions and cancellation-safe local trip checkpoints.
class SpeedometerController extends Notifier<SpeedometerState> {
  StreamSubscription<Result<SpeedReading>>? _subscription;
  StreamSubscription<Result<double>>? _compass;
  StreamSubscription<bool>? _nativeStatus;
  StreamSubscription<Result<TripTotals>>? _totals;
  Future<void> _pendingStart = Future<void>.value();
  Future<void> _pendingSave = Future<void>.value();
  Future<void> _pendingCancellation = Future<void>.value();
  Future<void> _pendingTripWrite = Future<void>.value();
  int _sessionGeneration = 0;
  int _preferencesLoadGeneration = 0;
  int _preferencesSaveGeneration = 0;
  bool _nativeWasTracking = false;
  SpeedAlertState _alertState = const SpeedAlertState();

  @override
  SpeedometerState build() {
    ref.onDispose(() {
      _sessionGeneration++;
      _preferencesLoadGeneration++;
      unawaited(_subscription?.cancel());
      unawaited(_compass?.cancel());
      unawaited(_nativeStatus?.cancel());
      unawaited(_totals?.cancel());
    });
    unawaited(Future<void>.microtask(loadPreferences));
    return const SpeedometerState();
  }

  /// Restores settings and the last durable trip without inventing a GPS bridge.
  Future<void> loadPreferences() async {
    if (!ref.mounted) return;
    final generation = ++_preferencesLoadGeneration;
    state = state.copyWith(
      preferencesLoad: const AsyncLoading<void>(),
      clearFailure: true,
    );
    final result = await ref.read(loadPreferencesUseCaseProvider)();
    if (!ref.mounted || generation != _preferencesLoadGeneration) return;
    switch (result) {
      case Error(:final failure):
        state = state.copyWith(
          failure: failure,
          preferencesLoad: AsyncError<void>(failure, StackTrace.empty),
        );
      case Success(:final value):
        state = state.copyWith(preferences: value);
        await _recoverTrip(generation);
    }
  }

  Future<void> _recoverTrip(int generation) async {
    final recovered = await ref.read(getActiveTripUseCaseProvider)();
    if (!ref.mounted || generation != _preferencesLoadGeneration) return;
    if (recovered case Error(:final failure)) {
      state = state.copyWith(
        failure: failure,
        preferencesLoad: AsyncError<void>(failure, StackTrace.empty),
      );
      return;
    }
    final active = (recovered as Success<RecordedTrip?>).value;
    state = state.copyWith(
      trip: active?.stats.withoutLastReading() ?? const TripStats(),
      activeTripId: active?.id,
      clearActiveTrip: active == null,
      status: active == null ? TrackingStatus.idle : TrackingStatus.paused,
      clearReading: true,
    );
    _attachPlatformObservers();
    await _syncPlatform();
    if (!ref.mounted || generation != _preferencesLoadGeneration) return;
    final running = await ref.read(inspectTrackingStateUseCaseProvider)();
    if (!ref.mounted || generation != _preferencesLoadGeneration) return;
    state = state.copyWith(preferencesLoad: const AsyncData<void>(null));
    if (running case Success(value: true)) {
      // Reattach only to a service already started by the user; never restart it.
      if (state.activeTripId != null) await start();
    } else if (state.activeTripId != null) {
      unawaited(_checkpoint(paused: true));
    }
  }

  /// Allows recovery with defaults when the settings document is unavailable.
  void useDefaultPreferences() {
    final generation = ++_preferencesLoadGeneration;
    state = state.copyWith(
      preferencesLoad: const AsyncData<void>(null),
      clearFailure: true,
    );
    unawaited(_recoverTrip(generation));
  }

  void _attachPlatformObservers() {
    _totals ??= ref
        .read(watchTripTotalsUseCaseProvider)()
        .listen(
          (result) {
            if (!ref.mounted) return;
            switch (result) {
              case Success(:final value):
                state = state.copyWith(totals: value);
              case Error(:final failure):
                state = state.copyWith(failure: failure);
            }
          },
          onError: (Object error) {
            if (ref.mounted) {
              ref.read(loggerProvider).error('trip_totals_stream_failed');
            }
          },
        );
    _nativeStatus ??= ref
        .read(watchTrackingStatusUseCaseProvider)()
        .listen(
          (running) {
            if (!ref.mounted) return;
            if (running) {
              _nativeWasTracking = true;
              return;
            }
            if (_nativeWasTracking) {
              _nativeWasTracking = false;
              unawaited(pause());
            }
          },
          onError: (Object error) {
            if (ref.mounted) {
              ref.read(loggerProvider).error('native_status_stream_failed');
            }
          },
        );
    _startCompass();
  }

  void _startCompass() {
    if (_compass != null ||
        !state.isAppVisible ||
        !state.hasDisclosureConsent) {
      return;
    }
    _compass = ref
        .read(watchCompassUseCaseProvider)()
        .listen(
          (result) {
            if (!ref.mounted) return;
            switch (result) {
              case Success(:final value):
                state = state.copyWith(compassHeadingDegrees: value);
              case Error():
                state = state.copyWith(clearCompass: true);
            }
          },
          onError: (Object error) {
            if (ref.mounted) state = state.copyWith(clearCompass: true);
          },
        );
  }

  /// Requests permission and starts a persistent session only after explicit Start.
  Future<void> start() {
    if (state.isBusy ||
        state.status == TrackingStatus.starting ||
        state.status == TrackingStatus.tracking) {
      return Future.value();
    }
    return _pendingStart = _start();
  }

  Future<void> _start() async {
    if (!state.hasDisclosureConsent ||
        state.isLoadingPreferences ||
        state.isBusy ||
        state.status == TrackingStatus.starting ||
        state.status == TrackingStatus.tracking) {
      return;
    }
    final generation = ++_sessionGeneration;
    state = state.copyWith(
      status: TrackingStatus.starting,
      clearFailure: true,
      clearReading: true,
      trip: state.trip.withoutLastReading(),
    );
    await _cancelTracking();
    await _pendingTripWrite;
    if (!ref.mounted || generation != _sessionGeneration) return;
    final permission = await ref.read(prepareLocationUseCaseProvider)();
    if (!ref.mounted || generation != _sessionGeneration) return;
    if (permission case Error(:final failure)) {
      _failSession(failure, generation);
      return;
    }
    if (state.activeTripId == null) {
      final created = await ref.read(startTripUseCaseProvider)(
        ref.read(clockProvider)(),
      );
      if (!ref.mounted) return;
      if (created case Error(:final failure)) {
        _failSession(failure, generation);
        return;
      }
      state = state.copyWith(activeTripId: (created as Success<String>).value);
      if (generation != _sessionGeneration) {
        unawaited(_checkpoint(paused: true));
        return;
      }
    }
    state = state.copyWith(status: TrackingStatus.tracking);
    _subscription = ref
        .read(watchSpeedUseCaseProvider)()
        .listen(
          (result) => _onReading(result, generation),
          onError: (Object error, StackTrace stack) {
            if (!ref.mounted) return;
            ref.read(loggerProvider).error('unexpected_location_stream_error');
            _failSession(
              const Failure(FailureKind.locationUnavailable),
              generation,
            );
          },
          onDone: () {
            if (ref.mounted &&
                generation == _sessionGeneration &&
                state.status == TrackingStatus.tracking) {
              _failSession(
                const Failure(FailureKind.locationUnavailable),
                generation,
              );
            }
          },
        );
    unawaited(_checkpoint(paused: false));
    await _syncPlatform();
  }

  void _onReading(Result<SpeedReading> result, int generation) {
    if (!ref.mounted || generation != _sessionGeneration) return;
    switch (result) {
      case Success(:final value):
        final trip = ref.read(updateTripUseCaseProvider)(
          previous: state.trip,
          reading: value,
          calibrationFactor: state.preferences.calibrationFactor,
        );
        state = state.copyWith(
          reading: value,
          trip: trip,
          clearFailure: state.failure?.kind != FailureKind.storage,
        );
        final accepted = trip.lastReading?.timestamp == value.timestamp;
        unawaited(_checkpoint(paused: false, reading: accepted ? value : null));
        final decision = ref.read(evaluateSpeedAlertUseCaseProvider)(
          preferences: state.preferences,
          speedMetersPerSecond: value.speedMetersPerSecond,
          now: ref.read(clockProvider)(),
          previous: _alertState,
        );
        _alertState = decision.state;
        if (decision.shouldAlert) {
          final strings = ref.read(
            dashboardLocalizationsProvider(state.preferences.localeCode),
          );
          unawaited(
            _reportOutput(
              ref.read(issueSpeedAlertUseCaseProvider)(
                state.preferences,
                message: strings.warningSpoken,
                languageTag: strings.localeName,
              ),
            ),
          );
        }
      case Error(:final failure):
        if (failure.kind == FailureKind.locationUnavailable) {
          state = state.copyWith(
            failure: failure,
            clearReading: true,
            trip: state.trip.withoutLastReading(),
          );
          unawaited(_checkpoint(paused: true));
        } else {
          _failSession(failure, generation);
        }
    }
    unawaited(_syncPlatform(applySettings: false));
  }

  bool get _isOverLimit => ref.read(evaluateSpeedLimitUseCaseProvider)(
    speedMetersPerSecond: state.reading?.speedMetersPerSecond ?? 0,
    limitMetersPerSecond:
        state.preferences.speedLimitMetersPerSecond +
        state.preferences.alertOffsetMetersPerSecond,
    enabled: state.preferences.limitEnabled,
  );

  Future<Result<void>> _checkpoint({
    required bool paused,
    SpeedReading? reading,
  }) {
    final id = state.activeTripId;
    if (id == null) return Future.value(const Success(null));
    final stats = state.trip;
    final preferences = state.preferences;
    final overLimit = _isOverLimit;
    final checkpoint = ref.read(checkpointTripUseCaseProvider);
    final write = _pendingTripWrite.then((_) async {
      final result = await checkpoint(
        id: id,
        stats: stats,
        reading: reading,
        recordRoute: preferences.recordRoute,
        overLimit: overLimit,
        paused: paused,
      );
      if (result case Error(:final failure) when ref.mounted) {
        state = state.copyWith(failure: failure);
        if (state.status == TrackingStatus.tracking) unawaited(pause());
      }
      return result;
    });
    _pendingTripWrite = write.then((_) {});
    return write;
  }

  void _failSession(Failure failure, int generation) {
    if (!ref.mounted || generation != _sessionGeneration) return;
    _sessionGeneration++;
    unawaited(_cancelTracking());
    state = state.copyWith(
      status: TrackingStatus.failure,
      failure: failure,
      clearReading: true,
      trip: state.trip.withoutLastReading(),
      overlayEnabled: false,
    );
    unawaited(_checkpoint(paused: true));
    unawaited(_syncPlatform());
  }

  /// Stops GPS and checkpoints a pause boundary before returning.
  Future<void> pause() async {
    if (state.status != TrackingStatus.tracking &&
        state.status != TrackingStatus.starting) {
      return;
    }
    _sessionGeneration++;
    state = state.copyWith(
      status: TrackingStatus.paused,
      clearReading: true,
      trip: state.trip.withoutLastReading(),
      overlayEnabled: false,
    );
    unawaited(_checkpoint(paused: true));
    await _cancelTracking();
    if (ref.mounted) await _syncPlatform();
    await _pendingTripWrite;
  }

  Future<void> _cancelTracking() {
    final subscription = _subscription;
    _subscription = null;
    final logger = ref.read(loggerProvider);
    _pendingCancellation = _pendingCancellation.then((_) async {
      try {
        await subscription?.cancel();
      } catch (_) {
        logger.error('location_cancel_failed');
      }
    });
    return _pendingCancellation;
  }

  /// Finishes a session, retaining it only when automatic saving is enabled.
  Future<void> finish() =>
      _completeTrip(discard: !state.preferences.autoRecordTrips);

  /// Discards history only after the final statistics have been committed.
  Future<void> reset() => _completeTrip(discard: true);

  Future<void> _completeTrip({required bool discard}) async {
    if (state.isBusy) return;
    state = state.copyWith(isBusy: true, clearFailure: true);
    await pause();
    await _pendingStart;
    await _pendingTripWrite;
    if (!ref.mounted) return;
    // A paused session may contain statistics from a failed earlier checkpoint.
    // Retry them before either saving or discarding so odometer data is durable.
    final checkpoint = await _checkpoint(paused: true);
    if (!ref.mounted) return;
    if (checkpoint case Error(:final failure)) {
      state = state.copyWith(isBusy: false, failure: failure);
      return;
    }
    final id = state.activeTripId;
    if (id != null) {
      final result = discard
          ? await ref.read(discardTripUseCaseProvider)(id)
          : await ref.read(finishTripUseCaseProvider)(
              id,
              ref.read(clockProvider)(),
            );
      if (!ref.mounted) return;
      if (result case Error(:final failure)) {
        state = state.copyWith(isBusy: false, failure: failure);
        return;
      }
    }
    state = state.copyWith(
      trip: const TripStats(),
      status: TrackingStatus.idle,
      clearReading: true,
      clearActiveTrip: true,
      clearFailure: true,
      isBusy: false,
    );
    _alertState = const SpeedAlertState();
    await _syncPlatform();
  }

  /// Keeps active foreground service sessions alive; optional foreground-only pauses.
  Future<void> setAppVisible(bool visible) async {
    state = state.copyWith(isAppVisible: visible);
    if (!visible) {
      await _compass?.cancel();
      _compass = null;
      if (!ref.mounted) return;
      if (!state.isAppVisible && !state.preferences.backgroundTracking) {
        await pause();
      }
    } else {
      unawaited(_totals?.cancel());
      _totals = null;
      if (!ref.mounted) return;
      _attachPlatformObservers();
      _startCompass();
      if (state.overlayPermissionRequired) {
        final permission = await ref.read(
          checkOverlayPermissionUseCaseProvider,
        )();
        if (!ref.mounted) return;
        if (permission case Success(value: true)) {
          state = state.copyWith(overlayPermissionRequired: false);
        }
      }
    }
    if (ref.mounted) await _syncPlatform();
  }

  Future<void> _syncPlatform({bool applySettings = true}) async {
    if (!ref.mounted) return;
    final preferences = state.preferences;
    final awake = state.isAppVisible && state.status == TrackingStatus.tracking;
    if (applySettings) {
      await ref.read(applyDeviceSettingsUseCaseProvider)(
        preferences,
        awake: awake,
      );
    }
    if (!ref.mounted) return;
    final strings = ref.read(
      dashboardLocalizationsProvider(state.preferences.localeCode),
    );
    final unit = switch (preferences.unit) {
      SpeedUnit.kilometersPerHour => strings.unitKilometers,
      SpeedUnit.milesPerHour => strings.unitMiles,
      SpeedUnit.metersPerSecond => strings.unitMeters,
      SpeedUnit.knots => strings.unitKnots,
    };
    await ref.read(updateTrackingDisplayUseCaseProvider)(
      TrackingDisplay(
        speedMetersPerSecond: state.reading?.speedMetersPerSecond,
        displaySpeed: preferences.unit.fromMetersPerSecond(
          state.reading?.speedMetersPerSecond ?? 0,
        ),
        unit: unit,
        overLimit: _isOverLimit,
        status: state.status == TrackingStatus.tracking
            ? strings.nativeTracking
            : strings.nativePaused,
        notificationTitle: strings.notificationTitle,
        stopLabel: strings.notificationStop,
      ),
    );
  }

  Future<void> _reportOutput(Future<Result<void>> action) async {
    final result = await action;
    if (!ref.mounted) return;
    if (result is Error<void>) {
      ref.read(loggerProvider).error('optional_device_output_unavailable');
    }
  }

  /// Persists a validated display choice, serializing writes in request order.
  Future<void> updatePreferences(DisplayPreferences preferences) =>
      _save(preferences);
  Future<void> _save(DisplayPreferences preferences) {
    if (!ref.mounted ||
        ((state.activeTripId != null ||
                state.status == TrackingStatus.starting) &&
            (preferences.activityMode != state.preferences.activityMode ||
                preferences.bodyWeightKilograms !=
                    state.preferences.bodyWeightKilograms))) {
      return Future<void>.value();
    }
    if (!preferences.hasValidValues) return Future<void>.value();
    final generation = ++_preferencesSaveGeneration;
    state = state.copyWith(
      preferences: preferences,
      clearFailure: state.failure?.kind == FailureKind.storage,
    );
    final save = ref.read(savePreferencesUseCaseProvider);
    _pendingSave = _pendingSave.then((_) async {
      final result = await save(preferences);
      if (!ref.mounted || generation != _preferencesSaveGeneration) return;
      if (result case Error(:final failure)) {
        state = state.copyWith(failure: failure);
      }
      if (!state.isAppVisible && !state.preferences.backgroundTracking) {
        await pause();
      }
      if (ref.mounted) await _syncPlatform();
    });
    return _pendingSave;
  }

  Future<void> acceptDisclosure() =>
      _save(state.preferences.copyWith(hasDisclosureConsent: true));
  Future<void> setUnit(SpeedUnit value) =>
      _save(state.preferences.copyWith(unit: value));
  Future<void> setGaugeStyle(GaugeStyle value) =>
      _save(state.preferences.copyWith(gaugeStyle: value));
  Future<void> setMirrored(bool value) =>
      _save(state.preferences.copyWith(mirroredHud: value));
  Future<void> setSimpleView(bool value) =>
      _save(state.preferences.copyWith(simpleView: value));
  Future<void> setDarkMode(bool value) =>
      _save(state.preferences.copyWith(darkMode: value));
  Future<void> setLimitEnabled(bool value) =>
      _save(state.preferences.copyWith(limitEnabled: value));
  Future<void> setSpeedLimit(double value) => _save(
    state.preferences.copyWith(
      speedLimitMetersPerSecond:
          value / state.preferences.unit.fromMetersPerSecond(1),
    ),
  );
  Future<void> setKeepAwake(bool value) =>
      _save(state.preferences.copyWith(keepAwake: value));
  Future<void> setBrightness(double value) =>
      _save(state.preferences.copyWith(brightness: value));
  Future<void> setAccentColorIndex(int value) =>
      _save(state.preferences.copyWith(accentColorIndex: value));
  Future<void> setLeftHanded(bool value) =>
      _save(state.preferences.copyWith(leftHanded: value));
  Future<void> setGaugeRange(double value) => _save(
    state.preferences.copyWith(
      gaugeRangeMetersPerSecond:
          value / state.preferences.unit.fromMetersPerSecond(1),
    ),
  );
  Future<void> setNightHud(bool value) =>
      _save(state.preferences.copyWith(nightHud: value));
  Future<void> setHudContent({
    bool? showTime,
    bool? showCompass,
    bool? showTrip,
  }) => _save(
    state.preferences.copyWith(
      hudShowTime: showTime,
      hudShowCompass: showCompass,
      hudShowTrip: showTrip,
    ),
  );
  Future<void> setSoundAlert(bool value) =>
      _save(state.preferences.copyWith(soundAlert: value));
  Future<void> setVibrationAlert(bool value) =>
      _save(state.preferences.copyWith(vibrationAlert: value));
  Future<void> setVoiceAlert(bool value) =>
      _save(state.preferences.copyWith(voiceAlert: value));
  Future<void> setAlertVolume(double value) =>
      _save(state.preferences.copyWith(alertVolume: value));
  Future<void> setAlertOffset(double value) => _save(
    state.preferences.copyWith(
      alertOffsetMetersPerSecond:
          value / state.preferences.unit.fromMetersPerSecond(1),
    ),
  );
  Future<void> setCalibrationFactor(double value) =>
      _save(state.preferences.copyWith(calibrationFactor: value));
  Future<void> setRecordRoute(bool value) =>
      _save(state.preferences.copyWith(recordRoute: value));
  Future<void> setAutoRecordTrips(bool value) =>
      _save(state.preferences.copyWith(autoRecordTrips: value));
  Future<void> setBackgroundTracking(bool value) =>
      _save(state.preferences.copyWith(backgroundTracking: value));
  Future<void> setLocaleCode(String? value) => _save(
    state.preferences.copyWith(
      localeCode: value,
      clearLocaleCode: value == null,
    ),
  );
  Future<void> setEconomyGps(bool value) =>
      _save(state.preferences.copyWith(economyGps: value));

  /// Changes activities only between trips and restores remembered instruments.
  Future<void> setActivityMode(ActivityMode mode) {
    if (state.isBusy ||
        state.isLoadingPreferences ||
        state.status == TrackingStatus.starting ||
        state.activeTripId != null) {
      return Future<void>.value();
    }
    final preferences = ref.read(selectActivityUseCaseProvider)(
      preferences: state.preferences,
      mode: mode,
      hasActiveTrip: state.activeTripId != null,
    );
    if (preferences == state.preferences) return Future<void>.value();
    return _save(preferences);
  }

  /// Weight is optional and stays fixed for the whole current trip.
  Future<void> setBodyWeight(double? kilograms) {
    if (state.isBusy ||
        state.isLoadingPreferences ||
        state.status == TrackingStatus.starting ||
        state.activeTripId != null) {
      return Future<void>.value();
    }
    return _save(
      state.preferences.copyWith(
        bodyWeightKilograms: kilograms,
        clearBodyWeight: kilograms == null,
      ),
    );
  }

  /// Enables overlay only after the explanation and special permission grant.
  Future<void> enableOverlay() async {
    final permission = await ref.read(checkOverlayPermissionUseCaseProvider)();
    if (!ref.mounted) return;
    if (permission case Success(value: true)) {
      final result = await ref.read(setOverlayUseCaseProvider)(true);
      if (!ref.mounted) return;
      if (result case Error(:final failure)) {
        state = state.copyWith(failure: failure);
        return;
      }
      state = state.copyWith(
        overlayEnabled: true,
        overlayPermissionRequired: false,
      );
    } else {
      state = state.copyWith(overlayPermissionRequired: true);
    }
  }

  Future<void> disableOverlay() async {
    await ref.read(setOverlayUseCaseProvider)(false);
    if (ref.mounted) state = state.copyWith(overlayEnabled: false);
  }

  Future<void> openOverlaySettings() async {
    await ref.read(requestOverlayPermissionUseCaseProvider)();
  }

  /// Exports current settings and all persisted trips through the OS share sheet.
  Future<void> exportBackup() async {
    if (state.isBusy) return;
    state = state.copyWith(isBusy: true, clearFailure: true);
    await _pendingTripWrite;
    if (!ref.mounted) return;
    final result = await ref.read(exportBackupUseCaseProvider)(
      state.preferences,
      subject: ref
          .read(dashboardLocalizationsProvider(state.preferences.localeCode))
          .exportBackup,
    );
    if (!ref.mounted) return;
    state = state.copyWith(isBusy: false);
    if (result case Error(:final failure)) {
      state = state.copyWith(failure: failure);
    }
  }

  /// Stops tracking, validates a local document, and atomically replaces trips.
  Future<void> restoreBackup() async {
    if (state.isBusy) return;
    state = state.copyWith(isBusy: true, clearFailure: true);
    await pause();
    await _pendingTripWrite;
    await _pendingSave;
    if (!ref.mounted) return;
    final result = await ref.read(restoreBackupUseCaseProvider)();
    if (!ref.mounted) return;
    state = state.copyWith(isBusy: false);
    switch (result) {
      case Error(:final failure):
        state = state.copyWith(failure: failure);
      case Success(:final value):
        if (value != null) {
          state = state.copyWith(preferences: value);
          await _recoverTrip(++_preferencesLoadGeneration);
        }
    }
  }

  Future<void> resetPreferences() =>
      _save(const DisplayPreferences(hasDisclosureConsent: true));

  /// User-confirmed deletion includes the lifetime odometer and saved settings.
  Future<void> deleteAllData() async {
    if (state.isBusy) return;
    state = state.copyWith(isBusy: true);
    await pause();
    await _pendingTripWrite;
    await _pendingSave;
    if (!ref.mounted) return;
    final result = await ref.read(clearLocalDataUseCaseProvider)();
    if (!ref.mounted) return;
    if (result case Error(:final failure)) {
      state = state.copyWith(isBusy: false, failure: failure);
      return;
    }
    state = const SpeedometerState(preferencesLoad: AsyncData<void>(null));
    await _syncPlatform();
  }

  Future<void> openAppSettings() async {
    final result = await ref.read(openAppSettingsUseCaseProvider)();
    if (!ref.mounted) return;
    if (result case Error(:final failure)) {
      state = state.copyWith(failure: failure);
    }
  }

  Future<void> openLocationSettings() async {
    final result = await ref.read(openLocationSettingsUseCaseProvider)();
    if (!ref.mounted) return;
    if (result case Error(:final failure)) {
      state = state.copyWith(failure: failure);
    }
  }

  void clearFailure() => state = state.copyWith(clearFailure: true);
}
