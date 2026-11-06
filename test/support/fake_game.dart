import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nostalplay/core/game_action.dart';
import 'package:nostalplay/core/game_definition.dart';

/// Test game: A scores 10, B ends the run.
GameDefinition fakeGame() => GameDefinition(
  id: 'fake',
  title: 'Fake',
  rules: 'Test rules.',
  dpadHint: 'Move',
  aHint: 'Boost',
  gridInfo: 'Grid: 4',
  builder: (context, session, input) =>
      FakeBoard(session: session, input: input),
);

class FakeBoard extends StatefulWidget {
  const FakeBoard({super.key, required this.session, required this.input});

  final dynamic session;
  final dynamic input;

  @override
  State<FakeBoard> createState() => FakeBoardState();
}

class FakeBoardState extends State<FakeBoard> {
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
