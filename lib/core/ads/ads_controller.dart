import 'dart:async';

import 'package:flutter/foundation.dart';

import 'ads_config.dart';

/// What the ads flow needs from the platform; faked in tests.
abstract class AdsPlatform {
  /// iOS App Tracking Transparency prompt (no-op elsewhere).
  Future<void> requestTracking();

  /// Runs the UMP consent flow and says whether ads may be requested.
  Future<bool> gatherConsent();

  /// Whether the user must be offered a way to change their consent.
  Future<bool> privacyOptionsRequired();

  Future<void> showPrivacyOptions();

  Future<void> initializeSdk();
}

/// Orders the pre-ads steps (tracking prompt, consent) and tells the UI when
/// banners may load. Nothing here may block the app or throw into the UI.
class AdsController extends ChangeNotifier {
  AdsController({required this.config, required AdsPlatform platform})
    : _platform = platform;

  /// No ads at all (tests).
  AdsController.disabled()
    : config = const AdsConfig.disabled(),
      _platform = null;

  final AdsConfig config;
  final AdsPlatform? _platform;

  bool _canShowAds = false;
  bool _privacyRequired = false;
  bool _started = false;

  bool get enabled => config.enabled && _platform != null;
  bool get canShowAds => _canShowAds;
  bool get privacyOptionsRequired => _privacyRequired;

  Future<void> start() async {
    final p = _platform;
    if (!enabled || p == null || _started) return;
    _started = true;
    try {
      await p.requestTracking();
      final canRequest = await p.gatherConsent();
      _privacyRequired = await p.privacyOptionsRequired();
      if (canRequest) {
        await p.initializeSdk();
        _canShowAds = true;
      }
    } catch (e, s) {
      debugPrint('Ads setup failed: $e\n$s');
    }
    notifyListeners();
  }

  Future<void> showPrivacyOptions() async {
    final p = _platform;
    if (p == null) return;
    try {
      await p.showPrivacyOptions();
      // Consent may have changed: refresh what we may show.
      final canRequest = await p.gatherConsent();
      if (canRequest && !_canShowAds) {
        await p.initializeSdk();
        _canShowAds = true;
      }
      _privacyRequired = await p.privacyOptionsRequired();
      notifyListeners();
    } catch (e, s) {
      debugPrint('Privacy options failed: $e\n$s');
    }
  }
}
