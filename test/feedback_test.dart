import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/app/app.dart';
import 'package:nostalplay/core/feedback/game_feedback.dart';
import 'package:nostalplay/core/game_definition.dart';
import 'package:nostalplay/core/game_input.dart';
import 'package:nostalplay/core/game_session.dart';
import 'package:nostalplay/core/settings_controller.dart';
import 'package:nostalplay/core/storage/app_storage.dart';
import 'package:nostalplay/core/widgets/action_button.dart';
import 'package:nostalplay/games/snake/snake_board.dart';
import 'package:nostalplay/games/snake/snake_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_game.dart';
import 'support/fakes.dart';

Future<(GameFeedback, SettingsController, FakeSfx, FakeHaptics)> _feedback([
  Map<String, Object> prefs = const {},
]) async {
  SharedPreferences.setMockInitialValues(prefs);
  final settings = SettingsController(await AppStorage.load());
  final sfx = FakeSfx();
  final haptics = FakeHaptics();
  return (
    GameFeedback(settings: settings, sfx: sfx, haptics: haptics),
    settings,
    sfx,
    haptics,
  );
}

Future<(FakeSfx, FakeHaptics)> _pumpApp(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues(prefs);
  final sfx = FakeSfx();
  final haptics = FakeHaptics();
  await tester.pumpWidget(
    NostalPlayApp(
      storage: await AppStorage.load(),
      registry: GameRegistry([fakeGame()]),
      sfx: sfx,
      haptics: haptics,
    ),
  );
  await tester.tap(find.text('FAKE'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('PLAY'));
  await tester.pumpAndSettle();
  return (sfx, haptics);
}

Future<void> _tap(WidgetTester tester, String label) async {
  final g = await tester.startGesture(
    tester.getCenter(find.widgetWithText(ActionButton, label)),
  );
  await g.up();
  await tester.pump();
}

void main() {
  group('GameFeedback', () {
    test('plays sound and vibration when both are on', () async {
      final (f, _, sfx, haptics) = await _feedback();
      f.buttonPressed();
      f.ate();
      f.gameOver(newRecord: false);
      f.gameOver(newRecord: true);
      expect(sfx.played, [Sfx.eat, Sfx.gameOver, Sfx.newRecord]);
      expect(haptics.events, ['selection', 'light', 'heavy', 'heavy']);
    });

    test('sound off silences sounds but keeps vibration', () async {
      final (f, _, sfx, haptics) = await _feedback({
        'v1:settings:sound': false,
      });
      f.ate();
      f.gameOver(newRecord: true);
      expect(sfx.played, isEmpty);
      expect(haptics.events, ['light', 'heavy']);
    });

    test('vibration off silences vibration but keeps sounds', () async {
      final (f, _, sfx, haptics) = await _feedback({
        'v1:settings:haptics': false,
      });
      f.buttonPressed();
      f.ate();
      expect(haptics.events, isEmpty);
      expect(sfx.played, [Sfx.eat]);
    });

    test('toggling a setting applies to the very next call', () async {
      final (f, settings, sfx, haptics) = await _feedback();
      f.ate();
      await settings.setSound(false);
      await settings.setHaptics(false);
      f.ate();
      expect(sfx.played, [Sfx.eat]);
      expect(haptics.events, ['light']);
      await settings.setSound(true);
      f.ate();
      expect(sfx.played, [Sfx.eat, Sfx.eat]);
    });
  });

  group('in the app', () {
    testWidgets('each button press vibrates lightly', (tester) async {
      final (_, haptics) = await _pumpApp(tester);
      await _tap(tester, 'A');
      await _tap(tester, 'A');
      expect(haptics.events, ['selection', 'selection']);
    });

    testWidgets('no vibration when it is turned off', (tester) async {
      final (_, haptics) = await _pumpApp(
        tester,
        prefs: {'v1:settings:haptics': false},
      );
      await _tap(tester, 'A');
      expect(haptics.events, isEmpty);
    });

    testWidgets('game over plays the game over sound and a heavy buzz', (
      tester,
    ) async {
      final (sfx, haptics) = await _pumpApp(
        tester,
        prefs: {'v1:fake:best': 100},
      );
      await _tap(tester, 'A'); // start
      await _tap(tester, 'B'); // game over, 0 points
      expect(sfx.played, [Sfx.gameOver]);
      expect(haptics.events.last, 'heavy');
    });

    testWidgets('beating the best plays the new record sound', (tester) async {
      final (sfx, _) = await _pumpApp(tester);
      await _tap(tester, 'A'); // start
      await _tap(tester, 'A'); // +10
      await _tap(tester, 'B'); // game over
      expect(sfx.played, [Sfx.newRecord]);
    });

    testWidgets('sound off: game over is silent', (tester) async {
      final (sfx, _) = await _pumpApp(
        tester,
        prefs: {'v1:settings:sound': false},
      );
      await _tap(tester, 'A');
      await _tap(tester, 'B');
      expect(sfx.played, isEmpty);
    });
  });

  testWidgets('Snake plays the eat sound and a light buzz', (tester) async {
    final (f, _, sfx, haptics) = await _feedback();
    final session = GameSession(
      gameId: 'snake',
      storage: await AppStorage.load(),
    );
    final input = GameInput();
    addTearDown(() {
      session.dispose();
      input.dispose();
    });
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 320,
          height: 320,
          child: SnakeBoard(
            session: session,
            input: input,
            feedback: f,
            logic: SnakeLogic.fromState(
              size: 16,
              body: [const Cell(8, 8), const Cell(7, 8), const Cell(6, 8)],
              direction: Direction.right,
              food: const Cell(9, 8),
            ),
          ),
        ),
      ),
    );
    session.start();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 210));
    expect(sfx.played, [Sfx.eat]);
    expect(haptics.events, ['light']);
    expect(session.score, 10);
  });
}
