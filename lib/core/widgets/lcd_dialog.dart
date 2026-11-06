import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Dialog drawn on the LCD: bright canvas, double pixel border.
class LcdDialog extends StatelessWidget {
  const LcdDialog({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: NpColors.lcdBright,
        border: Border.all(color: NpColors.lcdDeep, width: 2),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(border: Border.all(color: NpColors.lcdDark)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: lcdStyle(size: 15),
            ),
            const SizedBox(height: 6),
            const Divider(height: 2, thickness: 2, color: NpColors.lcdDeep),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Button on the LCD. [primary] is the filled variant with a ▶ cursor.
class LcdButton extends StatelessWidget {
  const LcdButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.hint,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  /// Physical button shown on the right, e.g. "A".
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final fg = primary ? NpColors.lcdBright : NpColors.lcdDeep;
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: primary ? NpColors.lcdDeep : null,
            border: Border.all(color: NpColors.lcdDeep, width: 2),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 14,
                child: primary
                    ? Icon(Icons.play_arrow, size: 16, color: fg)
                    : null,
              ),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: lcdStyle(size: 13, color: fg),
                ),
              ),
              SizedBox(
                width: 28,
                child: hint == null
                    ? null
                    : Text(
                        '[$hint]',
                        textAlign: TextAlign.right,
                        style: lcdStyle(size: 10, color: fg),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Square pixel toggle with an icon and a label (sound, vibration).
class LcdToggle extends StatelessWidget {
  const LcdToggle({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.selected = false,
  });

  /// Highlighted by the D-pad cursor.
  final bool selected;

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? NpColors.lcdDeep : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: NpColors.lcdDeep),
              const SizedBox(width: 4),
              Text(label, style: lcdStyle(size: 11)),
              const SizedBox(width: 6),
              Container(
                width: 18,
                height: 18,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(color: NpColors.lcdDeep, width: 2),
                ),
                child: value ? const ColoredBox(color: NpColors.lcdDeep) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small framed message on the LCD, e.g. "NHẤN A ĐỂ CHƠI".
class LcdBadge extends StatelessWidget {
  const LcdBadge({super.key, required this.text, this.inverted = false});

  final String text;

  /// Dark fill with bright text (used for "KỶ LỤC MỚI!").
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: inverted ? NpColors.lcdDeep : NpColors.lcdBright,
        border: Border.all(color: NpColors.lcdDeep, width: 2),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: lcdStyle(
          size: 13,
          color: inverted ? NpColors.lcdBright : NpColors.lcdDeep,
        ),
      ),
    );
  }
}
