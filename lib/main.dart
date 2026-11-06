import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/app.dart';
import 'core/ads/ads_config.dart';
import 'core/ads/ads_controller.dart';
import 'core/ads/google_ads_platform.dart';
import 'core/feedback/platform_feedback.dart';
import 'core/storage/app_storage.dart';
import 'games/games.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
  final storage = await AppStorage.load();
  final ads = AdsController(
    config: const AdsConfig(enabled: true),
    platform: GoogleAdsPlatform(),
  );
  runApp(
    NostalPlayApp(
      storage: storage,
      registry: buildGameRegistry(),
      sfx: AudioSfxPlayer(),
      haptics: const SystemHaptics(),
      ads: ads,
    ),
  );
  // Shortly after the first frame (iOS only shows the tracking prompt once the
  // app is active) and never awaited: ads must not delay the app.
  unawaited(Future<void>.delayed(const Duration(seconds: 1), ads.start));
}
