import 'package:flutter/widgets.dart';

import 'storage/app_storage.dart';

enum SessionState { ready, playing, paused, gameOver }

/// Lifecycle of one play session: ready -> playing <-> paused -> gameOver.
/// Owns the score and the persisted best score of its game.
class GameSession extends ChangeNotifier with WidgetsBindingObserver {
  GameSession({required this.gameId, required AppStorage storage})
    : _storage = storage,
      _best = storage.bestScore(gameId) {
    _bestAtRunStart = _best;
  }

  final String gameId;
  final AppStorage _storage;

  SessionState _state = SessionState.ready;
  int _score = 0;
  int _best;
  int _bestAtRunStart = 0;
  bool _newRecord = false;
  bool _won = false;
  int _runId = 0;
  bool _attached = false;

  SessionState get state => _state;
  int get score => _score;

  /// Best score shown on the HUD: never lower than the current score.
  int get best => _score > _best ? _score : _best;

  /// True when the finished run beat the best score of before the run.
  bool get newRecord => _newRecord;

  /// True when the player won (e.g. Snake filled the whole grid).
  bool get won => _won;

  /// Increments on every restart so games know to reset their own state.
  int get runId => _runId;

  bool get isPlaying => _state == SessionState.playing;

  void _set(SessionState next) {
    _state = next;
    notifyListeners();
  }

  void start() {
    if (_state != SessionState.ready) return;
    _set(SessionState.playing);
  }

  void pause() {
    if (_state != SessionState.playing) return;
    _set(SessionState.paused);
  }

  void resume() {
    if (_state != SessionState.paused) return;
    _set(SessionState.playing);
  }

  /// Back to the ready state with a fresh run (score 0).
  void restart() {
    _persistBestIfHigher();
    _score = 0;
    _newRecord = false;
    _won = false;
    _bestAtRunStart = _best;
    _runId++;
    _set(SessionState.ready);
  }

  void addScore(int points) {
    if (_state != SessionState.playing || points <= 0) return;
    _score += points;
    notifyListeners();
  }

  void gameOver({bool won = false}) {
    if (_state != SessionState.playing) return;
    _won = won;
    _newRecord = _score > _bestAtRunStart;
    _persistBestIfHigher();
    _set(SessionState.gameOver);
  }

  /// Call when leaving the game mid-run so a higher score is not lost.
  void quit() => _persistBestIfHigher();

  void _persistBestIfHigher() {
    if (_score > _best) {
      _best = _score;
      _storage.setBestScore(gameId, _best);
    }
  }

  /// Registers for app lifecycle events (call [detachLifecycle] on dispose).
  void attachLifecycle() {
    if (_attached) return;
    _attached = true;
    WidgetsBinding.instance.addObserver(this);
  }

  void detachLifecycle() {
    if (!_attached) return;
    _attached = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  /// Leaving the foreground pauses a running game and saves a higher score.
  /// Coming back never resumes by itself.
  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycle) {
    if (lifecycle == AppLifecycleState.resumed) return;
    pause();
    _persistBestIfHigher();
  }

  @override
  void dispose() {
    detachLifecycle();
    super.dispose();
  }
}
