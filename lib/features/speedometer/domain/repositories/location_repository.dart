import '../../../../core/error/result.dart';
import '../entities/speed_reading.dart';

/// Location operations needed by the app, independent of platform plugins.
abstract interface class LocationRepository {
  /// Checks services and requests foreground permission after user disclosure.
  Future<Result<void>> prepare();

  /// Emits quality-filtered speed readings or recoverable location failures.
  Stream<Result<SpeedReading>> watch();

  /// Opens the app's settings when permission needs manual recovery.
  Future<Result<void>> openAppSettings();

  /// Opens device location settings when location services are disabled.
  Future<Result<void>> openLocationSettings();
}
