import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../game_action.dart';
import 'action_button.dart';
import 'dpad.dart';
import 'lcd_frame.dart';

/// The virtual handheld: ivory body, dark bezel with status row and LCD,
/// and the D-pad + A/B controls underneath.
class ConsoleShell extends StatelessWidget {
  const ConsoleShell({
    super.key,
    required this.lcd,
    this.leftStatus = '',
    this.rightStatus = '',
    this.onPause,
    this.onActionDown,
    this.onActionUp,
    this.dimControls = false,
  });

  /// Content of the LCD (drawn inside a square [LcdFrame]).
  final Widget lcd;
  final String leftStatus;
  final String rightStatus;
  final VoidCallback? onPause;
  final GameActionCallback? onActionDown;
  final GameActionCallback? onActionUp;

  /// Dims the controls (used while paused).
  final bool dimControls;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: NpColors.ground,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: NpColors.chassisIvory,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  border: Border.all(color: NpColors.chassisBevel, width: 2),
                ),
                child: LayoutBuilder(
                  builder: (context, c) => SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: c.maxHeight),
                      // On tall screens the spare height is split evenly above
                      // and below the controls instead of leaving a void.
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              _topStrip(),
                              _bezel(),
                              const SizedBox(height: 16),
                            ],
                          ),
                          Opacity(
                            opacity: dimControls ? 0.6 : 1,
                            child: _controls(),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topStrip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 18, 10),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: 'Tạm dừng',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPause,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: NpColors.chassisIvory,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: NpColors.chassisBevel, width: 2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5,
                      height: 16,
                      child: ColoredBox(color: Color(0xFF1E1E1E)),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: 5,
                      height: 16,
                      child: ColoredBox(color: Color(0xFF1E1E1E)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'NOSTALPLAY',
            style: TextStyle(
              fontFamily: kMono,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 2.4,
              color: NpColors.silkscreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bezel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF242926),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      leftStatus,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: lcdStyle(size: 12, color: NpColors.lcdBright),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      rightStatus,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: lcdStyle(size: 12, color: NpColors.lcdBright),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LcdFrame(child: lcd),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controls() {
    return Padding(
      // The D-pad carries its own 10 px touch margin, so this puts the drawn
      // pad about 14 px from the left edge.
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DPad(onActionDown: onActionDown, onActionUp: onActionUp),
          SizedBox(
            width: 136,
            height: 120,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: _labelled(
                    ActionButton(
                      label: 'A',
                      action: GameAction.buttonA,
                      onActionDown: onActionDown,
                      onActionUp: onActionUp,
                    ),
                    'A',
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: _labelled(
                    ActionButton(
                      label: 'B',
                      action: GameAction.buttonB,
                      onActionDown: onActionDown,
                      onActionUp: onActionUp,
                    ),
                    'B',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelled(Widget button, String caption) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        Text(
          caption,
          style: const TextStyle(
            fontFamily: kMono,
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: NpColors.silkscreen,
          ),
        ),
      ],
    );
  }
}
