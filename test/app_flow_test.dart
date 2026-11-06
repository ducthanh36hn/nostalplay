import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/app/app.dart';
import 'package:nostalplay/core/game_action.dart';
import 'package:nostalplay/core/game_definition.dart';
import 'package:nostalplay/core/storage/app_storage.dart';
import 'package:nostalplay/core/widgets/action_button.dart';
import 'package:nostalplay/core/widgets/dpad.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Test game: A scores 10, B ends the run.
GameDefinition _fakeGame() => GameDefinition(
  id: 'fake',
  title: 'Fake',
  rules: 'Test rules.',
  dpadHint: 'Move',
  aHint: 'Boost',
  gridInfo: 'Grid: 4',
  builder: (context, session, input) => _Board(session: session, input: input),
);

class _Board extends StatefulWidget {
  const _Board({required this.session, required this.input});

  final dynamic session;
  final dynamic input;

  @override
  State<_Board> createState() => _BoardState();
}

class _BoardState extends State<_Board> {
  late final StreamSubscription<GameAction> _sub;

  @override
  void initState() {
    super.initState();
    _sub = (widget.input.downs as Stream<GameAction>).listen((a) {
      if (!widget.session.isPlaying) return;
      if (a == GameAction.buttonA) widget.session.addScore(10);
      if (a == GameAction.buttonB) widget.session.gameOver();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}

Future<void> _pumpApp(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues(prefs);
  await tester.pumpWidget(
    NostalPlayApp(
      storage: await AppStorage.load(),
      registry: GameRegistry([_fakeGame()]),
    ),
  );
}

Future<void> _tapButton(WidgetTester tester, String label) async {
  final g = await tester.startGesture(
    tester.getCenter(find.widgetWithText(ActionButton, label)),
  );
  await g.up();
  await tester.pump();
}

Future<void> _openGame(WidgetTester tester) async {
  await tester.tap(find.text('FAKE'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('PLAY'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('home lists games with New game, then Best after a record', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(find.text('FAKE'), findsOneWidget);
    expect(find.text('New game'), findsOneWidget);

    await _openGame(tester);
    await _tapButton(tester, 'A'); // start
    await _tapButton(tester, 'A'); // +10
    await _tapButton(tester, 'A'); // +10
    await _tapButton(tester, 'B'); // game over
    expect(find.text('★ KỶ LỤC MỚI! ★'), findsOneWidget);
    expect(find.text('20'), findsNWidgets(2)); // score + best

    await _tapButton(tester, 'B'); // back to menu (detail)
    await tester.pumpAndSettle();
    expect(find.text('BEST: 20'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Best: 20'), findsOneWidget);
  });

  testWidgets('detail shows rules, controls and best', (tester) async {
    await _pumpApp(tester, prefs: {'v1:fake:best': 90});
    expect(find.text('Best: 90'), findsOneWidget);
    await tester.tap(find.text('FAKE'));
    await tester.pumpAndSettle();
    expect(find.text('BEST: 90'), findsOneWidget);
    expect(find.text('Test rules.'), findsOneWidget);
    expect(find.text('Grid: 4'), findsOneWidget);
    expect(find.text('Boost'), findsOneWidget);
    expect(find.text('Không dùng'), findsOneWidget);
    expect(find.text('PLAY'), findsOneWidget);
  });

  testWidgets('game screen starts on Ready and A starts the run', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _openGame(tester);
    expect(find.text('NHẤN A ĐỂ CHƠI'), findsOneWidget);
    expect(find.text('SCORE 0000'), findsOneWidget);
    await _tapButton(tester, 'A');
    expect(find.text('NHẤN A ĐỂ CHƠI'), findsNothing);
    expect(
      find.text('SCORE 0000'),
      findsOneWidget,
      reason: 'start press is not a point',
    );
    await _tapButton(tester, 'A');
    expect(find.text('SCORE 0010'), findsOneWidget);
  });

  testWidgets('pause button, A resumes, B leaves', (tester) async {
    await _pumpApp(tester);
    await _openGame(tester);
    await _tapButton(tester, 'A');

    await tester.tap(find.bySemanticsLabel('Tạm dừng'));
    await tester.pump();
    expect(find.text('TẠM DỪNG'), findsOneWidget);

    await _tapButton(tester, 'A');
    expect(find.text('TẠM DỪNG'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Tạm dừng'));
    await tester.pump();
    await _tapButton(tester, 'B');
    await tester.pumpAndSettle();
    expect(
      find.text('PLAY'),
      findsOneWidget,
      reason: 'back on the detail screen',
    );
  });

  testWidgets('system Back pauses, then resumes, then leaves when idle', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _openGame(tester);
    await _tapButton(tester, 'A'); // playing

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.text('TẠM DỪNG'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.text('TẠM DỪNG'), findsNothing);

    await _tapButton(tester, 'B'); // game over
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('PLAY'), findsOneWidget);
  });

  testWidgets('Chơi lại restarts immediately with score 0', (tester) async {
    await _pumpApp(tester);
    await _openGame(tester);
    await _tapButton(tester, 'A');
    await _tapButton(tester, 'A');
    await _tapButton(tester, 'B'); // game over
    expect(find.text('GAME OVER'), findsOneWidget);

    await _tapButton(tester, 'A'); // play again
    expect(find.text('GAME OVER'), findsNothing);
    expect(find.text('SCORE 0000'), findsOneWidget);
    expect(find.text('BEST 0010'), findsOneWidget);
  });

  testWidgets('settings toggles persist', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('CÀI ĐẶT'), findsOneWidget);
    expect(find.text('[ON]'), findsNWidgets(2));

    await tester.tap(find.text('Rung'));
    await tester.pump();
    expect(find.text('[OFF]'), findsOneWidget);
    expect(
      (await SharedPreferences.getInstance()).getBool('v1:settings:haptics'),
      isFalse,
    );
    expect(find.text('NOSTALPLAY V1.0.0'), findsOneWidget);
  });

  testWidgets('game screen fits a 320x568 phone in every state', (
    tester,
  ) async {
    await _pumpApp(tester, size: const Size(320, 568));
    await _openGame(tester);
    expect(tester.takeException(), isNull);

    final dpad = tester.getRect(find.byType(DPad));
    final a = tester.getRect(find.widgetWithText(ActionButton, 'A'));
    final b = tester.getRect(find.widgetWithText(ActionButton, 'B'));
    expect(dpad.overlaps(a), isFalse);
    expect(dpad.overlaps(b), isFalse);
    expect(a.overlaps(b), isFalse);
    expect(a.width, greaterThanOrEqualTo(44));
    expect(dpad.width / 3, greaterThanOrEqualTo(44));

    await _tapButton(tester, 'A');
    await tester.tap(find.bySemanticsLabel('Tạm dừng'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await _tapButton(tester, 'A');
    await _tapButton(tester, 'A');
    await _tapButton(tester, 'B');
    expect(find.text('GAME OVER'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
