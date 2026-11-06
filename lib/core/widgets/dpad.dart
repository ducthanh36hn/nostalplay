import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../game_action.dart';

/// Maps a touch position inside a square D-pad of [size] to a direction.
/// Returns null in the centre dead zone or outside the pad.
GameAction? dpadDirectionAt(Offset p, double size) {
  if (p.dx < 0 || p.dy < 0 || p.dx > size || p.dy > size) return null;
  final d = p - Offset(size / 2, size / 2);
  if (d.distance < size * 0.12) return null;
  if (d.dx.abs() > d.dy.abs()) {
    return d.dx > 0 ? GameAction.right : GameAction.left;
  }
  return d.dy > 0 ? GameAction.down : GameAction.up;
}

/// Cross-shaped D-pad. Each finger holds at most one direction and can slide
/// between directions; multiple fingers are tracked by pointer id.
class DPad extends StatefulWidget {
  const DPad({
    super.key,
    this.onActionDown,
    this.onActionUp,
    this.size = 132,
  });

  final GameActionCallback? onActionDown;
  final GameActionCallback? onActionUp;
  final double size;

  @override
  State<DPad> createState() => _DPadState();
}

class _DPadState extends State<DPad> {
  final Map<int, GameAction> _held = {};

  void _update(int pointer, GameAction? next) {
    final prev = _held[pointer];
    if (prev == next) return;
    setState(() {
      if (next == null) {
        _held.remove(pointer);
      } else {
        _held[pointer] = next;
      }
    });
    if (prev != null && !_held.containsValue(prev)) {
      widget.onActionUp?.call(prev);
    }
    if (next != null) widget.onActionDown?.call(next);
  }

  void _event(PointerEvent e) =>
      _update(e.pointer, dpadDirectionAt(e.localPosition, widget.size));

  @override
  Widget build(BuildContext context) {
    final s = widget.size;
    final arm = s / 3;
    final active = _held.values.toSet();

    Widget petal(GameAction a, Rect r, IconData icon) {
      final on = active.contains(a);
      return Positioned.fromRect(
        rect: r,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: on ? const Color(0xFF3A3A3A) : NpColors.controlCharcoal,
          ),
          child: Icon(icon, size: 34, color: const Color(0xFF1E1E1E)),
        ),
      );
    }

    return Semantics(
      container: true,
      label: 'Phím điều hướng',
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _event,
        onPointerMove: _event,
        onPointerUp: (e) => _update(e.pointer, null),
        onPointerCancel: (e) => _update(e.pointer, null),
        child: SizedBox(
          width: s,
          height: s,
          child: Stack(
            children: [
              petal(GameAction.up, Rect.fromLTWH(arm, 0, arm, arm),
                  Icons.arrow_drop_up),
              petal(GameAction.down, Rect.fromLTWH(arm, 2 * arm, arm, arm),
                  Icons.arrow_drop_down),
              petal(GameAction.left, Rect.fromLTWH(0, arm, arm, arm),
                  Icons.arrow_left),
              petal(GameAction.right, Rect.fromLTWH(2 * arm, arm, arm, arm),
                  Icons.arrow_right),
              Positioned.fromRect(
                rect: Rect.fromLTWH(arm, arm, arm, arm),
                child: const ColoredBox(color: NpColors.controlCharcoal),
              ),
              Center(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
