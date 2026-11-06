import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/ads/ads_controller.dart';
import '../core/feedback/game_feedback.dart';
import '../core/game_definition.dart';
import '../core/l10n/strings.dart';
import '../core/settings_controller.dart';
import '../core/storage/app_storage.dart';
import 'routes.dart';
import 'theme.dart';

class NostalPlayApp extends StatelessWidget {
  const NostalPlayApp({
    super.key,
    required this.storage,
    required this.registry,
    required this.sfx,
    required this.haptics,
    this.ads,
  });

  static final AdsController _noAds = AdsController.disabled();

  final AppStorage storage;
  final GameRegistry registry;
  final SfxPlayer sfx;
  final HapticsDriver haptics;

  /// Null means no ads (tests).
  final AdsController? ads;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppStorage>.value(value: storage),
        Provider<GameRegistry>.value(value: registry),
        ChangeNotifierProvider<AdsController>.value(value: ads ?? _noAds),
        ChangeNotifierProvider(create: (_) => SettingsController(storage)),
        Provider<GameFeedback>(
          create: (context) => GameFeedback(
            settings: context.read<SettingsController>(),
            sfx: sfx,
            haptics: haptics,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'NostalPlay',
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final settings = context.watch<SettingsController>();
          return StringsScope(strings: settings.strings, child: child!);
        },
        theme: buildTheme(),
        initialRoute: Routes.home,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
