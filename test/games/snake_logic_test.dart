import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/games/snake/snake_logic.dart';

SnakeLogic _line({
  int size = 8,
  Direction direction = Direction.right,
  Cell? food,
  int length = 3,
  int y = 4,
  int headX = 4,
}) {
  final body = [for (var i = 0; i < length; i++) Cell(headX - i, y)];
  return SnakeLogic.fromState(
    size: size,
    body: body,
    direction: direction,
    food: food,
  );
}

void main() {
  group('start', () {
    test('3 segments in the middle of 16x16, heading right (FR-13)', () {
      final g = SnakeLogic(random: Random(1));
      expect(g.size, 16);
      expect(g.body, [const Cell(8, 8), const Cell(7, 8), const Cell(6, 8)]);
      expect(g.direction, Direction.right);
      expect(g.status, SnakeStatus.running);
    });

    test('food starts on a free cell inside the grid', () {
      for (var seed = 0; seed < 50; seed++) {
        final g = SnakeLogic(random: Random(seed));
        final f = g.food!;
        expect(g.body.contains(f), isFalse);
        expect(f.x, inInclusiveRange(0, 15));
        expect(f.y, inInclusiveRange(0, 15));
      }
    });

    test('same seed gives the same food sequence', () {
      final a = SnakeLogic(random: Random(7));
      final b = SnakeLogic(random: Random(7));
      expect(a.food, b.food);
    });
  });

  group('movement', () {
    test('moves one cell per step and keeps its length', () {
      final g = _line();
      expect(g.step(), StepOutcome.moved);
      expect(g.body, [const Cell(5, 4), const Cell(4, 4), const Cell(3, 4)]);
    });

    test('turn changes direction on the next step', () {
      final g = _line();
      expect(g.turn(Direction.up), isTrue);
      g.step();
      expect(g.head, const Cell(4, 3));
      expect(g.direction, Direction.up);
    });
  });

  group('turning rules (FR-14)', () {
    test('cannot reverse 180 degrees', () {
      final g = _line();
      expect(g.turn(Direction.left), isFalse);
      g.step();
      expect(g.head, const Cell(5, 4));
    });

    test('repeating the current direction is ignored', () {
      final g = _line();
      expect(g.turn(Direction.right), isFalse);
    });

    test('two quick turns are applied over two ticks', () {
      final g = _line();
      expect(g.turn(Direction.up), isTrue);
      expect(g.turn(Direction.left), isTrue);
      g.step();
      expect(g.head, const Cell(4, 3));
      g.step();
      expect(g.head, const Cell(3, 3));
    });

    test('a reversal of the queued direction is ignored', () {
      final g = _line();
      expect(g.turn(Direction.up), isTrue);
      expect(g.turn(Direction.down), isFalse);
      g.step();
      expect(g.direction, Direction.up);
    });

    test('at most one turn waits behind the next one', () {
      final g = _line();
      expect(g.turn(Direction.up), isTrue);
      expect(g.turn(Direction.left), isTrue);
      expect(g.turn(Direction.down), isFalse, reason: 'queue is full');
    });

    test('turns are ignored once the snake is dead', () {
      final g = _line(headX: 7);
      g.step();
      expect(g.status, SnakeStatus.dead);
      expect(g.turn(Direction.up), isFalse);
    });
  });

  group('eating (FR-16)', () {
    test('grows by one and reports ate', () {
      final g = _line(food: const Cell(5, 4));
      expect(g.step(), StepOutcome.ate);
      expect(g.body.length, 4);
      expect(g.head, const Cell(5, 4));
      expect(g.eaten, 1);
    });

    test('new food never lands on the snake', () {
      for (var seed = 0; seed < 100; seed++) {
        final g = SnakeLogic.fromState(
          size: 6,
          body: [const Cell(2, 2), const Cell(1, 2), const Cell(0, 2)],
          direction: Direction.right,
          food: const Cell(3, 2),
          random: Random(seed),
        );
        g.step();
        expect(g.body.contains(g.food), isFalse);
      }
    });
  });

  group('collisions (FR-17)', () {
    test('wall on each side', () {
      for (final (d, x, y) in [
        (Direction.right, 7, 4),
        (Direction.left, 0, 4),
        (Direction.up, 4, 0),
        (Direction.down, 4, 7),
      ]) {
        final g = SnakeLogic.fromState(
          size: 8,
          body: [
            Cell(x, y),
            Cell(x - d.dx, y - d.dy),
            Cell(x - 2 * d.dx, y - 2 * d.dy),
          ],
          direction: d,
          food: null,
        );
        expect(g.step(), StepOutcome.died, reason: '$d');
        expect(g.status, SnakeStatus.dead);
      }
    });

    test('own body', () {
      final g = _line(length: 5, headX: 5, y: 4);
      g.turn(Direction.down);
      expect(g.step(), StepOutcome.moved);
      g.turn(Direction.left);
      expect(g.step(), StepOutcome.moved);
      g.turn(Direction.up); // next cell (4,4) is still part of the body
      expect(g.step(), StepOutcome.died);
      expect(g.status, SnakeStatus.dead);
    });

    test('moving into the cell the tail is leaving is legal', () {
      final g = SnakeLogic.fromState(
        size: 8,
        body: [
          const Cell(4, 4),
          const Cell(3, 4),
          const Cell(3, 5),
          const Cell(4, 5),
        ],
        direction: Direction.right,
        food: null,
      );
      g.turn(Direction.down); // head -> (4,5) = current tail, which moves away
      expect(g.step(), StepOutcome.moved);
      expect(g.status, SnakeStatus.running);
    });

    test('step after death keeps reporting died', () {
      final g = _line(headX: 7);
      g.step();
      expect(g.step(), StepOutcome.died);
    });
  });

  group('win (FR-17)', () {
    test('filling the whole grid wins and leaves no food', () {
      // 4x4 grid, snake of 15 cells snaking through, food on the last cell.
      final cells = <Cell>[];
      for (var y = 0; y < 4; y++) {
        final xs = y.isEven ? [0, 1, 2, 3] : [3, 2, 1, 0];
        for (final x in xs) {
          cells.add(Cell(x, y));
        }
      }
      // Path order: row0 left->right, row1 right->left, ...; last cell (0,3).
      final path = cells; // 16 cells
      final snake = path.sublist(0, 15).reversed.toList(); // head = path[14]
      final g = SnakeLogic.fromState(
        size: 4,
        body: snake,
        direction: Direction.left,
        food: path[15],
      );
      expect(g.head, path[14]);
      expect(g.step(), StepOutcome.won);
      expect(g.status, SnakeStatus.won);
      expect(g.food, isNull);
      expect(g.body.length, 16);
    });
  });

  group('speed (FR-15)', () {
    test('starts at 200 ms, -10 ms every 5 foods, floor 80 ms', () {
      SnakeLogic at(int eaten) => SnakeLogic.fromState(
        size: 8,
        body: [const Cell(2, 2)],
        direction: Direction.right,
        food: null,
        eaten: eaten,
      );
      expect(at(0).tickMs, 200);
      expect(at(4).tickMs, 200);
      expect(at(5).tickMs, 190);
      expect(at(10).tickMs, 180);
      expect(at(59).tickMs, 90);
      expect(at(60).tickMs, 80);
      expect(at(500).tickMs, 80);
    });
  });

  test('random play keeps the invariants (fuzz)', () {
    for (var seed = 0; seed < 20; seed++) {
      final rnd = Random(seed);
      final g = SnakeLogic(size: 8, random: Random(seed));
      for (var i = 0; i < 400 && g.status == SnakeStatus.running; i++) {
        if (rnd.nextInt(3) == 0) {
          g.turn(Direction.values[rnd.nextInt(4)]);
        }
        g.step();
        if (g.status != SnakeStatus.running) break;
        expect(g.body.toSet().length, g.body.length, reason: 'no overlaps');
        for (final c in g.body) {
          expect(c.x, inInclusiveRange(0, 7));
          expect(c.y, inInclusiveRange(0, 7));
        }
        expect(g.body.contains(g.food), isFalse);
      }
    }
  });
}
