import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'game_feedback.dart';

/// Real vibration through Flutter's haptic feedback.
class SystemHaptics implements HapticsDriver {
  const SystemHaptics();

  @override
  void selection() => HapticFeedback.selectionClick();

  @override
  void light() => HapticFeedback.lightImpact();

  @override
  void heavy() => HapticFeedback.heavyImpact();
}

/// Plays the bundled effects with pre-loaded low-latency players. Any audio
/// failure is swallowed: a missing sound must never break the game.
class AudioSfxPlayer implements SfxPlayer {
  AudioSfxPlayer() {
    _ready = _load();
  }

  static const _files = {
    Sfx.eat: 'audio/eat.wav',
    Sfx.gameOver: 'audio/game_over.wav',
    Sfx.newRecord: 'audio/new_record.wav',
  };

  final Map<Sfx, AudioPool> _pools = {};
  late final Future<void> _ready;

  static final _context = AudioContext(
    // Ambient: respects the silent switch and mixes with other audio.
    iOS: AudioContextIOS(category: AVAudioSessionCategory.ambient),
    android: const AudioContextAndroid(
      contentType: AndroidContentType.sonification,
      usageType: AndroidUsageType.game,
      audioFocus: AndroidAudioFocus.none,
    ),
  );

  Future<void> _load() async {
    for (final e in _files.entries) {
      try {
        _pools[e.key] = await AudioPool.create(
          source: AssetSource(e.value),
          maxPlayers: 2,
          audioContext: _context,
          playerMode: PlayerMode.lowLatency,
        );
      } catch (error) {
        debugPrint('Sound ${e.value} unavailable: $error');
      }
    }
  }

  @override
  Future<void> play(Sfx sfx) async {
    try {
      await _ready;
      await _pools[sfx]?.start();
    } catch (error) {
      debugPrint('Sound $sfx failed: $error');
    }
  }

  @override
  Future<void> dispose() async {
    for (final p in _pools.values) {
      await p.dispose();
    }
    _pools.clear();
  }
}
