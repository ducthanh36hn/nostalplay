import 'dart:async';
import 'dart:io' show Platform;

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_controller.dart';

/// Real implementation: ATT (iOS), Google UMP consent, Mobile Ads SDK.
class GoogleAdsPlatform implements AdsPlatform {
  @override
  Future<void> requestTracking() async {
    if (!Platform.isIOS) return;
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  @override
  Future<bool> gatherConsent() async {
    final info = ConsentInformation.instance;
    final updated = Completer<void>();
    info.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      updated.complete,
      (error) => updated.complete(), // keep going with whatever is cached
    );
    await updated.future;
    final shown = Completer<void>();
    unawaited(
      ConsentForm.loadAndShowConsentFormIfRequired((_) => shown.complete()),
    );
    await shown.future;
    return info.canRequestAds();
  }

  @override
  Future<bool> privacyOptionsRequired() async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() ==
      PrivacyOptionsRequirementStatus.required;

  @override
  Future<void> showPrivacyOptions() {
    final done = Completer<void>();
    unawaited(ConsentForm.showPrivacyOptionsForm((_) => done.complete()));
    return done.future;
  }

  @override
  Future<void> initializeSdk() => MobileAds.instance.initialize();
}
