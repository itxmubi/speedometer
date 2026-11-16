import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/logger.dart';
import 'ad_unit_ids.dart';

/// Thin wrapper around the Google Mobile Ads SDK.
///
/// Uses only Google's public test ad unit IDs (see [AdUnitIds]). The SDK
/// itself performs network requests and ad-related data collection even for
/// test ads, which is why this is isolated behind one small class rather
/// than used directly from widgets.
class AdsService {
  AdsService({Logger logger = const Logger()}) : _logger = logger;

  final Logger _logger;
  bool _initialized = false;

  /// Initializes the Mobile Ads SDK. Safe to call more than once.
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
    } catch (_) {
      _logger.error('ads_init_failed');
    }
  }

  /// Loads an app open ad, invoking [onLoaded] with the loaded instance or
  /// [onFailed] if loading failed. Never throws.
  ///
  /// App open ads are Google's documented format for "shown when a user
  /// opens or switches back to an app"; plain interstitials are explicitly
  /// disallowed on app load/resume (see [AdUnitIds.androidAppOpen]).
  void loadAppOpenAd({
    required void Function(AppOpenAd ad) onLoaded,
    void Function()? onFailed,
  }) {
    AppOpenAd.load(
      adUnitId: AdUnitIds.androidAppOpen,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: (error) {
          _logger.error('app_open_ad_load_failed');
          onFailed?.call();
        },
      ),
    );
  }
}
