import '../settings_controller.dart';

/// Sound effects the platform and games can ask for.
enum Sfx { eat, gameOver, newRecord }

abstract class SfxPlayer {
  Future<void> play(Sfx sfx);
  Future<void> dispose();
}

/// Device vibration, kept behind an interface so tests can observe it.
abstract class HapticsDriver {
  void selection();
  void light();
  void heavy();
}

/// Single entry point for sound and vibration. Honours the user's settings on
/// every call, so a toggle takes effect immediately.
class GameFeedback {
  GameFeedback({
    required this.settings,
    required SfxPlayer sfx,
    required HapticsDriver haptics,
  }) : _sfx = sfx,
       _haptics = haptics;

  final SettingsController settings;
  final SfxPlayer _sfx;
  final HapticsDriver _haptics;

  void _sound(Sfx sfx) {
    if (settings.soundEnabled) _sfx.play(sfx);
  }

  /// A virtual button was pressed.
  void buttonPressed() {
    if (settings.hapticsEnabled) _haptics.selection();
  }

  void ate() {
    _sound(Sfx.eat);
    if (settings.hapticsEnabled) _haptics.light();
  }

  void gameOver({required bool newRecord}) {
    _sound(newRecord ? Sfx.newRecord : Sfx.gameOver);
    if (settings.hapticsEnabled) _haptics.heavy();
  }
}
