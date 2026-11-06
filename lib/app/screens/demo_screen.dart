import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_action.dart';
import '../../core/settings_controller.dart';
import '../../core/widgets/console_shell.dart';
import '../../core/widgets/lcd_dialog.dart';

/// Temporary screen (step 2) to compare the shared widgets with the Stitch
/// design. Replaced by the real screens in step 4.
class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  bool _paused = false;
  final Set<GameAction> _held = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConsoleShell(
        leftStatus: 'SCORE 0030',
        rightStatus: 'BEST 1250',
        dimControls: _paused,
        onPause: () => setState(() => _paused = !_paused),
        onActionDown: (a) => setState(() => _held.add(a)),
        onActionUp: (a) => setState(() => _held.remove(a)),
        lcd: _paused ? _pause() : _ready(),
      ),
    );
  }

  Widget _ready() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LcdDialog(
            title: 'Nhấn A để chơi',
            children: [
              Text(
                _held.isEmpty
                    ? 'ĐANG CHỜ NÚT'
                    : _held.map((a) => a.name.toUpperCase()).join(' + '),
                textAlign: TextAlign.center,
                style: lcdStyle(size: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pause() {
    final settings = context.watch<SettingsController>();
    return ColoredBox(
      color: NpColors.lcdDark.withValues(alpha: 0.7),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Center(
          child: LcdDialog(
            title: 'Tạm dừng',
            children: [
              LcdButton(
                label: 'Tiếp tục',
                primary: true,
                hint: 'A',
                onPressed: () => setState(() => _paused = false),
              ),
              const SizedBox(height: 8),
              LcdButton(label: 'Chơi lại', onPressed: () {}),
              const SizedBox(height: 8),
              LcdButton(label: 'Về menu', hint: 'B', onPressed: () {}),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LcdToggle(
                    icon: Icons.volume_up,
                    label: 'Âm thanh',
                    value: settings.soundEnabled,
                    onChanged: settings.setSound,
                  ),
                  LcdToggle(
                    icon: Icons.vibration,
                    label: 'Rung',
                    value: settings.hapticsEnabled,
                    onChanged: settings.setHaptics,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
