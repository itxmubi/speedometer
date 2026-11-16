import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/logger.dart';
import 'ad_unit_ids.dart';
import 'ads_providers.dart';

/// Standard (non-"large") anchored adaptive banner shown at the bottom of
/// the dashboard.
///
/// Loads Google's public test banner ad unit (see [AdUnitIds]). Google's
/// banner guidance requires reserving fixed ad space while a screen loads
/// so ads never shift other content and invite accidental taps
/// (https://support.google.com/admob/answer/2936217#reserve-ad-space). This
/// widget therefore reserves the final adaptive-banner height up front,
/// before the ad request even starts, instead of expanding from zero height
/// once a creative arrives. If no ad fills, it collapses once to zero
/// height, which only ever happens before the user could have interacted
/// with that space.
class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends ConsumerState<BannerAdWidget> {
  BannerAd? _bannerAd;
  AdSize? _reservedSize;
  bool _loaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (!mounted) return;
    final width = MediaQuery.sizeOf(context).width.truncate();
    // Use the standard (non-"large") anchored adaptive banner: height capped
    // at ~15% of screen height / 50-90dp. The newer "large" variant (up to
    // 20% of screen height, 50-150dp) exists to let publishers opt into a
    // visibly bigger banner for more revenue; this app intentionally keeps
    // the compact, less intrusive size instead. The non-large factory is
    // deprecated upstream purely to steer publishers toward the larger
    // format, not because it stopped working, so the deprecation is
    // suppressed deliberately here.
    final size =
        // ignore: deprecated_member_use
        await AdSize.getAnchoredAdaptiveBannerAdSize(
          Orientation.portrait,
          width,
        ) ??
        AdSize.banner;
    if (!mounted) return;
    // Reserve the final height immediately so the dashboard layout below
    // never shifts once the ad itself finishes loading.
    setState(() => _reservedSize = size);
    await ref.read(adsServiceProvider).initialize();
    if (!mounted) return;
    final bannerAd = BannerAd(
      adUnitId: AdUnitIds.androidBanner,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          const Logger().error('banner_load_failed');
          ad.dispose();
          if (mounted) setState(() => _failed = true);
        },
      ),
    );
    _bannerAd = bannerAd;
    await bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reservedSize = _reservedSize;
    if (reservedSize == null || _failed) return const SizedBox.shrink();
    final bannerAd = _bannerAd;
    return SafeArea(
      top: false,
      child: SizedBox(
        width: reservedSize.width.toDouble(),
        height: reservedSize.height.toDouble(),
        child: _loaded && bannerAd != null
            ? AdWidget(ad: bannerAd)
            : const SizedBox.shrink(),
      ),
    );
  }
}
