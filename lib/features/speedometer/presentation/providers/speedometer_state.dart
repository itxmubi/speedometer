import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/display_preferences.dart';
import '../../../trips/domain/entities/trip_totals.dart';
import '../../domain/entities/speed_reading.dart';
import '../../domain/entities/trip_stats.dart';
import 'tracking_status.dart';

export 'tracking_status.dart';

/// Immutable dashboard state backed by durable local trip checkpoints.
class SpeedometerState {
  /// Creates the initial or current session state.
  const SpeedometerState({
    this.trip = const TripStats(),
    this.reading,
    this.status = TrackingStatus.idle,
    this.failure,
    this.preferences = const DisplayPreferences(),
    this.preferencesLoad = const AsyncLoading<void>(),
    this.totals = const TripTotals(),
    this.activeTripId,
    this.compassHeadingDegrees,
    this.overlayEnabled = false,
    this.overlayPermissionRequired = false,
    this.isBusy = false,
    this.isAppVisible = true,
  });

  /// Durable aggregate odometer and calendar totals.
  final TripTotals totals;

  /// Identifier of the recoverable, checkpointed current trip.
  final String? activeTripId;

  /// Magnetic compass heading when the device supplies the sensor.
  final double? compassHeadingDegrees;
  final bool overlayEnabled;
  final bool overlayPermissionRequired;
  final bool isBusy;
  final bool isAppVisible;

  /// Statistics accumulated in the current process session.
  final TripStats trip;

  /// Latest reliable fix, cleared whenever acquisition is interrupted.
  final SpeedReading? reading;

  /// Current acquisition and user-control lifecycle.
  final TrackingStatus status;

  /// Expected failure that the UI can translate without raw platform details.
  final Failure? failure;

  /// The latest device-local display and disclosure choices.
  final DisplayPreferences preferences;

  /// Explicit loading, error, and data states for startup preferences.
  final AsyncValue<void> preferencesLoad;

  /// Whether the startup settings request is in flight.
  bool get isLoadingPreferences => preferencesLoad.isLoading;

  /// Whether startup requires retry or an explicit defaults choice.
  bool get initializationFailed => preferencesLoad.hasError;

  /// Whether the user has read and accepted the foreground location disclosure.
  bool get hasDisclosureConsent => preferences.hasDisclosureConsent;

  /// Copies state, explicitly clearing nullable values when requested.
  SpeedometerState copyWith({
    TripStats? trip,
    SpeedReading? reading,
    bool clearReading = false,
    TrackingStatus? status,
    Failure? failure,
    bool clearFailure = false,
    DisplayPreferences? preferences,
    AsyncValue<void>? preferencesLoad,
    TripTotals? totals,
    String? activeTripId,
    bool clearActiveTrip = false,
    double? compassHeadingDegrees,
    bool clearCompass = false,
    bool? overlayEnabled,
    bool? overlayPermissionRequired,
    bool? isBusy,
    bool? isAppVisible,
  }) => SpeedometerState(
    trip: trip ?? this.trip,
    reading: clearReading ? null : reading ?? this.reading,
    status: status ?? this.status,
    failure: clearFailure ? null : failure ?? this.failure,
    preferences: preferences ?? this.preferences,
    preferencesLoad: preferencesLoad ?? this.preferencesLoad,
    totals: totals ?? this.totals,
    activeTripId: clearActiveTrip ? null : activeTripId ?? this.activeTripId,
    compassHeadingDegrees: clearCompass
        ? null
        : compassHeadingDegrees ?? this.compassHeadingDegrees,
    overlayEnabled: overlayEnabled ?? this.overlayEnabled,
    overlayPermissionRequired:
        overlayPermissionRequired ?? this.overlayPermissionRequired,
    isBusy: isBusy ?? this.isBusy,
    isAppVisible: isAppVisible ?? this.isAppVisible,
  );
}
