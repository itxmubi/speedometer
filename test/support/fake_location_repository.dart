import 'dart:async';

import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/domain/repositories/location_repository.dart';

/// Deterministic GPS source for widget and integration flows.
class FakeLocationRepository implements LocationRepository {
  final readings = StreamController<Result<SpeedReading>>.broadcast();
  int prepareCalls = 0;
  Result<void> prepareResult = const Success(null);

  @override
  Future<Result<void>> prepare() async {
    prepareCalls++;
    return prepareResult;
  }

  @override
  Stream<Result<SpeedReading>> watch() => readings.stream;

  @override
  Future<Result<void>> openAppSettings() async => const Success(null);

  @override
  Future<Result<void>> openLocationSettings() async => const Success(null);

  /// Releases the fake source after the app has been disposed.
  Future<void> dispose() => readings.close();
}
