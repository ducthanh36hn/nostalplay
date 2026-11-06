import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/core/ads/ads_config.dart';
import 'package:nostalplay/core/ads/ads_controller.dart';

class _FakePlatform implements AdsPlatform {
  _FakePlatform({this.canRequest = true, this.privacy = false});

  final bool canRequest;
  bool privacy;
  final log = <String>[];

  @override
  Future<void> requestTracking() async => log.add('att');

  @override
  Future<bool> gatherConsent() async {
    log.add('consent');
    return canRequest;
  }

  @override
  Future<bool> privacyOptionsRequired() async => privacy;

  @override
  Future<void> showPrivacyOptions() async => log.add('options');

  @override
  Future<void> initializeSdk() async => log.add('init');
}

class _ThrowingPlatform extends _FakePlatform {
  @override
  Future<void> requestTracking() => throw StateError('boom');
}

void main() {
  const config = AdsConfig(enabled: true);

  test('tracking, then consent, then SDK init, then ads allowed', () async {
    final p = _FakePlatform(privacy: true);
    final c = AdsController(config: config, platform: p);
    expect(c.canShowAds, isFalse);
    await c.start();
    expect(p.log, ['att', 'consent', 'init']);
    expect(c.canShowAds, isTrue);
    expect(c.privacyOptionsRequired, isTrue);
  });

  test('no consent: SDK stays uninitialised and no ads', () async {
    final p = _FakePlatform(canRequest: false);
    final c = AdsController(config: config, platform: p);
    await c.start();
    expect(p.log, ['att', 'consent']);
    expect(c.canShowAds, isFalse);
  });

  test('a platform error never escapes and shows no ads', () async {
    final c = AdsController(config: config, platform: _ThrowingPlatform());
    await c.start();
    expect(c.canShowAds, isFalse);
  });

  test('start runs once; disabled controller does nothing', () async {
    final p = _FakePlatform();
    final c = AdsController(config: config, platform: p);
    await c.start();
    await c.start();
    expect(p.log.where((e) => e == 'att'), hasLength(1));

    final off = AdsController.disabled();
    await off.start();
    expect(off.enabled, isFalse);
    expect(off.canShowAds, isFalse);
  });

  test('privacy options re-check consent afterwards', () async {
    final p = _FakePlatform();
    final c = AdsController(config: config, platform: p);
    await c.start();
    p.log.clear();
    await c.showPrivacyOptions();
    expect(p.log, ['options', 'consent']);
  });
}
