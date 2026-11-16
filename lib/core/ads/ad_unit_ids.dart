/// Google Mobile Ads identifiers used by this prototype.
///
/// These are Google's official **public demo/test identifiers**
/// (https://developers.google.com/admob/android/test-ads). They always
/// return clearly labeled test creatives, never real ads, and are safe to
/// ship in development builds. **Do not replace them with production ad
/// unit IDs without re-reading `rules.md` and `project_plan.md`** — ads were
/// explicitly out of scope for the free, offline-first positioning described
/// there, so switching to real monetization is a deliberate product
/// decision, not a drop-in configuration change.
abstract final class AdUnitIds {
  /// Google test AdMob application ID, declared in AndroidManifest.xml.
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';

  /// Google test adaptive banner ad unit ID (Android).
  static const String androidBanner = 'ca-app-pub-3940256099942544/9214589741';

  /// Google test app open ad unit ID (Android).
  ///
  /// App open ads, not interstitials, are the format Google documents for
  /// "shown when a user opens or switches back to an app"
  /// (https://support.google.com/admob/answer/9341964). Google's
  /// interstitial policy explicitly disallows showing an interstitial on
  /// app load or resume (https://support.google.com/admob/answer/6201362),
  /// so this app must not reuse the interstitial unit ID for that trigger.
  static const String androidAppOpen = 'ca-app-pub-3940256099942544/9257395921';
}
