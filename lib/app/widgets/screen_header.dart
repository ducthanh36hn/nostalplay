import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../theme.dart';

/// Top bar for stacked screens: 44px back button and a centred title.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: context.s.back,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: NpColors.card,
                  border: Border.all(color: NpColors.lcdDark, width: 2),
                ),
                child: const Icon(Icons.arrow_back, color: NpColors.primary),
              ),
            ),
          ),
          Expanded(
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: kMono,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 1.2,
                color: NpColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}
