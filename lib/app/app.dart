import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/game_definition.dart';
import '../core/settings_controller.dart';
import '../core/storage/app_storage.dart';
import 'screens/demo_screen.dart';
import 'theme.dart';

class NostalPlayApp extends StatelessWidget {
  const NostalPlayApp({
    super.key,
    required this.storage,
    required this.registry,
  });

  final AppStorage storage;
  final GameRegistry registry;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppStorage>.value(value: storage),
        Provider<GameRegistry>.value(value: registry),
        ChangeNotifierProvider(create: (_) => SettingsController(storage)),
      ],
      child: MaterialApp(
        title: 'NostalPlay',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const DemoScreen(),
      ),
    );
  }
}
