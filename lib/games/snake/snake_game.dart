import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/game_action.dart';
import '../../core/game_definition.dart';
import '../../core/game_input.dart';
import '../../core/game_session.dart';
import '../../core/widgets/pixel_icon.dart';

const _snakeCells = <Rect>[
  Rect.fromLTWH(3, 3, 2, 2),
  Rect.fromLTWH(5, 3, 2, 2),
  Rect.fromLTWH(7, 3, 2, 2),
  Rect.fromLTWH(9, 3, 2, 2),
  Rect.fromLTWH(9, 5, 2, 2),
  Rect.fromLTWH(9, 7, 2, 2),
  Rect.fromLTWH(7, 7, 2, 2),
  Rect.fromLTWH(5, 7, 2, 2),
  Rect.fromLTWH(5, 9, 2, 2),
  Rect.fromLTWH(5, 11, 2, 2),
  Rect.fromLTWH(7, 11, 2, 2),
  Rect.fromLTWH(9, 11, 2, 2),
  Rect.fromLTWH(11, 11, 2, 2),
  Rect.fromLTWH(13, 4, 2, 2),
];

/// Snake. The board is a TEMPORARY placeholder until step 5: A scores 10,
/// B ends the run, so the platform flow can be exercised end to end.
final GameDefinition snakeGame = GameDefinition(
  id: 'snake',
  title: 'Snake',
  rules:
      'Điều khiển rắn ăn mồi để dài ra. Đâm vào tường hoặc thân mình là '
      'thua. Càng ăn nhiều, rắn càng nhanh.',
  dpadHint: 'Đổi hướng',
  aHint: 'Giữ để tăng tốc',
  gridInfo: 'Lưới: 16 × 16',
  icon: (_) => const PixelIcon(cells: _snakeCells, size: 48),
  builder: (context, session, input) =>
      _PlaceholderBoard(session: session, input: input),
);

class _PlaceholderBoard extends StatefulWidget {
  const _PlaceholderBoard({required this.session, required this.input});

  final GameSession session;
  final GameInput input;

  @override
  State<_PlaceholderBoard> createState() => _PlaceholderBoardState();
}

class _PlaceholderBoardState extends State<_PlaceholderBoard> {
  late final StreamSubscription<GameAction> _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.input.downs.listen((a) {
      if (!widget.session.isPlaying) return;
      if (a == GameAction.buttonA) widget.session.addScore(10);
      if (a == GameAction.buttonB) widget.session.gameOver();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
