import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/feedback/game_feedback.dart';
import '../core/game_definition.dart';
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
  });

  final AppStorage storage;
  final GameRegistry registry;
  final SfxPlayer sfx;
  final HapticsDriver haptics;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppStorage>.value(value: storage),
        Provider<GameRegistry>.value(value: registry),
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
        theme: buildTheme(),
        initialRoute: Routes.home,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
