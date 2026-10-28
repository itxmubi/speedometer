import 'dart:async';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_kind.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/speed_reading.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/services/gps_quality_policy.dart';
import '../../domain/usecases/smooth_speed_use_case.dart';
import '../../domain/services/gps_segment_policy.dart';
import '../datasources/location_data_source.dart';

/// Translates plugin data and failures into privacy-safe domain outcomes.
final class GeolocatorLocationRepository implements LocationRepository {
  /// Injects the platform adapter and a clock for deterministic freshness tests.
  const GeolocatorLocationRepository(
    this._dataSource, {
    DateTime Function() now = DateTime.now,
    Logger logger = const Logger(),
    Duration inactivityTimeout = GpsQualityPolicy.maximumSampleGap,
  }) : _now = now,
       _logger = logger,
       _inactivityTimeout = inactivityTimeout;

  final LocationDataSource _dataSource;
  final DateTime Function() _now;
  final Logger _logger;
  final Duration _inactivityTimeout;

  static const Duration _maximumFixAge = Duration(seconds: 5);
  static const Duration _maximumFutureOffset = Duration(seconds: 5);

  @override
  Future<Result<void>> prepare() async {
    try {
      if (!await _dataSource.isLocationServiceEnabled()) {
        return const Error(Failure(FailureKind.locationDisabled));
      }
      var permission = await _dataSource.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _dataSource.requestPermission();
      }
      return switch (permission) {
        LocationPermission.always ||
        LocationPermission.whileInUse => const Success(null),
        LocationPermission.deniedForever => const Error(
          Failure(FailureKind.permissionDeniedForever),
        ),
        LocationPermission.denied => const Error(
          Failure(FailureKind.permissionDenied),
        ),
        LocationPermission.unableToDetermine => const Error(
          Failure(FailureKind.unsupported),
        ),
      };
    } catch (exception) {
      return Error(_failureFor(exception));
    }
  }

  @override
  Stream<Result<SpeedReading>> watch() {
    DateTime? lastTimestamp;
    SpeedReading? previous;
    SpeedReading? segmentAnchor;
    try {
      // A transformer forwards cancellation immediately even when native GPS
      // never supplies another event. An awaiting async* generator cannot.
      return _dataSource
          .watchPositions()
          .transform(
            StreamTransformer<Position, Result<SpeedReading>>.fromHandlers(
              handleData: (position, sink) {
                final reading = _toReading(position);
                if (!_hasUsableMeasurements(position) ||
                    !GpsQualityPolicy.isUsable(reading) ||
                    !_isFresh(position.timestamp)) {
                  previous = null;
                  segmentAnchor = null;
                  sink.add(
                    const Error(Failure(FailureKind.locationUnavailable)),
                  );
                  return;
                }
                if (lastTimestamp case final previous?) {
                  final interval = position.timestamp.difference(previous);
                  if (interval < GpsQualityPolicy.minimumSampleInterval) return;
                }
                if (segmentAnchor case final anchor?) {
                  final interval = reading.timestamp.difference(
                    anchor.timestamp,
                  );
                  if (interval <= GpsQualityPolicy.maximumSampleGap &&
                      GpsSegmentPolicy.isJump(
                        anchor,
                        reading,
                        GpsSegmentPolicy.distanceBetween(anchor, reading),
                        interval.inMicroseconds /
                            Duration.microsecondsPerSecond,
                      )) {
                    // Keep the last trustworthy anchor to reject repeated spikes.
                    previous = null;
                    sink.add(
                      const Error(Failure(FailureKind.locationUnavailable)),
                    );
                    return;
                  }
                }
                segmentAnchor = reading;
                lastTimestamp = position.timestamp;
                final smoothed = const SmoothSpeedUseCase()(
                  reading,
                  previous: previous,
                );
                previous = smoothed;
                sink.add(Success(smoothed));
              },
              handleError: (exception, stackTrace, sink) {
                sink.add(Error(_failureFor(exception)));
                sink.close();
              },
            ),
          )
          .timeout(
            _inactivityTimeout,
            onTimeout: (sink) {
              previous = null;
              segmentAnchor = null;
              lastTimestamp = null;
              _logger.error('location_locationUnavailable');
              // Signal loss clears the readout but keeps the user's session alive.
              // A new fix reanchors the trip; only explicit Stop cancels GPS.
              sink.add(const Error(Failure(FailureKind.locationUnavailable)));
            },
          );
    } catch (exception) {
      return Stream.value(Error(_failureFor(exception)));
    }
  }

  @override
  Future<Result<void>> openAppSettings() =>
      _openSettings(_dataSource.openAppSettings);

  @override
  Future<Result<void>> openLocationSettings() =>
      _openSettings(_dataSource.openLocationSettings);

  Future<Result<void>> _openSettings(Future<bool> Function() open) async {
    try {
      return await open()
          ? const Success(null)
          : const Error(Failure(FailureKind.unsupported));
    } catch (exception) {
      return Error(_failureFor(exception));
    }
  }

  bool _isFresh(DateTime timestamp) {
    final age = _now().difference(timestamp);
    return age <= _maximumFixAge && age >= -_maximumFutureOffset;
  }

  bool _hasUsableMeasurements(Position position) =>
      position.hasSpeed &&
      position.hasAccuracy &&
      (!position.hasSpeedAccuracy ||
          (position.speedAccuracy.isFinite &&
              position.speedAccuracy >= 0 &&
              position.speedAccuracy <=
                  GpsQualityPolicy.maximumSpeedAccuracyMetersPerSecond));

  SpeedReading _toReading(Position position) => SpeedReading(
    speedMetersPerSecond: GpsQualityPolicy.normalizeSpeed(position.speed),
    accuracyMeters: position.accuracy,
    altitudeMeters: position.hasAltitude && position.altitude.isFinite
        ? position.altitude
        : null,
    headingDegrees:
        position.hasHeading &&
            position.heading.isFinite &&
            position.heading >= 0 &&
            position.heading < 360
        ? position.heading
        : null,
    latitude: position.latitude,
    longitude: position.longitude,
    timestamp: position.timestamp,
  );

  Failure _failureFor(Object exception) {
    final kind = switch (exception) {
      LocationServiceDisabledException() => FailureKind.locationDisabled,
      PermissionDeniedException() ||
      InvalidPermissionException() => FailureKind.permissionDenied,
      MissingPluginException() || UnsupportedError() => FailureKind.unsupported,
      TimeoutException() ||
      PositionUpdateException() => FailureKind.locationUnavailable,
      _ => FailureKind.unexpected,
    };
    // Never attach plugin exception text: it can contain precise coordinates.
    _logger.error('location_${kind.name}');
    return Failure(kind);
  }
}
