import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app/app.dart';
import 'core/ads/ads_config.dart';
import 'core/feedback/platform_feedback.dart';
import 'core/storage/app_storage.dart';
import 'games/games.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
  // Not awaited: ads must never delay the first frame.
  unawaited(MobileAds.instance.initialize());
  final storage = await AppStorage.load();
  runApp(
    NostalPlayApp(
      storage: storage,
      registry: buildGameRegistry(),
      sfx: AudioSfxPlayer(),
      haptics: const SystemHaptics(),
      ads: const AdsConfig(enabled: true),
    ),
  );
}
