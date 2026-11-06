import 'dart:io' show Platform;

/// AdMob settings. The IDs below are Google's public **test** IDs: they always
/// serve test ads and are safe to ship in development. Before release, replace
/// them with the real ones (and the matching app IDs in
/// `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`).
class AdsConfig {
  const AdsConfig({required this.enabled});

  /// No ads (tests, or builds that must stay offline).
  const AdsConfig.disabled() : enabled = false;

  final bool enabled;

  static const _androidBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const _iosBanner = 'ca-app-pub-3940256099942544/2934735716';

  String get bannerUnitId => Platform.isIOS ? _iosBanner : _androidBanner;
}
