import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// The app icon's handheld drawn as a widget: bold outline body, striped
/// screen, D-pad, A/B rings and two small dashes. Same artwork as
/// `tools/gen_icon.py`, so the Home header matches the launcher icon.
class HandheldIcon extends StatelessWidget {
  const HandheldIcon({
    super.key,
    this.size = 36,
    this.color = NpColors.primary,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _HandheldPainter(color));
}

class _HandheldPainter extends CustomPainter {
  _HandheldPainter(this.color);

  final Color color;

  // Design space is 1001 px; the handheld occupies x 290..712, y 175..826.
  static const _t = 34.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Fit the 422 x 651 artwork into the square, centred.
    final k = size.height / 651;
    canvas.translate(
      (size.width - 422 * k) / 2 - 290 * k,
      (size.height - 651 * k) / 2 - 175 * k,
    );
    canvas.scale(k);

    final fill = Paint()..color = color;
    Rect r(double x0, double y0, double x1, double y1) =>
        Rect.fromLTRB(x0, y0, x1, y1);

    // Body: square top, rounded bottom, hollow.
    RRect body(double inset, double radius) => RRect.fromRectAndCorners(
      r(290 + inset, 175 + inset, 712 - inset, 826 - inset),
      bottomLeft: Radius.circular(radius),
      bottomRight: Radius.circular(radius),
    );
    canvas.drawDRRect(body(0, 70), body(_t, 30), fill);

    // Screen frame and diagonal stripes clipped to its inside.
    final screen = r(355, 236, 646, 496);
    final inner = screen.deflate(_t);
    canvas.drawDRRect(
      RRect.fromRectXY(screen, 0, 0),
      RRect.fromRectXY(inner, 0, 0),
      fill,
    );
    canvas.save();
    canvas.clipRect(inner);
    final stripe = Paint()
      ..color = color
      ..strokeWidth = _t * 0.95
      ..style = PaintingStyle.stroke;
    for (final c in const [745.0, 870.0, 995.0]) {
      canvas.drawLine(Offset(c - 200, 200), Offset(c - 520, 520), stripe);
    }
    canvas.restore();

    // D-pad.
    canvas.drawRect(r(340, 577, 466, 577 + _t), fill);
    canvas.drawRect(r(383, 534, 383 + _t, 660), fill);

    // A / B rings.
    final ring = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _t;
    for (final c in const [Offset(612, 584), Offset(544, 676)]) {
      canvas.drawCircle(c, 54 - _t / 2, ring);
    }

    // Select / Start dashes.
    canvas.drawRect(r(338, 712, 394, 712 + _t), fill);
    canvas.drawRect(r(414, 712, 470, 712 + _t), fill);
  }

  @override
  bool shouldRepaint(_HandheldPainter old) => old.color != color;
}
