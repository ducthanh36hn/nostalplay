import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/core/game_session.dart';
import 'package:nostalplay/core/storage/app_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<(GameSession, AppStorage)> _make([
  Map<String, Object> seed = const {},
]) async {
  SharedPreferences.setMockInitialValues(seed);
  final storage = await AppStorage.load();
  return (GameSession(gameId: 'snake', storage: storage), storage);
}

void main() {
  test('follows ready -> playing <-> paused -> gameOver', () async {
    final (s, _) = await _make();
    expect(s.state, SessionState.ready);
    s.pause(); // ignored: not playing
    expect(s.state, SessionState.ready);
    s.start();
    expect(s.state, SessionState.playing);
    s.pause();
    expect(s.state, SessionState.paused);
    s.start(); // ignored
    expect(s.state, SessionState.paused);
    s.resume();
    expect(s.state, SessionState.playing);
    s.gameOver();
    expect(s.state, SessionState.gameOver);
    s.resume(); // ignored
    expect(s.state, SessionState.gameOver);
  });

  test('score only counts while playing', () async {
    final (s, _) = await _make();
    s.addScore(10);
    expect(s.score, 0);
    s.start();
    s.addScore(10);
    s.addScore(-5);
    s.addScore(0);
    expect(s.score, 10);
    s.pause();
    s.addScore(10);
    expect(s.score, 10);
  });

  test('loads best score and flags a new record on game over', () async {
    final (s, storage) = await _make({'v1:snake:best': 50});
    expect(s.best, 50);
    s.start();
    s.addScore(60);
    expect(s.best, 60, reason: 'HUD best follows the live score');
    s.gameOver();
    expect(s.newRecord, isTrue);
    expect(storage.bestScore('snake'), 60);
  });

  test('no new record when the best is not beaten', () async {
    final (s, storage) = await _make({'v1:snake:best': 100});
    s.start();
    s.addScore(40);
    s.gameOver();
    expect(s.newRecord, isFalse);
    expect(s.best, 100);
    expect(storage.bestScore('snake'), 100);
  });

  test('equal score is not a record', () async {
    final (s, _) = await _make({'v1:snake:best': 40});
    s.start();
    s.addScore(40);
    s.gameOver();
    expect(s.newRecord, isFalse);
  });

  test('won flag is kept', () async {
    final (s, _) = await _make();
    s.start();
    s.gameOver(won: true);
    expect(s.won, isTrue);
  });

  test('restart resets the run and bumps runId', () async {
    final (s, _) = await _make();
    s.start();
    s.addScore(30);
    s.gameOver();
    final run = s.runId;
    s.restart();
    expect(s.state, SessionState.ready);
    expect(s.score, 0);
    expect(s.newRecord, isFalse);
    expect(s.best, 30);
    expect(s.runId, run + 1);
  });

  test('a record after a restart is judged against the new best', () async {
    final (s, _) = await _make();
    s.start();
    s.addScore(30);
    s.gameOver();
    s.restart();
    s.start();
    s.addScore(20);
    s.gameOver();
    expect(s.newRecord, isFalse);
  });

  test('quit saves a higher score mid-run (FR-9)', () async {
    final (s, storage) = await _make({'v1:snake:best': 10});
    s.start();
    s.addScore(70);
    s.quit();
    expect(storage.bestScore('snake'), 70);
  });

  test(
    'leaving the foreground pauses and saves; resuming does not resume',
    () async {
      final (s, storage) = await _make();
      s.start();
      s.addScore(20);
      s.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(s.state, SessionState.paused);
      expect(storage.bestScore('snake'), 20);
      s.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(s.state, SessionState.paused);
    },
  );

  test('a run that backgrounds then ends still counts as a record', () async {
    final (s, _) = await _make({'v1:snake:best': 10});
    s.start();
    s.addScore(20);
    s.didChangeAppLifecycleState(AppLifecycleState.paused);
    s.resume();
    s.gameOver();
    expect(s.newRecord, isTrue);
  });

  test('dispose works without ever attaching the lifecycle observer', () async {
    final (s, _) = await _make();
    s.dispose();
  });

  test('notifies listeners on state and score changes', () async {
    final (s, _) = await _make();
    var n = 0;
    s.addListener(() => n++);
    s.start();
    s.addScore(10);
    s.pause();
    expect(n, 3);
  });
}
