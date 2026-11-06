import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// A tiny pixel-art icon: filled rects on a [grid] x [grid] board.
class PixelIcon extends StatelessWidget {
  const PixelIcon({
    super.key,
    required this.cells,
    this.grid = 16,
    this.color = NpColors.lcdDeep,
    this.size = 48,
  });

  final List<Rect> cells;
  final int grid;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _PixelPainter(cells, grid, color),
    );
  }
}

class _PixelPainter extends CustomPainter {
  _PixelPainter(this.cells, this.grid, this.color);

  final List<Rect> cells;
  final int grid;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width / grid;
    final paint = Paint()
      ..color = color
      ..isAntiAlias = false;
    for (final c in cells) {
      canvas.drawRect(
        Rect.fromLTWH(c.left * u, c.top * u, c.width * u, c.height * u),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_PixelPainter old) =>
      old.cells != cells || old.grid != grid || old.color != color;
}
