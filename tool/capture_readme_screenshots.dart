// Documentation capture utility; excluded from the normal test discovery path.
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/theme/app_theme.dart';
import 'package:speedometer/features/speedometer/domain/entities/display_preferences.dart';
import 'package:speedometer/features/speedometer/domain/entities/gauge_style.dart';
import 'package:speedometer/features/speedometer/domain/entities/speed_reading.dart';
import 'package:speedometer/features/speedometer/domain/entities/trip_stats.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_controller.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_providers.dart';
import 'package:speedometer/features/speedometer/presentation/providers/speedometer_state.dart';
import 'package:speedometer/features/speedometer/presentation/screens/settings_screen.dart';
import 'package:speedometer/features/speedometer/presentation/screens/speedometer_screen.dart';
import 'package:speedometer/features/trips/domain/entities/recorded_trip.dart';
import 'package:speedometer/features/trips/domain/entities/track_point.dart';
import 'package:speedometer/features/trips/domain/entities/trip_totals.dart';
import 'package:speedometer/features/trips/presentation/providers/trip_providers.dart';
import 'package:speedometer/features/trips/presentation/screens/history_screen.dart';
import 'package:speedometer/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

final _epoch = DateTime.utc(2026, 10, 28, 8, 30);
final _boundary = GlobalKey();

Future<void> _loadFonts() async {
  final config =
      jsonDecode(File('.dart_tool/package_config.json').readAsStringSync())
          as Map<String, Object?>;
  final packages = config['packages'] as List<Object?>;
  final flutter = packages.cast<Map<String, Object?>>().firstWhere(
    (p) => p['name'] == 'flutter',
  );
  final uri = File(
    '.dart_tool/package_config.json',
  ).absolute.uri.resolve(flutter['rootUri'] as String);
  final sdk = Directory.fromUri(uri).parent.parent.path;
  final directory = '$sdk/bin/cache/artifacts/material_fonts';
  final roboto = FontLoader('Roboto');
  for (final name in ['Regular', 'Medium', 'Bold']) {
    roboto.addFont(
      Future.value(
        ByteData.sublistView(
          File('$directory/Roboto-$name.ttf').readAsBytesSync(),
        ),
      ),
    );
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(
      Future.value(
        ByteData.sublistView(
          File('$directory/MaterialIcons-Regular.otf').readAsBytesSync(),
        ),
      ),
    );
  await icons.load();
}

RecordedTrip _trip(int index) => RecordedTrip(
  id: 'demo-$index',
  startedAt: _epoch.subtract(Duration(days: index)),
  endedAt: _epoch
      .subtract(Duration(days: index))
      .add(const Duration(minutes: 18)),
  stats: const TripStats(
    distanceMeters: 12400,
    elapsed: Duration(minutes: 18),
    movingTime: Duration(minutes: 16),
    maxSpeedMetersPerSecond: 25,
  ),
  points: List.generate(
    80,
    (i) => TrackPoint(
      timestamp: _epoch
          .subtract(Duration(days: index))
          .add(Duration(seconds: i * 5)),
      speedMetersPerSecond: 14 + (i % 12),
      segment: 0,
      overLimit: i > 30 && i < 40,
      latitude: 25.0 + i * 0.00015,
      longitude: 55.0 + (i < 35 ? i : 70 - i) * 0.0002,
    ),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(_loadFonts);
  testWidgets('capture current UI with synthetic data for README', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 960);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> capture(
      String name,
      Widget screen, {
      GaugeStyle style = GaugeStyle.digital,
      String? scrollTo,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            speedometerControllerProvider.overrideWith(
              () => _ScreenshotController(style),
            ),
            dashboardTimeProvider.overrideWith((ref) => Stream.value(_epoch)),
            tripHistoryProvider.overrideWith(
              (ref) => Stream.value(List.generate(6, _trip)),
            ),
            tripDetailProvider('demo-0').overrideWith((ref) async => _trip(0)),
          ],
          child: RepaintBoundary(
            key: _boundary,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.dark.copyWith(
                textTheme: AppTheme.dark.textTheme.apply(fontFamily: 'Roboto'),
              ),
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: screen,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (scrollTo != null) {
        await tester.scrollUntilVisible(
          find.text(scrollTo),
          180,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      final render = _boundary.currentContext?.findRenderObject();
      if (render is! RenderRepaintBoundary) {
        throw StateError('Missing capture boundary');
      }
      await tester.runAsync(() async {
        final image = await render.toImage(pixelRatio: 2);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        if (data == null) throw StateError('PNG encoding failed');
        await File(
          'docs/screenshots/$name.png',
        ).writeAsBytes(data.buffer.asUint8List());
        image.dispose();
      });
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }

    await capture('dashboard-digital', const SpeedometerScreen());
    await capture(
      'trip-statistics',
      const SpeedometerScreen(),
      scrollTo: 'This trip',
    );
    await capture(
      'dashboard-hud',
      const SpeedometerScreen(),
      style: GaugeStyle.hud,
    );
    await capture('trip-history', const HistoryScreen());
    await capture(
      'trip-route',
      const TripDetailScreen(tripId: 'demo-0'),
      scrollTo: 'Recorded route',
    );
    await capture('settings', const SettingsScreen());
  });
}

class _ScreenshotController extends SpeedometerController {
  _ScreenshotController(this.style);
  final GaugeStyle style;
  @override
  SpeedometerState build() => SpeedometerState(
    preferences: DisplayPreferences(
      hasDisclosureConsent: true,
      gaugeStyle: style,
      nightHud: style == GaugeStyle.hud,
      limitEnabled: true,
      speedLimitMetersPerSecond: 80 / 3.6,
    ),
    preferencesLoad: const AsyncData<void>(null),
    activeTripId: 'demo-live',
    status: TrackingStatus.tracking,
    compassHeadingDegrees: 123,
    reading: SpeedReading(
      speedMetersPerSecond: 18.3,
      accuracyMeters: 4,
      latitude: 25,
      longitude: 55,
      timestamp: _epoch,
      altitudeMeters: 18,
      headingDegrees: 123,
    ),
    trip: const TripStats(
      distanceMeters: 12400,
      elapsed: Duration(minutes: 18),
      movingTime: Duration(minutes: 16),
      maxSpeedMetersPerSecond: 25,
    ),
    totals: const TripTotals(
      odometerMeters: 245800,
      todayMeters: 24600,
      weekMeters: 120400,
      monthMeters: 245800,
    ),
  );
}
