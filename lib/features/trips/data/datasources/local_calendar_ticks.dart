import 'dart:async';

/// Emits at local midnight without polling; cancellation releases its timer.
/// Re-subscribe on app resume to account for manual clock/timezone changes.
Stream<void> localCalendarTicks(DateTime Function() now) =>
    Stream<void>.multi((sink) {
      Timer? timer;
      void schedule() {
        final current = now().toLocal();
        final midnight = DateTime(current.year, current.month, current.day + 1);
        timer = Timer(midnight.difference(current), () {
          sink.add(null);
          schedule();
        });
      }

      schedule();
      sink.onCancel = () => timer?.cancel();
    });
