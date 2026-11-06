import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../core/feedback/game_feedback.dart';
import '../../core/game_definition.dart';
import '../../core/widgets/pixel_icon.dart';
import 'snake_board.dart';

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

/// Snake: D-pad steers, hold A to run at double speed.
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
  builder: (context, session, input) => SnakeBoard(
    session: session,
    input: input,
    feedback: context.read<GameFeedback>(),
  ),
);
