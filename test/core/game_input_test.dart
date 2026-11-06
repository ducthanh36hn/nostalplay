import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/core/game_action.dart';
import 'package:nostalplay/core/game_input.dart';

void main() {
  test('tracks held actions and ignores repeated downs', () {
    final input = GameInput();
    final downs = <GameAction>[];
    input.downs.listen(downs.add);

    input.down(GameAction.left);
    input.down(GameAction.left);
    input.down(GameAction.buttonA);

    expect(input.held, {GameAction.left, GameAction.buttonA});
    expect(downs, [GameAction.left, GameAction.buttonA]);
    input.dispose();
  });

  test('up only fires for held actions', () {
    final input = GameInput();
    final ups = <GameAction>[];
    input.ups.listen(ups.add);

    input.up(GameAction.up);
    input.down(GameAction.up);
    input.up(GameAction.up);

    expect(ups, [GameAction.up]);
    expect(input.isHeld(GameAction.up), isFalse);
    input.dispose();
  });

  test('releaseAll releases every held action', () {
    final input = GameInput();
    final ups = <GameAction>[];
    input.ups.listen(ups.add);
    input.down(GameAction.right);
    input.down(GameAction.buttonB);

    input.releaseAll();

    expect(input.held, isEmpty);
    expect(ups.toSet(), {GameAction.right, GameAction.buttonB});
    input.dispose();
  });
}
