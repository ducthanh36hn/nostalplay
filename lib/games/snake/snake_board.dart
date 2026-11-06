import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/game_action.dart';
import '../../core/game_input.dart';
import '../../core/game_session.dart';
import 'snake_logic.dart';
import 'snake_painter.dart';

/// The playable Snake board: owns the rules object, advances it on a ticker
/// while the session is playing, and reports points / game over.
class SnakeBoard extends StatefulWidget {
  const SnakeBoard({
    super.key,
    required this.session,
    required this.input,
    this.logic,
  });

  final GameSession session;
  final GameInput input;

  /// Injected rules object for tests; a fresh game is created when null.
  final SnakeLogic? logic;

  @override
  State<SnakeBoard> createState() => _SnakeBoardState();
}

class _SnakeBoardState extends State<SnakeBoard>
    with SingleTickerProviderStateMixin {
  /// Holding A runs the snake at double speed (FR-18).
  static const _boostFactor = 2;

  /// Never catch up more than this many moves in one frame.
  static const _maxStepsPerFrame = 3;

  late final SnakeLogic _logic = widget.logic ?? SnakeLogic();
  late final Ticker _ticker;
  final ValueNotifier<int> _repaint = ValueNotifier(0);
  late final StreamSubscription<GameAction> _downs;
  Duration _last = Duration.zero;
  bool _skipNextDelta = true;
  double _accumulatedMs = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
    _ticker.muted = !widget.session.isPlaying;
    widget.session.addListener(_onSession);
    _downs = widget.input.downs.listen(_onDown);
  }

  /// The ticker only runs while playing, so a paused or finished game costs
  /// no frames. Resuming starts a fresh clock instead of catching up.
  void _onSession() {
    final playing = widget.session.isPlaying;
    if (playing && _ticker.muted) _skipNextDelta = true;
    _ticker.muted = !playing;
  }

  @override
  void dispose() {
    widget.session.removeListener(_onSession);
    _downs.cancel();
    _ticker.dispose();
    _repaint.dispose();
    super.dispose();
  }

  void _onDown(GameAction a) {
    if (!widget.session.isPlaying) return;
    final d = switch (a) {
      GameAction.up => Direction.up,
      GameAction.down => Direction.down,
      GameAction.left => Direction.left,
      GameAction.right => Direction.right,
      _ => null,
    };
    if (d != null) _logic.turn(d);
  }

  void _onTick(Duration elapsed) {
    final dtMs = _skipNextDelta ? 0.0 : (elapsed - _last).inMicroseconds / 1000;
    _skipNextDelta = false;
    _last = elapsed;
    if (!widget.session.isPlaying) {
      _accumulatedMs = 0;
      return;
    }
    _accumulatedMs += math.min(dtMs, _logic.tickMs.toDouble());

    var steps = 0;
    while (steps < _maxStepsPerFrame && widget.session.isPlaying) {
      final boost = widget.input.isHeld(GameAction.buttonA) ? _boostFactor : 1;
      final interval = _logic.tickMs / boost;
      if (_accumulatedMs < interval) break;
      _accumulatedMs -= interval;
      steps++;
      _advance();
    }
    if (steps > 0) _repaint.value++;
  }

  void _advance() {
    switch (_logic.step()) {
      case StepOutcome.moved:
        break;
      case StepOutcome.ate:
        widget.session.addScore(SnakeLogic.pointsPerFood);
      case StepOutcome.died:
        widget.session.gameOver();
      case StepOutcome.won:
        widget.session.addScore(SnakeLogic.pointsPerFood);
        widget.session.gameOver(won: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: SnakePainter(_logic, repaint: _repaint),
        size: Size.infinite,
      ),
    );
  }
}
