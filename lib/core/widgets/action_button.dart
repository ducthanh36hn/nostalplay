import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../game_action.dart';

/// Round crimson A/B button. Reports down/up for the pointer that pressed it
/// and keeps that pointer until it is released, so sliding the finger onto a
/// neighbouring button never triggers it.
class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.action,
    this.onActionDown,
    this.onActionUp,
    this.size = 56,
  });

  final String label;
  final GameAction action;
  final GameActionCallback? onActionDown;
  final GameActionCallback? onActionUp;
  final double size;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  int? _pointer;

  bool get _pressed => _pointer != null;

  void _down(PointerDownEvent e) {
    if (_pointer != null) return;
    setState(() => _pointer = e.pointer);
    widget.onActionDown?.call(widget.action);
  }

  void _release(int pointer) {
    if (_pointer != pointer) return;
    setState(() => _pointer = null);
    widget.onActionUp?.call(widget.action);
  }

  @override
  Widget build(BuildContext context) {
    final depth = _pressed ? 1.0 : 4.0;
    return Semantics(
      button: true,
      label: 'Nút ${widget.label}',
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _down,
        onPointerUp: (e) => _release(e.pointer),
        onPointerCancel: (e) => _release(e.pointer),
        child: SizedBox(
          width: widget.size,
          height: widget.size + 4,
          child: Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, _pressed ? 3 : 0),
              child: Container(
                width: widget.size,
                height: widget.size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NpColors.actionCrimson,
                  border: Border.all(color: const Color(0xFFB52B3F)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6A1623),
                      offset: Offset(0, depth),
                    ),
                  ],
                ),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: kMono,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFFFFDADA),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
