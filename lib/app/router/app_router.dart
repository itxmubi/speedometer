import '../../features/speedometer/presentation/screens/focused_display_screen.dart';
import '../../features/trips/presentation/screens/history_screen.dart';
import '../../features/trips/presentation/screens/trip_detail_screen.dart';
import '../../features/fuel/presentation/screens/fuel_screen.dart';
import '../../features/speedometer/presentation/screens/legal_document_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../features/speedometer/presentation/providers/speedometer_controller.dart';
import '../../features/speedometer/presentation/screens/permission_screen.dart';
import '../../features/speedometer/presentation/screens/settings_screen.dart';
import '../../features/speedometer/presentation/screens/speedometer_screen.dart';
import '../startup_screen.dart';
import 'app_routes.dart';

/// Router with disclosure and initialization guards, independent of widget code.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(
    speedometerControllerProvider.select(
      (state) => (
        state.isLoadingPreferences,
        state.initializationFailed,
        state.hasDisclosureConsent,
      ),
    ),
    (_, _) => refresh.value++,
  );
  final router = GoRouter(
    initialLocation: AppRoutes.dashboard,
    refreshListenable: refresh,
    redirect: (context, route) {
      final state = ref.read(speedometerControllerProvider);
      if (state.isLoadingPreferences || state.initializationFailed) {
        return route.matchedLocation == AppRoutes.loading
            ? null
            : AppRoutes.loading;
      }
      if (!state.hasDisclosureConsent) {
        return route.matchedLocation == AppRoutes.permissions
            ? null
            : AppRoutes.permissions;
      }
      if (route.matchedLocation == AppRoutes.permissions ||
          route.matchedLocation == AppRoutes.loading) {
        return AppRoutes.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.focusedDisplay,
        builder: (context, state) => const FocusedDisplayScreen(),
      ),
      GoRoute(
        path: AppRoutes.fuel,
        builder: (context, state) =>
            FuelScreen(onOpenMileageLog: () => context.push(AppRoutes.history)),
      ),
      GoRoute(
        path: AppRoutes.trips,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.tripDetailPattern,
        builder: (context, state) =>
            TripDetailScreen(tripId: state.pathParameters['tripId'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const SpeedometerScreen(),
      ),
      GoRoute(
        path: AppRoutes.permissions,
        builder: (context, state) => const PermissionScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (context, state) => LegalDocumentScreen(
          title: AppLocalizations.of(context).privacyPolicy,
        ),
      ),
      GoRoute(
        path: AppRoutes.termsAndConditions,
        builder: (context, state) => LegalDocumentScreen(
          title: AppLocalizations.of(context).termsAndConditions,
        ),
      ),
      GoRoute(
        path: AppRoutes.loading,
        builder: (context, state) => const StartupScreen(),
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
