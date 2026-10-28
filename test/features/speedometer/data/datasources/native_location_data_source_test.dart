import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedometer/core/platform/method_channel_device_services.dart';
import 'package:speedometer/features/speedometer/data/datasources/location_data_source.dart';
import 'package:speedometer/features/speedometer/data/datasources/native_location_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const methods = MethodChannel('native_source/device');
  const locationName = 'native_source/location';
  const locationMethods = MethodChannel(locationName);
  const services = MethodChannelDeviceServices(
    channel: methods,
    locationChannel: EventChannel(locationName),
  );
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final methodsCalled = <String>[];
  final eventCalls = <String>[];
  late _PermissionSource permissions;
  late NativeLocationDataSource source;

  setUp(() {
    methodsCalled.clear();
    eventCalls.clear();
    permissions = _PermissionSource();
    source = NativeLocationDataSource(services, permissions);
    messenger.setMockMethodCallHandler(methods, (call) async {
      methodsCalled.add(call.method);
      return null;
    });
    messenger.setMockMethodCallHandler(locationMethods, (call) async {
      eventCalls.add(call.method);
      return null;
    });
  });
  tearDown(() {
    messenger.setMockMethodCallHandler(methods, null);
    messenger.setMockMethodCallHandler(locationMethods, null);
  });

  Future<void> send(Object event) async {
    await messenger.handlePlatformMessage(
      locationName,
      const StandardMethodCodec().encodeSuccessEnvelope(event),
      (_) {},
    );
    await pumpEventQueue();
  }

  test(
    'creating a stream and checking permissions never starts native GPS',
    () async {
      source.watchPositions();
      expect(await source.isLocationServiceEnabled(), isTrue);
      expect(await source.checkPermission(), LocationPermission.denied);
      expect(await source.requestPermission(), LocationPermission.whileInUse);
      expect(await source.openAppSettings(), isTrue);
      expect(await source.openLocationSettings(), isTrue);
      await pumpEventQueue();

      expect(permissions.permissionRequests, 1);
      expect(permissions.positionSubscriptions, 0);
      expect(methodsCalled, isEmpty);
      expect(eventCalls, isEmpty);
    },
  );

  test(
    'canceling before the first fix stops native GPS and unsubscribes immediately',
    () async {
      final positions = <Position>[];
      final subscription = source.watchPositions().listen(positions.add);
      await pumpEventQueue();
      expect(methodsCalled, ['startTracking']);
      expect(eventCalls, ['listen']);

      await subscription.cancel();

      expect(positions, isEmpty);
      expect(methodsCalled, ['startTracking', 'stopTracking']);
      expect(eventCalls, ['listen', 'cancel']);
      expect(permissions.positionSubscriptions, 0);
    },
  );

  test(
    'cancellation waits for pending startup before permitting another session',
    () async {
      final startGate = Completer<void>();
      final startCalled = Completer<void>();
      messenger.setMockMethodCallHandler(methods, (call) async {
        methodsCalled.add(call.method);
        if (call.method == 'startTracking') {
          if (!startCalled.isCompleted) startCalled.complete();
          await startGate.future;
        }
        return null;
      });
      final subscription = source.watchPositions().listen((_) {});
      await startCalled.future;

      var cancellationDone = false;
      final cancelling = subscription.cancel().then(
        (_) => cancellationDone = true,
      );
      await pumpEventQueue();
      expect(methodsCalled, ['startTracking', 'stopTracking']);
      expect(cancellationDone, isFalse);
      startGate.complete();
      await cancelling;
      final next = source.watchPositions().listen((_) {});
      await pumpEventQueue();
      expect(methodsCalled, ['startTracking', 'stopTracking', 'startTracking']);
      await next.cancel();
      expect(methodsCalled.last, 'stopTracking');
      expect(eventCalls, ['listen', 'cancel', 'listen', 'cancel']);
    },
  );

  test(
    'native startup permission failure becomes a location permission exception',
    () async {
      messenger.setMockMethodCallHandler(methods, (call) async {
        methodsCalled.add(call.method);
        if (call.method == 'startTracking') {
          throw PlatformException(code: 'permission_denied');
        }
        return null;
      });
      final errors = <Object>[];
      final positions = <Position>[];
      final subscription = source.watchPositions().listen(
        positions.add,
        onError: errors.add,
      );
      await pumpEventQueue();

      expect(positions, isEmpty);
      expect(errors.single, isA<PermissionDeniedException>());
      await subscription.cancel();
      expect(methodsCalled.last, 'stopTracking');
    },
  );

  test(
    'native stream permission and disabled-service errors keep their category',
    () async {
      final errors = <Object>[];
      final subscription = source.watchPositions().listen(
        (_) {},
        onError: errors.add,
      );
      await pumpEventQueue();
      for (final code in ['permission_denied_forever', 'location_disabled']) {
        await messenger.handlePlatformMessage(
          locationName,
          const StandardMethodCodec().encodeErrorEnvelope(code: code),
          (_) {},
        );
        await pumpEventQueue();
      }

      expect(errors[0], isA<PermissionDeniedException>());
      expect(errors[1], isA<LocationServiceDisabledException>());
      await subscription.cancel();
    },
  );

  test(
    'native fixes preserve unavailable API fields and valid zero coordinates',
    () async {
      final positions = <Position>[];
      final subscription = source.watchPositions().listen(positions.add);
      await pumpEventQueue();
      await send({
        'latitude': 0.0,
        'longitude': 0.0,
        'timestamp': 1792540800000,
        'speed': 0.0,
        'accuracy': 0.0,
        'altitude': 0.0,
        'heading': 0.0,
        'speedAccuracy': 0.0,
        'hasSpeed': false,
        'hasAccuracy': false,
        'hasAltitude': false,
        'hasHeading': false,
        'hasSpeedAccuracy': false,
      });

      final position = positions.single;
      expect(position.latitude, 0);
      expect(position.longitude, 0);
      expect(
        position.timestamp,
        DateTime.fromMillisecondsSinceEpoch(1792540800000, isUtc: true),
      );
      expect(
        position.hasSpeed ||
            position.hasAccuracy ||
            position.hasAltitude ||
            position.hasHeading ||
            position.hasSpeedAccuracy,
        isFalse,
      );
      await subscription.cancel();
    },
  );

  test(
    'complete fixes carry native speed accuracy heading and mock status unchanged',
    () async {
      final positions = <Position>[];
      final subscription = source.watchPositions().listen(positions.add);
      await pumpEventQueue();
      await send({
        'latitude': 25.0,
        'longitude': 55.0,
        'timestamp': 1792540800000,
        'speed': 12.5,
        'accuracy': 3.0,
        'altitude': 100.0,
        'heading': 90.0,
        'speedAccuracy': 0.4,
        'altitudeAccuracy': 2.0,
        'headingAccuracy': 1.0,
        'hasSpeed': true,
        'hasAccuracy': true,
        'hasAltitude': true,
        'hasHeading': true,
        'hasSpeedAccuracy': true,
        'isMocked': true,
      });

      final position = positions.single;
      expect(position.speed, 12.5);
      expect(position.accuracy, 3);
      expect(position.altitude, 100);
      expect(position.heading, 90);
      expect(position.speedAccuracy, 0.4);
      expect(position.altitudeAccuracy, 2);
      expect(position.headingAccuracy, 1);
      expect(
        position.hasSpeed &&
            position.hasAccuracy &&
            position.hasAltitude &&
            position.hasHeading &&
            position.hasSpeedAccuracy,
        isTrue,
      );
      expect(position.isMocked, isTrue);
      await subscription.cancel();
    },
  );
}

class _PermissionSource implements LocationDataSource {
  int permissionRequests = 0;
  int positionSubscriptions = 0;
  @override
  Future<bool> isLocationServiceEnabled() async => true;
  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.denied;
  @override
  Future<LocationPermission> requestPermission() async {
    permissionRequests++;
    return LocationPermission.whileInUse;
  }

  @override
  Future<bool> openAppSettings() async => true;
  @override
  Future<bool> openLocationSettings() async => true;
  @override
  Stream<Position> watchPositions() {
    positionSubscriptions++;
    return const Stream.empty();
  }
}
