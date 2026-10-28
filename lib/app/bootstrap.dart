import '../features/trips/presentation/providers/trip_providers.dart' as trips;
import '../features/speedometer/presentation/providers/speedometer_providers.dart';
import '../features/speedometer/presentation/providers/speedometer_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/logger.dart';
import 'app.dart';

/// Installs privacy-safe global handlers before starting the app.
void bootstrap() {
  WidgetsFlutterBinding.ensureInitialized();
  const logger = Logger();
  FlutterError.onError = (details) {
    logger.error('unhandled_flutter_error');
    if (kDebugMode) FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error('unhandled_platform_error');
    return true;
  };
  // A remote crash reporter is intentionally deferred until production privacy
  // and collection choices are defined; this prototype never uploads reports.
  runApp(
    ProviderScope(
      overrides: [
        sessionTripRepositoryProvider.overrideWith(
          (ref) => ref.watch(trips.tripRepositoryProvider),
        ),
        tripFilesRepositoryProvider.overrideWith(
          (ref) => ref.watch(trips.tripFileRepositoryProvider),
        ),
        trips.tripSpeedUnitProvider.overrideWith(
          (ref) => ref.watch(
            speedometerControllerProvider.select(
              (state) => state.preferences.unit,
            ),
          ),
        ),
      ],
      child: const SpeedometerApp(),
    ),
  );
}
