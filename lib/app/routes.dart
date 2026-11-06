import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/game_definition.dart';
import 'screens/game_detail_screen.dart';
import 'screens/game_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';

class Routes {
  const Routes._();

  static const home = '/';
  static const detail = '/detail';
  static const play = '/play';
  static const settings = '/settings';
}

/// `detail` and `play` take the game id as route arguments.
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.home:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const HomeScreen(),
      );
    case Routes.settings:
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const SettingsScreen(),
      );
    case Routes.detail:
    case Routes.play:
      final id = settings.arguments as String?;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) {
          final game = id == null
              ? null
              : context.read<GameRegistry>().byId(id);
          if (game == null) return const HomeScreen();
          return settings.name == Routes.detail
              ? GameDetailScreen(game: game)
              : GameScreen(game: game);
        },
      );
  }
  return null;
}
