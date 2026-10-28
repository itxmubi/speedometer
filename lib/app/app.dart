import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../features/speedometer/domain/entities/gauge_style.dart';
import '../features/speedometer/presentation/providers/speedometer_controller.dart';
import '../generated/l10n/app_localizations.dart';
import 'router/app_router.dart';

/// Root application and user-configured foreground-service lifecycle boundary.
class SpeedometerApp extends ConsumerStatefulWidget {
  const SpeedometerApp({super.key});

  @override
  ConsumerState<SpeedometerApp> createState() => _SpeedometerAppState();
}

class _SpeedometerAppState extends ConsumerState<SpeedometerApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(
        ref.read(speedometerControllerProvider.notifier).setAppVisible(true),
      );
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      unawaited(
        ref.read(speedometerControllerProvider.notifier).setAppVisible(false),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preferences = ref.watch(
      speedometerControllerProvider.select((state) => state.preferences),
    );
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(appRouterProvider),
      theme: AppTheme.forPreferences(
        dark: false,
        accentIndex: preferences.accentColorIndex,
        nightHud:
            preferences.nightHud && preferences.gaugeStyle == GaugeStyle.hud,
      ),
      darkTheme: AppTheme.forPreferences(
        dark: true,
        accentIndex: preferences.accentColorIndex,
        nightHud:
            preferences.nightHud && preferences.gaugeStyle == GaugeStyle.hud,
      ),
      themeMode: preferences.darkMode ? ThemeMode.dark : ThemeMode.light,
      locale: preferences.localeCode == null
          ? null
          : Locale(preferences.localeCode ?? 'en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
