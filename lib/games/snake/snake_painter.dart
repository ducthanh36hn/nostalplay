import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'snake_logic.dart';

/// Animation state shared between the board (writer) and painter (reader).
class SnakeFrame {
  /// Body before the latest move, head first; the snake slides from it.
  List<Cell> previousBody = const [];

  /// How far through the current move we are, 0..1.
  double progress = 1;

  /// Milliseconds since the game started, for the food pulse.
  double timeMs = 0;

  /// Milliseconds since the current food appeared, for its pop-in.
  double foodAgeMs = 1000;
}

/// Draws the Snake grid on the LCD. Repaints whenever [repaint] notifies.
class SnakePainter extends CustomPainter {
  SnakePainter(this.logic, {required Listenable repaint, SnakeFrame? frame})
    : frame = frame ?? SnakeFrame(),
      super(repaint: repaint);

  final SnakeLogic logic;
  final SnakeFrame frame;

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
      // Pop in with a small overshoot, then breathe gently.
      final t = (frame.foodAgeMs / 180).clamp(0.0, 1.0);
      final pop = t < 1 ? Curves.easeOutBack.transform(t) : 1.0;
      final pulse =
          0.92 + 0.08 * math.sin(frame.timeMs / 1000 * 2 * math.pi * 1.6);
      final scale = pop * pulse;
      final u = cell / 3;
      final centre = Offset((food.x + 0.5) * cell, (food.y + 0.5) * cell);
      for (final o in _apple) {
        final cx = centre.dx + (o.dx - 1) * u * scale;
        final cy = centre.dy + (o.dy - 1) * u * scale;
        final half = u * scale / 2;
        canvas.drawRect(
          Rect.fromLTRB(cx - half, cy - half, cx + half, cy + half),
          ink,
        );
      }
    }

    // Each segment slides from where it was to where it is now.
    final inset = cell > 8 ? 1.0 : 0.0;
    final prev = frame.previousBody;
    final p = Curves.easeOut.transform(frame.progress.clamp(0.0, 1.0));
    for (var i = 0; i < logic.body.length; i++) {
      final to = logic.body[i];
      final from = prev.isEmpty ? to : prev[math.min(i, prev.length - 1)];
      final x = (from.x + (to.x - from.x) * p) * cell;
      final y = (from.y + (to.y - from.y) * p) * cell;
      // The head fills its whole cell so it reads as the front.
      final k = i == 0 ? 0.0 : inset;
      canvas.drawRect(
        Rect.fromLTWH(x + k, y + k, cell - 2 * k, cell - 2 * k),
        ink,
      );
      if (i == 0) _paintHeadDetails(canvas, Offset(x, y), cell, ink);
    }
  }

  /// Eyes on the front of the head, following the direction the snake is
  /// really moving in.
  void _paintHeadDetails(Canvas canvas, Offset origin, double cell, Paint ink) {
    final f = Offset(
      logic.direction.dx.toDouble(),
      logic.direction.dy.toDouble(),
    );
    final side = Offset(-f.dy, f.dx);
    final centre = origin + Offset(cell / 2, cell / 2);

    // Eyes: two bright pixels, a little ahead of the middle.
    final e = math.max(2.0, cell * 0.17);
    final eye = Paint()
      ..color = NpColors.lcdBright
      ..isAntiAlias = false;
    for (final sign in const [-1.0, 1.0]) {
      final c = centre + f * (cell * 0.18) + side * (sign * cell * 0.22);
      canvas.drawRect(Rect.fromCenter(center: c, width: e, height: e), eye);
    }
  }

  @override
  bool shouldRepaint(SnakePainter old) =>
      old.logic != logic || old.frame != frame;
}
