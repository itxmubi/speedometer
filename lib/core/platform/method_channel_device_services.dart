import 'dart:async';

import 'package:flutter/services.dart';

import '../error/failure.dart';
import '../error/failure_kind.dart';
import '../error/result.dart';
import '../utils/logger.dart';
import 'device_services.dart';
import 'native_location_fix.dart';

/// Android method/event channels behind a replaceable, testable boundary.
final class MethodChannelDeviceServices implements DeviceServices {
  /// Uses app channels by default; tests can supply isolated channels.
  const MethodChannelDeviceServices({
    MethodChannel channel = const MethodChannel('speedometer/device'),
    EventChannel locationChannel = const EventChannel('speedometer/location'),
    EventChannel compassChannel = const EventChannel('speedometer/compass'),
    EventChannel statusChannel = const EventChannel('speedometer/tracking'),
    Logger logger = const Logger(),
  }) : _channel = channel,
       _locationChannel = locationChannel,
       _compassChannel = compassChannel,
       _statusChannel = statusChannel,
       _logger = logger;

  final MethodChannel _channel;
  final EventChannel _locationChannel;
  final EventChannel _compassChannel;
  final EventChannel _statusChannel;
  final Logger _logger;

  @override
  Future<Result<void>> applyDisplay({
    required bool keepAwake,
    required double brightness,
  }) => _void('applyDisplay', {
    'keepAwake': keepAwake,
    'brightness': brightness.isFinite ? brightness.clamp(-1, 1) : -1.0,
  });

  @override
  Future<Result<void>> emitAlert({
    required bool sound,
    required bool vibration,
    required bool voice,
    required double volume,
    required String message,
    required String languageTag,
  }) => _void('emitAlert', {
    'sound': sound,
    'vibration': vibration,
    'voice': voice,
    'volume': volume.isFinite ? volume.clamp(0, 1) : 0.0,
    'message': message,
    'languageTag': languageTag,
  });

  @override
  Future<Result<void>> updateTrackingDisplay({
    required double? speedMetersPerSecond,
    required double displaySpeed,
    required String unit,
    required bool overLimit,
    required String status,
    required String notificationTitle,
    required String stopLabel,
  }) => _void('updateTrackingDisplay', {
    'speedMetersPerSecond': speedMetersPerSecond,
    'displaySpeed': displaySpeed.isFinite ? displaySpeed : 0.0,
    'unit': unit,
    'overLimit': overLimit,
    'status': status,
    'notificationTitle': notificationTitle,
    'stopLabel': stopLabel,
  });

  @override
  Future<Result<void>> setOverlayEnabled(bool enabled) =>
      _void('setOverlayEnabled', {'enabled': enabled});

  @override
  Future<Result<bool>> canDrawOverlays() => _bool('canDrawOverlays');

  @override
  Future<Result<void>> requestOverlayPermission() =>
      _void('requestOverlayPermission');

  @override
  Future<Result<void>> startTracking() => _void('startTracking');

  @override
  Future<Result<void>> setGpsInterval(Duration interval) => _void(
    'setGpsInterval',
    {'milliseconds': interval.inMilliseconds.clamp(1000, 3000)},
  );

  @override
  Future<Result<void>> stopTracking() => _void('stopTracking');

  @override
  Future<Result<bool>> isTracking() => _bool('isTracking');

  @override
  Future<Result<void>> dispose() => _void('dispose');

  @override
  Stream<Result<NativeLocationFix>> watchLocation() =>
      _results(_locationChannel, (event) {
        final fix = event is Map<Object?, Object?>
            ? NativeLocationFix.fromMap(event)
            : null;
        if (fix == null) {
          _logger.error('native_location_invalid');
          return const Error(Failure(FailureKind.locationUnavailable));
        }
        return Success(fix);
      });

  @override
  Stream<Result<double>> watchCompass() => _results(
    _compassChannel,
    (event) => event is num && event.isFinite && event >= 0 && event < 360
        ? Success(event.toDouble())
        : const Error(Failure(FailureKind.locationUnavailable)),
  );

  @override
  Stream<bool> watchTrackingStatus() =>
      _statusChannel.receiveBroadcastStream().transform(
        StreamTransformer<Object?, bool>.fromHandlers(
          handleData: (event, sink) {
            if (event is bool) sink.add(event);
          },
          handleError: (error, stack, sink) {
            _logger.error('native_tracking_status_failed');
            sink.add(false);
          },
        ),
      );

  // Direct transformation preserves immediate cancellation even when GPS has
  // never produced a fix. Async generators can wait for the next native event.
  Stream<Result<T>> _results<T>(
    EventChannel channel,
    Result<T> Function(Object?) convert,
  ) => channel.receiveBroadcastStream().transform(
    StreamTransformer<Object?, Result<T>>.fromHandlers(
      handleData: (event, sink) => sink.add(convert(event)),
      handleError: (error, stack, sink) {
        if (error is PlatformException) {
          sink.add(Error(_failure(error)));
        } else {
          _logger.error('native_stream_failed');
          sink.add(
            Error(
              Failure(
                error is MissingPluginException
                    ? FailureKind.unsupported
                    : FailureKind.unexpected,
              ),
            ),
          );
        }
      },
    ),
  );

  Future<Result<void>> _void(
    String method, [
    Map<String, Object?>? arguments,
  ]) async {
    try {
      await _channel.invokeMethod<void>(method, arguments);
      return const Success(null);
    } on PlatformException catch (error) {
      return Error(_failure(error));
    } on MissingPluginException {
      return const Error(Failure(FailureKind.unsupported));
    } on Object {
      _logger.error('native_operation_failed');
      return const Error(Failure(FailureKind.unexpected));
    }
  }

  Future<Result<bool>> _bool(String method) async {
    try {
      final value = await _channel.invokeMethod<bool>(method);
      return value == null
          ? const Error(Failure(FailureKind.unexpected))
          : Success(value);
    } on PlatformException catch (error) {
      return Error(_failure(error));
    } on MissingPluginException {
      return const Error(Failure(FailureKind.unsupported));
    } on Object {
      _logger.error('native_operation_failed');
      return const Error(Failure(FailureKind.unexpected));
    }
  }

  Failure _failure(PlatformException error) {
    _logger.error('native_operation_failed');
    return Failure(switch (error.code) {
      'permission_denied' ||
      'overlay_permission' => FailureKind.permissionDenied,
      'permission_denied_forever' => FailureKind.permissionDeniedForever,
      'location_disabled' => FailureKind.locationDisabled,
      'location_unavailable' => FailureKind.locationUnavailable,
      'unsupported' => FailureKind.unsupported,
      _ => FailureKind.unexpected,
    });
  }
}
