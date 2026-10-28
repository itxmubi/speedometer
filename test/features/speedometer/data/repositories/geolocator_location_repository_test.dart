import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/core/utils/logger.dart';
import 'package:speedometer/features/speedometer/data/datasources/location_data_source.dart';
import 'package:speedometer/features/speedometer/data/repositories/geolocator_location_repository.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';

void main() {
  late _FakeLocationDataSource source;
  late _RecordingLogger logger;
  late GeolocatorLocationRepository repository;

  setUp(() {
    source = _FakeLocationDataSource();
    logger = _RecordingLogger();
    repository = GeolocatorLocationRepository(
      source,
      now: () => DateTime.utc(2026, 10, 21, 10),
      logger: logger,
    );
  });

  test('prepares when foreground permission is already granted', () async {
    expect(await repository.prepare(), isA<Success<void>>());
    expect(source.requests, 0);
  });

  test('requests denied permission exactly once and accepts a grant', () async {
    source.permission = LocationPermission.denied;
    source.requestedPermission = LocationPermission.whileInUse;
    expect(await repository.prepare(), isA<Success<void>>());
    expect(source.requests, 1);
  });

  test('returns denied failure after the user refuses permission', () async {
    source.permission = LocationPermission.denied;
    source.requestedPermission = LocationPermission.denied;
    expect(_kind(await repository.prepare()), FailureKind.permissionDenied);
  });

  test('does not re-request permanently denied permission', () async {
    source.permission = LocationPermission.deniedForever;
    expect(
      _kind(await repository.prepare()),
      FailureKind.permissionDeniedForever,
    );
    expect(source.requests, 0);
  });

  test('handles permanent denial returned by the permission request', () async {
    source.permission = LocationPermission.denied;
    source.requestedPermission = LocationPermission.deniedForever;
    expect(
      _kind(await repository.prepare()),
      FailureKind.permissionDeniedForever,
    );
  });

  test(
    'disabled services return recovery failure before requesting permission',
    () async {
      source.servicesEnabled = false;
      expect(_kind(await repository.prepare()), FailureKind.locationDisabled);
      expect(source.requests, 0);
      expect(source.permissionChecks, 0);
    },
  );

  test('unknown permission is handled as unsupported', () async {
    source.permission = LocationPermission.unableToDetermine;
    expect(_kind(await repository.prepare()), FailureKind.unsupported);
  });

  test(
    'converts platform preparation exceptions and logs no raw message',
    () async {
      source.serviceError = const PermissionDeniedException(
        'private coordinates',
      );
      expect(_kind(await repository.prepare()), FailureKind.permissionDenied);
      expect(logger.events, ['location_permissionDenied']);
    },
  );

  test('maps Doppler speed and valid optional measurements', () async {
    source.positions = Stream.value(_position(speed: 12));
    final result = await repository.watch().single;
    expect(result, isA<Success<SpeedReading>>());
    if (result case Success(:final value)) {
      expect(value.speedMetersPerSecond, 12);
      expect(value.accuracyMeters, 5);
      expect(value.altitudeMeters, 50);
      expect(value.headingDegrees, 90);
    }
  });

  test('normalizes stationary Doppler jitter without smoothing lag', () async {
    source.positions = Stream.value(_position(speed: 0.49));
    final result = await repository.watch().single;
    expect(result, isA<Success<SpeedReading>>());
    if (result case Success(:final value)) {
      expect(value.speedMetersPerSecond, 0);
    }
  });

  for (final accuracy in [25.01, 1000.0, -1.0, double.nan]) {
    test('rejects poor or invalid horizontal accuracy $accuracy', () async {
      source.positions = Stream.value(_position(accuracy: accuracy));
      expect(
        _kind(await repository.watch().single),
        FailureKind.locationUnavailable,
      );
    });
  }

  test('accepts a fix at the 25 meter accuracy boundary', () async {
    source.positions = Stream.value(_position(accuracy: 25));
    expect(await repository.watch().single, isA<Success<SpeedReading>>());
  });

  for (final speed in [-1.0, 151.0, double.nan, double.infinity]) {
    test('rejects unavailable or invalid Doppler speed $speed', () async {
      source.positions = Stream.value(_position(speed: speed));
      expect(
        _kind(await repository.watch().single),
        FailureKind.locationUnavailable,
      );
    });
  }

  test(
    'missing platform speed must not become a false stationary reading',
    () async {
      source.positions = Stream.value(_position(hasSpeed: false, speed: 0));
      expect(
        _kind(await repository.watch().single),
        FailureKind.locationUnavailable,
      );
    },
  );

  test(
    'missing platform accuracy must not appear perfectly accurate',
    () async {
      source.positions = Stream.value(
        _position(hasAccuracy: false, accuracy: 0),
      );
      expect(
        _kind(await repository.watch().single),
        FailureKind.locationUnavailable,
      );
    },
  );

  test(
    'uncertain Doppler speed is not presented as a precise reading',
    () async {
      source.positions = Stream.value(_position(speedAccuracy: 4));
      expect(
        _kind(await repository.watch().single),
        FailureKind.locationUnavailable,
      );
    },
  );

  test(
    'missing optional measurements stay absent instead of becoming zero',
    () async {
      source.positions = Stream.value(
        _position(hasAltitude: false, hasHeading: false),
      );
      final result = await repository.watch().single;
      if (result case Success(:final value)) {
        expect(value.altitudeMeters, isNull);
        expect(value.headingDegrees, isNull);
      } else {
        fail(
          'A valid speed must remain available without altitude or heading.',
        );
      }
    },
  );

  test(
    'invalid optional altitude and heading do not poison usable speed',
    () async {
      source.positions = Stream.value(
        _position(altitude: double.nan, heading: -1),
      );
      final result = await repository.watch().single;
      if (result case Success(:final value)) {
        expect(value.altitudeMeters, isNull);
        expect(value.headingDegrees, isNull);
      } else {
        fail('Invalid optional measurements should not hide usable speed.');
      }
    },
  );

  test('rejects cached and implausibly future-dated fixes', () async {
    source.positions = Stream.fromIterable([
      _position(offset: const Duration(seconds: -16)),
      _position(offset: const Duration(seconds: 6)),
    ]);
    final results = await repository.watch().toList();
    expect(results.map(_kind), everyElement(FailureKind.locationUnavailable));
  });

  test(
    'throttles burst fixes and ignores duplicate or older timestamps',
    () async {
      source.positions = Stream.fromIterable([
        _position(),
        _position(),
        _position(offset: const Duration(seconds: -1)),
        _position(offset: const Duration(milliseconds: 250)),
        _position(offset: const Duration(seconds: 1)),
      ]);
      expect(await repository.watch().length, 2);
    },
  );

  test('quality can recover after an inaccurate fix', () async {
    source.positions = Stream.fromIterable([
      _position(accuracy: 1000),
      _position(offset: const Duration(seconds: 1)),
    ]);
    final results = await repository.watch().toList();
    expect(_kind(results.first), FailureKind.locationUnavailable);
    expect(results.last, isA<Success<SpeedReading>>());
  });

  test(
    'light smoothing uses accepted Doppler samples and stops immediately',
    () async {
      source.positions = Stream.fromIterable([
        _position(speed: 12),
        _position(speed: 12.5, offset: const Duration(seconds: 1)),
        _position(speed: 0.2, offset: const Duration(seconds: 2)),
      ]);
      final results = await repository.watch().toList();
      final speeds = results
          .whereType<Success<SpeedReading>>()
          .map((result) => result.value.speedMetersPerSecond)
          .toList();

      expect(speeds[0], 12);
      expect(speeds[1], closeTo(12 + 0.5 / 1.35, 0.00001));
      expect(speeds[2], 0);
    },
  );

  test('a rejected fix resets smoothing before signal recovery', () async {
    source.positions = Stream.fromIterable([
      _position(speed: 12),
      _position(accuracy: 1000, offset: const Duration(seconds: 1)),
      _position(speed: 12.5, offset: const Duration(seconds: 2)),
    ]);
    final results = await repository.watch().toList();

    expect(_kind(results[1]), FailureKind.locationUnavailable);
    expect(
      (results.last as Success<SpeedReading>).value.speedMetersPerSecond,
      12.5,
    );
  });

  for (final entry in <Object, FailureKind>{
    const LocationServiceDisabledException(): FailureKind.locationDisabled,
    const PermissionDeniedException('private'): FailureKind.permissionDenied,
    const PositionUpdateException('private'): FailureKind.locationUnavailable,
    MissingPluginException('private'): FailureKind.unsupported,
    UnsupportedError('private'): FailureKind.unsupported,
    TimeoutException('private'): FailureKind.locationUnavailable,
    StateError('private'): FailureKind.unexpected,
  }.entries) {
    test('translates ${entry.key.runtimeType} stream failures', () async {
      source.positions = Stream.error(entry.key);
      expect(_kind(await repository.watch().single), entry.value);
      expect(logger.events.single, 'location_${entry.value.name}');
    });
  }

  test('signal loss stays subscribed, recovers and resets smoothing', () async {
    var cancelled = false;
    var done = false;
    final controller = StreamController<Position>(
      onCancel: () {
        cancelled = true;
      },
    );
    source.positions = controller.stream;
    final recovering = GeolocatorLocationRepository(
      source,
      now: () => DateTime.utc(2026, 10, 21, 10),
      inactivityTimeout: Duration.zero,
    );
    final first = Completer<SpeedReading>();
    final unavailable = Completer<void>();
    final recovered = Completer<SpeedReading>();
    final subscription = recovering.watch().listen((event) {
      switch (event) {
        case Success(:final value):
          if (!first.isCompleted) {
            first.complete(value);
          } else if (!recovered.isCompleted) {
            recovered.complete(value);
          }
        case Error():
          if (!unavailable.isCompleted) unavailable.complete();
      }
    }, onDone: () => done = true);
    controller.add(_position(speed: 12));
    await first.future;
    await unavailable.future;
    expect(cancelled, isFalse);
    expect(done, isFalse);
    controller.add(_position(speed: 12.5, offset: const Duration(seconds: 2)));
    expect((await recovered.future).speedMetersPerSecond, 12.5);
    await subscription.cancel();
    expect(cancelled, isTrue);
    await controller.close();
  });

  test('rejects cached fixes older than five seconds', () async {
    source.positions = Stream.value(
      _position(offset: const Duration(seconds: -6)),
    );
    expect(
      _kind(await repository.watch().single),
      FailureKind.locationUnavailable,
    );
  });

  test(
    'coordinate spikes cannot reach the readout and later fixes recover',
    () async {
      source.positions = Stream.fromIterable([
        _position(),
        _position(latitude: 1, speed: 100, offset: const Duration(seconds: 1)),
        _position(
          latitude: 0.0002,
          speed: 10,
          offset: const Duration(seconds: 2),
        ),
      ]);
      final results = await repository.watch().toList();
      expect(results.first, isA<Success<SpeedReading>>());
      expect(_kind(results[1]), FailureKind.locationUnavailable);
      expect((results.last as Success<SpeedReading>).value.latitude, 0.0002);
    },
  );

  test(
    'cancels a silent native stream immediately without waiting for a fix',
    () async {
      var cancelled = false;
      final controller = StreamController<Position>(
        onCancel: () => cancelled = true,
      );
      source.positions = controller.stream;
      final subscription = repository.watch().listen((_) {});
      await subscription.cancel();
      expect(cancelled, isTrue);
      await controller.close();
    },
  );

  test('cancelling the domain stream cancels the native source', () async {
    var cancelled = false;
    final controller = StreamController<Position>(
      onCancel: () => cancelled = true,
    );
    source.positions = controller.stream;
    final result = repository.watch().first;
    controller.add(_position());
    expect(await result, isA<Success<SpeedReading>>());
    await controller.close();
    expect(cancelled, isTrue);
  });

  test('settings actions expose success and unsupported outcomes', () async {
    expect(await repository.openAppSettings(), isA<Success<void>>());
    expect(await repository.openLocationSettings(), isA<Success<void>>());
    source.settingsOpen = false;
    expect(_kind(await repository.openAppSettings()), FailureKind.unsupported);
    expect(
      _kind(await repository.openLocationSettings()),
      FailureKind.unsupported,
    );
  });

  test('settings platform failures remain typed results', () async {
    source.settingsError = MissingPluginException('private');
    expect(_kind(await repository.openAppSettings()), FailureKind.unsupported);
  });
}

FailureKind? _kind<T>(Result<T> result) => switch (result) {
  Success<T>() => null,
  Error<T>(:final failure) => failure.kind,
};

Position _position({
  double speed = 10,
  double latitude = 0,
  double accuracy = 5,
  double speedAccuracy = 0.2,
  double altitude = 50,
  double heading = 90,
  bool hasSpeed = true,
  bool hasAccuracy = true,
  bool hasAltitude = true,
  bool hasHeading = true,
  Duration offset = Duration.zero,
}) => Position(
  latitude: latitude,
  longitude: 0,
  timestamp: DateTime.utc(2026, 10, 21, 10).add(offset),
  accuracy: accuracy,
  altitude: altitude,
  altitudeAccuracy: 1,
  heading: heading,
  headingAccuracy: 1,
  speed: speed,
  speedAccuracy: speedAccuracy,
  hasSpeed: hasSpeed,
  hasAccuracy: hasAccuracy,
  hasAltitude: hasAltitude,
  hasHeading: hasHeading,
  hasSpeedAccuracy: true,
);

class _FakeLocationDataSource implements LocationDataSource {
  bool servicesEnabled = true;
  LocationPermission permission = LocationPermission.whileInUse;
  LocationPermission requestedPermission = LocationPermission.whileInUse;
  int requests = 0;
  int permissionChecks = 0;
  Object? serviceError;
  Stream<Position> positions = const Stream.empty();
  bool settingsOpen = true;
  Object? settingsError;

  @override
  Future<bool> isLocationServiceEnabled() async {
    if (serviceError case final error?) throw error;
    return servicesEnabled;
  }

  @override
  Future<LocationPermission> checkPermission() async {
    permissionChecks++;
    return permission;
  }

  @override
  Future<LocationPermission> requestPermission() async {
    requests++;
    return requestedPermission;
  }

  @override
  Stream<Position> watchPositions() => positions;

  @override
  Future<bool> openAppSettings() async {
    if (settingsError case final error?) throw error;
    return settingsOpen;
  }

  @override
  Future<bool> openLocationSettings() => openAppSettings();
}

class _RecordingLogger extends Logger {
  final List<String> events = [];

  @override
  void error(String event) => events.add(event);
}
