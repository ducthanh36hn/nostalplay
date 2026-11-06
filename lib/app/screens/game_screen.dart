import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/feedback/game_feedback.dart';
import '../../core/game_action.dart';
import '../../core/game_definition.dart';
import '../../core/game_input.dart';
import '../../core/game_session.dart';
import '../../core/settings_controller.dart';
import '../../core/storage/app_storage.dart';
import '../../core/widgets/console_shell.dart';
import '../../core/widgets/lcd_dialog.dart';
import '../theme.dart';

/// Hosts one running game: console, LCD content and the Ready / Pause /
/// Game Over overlays. Menu actions are routed from the A/B buttons by state.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.game});

  final GameDefinition game;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameSession _session;
  final GameInput _input = GameInput();
  SessionState? _lastState;
  late final GameFeedback _feedback;

  /// D-pad cursor in the Pause menu: resume, restart, menu, sound, vibration.
  int _pauseIndex = 0;
  static const _pauseItems = 5;

  /// D-pad cursor in the Game Over menu: play again, back to menu.
  int _overIndex = 0;
  static const _overItems = 2;

  @override
  void initState() {
    super.initState();
    _feedback = context.read<GameFeedback>();
    _session =
        GameSession(gameId: widget.game.id, storage: context.read<AppStorage>())
          ..attachLifecycle()
          ..addListener(_onSessionChanged);
  }

  void _onSessionChanged() {
    // Nothing may stay "held" across a pause, game over or restart.
    final changed = _session.state != _lastState;
    if (changed && _session.state == SessionState.paused) _pauseIndex = 0;
    if (changed && _session.state == SessionState.gameOver) _overIndex = 0;
    if (changed && !_session.isPlaying) _input.releaseAll();
    if (changed && _session.state == SessionState.gameOver) {
      _feedback.gameOver(newRecord: _session.newRecord);
    }
    _lastState = _session.state;
  }

  @override
  void dispose() {
    _session.quit();
    _session.dispose();
    _input.dispose();
    super.dispose();
  }

  void _leave() => Navigator.of(context).pop();

  void _playAgain() {
    _session
      ..restart()
      ..start();
  }

  void _onActionDown(GameAction a) {
    // The game sees the press first, but the menu routing uses the state the
    // press arrived in: a press that ends the run must not also act on the
    // Game Over menu.
    final state = _session.state;
    _feedback.buttonPressed();
    _input.down(a);
    switch (state) {
      case SessionState.ready:
        if (a == GameAction.buttonA) _session.start();
      case SessionState.paused:
        switch (a) {
          case GameAction.up:
            setState(() => _pauseIndex = (_pauseIndex - 1) % _pauseItems);
          case GameAction.down:
            setState(() => _pauseIndex = (_pauseIndex + 1) % _pauseItems);
          case GameAction.buttonA:
            _activatePauseItem(_pauseIndex);
          case GameAction.buttonB || GameAction.left || GameAction.right:
            break;
        }
      case SessionState.gameOver:
        switch (a) {
          case GameAction.up:
            setState(() => _overIndex = (_overIndex - 1) % _overItems);
          case GameAction.down:
            setState(() => _overIndex = (_overIndex + 1) % _overItems);
          case GameAction.buttonA:
            _overIndex == 0 ? _playAgain() : _leave();
          case GameAction.buttonB || GameAction.left || GameAction.right:
            break;
        }
      case SessionState.playing:
        break;
    }
  }

  void _activatePauseItem(int i) {
    final settings = context.read<SettingsController>();
    switch (i) {
      case 0:
        _session.resume();
      case 1:
        _playAgain();
      case 2:
        _leave();
      case 3:
        settings.setSound(!settings.soundEnabled);
      case 4:
        settings.setHaptics(!settings.hapticsEnabled);
    }
  }

  void _onPausePressed() {
    if (_session.state == SessionState.playing) {
      _session.pause();
    } else if (_session.state == SessionState.paused) {
      _session.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _session,
      builder: (context, _) {
        final state = _session.state;
        return PopScope(
          canPop: state == SessionState.ready || state == SessionState.gameOver,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            _onPausePressed();
          },
          child: Scaffold(
            body: ConsoleShell(
              leftStatus: 'SCORE ${_pad(_session.score)}',
              rightStatus: 'BEST ${_pad(_session.best)}',
              dimControls: state == SessionState.paused,
              onPause: _onPausePressed,
              onActionDown: _onActionDown,
              onActionUp: _input.up,
              lcd: Stack(
                fit: StackFit.expand,
                children: [
                  KeyedSubtree(
                    key: ValueKey(_session.runId),
                    child: widget.game.builder(context, _session, _input),
                  ),
                  if (state == SessionState.ready) _ready(),
                  if (state == SessionState.paused) _pause(),
                  if (state == SessionState.gameOver) _gameOver(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String _pad(int n) => n.toString().padLeft(4, '0');

  Widget _overlay(
    Widget child, {
    bool dim = false,
    Alignment alignment = Alignment.center,
  }) {
    return ColoredBox(
      color: dim ? NpColors.lcdDark.withValues(alpha: 0.7) : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Align(
          alignment: alignment,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(width: 256, child: child),
          ),
        ),
      ),
    );
  }

  Widget _ready() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _session.start,
      // Above the middle row so the snake and apple stay visible.
      child: _overlay(
        const LcdBadge(text: 'NHẤN A ĐỂ CHƠI'),
        alignment: const Alignment(0, -0.6),
      ),
    );
  }

  Widget _pause() {
    final settings = context.watch<SettingsController>();
    return _overlay(
      dim: true,
      LcdDialog(
        title: 'Tạm dừng',
        children: [
          LcdButton(
            label: 'Tiếp tục',
            primary: _pauseIndex == 0,
            hint: _pauseIndex == 0 ? 'A' : null,
            onPressed: () => _activatePauseItem(0),
          ),
          const SizedBox(height: 8),
          LcdButton(
            label: 'Chơi lại',
            primary: _pauseIndex == 1,
            hint: _pauseIndex == 1 ? 'A' : null,
            onPressed: () => _activatePauseItem(1),
          ),
          const SizedBox(height: 8),
          LcdButton(
            label: 'Về menu',
            primary: _pauseIndex == 2,
            hint: _pauseIndex == 2 ? 'A' : null,
            onPressed: () => _activatePauseItem(2),
          ),
          const SizedBox(height: 4),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              LcdToggle(
                icon: Icons.volume_up,
                label: 'Âm thanh',
                value: settings.soundEnabled,
                selected: _pauseIndex == 3,
                onChanged: settings.setSound,
              ),
              LcdToggle(
                icon: Icons.vibration,
                label: 'Rung',
                value: settings.hapticsEnabled,
                selected: _pauseIndex == 4,
                onChanged: settings.setHaptics,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gameOver() {
    return _overlay(
      LcdDialog(
        title: _session.won ? 'Hoàn hảo!' : 'Game over',
        children: [
          if (_session.newRecord) ...[
            const Center(
              child: LcdBadge(text: '★ KỶ LỤC MỚI! ★', inverted: true),
            ),
            const SizedBox(height: 8),
          ],
          _stat('Điểm', _session.score),
          const SizedBox(height: 4),
          _stat('Kỷ lục (best)', _session.best),
          const SizedBox(height: 10),
          LcdButton(
            label: 'Chơi lại',
            primary: _overIndex == 0,
            hint: _overIndex == 0 ? 'A' : null,
            onPressed: _playAgain,
          ),
          const SizedBox(height: 8),
          LcdButton(
            label: 'Về menu',
            primary: _overIndex == 1,
            hint: _overIndex == 1 ? 'A' : null,
            onPressed: _leave,
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, int value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${label.toUpperCase()}:',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: lcdStyle(size: 12),
          ),
        ),
        const SizedBox(width: 8),
        Text('$value', style: lcdStyle(size: 14)),
      ],
    );
  }
}
