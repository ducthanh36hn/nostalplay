import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import 'ads_config.dart';

/// Banner ad slot (320x50). Keeps its height whether or not an ad has loaded
/// so the layout around it never jumps, and quietly stays empty when the ad
/// fails (offline, no fill). Renders nothing when ads are disabled.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  static const double height = 50;

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    final config = context.read<AdsConfig>();
    if (!config.enabled) return;
    _ad = BannerAd(
      adUnitId: config.bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _ad = null;
              _loaded = false;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!context.read<AdsConfig>().enabled) return const SizedBox.shrink();
    final ad = _ad;
    return Semantics(
      label: 'Quảng cáo',
      child: Container(
        height: AdBanner.height + 8,
        alignment: Alignment.center,
        color: NpColors.ground,
        child: _loaded && ad != null
            ? SizedBox(
                width: ad.size.width.toDouble(),
                height: ad.size.height.toDouble(),
                child: AdWidget(ad: ad),
              )
            : null,
      ),
    );
  }
}
