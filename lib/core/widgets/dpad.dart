import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../game_action.dart';
import '../l10n/strings.dart';

/// Maps a touch position inside a square D-pad of [size] to a direction.
/// Returns null in the centre dead zone or outside the pad. [slop] widens the
/// accepted area around the pad so a thumb that lands slightly off still counts.
GameAction? dpadDirectionAt(Offset p, double size, {double slop = 0}) {
  if (p.dx < -slop ||
      p.dy < -slop ||
      p.dx > size + slop ||
      p.dy > size + slop) {
    return null;
  }
  final d = p - Offset(size / 2, size / 2);
  if (d.distance < size * 0.1) return null;
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
    this.touchMargin = 10,
  });

  final GameActionCallback? onActionDown;
  final GameActionCallback? onActionUp;
  final double size;

  /// Extra touch-sensitive band around the drawn pad (also adds that much
  /// breathing room around it in the layout).
  final double touchMargin;

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

  void _event(PointerEvent e) {
    final m = widget.touchMargin;
    final local = e.localPosition - Offset(m, m);
    _update(e.pointer, dpadDirectionAt(local, widget.size, slop: m));
  }

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
      label: context.s.dpadSemantics,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _event,
        onPointerMove: _event,
        onPointerUp: (e) => _update(e.pointer, null),
        onPointerCancel: (e) => _update(e.pointer, null),
        child: Padding(
          padding: EdgeInsets.all(widget.touchMargin),
          child: SizedBox(
            width: s,
            height: s,
            child: Stack(
              children: [
                petal(
                  GameAction.up,
                  Rect.fromLTWH(arm, 0, arm, arm),
                  Icons.arrow_drop_up,
                ),
                petal(
                  GameAction.down,
                  Rect.fromLTWH(arm, 2 * arm, arm, arm),
                  Icons.arrow_drop_down,
                ),
                petal(
                  GameAction.left,
                  Rect.fromLTWH(0, arm, arm, arm),
                  Icons.arrow_left,
                ),
                petal(
                  GameAction.right,
                  Rect.fromLTWH(2 * arm, arm, arm, arm),
                  Icons.arrow_right,
                ),
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
      ),
    );
  }
}
