import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/ads/ads_providers.dart';
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
  // App open ads are Google's documented format for "shown when a user
  // opens or switches back to an app" (see AdUnitIds.androidAppOpen). Google
  // explicitly disallows plain interstitials on app load/resume.
  bool _wasBackgrounded = false;
  bool _isShowingAppOpenAd = false;
  int _resumeCount = 0;
  AppOpenAd? _appOpenAd;

  // Shows at most every third return from the background, so it never
  // appears on the very first launch and isn't shown every single time.
  static const int _appOpenEveryNthResume = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Preload before it's needed so the ad is ready by the time the user
    // next returns from the background, with no visible wait.
    unawaited(_preloadAppOpenAd());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(
        ref.read(speedometerControllerProvider.notifier).setAppVisible(true),
      );
      if (_wasBackgrounded && !_isShowingAppOpenAd) {
        _wasBackgrounded = false;
        _resumeCount++;
        if (_resumeCount % _appOpenEveryNthResume == 0) {
          _showAppOpenAdIfReady();
        }
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _wasBackgrounded = true;
      unawaited(
        ref.read(speedometerControllerProvider.notifier).setAppVisible(false),
      );
    }
  }

  Future<void> _preloadAppOpenAd() async {
    final ads = ref.read(adsServiceProvider);
    await ads.initialize();
    ads.loadAppOpenAd(
      onLoaded: (ad) {
        _appOpenAd = ad;
      },
    );
  }

  void _showAppOpenAdIfReady() {
    final ad = _appOpenAd;
    if (ad == null) return;
    _appOpenAd = null;
    _isShowingAppOpenAd = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _isShowingAppOpenAd = false;
        // Preload the next ad for the following background return.
        unawaited(_preloadAppOpenAd());
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _isShowingAppOpenAd = false;
        unawaited(_preloadAppOpenAd());
      },
    );
    ad.show();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appOpenAd?.dispose();
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
