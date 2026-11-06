import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/core/widgets/console_shell.dart';
import 'package:nostalplay/core/widgets/dpad.dart';
import 'package:nostalplay/core/widgets/lcd_frame.dart';

Future<void> pumpShell(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(body: ConsoleShell(lcd: SizedBox())),
    ),
  );
}

void main() {
  testWidgets('tall screen: spare height is split around the controls', (
    tester,
  ) async {
    await pumpShell(tester, const Size(412, 915));
    final lcdBottom = tester.getBottomLeft(find.byType(LcdFrame)).dy;
    final pad = tester.getRect(find.byType(DPad));
    final shell = tester.getRect(find.byType(ConsoleShell));
    final gapAbove = pad.top - lcdBottom;
    final gapBelow = shell.bottom - pad.bottom;
    // Controls sit roughly in the middle of the free space, not glued to the LCD.
    expect(gapAbove, greaterThan(40));
    expect((gapAbove - gapBelow).abs(), lessThan(40));
  });

  for (final size in const [Size(320, 568), Size(375, 667), Size(390, 844)]) {
    testWidgets('no overflow at $size', (tester) async {
      await pumpShell(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byType(DPad), findsOneWidget);
    });
  }
}
