import 'package:speedometer/features/trips/presentation/providers/trip_history_controller.dart';
import 'package:speedometer/features/trips/domain/entities/trip_history_query.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:speedometer/app/router/app_routes.dart';
import 'package:speedometer/core/error/failure.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/theme/app_theme.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';
import 'package:speedometer/features/trips/domain/entities/recorded_trip.dart';
import 'package:speedometer/features/trips/presentation/providers/trip_providers.dart';
import 'package:speedometer/features/trips/presentation/screens/history_screen.dart';
import 'package:speedometer/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:speedometer/features/trips/presentation/widgets/trip_format.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../trip_fixtures.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.light,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

void main() {
  testWidgets(
    'history changes pages, resets page on status filter and clears filters',
    (tester) async {
      final observed = <TripHistoryQuery>[];
      await tester.pumpWidget(
        _app(
          ProviderScope(
            overrides: [
              tripHistoryProvider.overrideWith((ref) {
                final query = ref.watch(tripHistoryQueryProvider);
                observed.add(query);
                return Stream.value(
                  query.active == true
                      ? []
                      : List.generate(
                          query.page == 0 ? TripHistoryQuery.pageSize + 1 : 3,
                          (i) => savedTrip(id: '${query.page}-$i'),
                        ),
                );
              }),
            ],
            child: const HistoryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Next page'));
      await tester.pumpAndSettle();
      expect(observed.last.page, 1);
      expect(find.text('Page 2'), findsOneWidget);
      expect(
        tester
            .widget<IconButton>(
              find.byWidgetPredicate(
                (w) => w is IconButton && w.tooltip == 'Next page',
              ),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('In progress').last);
      await tester.pumpAndSettle();
      expect(observed.last.page, 0);
      expect(observed.last.active, true);
      expect(find.text('No trips match these filters.'), findsOneWidget);
      await tester.tap(find.text('Clear filters'));
      await tester.pumpAndSettle();
      expect(observed.last.active, isNull);
      expect(observed.last.page, 0);
      expect(tester.takeException(), isNull);
    },
  );

  test('history date filters normalize days and reset pagination', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final sub = container.listen(tripHistoryQueryProvider, (_, _) {});
    addTearDown(sub.close);
    final controller = container.read(tripHistoryQueryProvider.notifier);
    controller.page(3);
    controller.dates(DateTime(2026, 10, 1, 12), DateTime(2026, 10, 31, 23));
    final query = container.read(tripHistoryQueryProvider);
    expect(query.page, 0);
    expect(query.from, DateTime(2026, 10, 1));
    expect(query.before, DateTime(2026, 11, 1));
    expect(query.through, DateTime(2026, 10, 31));
    controller.page(-1);
    expect(container.read(tripHistoryQueryProvider).page, 0);
  });

  testWidgets(
    'history filters and pagination fit small Arabic large-text layouts',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tripHistoryProvider.overrideWith(
              (ref) => Stream.value([savedTrip()]),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('ar'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HistoryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(HistoryScreen));
      final l10n = AppLocalizations.of(context);
      expect(Directionality.of(context), TextDirection.rtl);
      expect(find.text(l10n.filterDates).hitTestable(), findsOneWidget);
      expect(find.byTooltip(l10n.nextPage), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('history shows loading before local records arrive', (
    tester,
  ) async {
    final records = StreamController<List<RecordedTrip>>();
    addTearDown(records.close);
    await tester.pumpWidget(
      _app(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [
            tripHistoryProvider.overrideWith((ref) => records.stream),
          ],
          child: const HistoryScreen(),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'history explains the empty state and retries a storage failure',
    (tester) async {
      var attempts = 0;
      await tester.pumpWidget(
        _app(
          ProviderScope(
            retry: (retryCount, error) => null,
            overrides: [
              tripHistoryProvider.overrideWith((ref) {
                attempts++;
                return attempts == 1
                    ? Stream.error(const Failure(FailureKind.storage))
                    : Stream.value([]);
              }),
            ],
            child: const HistoryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(
        tester.element(find.byType(HistoryScreen)),
      );
      expect(find.text(l10n.failureStorage), findsOneWidget);
      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();
      expect(attempts, 2);
      expect(find.text(l10n.tripHistoryEmpty), findsOneWidget);
      expect(find.text(l10n.tripHistoryEmptyDescription), findsOneWidget);
      expect(find.text(l10n.failureStorage), findsNothing);
    },
  );

  testWidgets('history formats chosen units and opens a record by ID', (
    tester,
  ) async {
    final trip = savedTrip(id: 'id with spaces', active: true);
    String? openedId;
    final router = GoRouter(
      initialLocation: AppRoutes.history,
      routes: [
        GoRoute(
          path: AppRoutes.history,
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.tripDetailPattern,
          builder: (context, state) {
            openedId = state.pathParameters['tripId'];
            return const Scaffold(body: Text('Opened record'));
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          tripHistoryProvider.overrideWith((ref) => Stream.value([trip])),
          tripSpeedUnitProvider.overrideWithValue(SpeedUnit.milesPerHour),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(HistoryScreen)),
    );
    expect(
      find.textContaining(
        TripFormat.distance(1200, SpeedUnit.milesPerHour, l10n),
      ),
      findsOneWidget,
    );
    expect(find.textContaining(l10n.tripInProgress), findsOneWidget);
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    expect(openedId, trip.id);
    expect(find.text('Opened record'), findsOneWidget);
  });

  testWidgets('detail loads, reports failures and retries a missing record', (
    tester,
  ) async {
    final pending = Completer<RecordedTrip?>();
    var attempts = 0;
    await tester.pumpWidget(
      _app(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [
            tripDetailProvider('saved-trip').overrideWith((ref) {
              attempts++;
              return attempts == 1 ? pending.future : Future.value(null);
            }),
          ],
          child: const TripDetailScreen(tripId: 'saved-trip'),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    pending.completeError(const Failure(FailureKind.storage));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(TripDetailScreen)),
    );
    expect(find.text(l10n.failureStorage), findsOneWidget);
    await tester.tap(find.text(l10n.retry));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(find.text(l10n.tripNotFound), findsOneWidget);
  });

  testWidgets('detail keeps speed statistics available without a saved route', (
    tester,
  ) async {
    final trip = savedTrip(points: [sample(latitude: null, longitude: null)]);
    await tester.pumpWidget(
      _app(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [
            tripDetailProvider(trip.id).overrideWith((ref) async => trip),
          ],
          child: TripDetailScreen(tripId: trip.id),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(TripDetailScreen)),
    );
    expect(find.text(l10n.tripFinished), findsOneWidget);
    expect(find.text(l10n.tripDistance), findsOneWidget);
    expect(find.text(l10n.tripStartPoint), findsOneWidget);
    expect(find.text(l10n.unavailableValue), findsNWidgets(2));
    await tester.scrollUntilVisible(
      find.text(l10n.tripNoRoute),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l10n.tripNoRoute), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(l10n.tripSpeedGraph),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l10n.tripSpeedGraph), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('active trip cannot be deleted from its detail screen', (
    tester,
  ) async {
    final trip = savedTrip(active: true, points: []);
    await tester.pumpWidget(
      _app(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [
            tripDetailProvider(trip.id).overrideWith((ref) async => trip),
          ],
          child: TripDetailScreen(tripId: trip.id),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(TripDetailScreen)),
    );
    await tester.scrollUntilVisible(
      find.text(l10n.deleteTrip),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    final button = tester.widget<TextButton>(
      find.widgetWithText(TextButton, l10n.deleteTrip),
    );
    expect(button.onPressed, isNull);
    expect(find.text(l10n.tripNoSamples), findsWidgets);
  });
}
