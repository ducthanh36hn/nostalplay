import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Square LCD viewport: hard borders, no soft shadows (design system rule).
class LcdFrame extends StatelessWidget {
  const LcdFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: NpColors.lcdBright,
          border: Border.all(color: NpColors.lcdDeep, width: 2),
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: NpColors.lcdDark, width: 2),
              left: BorderSide(color: NpColors.lcdDark, width: 2),
            ),
          ),
          child: ClipRect(child: child),
        ),
      ),
    );
  }
}
