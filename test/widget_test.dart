import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/app/app.dart';
import 'package:nostalplay/core/game_definition.dart';
import 'package:nostalplay/core/storage/app_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nostalplay/core/game_action.dart';
import 'package:nostalplay/core/widgets/action_button.dart';
import 'package:nostalplay/core/widgets/dpad.dart';

Future<Widget> _app() async {
  SharedPreferences.setMockInitialValues({});
  return NostalPlayApp(
    storage: await AppStorage.load(),
    registry: GameRegistry(const []),
  );
}

void main() {
  testWidgets('app boots and shows the console', (tester) async {
    await tester.pumpWidget(await _app());
    expect(find.text('NOSTALPLAY'), findsOneWidget);
    expect(find.text('SCORE 0030'), findsOneWidget);
    expect(find.text('NHẤN A ĐỂ CHƠI'), findsOneWidget);
  });

  test('dpadDirectionAt maps zones and ignores centre/outside', () {
    const s = 132.0;
    expect(dpadDirectionAt(const Offset(66, 10), s), GameAction.up);
    expect(dpadDirectionAt(const Offset(66, 122), s), GameAction.down);
    expect(dpadDirectionAt(const Offset(10, 66), s), GameAction.left);
    expect(dpadDirectionAt(const Offset(122, 66), s), GameAction.right);
    expect(dpadDirectionAt(const Offset(66, 66), s), isNull);
    expect(dpadDirectionAt(const Offset(-1, 66), s), isNull);
    expect(dpadDirectionAt(const Offset(66, 140), s), isNull);
  });

  testWidgets('DPad reports down, slide, up per pointer', (tester) async {
    final log = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: DPad(
            onActionDown: (a) => log.add('down:${a.name}'),
            onActionUp: (a) => log.add('up:${a.name}'),
          ),
        ),
      ),
    );
    final c = tester.getCenter(find.byType(DPad));
    final g = await tester.startGesture(c + const Offset(0, -50));
    await g.moveTo(c + const Offset(50, 0));
    await g.up();
    expect(log, ['down:up', 'up:up', 'down:right', 'up:right']);
  });

  testWidgets('DPad supports two fingers at once', (tester) async {
    final log = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: DPad(
            onActionDown: (a) => log.add('down:${a.name}'),
            onActionUp: (a) => log.add('up:${a.name}'),
          ),
        ),
      ),
    );
    final c = tester.getCenter(find.byType(DPad));
    final a = await tester.startGesture(c + const Offset(0, -50), pointer: 1);
    final b = await tester.startGesture(c + const Offset(50, 0), pointer: 2);
    await a.up();
    await b.up();
    expect(log, ['down:up', 'down:right', 'up:up', 'up:right']);
  });

  testWidgets('ActionButton keeps its pointer; sliding away still releases', (
    tester,
  ) async {
    final log = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: ActionButton(
            label: 'A',
            action: GameAction.buttonA,
            onActionDown: (a) => log.add('down:${a.name}'),
            onActionUp: (a) => log.add('up:${a.name}'),
          ),
        ),
      ),
    );
    final g = await tester.startGesture(
      tester.getCenter(find.byType(ActionButton)),
    );
    await g.moveBy(const Offset(200, 0));
    await g.up();
    expect(log, ['down:buttonA', 'up:buttonA']);
  });

  testWidgets('console fits a 320x568 phone without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(await _app());
    expect(tester.takeException(), isNull);
    final dpad = tester.getRect(find.byType(DPad));
    final a = tester.getRect(find.widgetWithText(ActionButton, 'A'));
    final b = tester.getRect(find.widgetWithText(ActionButton, 'B'));
    expect(dpad.overlaps(a), isFalse);
    expect(dpad.overlaps(b), isFalse);
    expect(a.overlaps(b), isFalse);
    expect(a.width, greaterThanOrEqualTo(44));
    expect(dpad.width / 3, greaterThanOrEqualTo(44));
  });
}
