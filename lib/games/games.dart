import '../core/game_definition.dart';
import 'snake/snake_game.dart';

/// All games shipped in the app. Adding a game = one more entry here.
GameRegistry buildGameRegistry() => GameRegistry([snakeGame]);
