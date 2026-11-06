import 'dart:async';

import 'game_action.dart';

/// Shared input state for one running game. The on-screen controls feed it;
/// games either poll [isHeld] each tick or listen to [downs] / [ups].
class GameInput {
  final Set<GameAction> _held = {};
  final StreamController<GameAction> _downs = StreamController.broadcast(
    sync: true,
  );
  final StreamController<GameAction> _ups = StreamController.broadcast(
    sync: true,
  );

  /// Fires once per press (not per repeat).
  Stream<GameAction> get downs => _downs.stream;
  Stream<GameAction> get ups => _ups.stream;

  Set<GameAction> get held => Set.unmodifiable(_held);

  bool isHeld(GameAction action) => _held.contains(action);

  void down(GameAction action) {
    if (_held.add(action)) _downs.add(action);
  }

  void up(GameAction action) {
    if (_held.remove(action)) _ups.add(action);
  }

  /// Releases everything, e.g. when the game is paused or the app goes to
  /// the background, so no button stays "stuck".
  void releaseAll() {
    for (final a in _held.toList()) {
      up(a);
    }
  }

  void dispose() {
    _downs.close();
    _ups.close();
  }
}
