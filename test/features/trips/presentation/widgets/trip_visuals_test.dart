import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/features/trips/domain/entities/regional_map.dart';
import 'package:speedometer/features/trips/domain/repositories/regional_map_repository.dart';
import 'package:speedometer/features/trips/presentation/providers/regional_map_controller.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/error/failure.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/theme/app_theme.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_unit.dart';
import 'package:speedometer/features/trips/domain/entities/offline_land_polygon.dart';
import 'package:speedometer/features/trips/domain/entities/track_point.dart';
import 'package:speedometer/features/trips/presentation/providers/trip_providers.dart';
import 'package:speedometer/features/trips/presentation/widgets/route_geometry.dart';
import 'package:speedometer/features/trips/presentation/widgets/trip_format.dart';
import 'package:speedometer/features/trips/presentation/widgets/trip_replay.dart';
import 'package:speedometer/features/trips/presentation/widgets/trip_route_view.dart';
import 'package:speedometer/features/trips/presentation/widgets/trip_speed_chart.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

import '../../trip_fixtures.dart';

Widget _app(Widget child, {String language = 'en'}) => MaterialApp(
  locale: Locale(language),
  theme: AppTheme.light,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

CustomPainter _painter(WidgetTester tester, Type widgetType) =>
    tester
        .widget<CustomPaint>(
          find
              .descendant(
                of: find.byType(widgetType),
                matching: find.byType(CustomPaint),
              )
              .first,
        )
        .painter ??
    (throw StateError('Expected a custom painter'));

TestRecordingCanvas _paint(WidgetTester tester, Type widgetType) {
  final canvas = TestRecordingCanvas();
  _painter(tester, widgetType).paint(canvas, const Size(400, 300));
  return canvas;
}

void main() {
  testWidgets(
    'regional import requires disclosure, displays attribution, supports cancel/error/removal',
    (tester) async {
      final repository = _RegionalRepository();
      await tester.pumpWidget(
        _app(
          ProviderScope(
            overrides: [
              regionalMapRepositoryProvider.overrideWithValue(repository),
              offlineLandProvider.overrideWith((ref) async => []),
            ],
            child: TripRouteView(
              geometry: RouteGeometry(savedTrip().points),
              selectedIndex: 0,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> choose() async {
        await tester.tap(find.text('Load regional map').first);
        await tester.pumpAndSettle();
        expect(repository.calls, 0);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }

      await choose();
      expect(repository.calls, 1);
      expect(find.text('Regional map: Example roads, CC0'), findsOneWidget);
      _paint(tester, TripRouteView);
      repository.result = const Success(null);
      await tester.tap(find.text('Load regional map').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Regional map: Example roads, CC0'), findsOneWidget);
      await tester.tap(find.text('Remove regional map'));
      await tester.pumpAndSettle();
      expect(find.text('Regional map: Example roads, CC0'), findsNothing);
      repository.result = const Error(Failure(FailureKind.storage));
      await tester.tap(find.text('Load regional map').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Regional map could not be loaded.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  for (final language in ['en', 'de', 'es', 'fr', 'ar']) {
    testWidgets('offline map attribution is localized in $language', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          ProviderScope(
            retry: (retryCount, error) => null,
            overrides: [offlineLandProvider.overrideWith((ref) async => [])],
            child: TripRouteView(
              geometry: RouteGeometry(savedTrip().points),
              selectedIndex: 0,
            ),
          ),
          language: language,
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(
        tester.element(find.byType(TripRouteView)),
      );
      expect(l10n.localeName, language);
      expect(find.text(l10n.tripBasemapAttribution), findsOneWidget);
      expect(find.textContaining('l10n.'), findsNothing);
      expect(find.bySemanticsLabel(l10n.tripRouteSemantics), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(TripRouteView))),
        language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      );
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });
  }

  testWidgets('route stays usable while basemap loads and after a retry', (
    tester,
  ) async {
    final pending = Completer<List<OfflineLandPolygon>>();
    var attempts = 0;
    await tester.pumpWidget(
      _app(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [
            offlineLandProvider.overrideWith((ref) {
              attempts++;
              return attempts == 1 ? pending.future : Future.value([]);
            }),
          ],
          child: TripRouteView(
            geometry: RouteGeometry(savedTrip().points),
            selectedIndex: 0,
          ),
        ),
      ),
    );
    expect(find.byType(InteractiveViewer), findsOneWidget);
    pending.completeError(const Failure(FailureKind.storage));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(TripRouteView)),
    );
    expect(find.text(l10n.retry), findsOneWidget);
    await tester.tap(find.text(l10n.retry));
    await tester.pumpAndSettle();
    expect(attempts, 2);
    expect(find.text(l10n.retry), findsNothing);
    expect(find.byType(InteractiveViewer), findsOneWidget);
  });

  testWidgets('offline map responds to drag and pinch zoom', (tester) async {
    await tester.pumpWidget(
      _app(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [offlineLandProvider.overrideWith((ref) async => [])],
          child: TripRouteView(
            geometry: RouteGeometry(savedTrip().points),
            selectedIndex: 0,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final viewer = find.byType(InteractiveViewer);
    final transform = find
        .descendant(of: viewer, matching: find.byType(Transform))
        .first;
    final initial = tester.widget<Transform>(transform).transform.clone();
    await tester.drag(viewer, const Offset(40, 30));
    await tester.pumpAndSettle();
    final panned = tester.widget<Transform>(transform).transform.clone();
    expect(panned.getTranslation(), isNot(initial.getTranslation()));
    final center = tester.getCenter(viewer);
    final first = await tester.createGesture(pointer: 1);
    final second = await tester.createGesture(pointer: 2);
    await first.down(center - const Offset(30, 0));
    await second.down(center + const Offset(30, 0));
    await tester.pump();
    await first.moveTo(center - const Offset(90, 0));
    await second.moveTo(center + const Offset(90, 0));
    await tester.pump();
    await first.up();
    await second.up();
    await tester.pumpAndSettle();
    expect(
      tester.widget<Transform>(transform).transform.getMaxScaleOnAxis(),
      greaterThan(1),
    );
  });

  testWidgets('replay chooses timestamp samples, warnings and private gaps', (
    tester,
  ) async {
    final trip = savedTrip(
      points: [
        sample(),
        sample(seconds: 1, speed: 20, overLimit: true, latitude: 25.001),
        sample(seconds: 30, speed: 5, latitude: null, longitude: null),
        sample(seconds: 40, speed: 15, latitude: 25.002),
      ],
    );
    await tester.pumpWidget(
      _app(
        ProviderScope(
          retry: (retryCount, error) => null,
          overrides: [offlineLandProvider.overrideWith((ref) async => [])],
          child: TripReplay(trip: trip, unit: SpeedUnit.kilometersPerHour),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(TripReplay)));
    tester.widget<Slider>(find.byType(Slider)).onChanged?.call(0.05);
    await tester.pump();
    expect(
      find.text(TripFormat.speed(20, SpeedUnit.kilometersPerHour, l10n)),
      findsOneWidget,
    );
    expect(find.text(l10n.overLimit), findsOneWidget);
    expect(
      tester.widget<TripRouteView>(find.byType(TripRouteView)).selectedIndex,
      1,
    );
    tester.widget<Slider>(find.byType(Slider)).onChanged?.call(0.75);
    await tester.pump();
    expect(
      find.text(TripFormat.speed(5, SpeedUnit.kilometersPerHour, l10n)),
      findsOneWidget,
    );
    expect(find.text(l10n.overLimit), findsNothing);
    expect(
      tester.widget<TripRouteView>(find.byType(TripRouteView)).selectedIndex,
      2,
    );
    // A private sample has no current-position marker. The remaining circles
    // are the route start and the recorded over-limit warning.
    final circles = _paint(
      tester,
      TripRouteView,
    ).invocations.where((call) => call.invocation.memberName == #drawCircle);
    expect(circles, hasLength(2));
  });

  testWidgets(
    'replay plays, pauses and resets when the displayed trip changes',
    (tester) async {
      final trip = savedTrip(
        points: [sample(), sample(seconds: 40, speed: 20)],
      );
      final nextTrip = savedTrip(id: 'next', points: [sample(speed: 5)]);
      var current = trip;
      late StateSetter update;
      await tester.pumpWidget(
        _app(
          ProviderScope(
            retry: (retryCount, error) => null,
            overrides: [offlineLandProvider.overrideWith((ref) async => [])],
            child: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return TripReplay(
                  trip: current,
                  unit: SpeedUnit.kilometersPerHour,
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = AppLocalizations.of(tester.element(find.byType(TripReplay)));
      await tester.tap(find.byTooltip(l10n.tripReplayPlay));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        tester.widget<Slider>(find.byType(Slider)).value,
        closeTo(0.25, 0.01),
      );
      await tester.tap(find.byTooltip(l10n.tripReplayPause));
      await tester.pump();
      final pausedValue = tester.widget<Slider>(find.byType(Slider)).value;
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.widget<Slider>(find.byType(Slider)).value, pausedValue);
      update(() => current = nextTrip);
      await tester.pump();
      expect(tester.widget<Slider>(find.byType(Slider)).value, 0);
      expect(
        find.text(TripFormat.speed(5, SpeedUnit.kilometersPerHour, l10n)),
        findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'replay distinguishes missing samples from private-only samples',
    (tester) async {
      for (final points in <List<TrackPoint>>[
        [],
        [sample(latitude: null, longitude: null)],
      ]) {
        await tester.pumpWidget(
          _app(
            TripReplay(
              key: UniqueKey(),
              trip: savedTrip(points: points),
              unit: SpeedUnit.kilometersPerHour,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final l10n = AppLocalizations.of(
          tester.element(find.byType(TripReplay)),
        );
        expect(
          find.text(points.isEmpty ? l10n.tripNoSamples : l10n.tripNoRoute),
          findsOneWidget,
        );
        expect(find.byType(Slider), findsNothing);
        expect(find.byType(TripRouteView), findsNothing);
      }
    },
  );

  testWidgets(
    'speed chart breaks pauses and long GPS gaps and marks warnings',
    (tester) async {
      await tester.pumpWidget(
        _app(
          TripSpeedChart(
            points: [
              sample(),
              sample(seconds: 1, overLimit: true),
              sample(seconds: 2, segment: 1),
              sample(seconds: 20, segment: 1),
            ],
            unit: SpeedUnit.milesPerHour,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final canvas = _paint(tester, TripSpeedChart);
      // Two axes and one uninterrupted sample interval. Neither gap is bridged.
      expect(
        canvas.invocations.where(
          (call) => call.invocation.memberName == #drawLine,
        ),
        hasLength(3),
      );
      final colors = Theme.of(
        tester.element(find.byType(TripSpeedChart)),
      ).colorScheme;
      expect(
        canvas.invocations.any((call) {
          final invocation = call.invocation;
          return invocation.memberName == #drawCircle &&
              invocation.positionalArguments.last is Paint &&
              (invocation.positionalArguments.last as Paint).color.toARGB32() ==
                  colors.error.toARGB32();
        }),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );
}

class _RegionalRepository implements RegionalMapRepository {
  int calls = 0;
  Result<RegionalMap?> result = Success(
    RegionalMap(
      attribution: 'Example roads, CC0',
      lines: [
        [(25, 55), (25.01, 55.01)],
      ],
    ),
  );
  @override
  Future<Result<RegionalMap?>> pick() async {
    calls++;
    return result;
  }
}
