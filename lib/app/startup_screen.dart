import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/speedometer/presentation/providers/speedometer_controller.dart';
import '../generated/l10n/app_localizations.dart';

/// Shows loading and recoverable storage errors before entering the dashboard.
class StartupScreen extends ConsumerWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speedometerControllerProvider);
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: state.initializationFailed
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(strings.preferencesLoadFailure),
                    FilledButton(
                      onPressed: () => ref
                          .read(speedometerControllerProvider.notifier)
                          .loadPreferences(),
                      child: Text(strings.retry),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .read(speedometerControllerProvider.notifier)
                          .useDefaultPreferences(),
                      child: Text(strings.continueWithDefaults),
                    ),
                  ],
                )
              : Semantics(
                  label: strings.loadingPreferences,
                  child: const CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
