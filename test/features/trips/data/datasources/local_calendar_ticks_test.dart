import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:speedometer/features/trips/data/datasources/local_calendar_ticks.dart';

void main() {
  testWidgets('midnight timer reschedules and cancellation releases it', (
    tester,
  ) async {
    var now = DateTime(2026, 10, 31, 23, 59, 59);
    var ticks = 0;
    final subscription = localCalendarTicks(() => now).listen((_) => ticks++);
    await tester.pump();
    now = DateTime(2026, 11, 1);
    await tester.pump(const Duration(seconds: 1));
    expect(ticks, 1);
    now = DateTime(2026, 11, 2);
    await tester.pump(const Duration(days: 1));
    expect(ticks, 2);
    unawaited(subscription.cancel());
    await tester.pump();
    await tester.pump(const Duration(days: 1));
    expect(ticks, 2);
  });
}
