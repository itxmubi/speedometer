import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/core/platform/method_channel_device_services.dart';
import 'package:speedometer/core/platform/native_location_fix.dart';
import 'package:speedometer/features/speedometer/data/repositories/platform_device_repository.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('device_test');
  const locationName = 'location_test';
  const location = EventChannel(locationName);
  const compassName = 'compass_test';
  const compass = EventChannel(compassName);
  const services = MethodChannelDeviceServices(
    channel: channel,
    locationChannel: location,
    compassChannel: compass,
  );
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
    messenger.setMockMethodCallHandler(
      const MethodChannel(locationName),
      (_) async => null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel(compassName),
      (_) async => null,
    );
  });
  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    messenger.setMockMethodCallHandler(const MethodChannel(locationName), null);
    messenger.setMockMethodCallHandler(const MethodChannel(compassName), null);
  });

  test('economy cadence stays enabled when the activity is hidden', () async {
    final repository = PlatformDeviceRepository(services);
    await repository.applySettings(
      const DisplayPreferences(economyGps: true, keepAwake: true),
      awake: false,
    );
    expect(calls.map((call) => call.method), [
      'applyDisplay',
      'setGpsInterval',
    ]);
    expect(
      (calls.first.arguments as Map<Object?, Object?>)['keepAwake'],
      isFalse,
    );
    expect(
      (calls.last.arguments as Map<Object?, Object?>)['milliseconds'],
      3000,
    );
  });

  test(
    'GPS configuration failures are returned by the device repository',
    () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'setGpsInterval') {
          throw PlatformException(code: 'permission_denied');
        }
        return null;
      });
      final repository = PlatformDeviceRepository(services);
      final result = await repository.applySettings(
        const DisplayPreferences(),
        awake: true,
      );
      expect(
        (result as Error<void>).failure.kind,
        FailureKind.permissionDenied,
      );
    },
  );

  test('starting and stopping are explicit native operations', () async {
    expect(await services.startTracking(), isA<Success<void>>());
    expect(await services.stopTracking(), isA<Success<void>>());
    expect(calls.map((call) => call.method), ['startTracking', 'stopTracking']);
  });

  test('clamps unsafe display, volume and GPS interval inputs', () async {
    await services.applyDisplay(keepAwake: true, brightness: double.nan);
    await services.emitAlert(
      sound: true,
      vibration: false,
      voice: false,
      volume: 100,
      message: 'Limit',
      languageTag: 'en',
    );
    await services.setGpsInterval(const Duration(milliseconds: 10));

    expect((calls[0].arguments as Map<Object?, Object?>)['brightness'], -1);
    expect((calls[1].arguments as Map<Object?, Object?>)['volume'], 1);
    expect((calls[2].arguments as Map<Object?, Object?>)['milliseconds'], 1000);
  });

  test('maps only safe expected error categories', () async {
    for (final entry in {
      'permission_denied': FailureKind.permissionDenied,
      'permission_denied_forever': FailureKind.permissionDeniedForever,
      'overlay_permission': FailureKind.permissionDenied,
      'location_disabled': FailureKind.locationDisabled,
      'location_unavailable': FailureKind.locationUnavailable,
      'unsupported': FailureKind.unsupported,
      'arbitrary': FailureKind.unexpected,
    }.entries) {
      messenger.setMockMethodCallHandler(
        channel,
        (_) async => throw PlatformException(code: entry.key),
      );

      final result = await services.startTracking();

      expect(result, isA<Error<void>>());
      expect((result as Error<void>).failure.kind, entry.value);
    }
  });

  test('missing native implementation returns unsupported', () async {
    messenger.setMockMethodCallHandler(channel, null);

    final result = await services.canDrawOverlays();

    expect((result as Error<bool>).failure.kind, FailureKind.unsupported);
  });

  test('boolean queries reject absent results', () async {
    final result = await services.isTracking();

    expect((result as Error<bool>).failure.kind, FailureKind.unexpected);
    messenger.setMockMethodCallHandler(channel, (_) async => true);
    expect((await services.isTracking() as Success<bool>).value, isTrue);
  });

  test('location subscription never starts GPS and maps API flags', () async {
    final results = <Result<NativeLocationFix>>[];
    final subscription = services.watchLocation().listen(results.add);
    await pumpEventQueue();
    expect(calls, isEmpty);
    unawaited(
      messenger.handlePlatformMessage(
        locationName,
        const StandardMethodCodec().encodeSuccessEnvelope({
          'latitude': 0.0,
          'longitude': 0.0,
          'timestamp': 1792540800000,
          'speed': 3.0,
          'accuracy': 4.0,
          'hasSpeed': true,
          'hasAccuracy': true,
        }),
        (_) {},
      ),
    );
    await pumpEventQueue();

    expect(results, hasLength(1));
    expect(
      (results.single as Success<NativeLocationFix>).value.hasSpeed,
      isTrue,
    );
    expect(
      (results.single as Success<NativeLocationFix>).value.hasSpeedAccuracy,
      isFalse,
    );
    final cancellation = subscription.cancel();
    await pumpEventQueue();
    await cancellation;
  });

  test('compass recovers after unreliable samples', () async {
    final results = <Result<double>>[];
    final subscription = services.watchCompass().listen(results.add);
    await pumpEventQueue();
    for (final event in <Object?>[null, 123.4]) {
      unawaited(
        messenger.handlePlatformMessage(
          compassName,
          const StandardMethodCodec().encodeSuccessEnvelope(event),
          (_) {},
        ),
      );
      await pumpEventQueue();
    }

    expect(results[0], isA<Error<double>>());
    expect((results[1] as Success<double>).value, 123.4);
    final cancellation = subscription.cancel();
    await pumpEventQueue();
    await cancellation;
  });

  test('location cancellation completes before the first GPS fix', () async {
    final subscription = services.watchLocation().listen((_) {});
    await pumpEventQueue();

    final cancellation = subscription.cancel();
    await pumpEventQueue();
    await cancellation;

    expect(calls, isEmpty);
  });
}
