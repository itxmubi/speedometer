import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/core/error/failure.dart';
import 'package:speedometer/core/error/failure_kind.dart';
import 'package:speedometer/core/error/result.dart';
import 'package:speedometer/core/theme/app_theme.dart';
import 'package:speedometer/features/fuel/domain/entities/fuel_entry.dart';
import 'package:speedometer/features/fuel/domain/repositories/fuel_repository.dart';
import 'package:speedometer/features/fuel/presentation/providers/fuel_providers.dart';
import 'package:speedometer/features/fuel/presentation/screens/fuel_screen.dart';
import 'package:speedometer/generated/l10n/app_localizations.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    _Repository repository, {
    VoidCallback? onOpenMileageLog,
    Locale locale = const Locale('en'),
    Size size = const Size(600, 1000),
    double textScale = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(repository.updates.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          fuelRepositoryProvider.overrideWithValue(repository),
          fuelNowProvider.overrideWithValue(() => DateTime(2026, 10, 22)),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          home: FuelScreen(onOpenMileageLog: onOpenMileageLog),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('handles loading, error and empty without accessing a platform', (
    tester,
  ) async {
    final repository = _Repository()..waitForFirst = true;
    await pump(tester, repository);
    await tester.pump();
    await tester.pump();
    expect(repository.updates.hasListener, isTrue);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.updates.add(const Error(Failure(FailureKind.storage)));
    await tester.pumpAndSettle();
    final retry = AppLocalizations.of(
      tester.element(find.byType(FuelScreen)),
    ).retry;
    expect(find.text(retry), findsOneWidget);
    repository.waitForFirst = false;
    await tester.tap(find.text(retry));
    await tester.pumpAndSettle();
    expect(find.text('No fuel or vehicle costs yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('summary shows separate currencies and opens mileage history', (
    tester,
  ) async {
    final repository = _Repository()
      ..entries = [entry('usd'), entry('aed', currency: 'AED')];
    var opened = false;
    await pump(tester, repository, onOpenMileageLog: () => opened = true);
    await tester.pumpAndSettle();
    expect(find.text('AED'), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    expect(find.textContaining('L/100 km'), findsWidgets);
    await tester.tap(find.text('Trip mileage log'));
    expect(opened, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('validates input then persists an explicit fuel interval', (
    tester,
  ) async {
    final repository = _Repository();
    await pump(tester, repository);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add entry'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save entry'));
    await tester.tap(find.text('Save entry'));
    await tester.pumpAndSettle();
    expect(repository.entries, isEmpty);
    expect(find.textContaining('Enter valid numbers.'), findsOneWidget);
    Future<void> enter(String label, String value) async {
      final field = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == label,
      );
      await tester.ensureVisible(field);
      await tester.enterText(field, value);
    }

    await enter('Distance covered km', '100');
    await enter('Fuel used L', '7.5');
    await enter('Currency code', 'aed');
    await enter('Fuel cost', '25');
    await enter('Other vehicle costs', '10');
    await tester.ensureVisible(find.text('Save entry'));
    await tester.tap(find.text('Save entry'));
    await tester.pumpAndSettle();
    expect(repository.entries.single.distanceMeters, 100000);
    expect(repository.entries.single.fuelLiters, 7.5);
    expect(repository.entries.single.currencyCode, 'AED');
    expect(repository.entries.single.totalCost, 35);
    expect(find.text('Entry saved'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('deletes only after user confirms the selected entry', (
    tester,
  ) async {
    final repository = _Repository()..entries = [entry('id')];
    await pump(tester, repository);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Delete entry'), 300);
    await tester.tap(find.text('Delete entry'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(repository.entries, hasLength(1));
    await tester.tap(find.text('Delete entry'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete entry'));
    await tester.pumpAndSettle();
    expect(repository.entries, isEmpty);
    expect(find.text('Entry deleted'), findsOneWidget);
  });

  for (final locale in [const Locale('en'), const Locale('ar')]) {
    testWidgets(
      'fits small screens with large text in ${locale.languageCode}',
      (tester) async {
        final repository = _Repository()..entries = [entry('id')];
        await pump(
          tester,
          repository,
          locale: locale,
          size: const Size(320, 640),
          textScale: 2,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final context = tester.element(find.byType(FuelScreen));
        final l10n = AppLocalizations.of(context);
        await tester.ensureVisible(find.text(l10n.fuelAddEntry));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.fuelAddEntry));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}

FuelEntry entry(String id, {String currency = 'USD'}) => FuelEntry(
  id: id,
  occurredAt: DateTime.utc(2026, 10, 22),
  distanceMeters: 100000,
  fuelLiters: 5,
  fuelCost: 10,
  otherCost: 0,
  currencyCode: currency,
);

final class _Repository implements FuelRepository {
  final updates = StreamController<Result<List<FuelEntry>>>.broadcast();
  var entries = <FuelEntry>[];
  var waitForFirst = false;

  @override
  Stream<Result<List<FuelEntry>>> watchEntries() async* {
    if (!waitForFirst) yield Success(List.unmodifiable(entries));
    yield* updates.stream;
  }

  @override
  Future<Result<void>> saveEntry(FuelEntry entry) async {
    entries = [entry];
    updates.add(Success(List.unmodifiable(entries)));
    return const Success(null);
  }

  @override
  Future<Result<void>> deleteEntry(String id) async {
    entries = entries.where((entry) => entry.id != id).toList();
    updates.add(Success(List.unmodifiable(entries)));
    return const Success(null);
  }
}
