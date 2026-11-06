import 'dart:math';

import 'package:flutter/foundation.dart' show immutable;

enum Direction {
  up(0, -1),
  down(0, 1),
  left(-1, 0),
  right(1, 0);

  const Direction(this.dx, this.dy);

  final int dx;
  final int dy;

  Direction get opposite => switch (this) {
    Direction.up => Direction.down,
    Direction.down => Direction.up,
    Direction.left => Direction.right,
    Direction.right => Direction.left,
  };
}

@immutable
class Cell {
  const Cell(this.x, this.y);

  final int x;
  final int y;

  @override
  bool operator ==(Object other) =>
      other is Cell && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Cell($x, $y)';
}

enum SnakeStatus { running, dead, won }

enum StepOutcome { moved, ate, died, won }

/// Snake rules on a square grid. Pure Dart (no Flutter), driven by [step],
/// with an injectable [Random] so runs are reproducible in tests.
class SnakeLogic {
  static const int startTickMs = 200;
  static const int minTickMs = 80;
  static const int tickStepMs = 10;
  static const int foodsPerSpeedUp = 5;
  static const int pointsPerFood = 10;

  /// Directions that may wait: the one applied on the next tick plus one more.
  static const int maxQueuedTurns = 2;

  /// New game: 3 segments in the middle, heading right.
  SnakeLogic({this.size = 16, Random? random, Cell? food})
    : assert(size >= 4),
      _random = random ?? Random(),
      direction = Direction.right,
      body = [
        Cell(size ~/ 2, size ~/ 2),
        Cell(size ~/ 2 - 1, size ~/ 2),
        Cell(size ~/ 2 - 2, size ~/ 2),
      ] {
    this.food = food ?? _pickFood();
  }

  /// Arbitrary state, used by tests. [body] is head first.
  SnakeLogic.fromState({
    required this.size,
    required List<Cell> body,
    required this.direction,
    required this.food,
    Random? random,
    this.eaten = 0,
  }) : assert(size >= 2),
       _random = random ?? Random(),
       body = List.of(body);

  final int size;
  final Random _random;

  /// Head first.
  final List<Cell> body;
  Direction direction;
  Cell? food;
  int eaten = 0;
  SnakeStatus status = SnakeStatus.running;
  final List<Direction> _queue = [];

  Cell get head => body.first;

  /// Milliseconds between moves, before any speed boost.
  int get tickMs =>
      max(minTickMs, startTickMs - tickStepMs * (eaten ~/ foodsPerSpeedUp));

  /// Asks to turn. Ignored when it repeats or reverses the direction the snake
  /// will have by then (no 180° turn), or when too many turns are waiting.
  bool turn(Direction d) {
    if (status != SnakeStatus.running) return false;
    final reference = _queue.isEmpty ? direction : _queue.last;
    if (d == reference || d == reference.opposite) return false;
    if (_queue.length >= maxQueuedTurns) return false;
    _queue.add(d);
    return true;
  }

  StepOutcome step() {
    if (status == SnakeStatus.dead) return StepOutcome.died;
    if (status == SnakeStatus.won) return StepOutcome.won;

    if (_queue.isNotEmpty) direction = _queue.removeAt(0);
    final next = Cell(head.x + direction.dx, head.y + direction.dy);
    if (next.x < 0 || next.y < 0 || next.x >= size || next.y >= size) {
      status = SnakeStatus.dead;
      return StepOutcome.died;
    }

    final eating = next == food;
    // When not eating the tail leaves its cell this tick, so it is free.
    final blockedUntil = eating ? body.length : body.length - 1;
    for (var i = 0; i < blockedUntil; i++) {
      if (body[i] == next) {
        status = SnakeStatus.dead;
        return StepOutcome.died;
      }
    }

    body.insert(0, next);
    if (!eating) {
      body.removeLast();
      return StepOutcome.moved;
    }

    eaten++;
    if (body.length >= size * size) {
      food = null;
      status = SnakeStatus.won;
      return StepOutcome.won;
    }
    food = _pickFood();
    return StepOutcome.ate;
  }

  Cell? _pickFood() {
    final occupied = body.toSet();
    final free = <Cell>[];
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        final c = Cell(x, y);
        if (!occupied.contains(c)) free.add(c);
      }
    }
    return free.isEmpty ? null : free[_random.nextInt(free.length)];
  }
}
