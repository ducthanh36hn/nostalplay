import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/app/app.dart';
import 'package:nostalplay/core/game_action.dart';
import 'package:nostalplay/core/game_definition.dart';
import 'package:nostalplay/core/game_input.dart';
import 'package:nostalplay/core/game_session.dart';
import 'package:nostalplay/core/storage/app_storage.dart';
import 'package:nostalplay/core/widgets/action_button.dart';
import 'package:nostalplay/games/snake/snake_board.dart';
import 'package:nostalplay/games/snake/snake_game.dart';
import 'package:nostalplay/games/snake/snake_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/fakes.dart';

class _Harness {
  _Harness(this.session, this.input, this.logic);

  final GameSession session;
  final GameInput input;
  final SnakeLogic logic;
}

Future<_Harness> _pumpBoard(
  WidgetTester tester, {
  SnakeLogic? logic,
  bool start = true,
}) async {
  SharedPreferences.setMockInitialValues({});
  final session = GameSession(
    gameId: 'snake',
    storage: await AppStorage.load(),
  );
  final input = GameInput();
  final l =
      logic ??
      SnakeLogic.fromState(
        size: 16,
        body: [const Cell(8, 8), const Cell(7, 8), const Cell(6, 8)],
        direction: Direction.right,
        food: const Cell(0, 0),
      );
  addTearDown(() {
    session.dispose();
    input.dispose();
  });
  await tester.pumpWidget(
    MaterialApp(
      home: SizedBox(
        width: 320,
        height: 320,
        child: SnakeBoard(session: session, input: input, logic: l),
      ),
    ),
  );
  if (start) {
    session.start();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16)); // first tick
  }
  return _Harness(session, input, l);
}

void main() {
  testWidgets('does not move while the session is ready', (tester) async {
    final h = await _pumpBoard(tester, start: false);
    await tester.pump(const Duration(seconds: 2));
    expect(h.logic.head, const Cell(8, 8));
  });

  testWidgets('moves one cell every 200 ms', (tester) async {
    final h = await _pumpBoard(tester);
    // 16 ms already elapsed in the harness: 186 ms is still short of a tick.
    await tester.pump(const Duration(milliseconds: 170));
    expect(h.logic.head, const Cell(8, 8));
    await tester.pump(const Duration(milliseconds: 20));
    expect(h.logic.head, const Cell(9, 8));
  });

  testWidgets('holding A doubles the speed, releasing restores it', (
    tester,
  ) async {
    final h = await _pumpBoard(tester);
    h.input.down(GameAction.buttonA);
    await tester.pump(const Duration(milliseconds: 110));
    expect(h.logic.head, const Cell(9, 8));
    h.input.up(GameAction.buttonA);
    await tester.pump(const Duration(milliseconds: 150));
    expect(h.logic.head, const Cell(9, 8), reason: 'normal speed again');
  });

  testWidgets('D-pad presses steer the snake', (tester) async {
    final h = await _pumpBoard(tester);
    h.input.down(GameAction.up);
    await tester.pump(const Duration(milliseconds: 210));
    expect(h.logic.direction, Direction.up);
    expect(h.logic.head, const Cell(8, 7));
  });

  testWidgets('presses before the run starts are ignored', (tester) async {
    final h = await _pumpBoard(tester, start: false);
    h.input.down(GameAction.up);
    h.session.start();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 210));
    expect(h.logic.direction, Direction.right);
  });

  testWidgets('eating scores 10 points', (tester) async {
    final logic = SnakeLogic.fromState(
      size: 16,
      body: [const Cell(8, 8), const Cell(7, 8), const Cell(6, 8)],
      direction: Direction.right,
      food: const Cell(9, 8),
    );
    final h = await _pumpBoard(tester, logic: logic);
    await tester.pump(const Duration(milliseconds: 210));
    expect(h.session.score, 10);
    expect(h.logic.body.length, 4);
  });

  testWidgets('hitting the wall ends the run', (tester) async {
    final logic = SnakeLogic.fromState(
      size: 16,
      body: [const Cell(15, 8), const Cell(14, 8), const Cell(13, 8)],
      direction: Direction.right,
      food: const Cell(0, 0),
    );
    final h = await _pumpBoard(tester, logic: logic);
    await tester.pump(const Duration(milliseconds: 210));
    expect(h.session.state, SessionState.gameOver);
    expect(h.session.won, isFalse);
    await tester.pump(const Duration(seconds: 1));
    expect(h.logic.head, const Cell(15, 8), reason: 'frozen after death');
  });

  testWidgets('filling the grid ends the run as a win', (tester) async {
    final snake = <Cell>[];
    for (var y = 0; y < 4; y++) {
      final xs = y.isEven ? [0, 1, 2, 3] : [3, 2, 1, 0];
      for (final x in xs) {
        snake.add(Cell(x, y));
      }
    }
    final logic = SnakeLogic.fromState(
      size: 4,
      body: snake.sublist(0, 15).reversed.toList(),
      direction: Direction.left,
      food: snake[15],
    );
    final h = await _pumpBoard(tester, logic: logic);
    await tester.pump(const Duration(milliseconds: 210));
    expect(h.session.won, isTrue);
    expect(h.session.state, SessionState.gameOver);
    expect(h.session.score, 10);
  });

  testWidgets('pause stops the snake and resume does not jump ahead', (
    tester,
  ) async {
    final h = await _pumpBoard(tester);
    await tester.pump(const Duration(milliseconds: 210));
    final paused = h.logic.head;
    h.session.pause();
    await tester.pump(const Duration(seconds: 5));
    expect(h.logic.head, paused);

    h.session.resume();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    expect(h.logic.head, paused, reason: 'no catch-up after a long pause');
    await tester.pump(const Duration(milliseconds: 210));
    expect(h.logic.head, isNot(paused));
  });

  testWidgets('real Snake in the app: runs into the wall and shows Game Over', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      NostalPlayApp(
        storage: await AppStorage.load(),
        registry: GameRegistry([snakeGame]),
        sfx: FakeSfx(),
        haptics: FakeHaptics(),
      ),
    );
    await tester.tap(find.text('SNAKE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();

    final g = await tester.startGesture(
      tester.getCenter(find.widgetWithText(ActionButton, 'A')),
    );
    await g.up();
    await tester.pump();
    expect(find.text('NHẤN A ĐỂ CHƠI'), findsNothing);

    // The snake starts mid-board heading right: it must hit the wall.
    for (var i = 0; i < 80; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('GAME OVER'), findsOneWidget);
  });
}
