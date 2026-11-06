import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'snake_logic.dart';

/// Draws the Snake grid on the LCD. Repaints whenever [repaint] notifies.
class SnakePainter extends CustomPainter {
  SnakePainter(this.logic, {required Listenable repaint})
    : super(repaint: repaint);

  final SnakeLogic logic;

  static const _apple = <Offset>[
    Offset(1, 0),
    Offset(0, 1),
    Offset(1, 1),
    Offset(2, 1),
    Offset(1, 2),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final n = logic.size;
    final cell = size.width / n;

    final grid = Paint()
      ..color = NpColors.lcdMid.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    for (var i = 1; i < n; i++) {
      final p = i * cell;
      canvas.drawLine(Offset(p, 0), Offset(p, size.height), grid);
      canvas.drawLine(Offset(0, p), Offset(size.width, p), grid);
    }

    final ink = Paint()
      ..color = NpColors.lcdDeep
      ..isAntiAlias = false;

    final food = logic.food;
    if (food != null) {
      final u = cell / 3;
      for (final o in _apple) {
        canvas.drawRect(
          Rect.fromLTWH(
            food.x * cell + o.dx * u,
            food.y * cell + o.dy * u,
            u,
            u,
          ),
          ink,
        );
      }
    }

    final inset = cell > 8 ? 1.0 : 0.0;
    for (var i = 0; i < logic.body.length; i++) {
      final c = logic.body[i];
      // The head fills its whole cell so it reads as the front.
      final k = i == 0 ? 0.0 : inset;
      canvas.drawRect(
        Rect.fromLTWH(
          c.x * cell + k,
          c.y * cell + k,
          cell - 2 * k,
          cell - 2 * k,
        ),
        ink,
      );
    }
  }

  @override
  bool shouldRepaint(SnakePainter old) => old.logic != logic;
}
