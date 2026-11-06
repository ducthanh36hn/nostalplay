import 'package:flutter/widgets.dart';

import 'game_input.dart';
import 'game_session.dart';

/// Builds the content drawn on the LCD for a running game.
typedef GameBuilder =
    Widget Function(BuildContext context, GameSession session, GameInput input);

/// Everything the platform needs to list and run a game. Adding a game means
/// adding one of these to the registry; the core does not change.
class GameDefinition {
  const GameDefinition({
    required this.id,
    required this.title,
    required this.rules,
    required this.dpadHint,
    required this.aHint,
    this.bHint,
    this.gridInfo,
    this.icon,
    required this.builder,
  });

  /// Stable id, also used in storage keys.
  final String id;
  final String title;
  final String rules;

  /// What each control does; a null [bHint] means "not used".
  final String dpadHint;
  final String aHint;
  final String? bHint;
  final String? gridInfo;

  /// Pixel icon for the home card.
  final WidgetBuilder? icon;
  final GameBuilder builder;
}

class GameRegistry {
  GameRegistry(List<GameDefinition> games) : games = List.unmodifiable(games) {
    final seen = <String>{};
    for (final g in games) {
      if (!seen.add(g.id)) {
        throw ArgumentError('Duplicate game id: ${g.id}');
      }
    }
  }

  final List<GameDefinition> games;

  GameDefinition? byId(String id) {
    for (final g in games) {
      if (g.id == id) return g;
    }
    return null;
  }
}
