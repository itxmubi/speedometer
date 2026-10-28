import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/theme/app_spacing.dart';
import 'package:speedometer/core/theme/app_theme.dart';
import 'package:speedometer/core/theme/app_typography.dart';
import 'package:speedometer/features/speedometer/presentation/widgets/analog_gauge.dart';

void main() {
  testWidgets('dial includes speed, limit marker, and accessible readout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 340);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: RepaintBoundary(
            key: const Key('dial-golden'),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: AnalogGauge(
                speed: 85,
                limit: 100,
                range: 200,
                labels: const [
                  '0',
                  '25',
                  '50',
                  '75',
                  '100',
                  '125',
                  '150',
                  '175',
                  '200',
                ],
                overLimit: false,
                semanticLabel: 'Current speed 85 km/h',
                child: Text(
                  '85',
                  style: AppTypography.analogSpeed.copyWith(
                    color: AppTheme.dark.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Current speed 85 km/h'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byKey(const Key('dial-golden')),
      matchesGoldenFile('goldens/analog_gauge.png'),
    );
  });
}
