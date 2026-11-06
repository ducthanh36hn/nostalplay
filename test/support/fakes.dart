import 'package:nostalplay/core/feedback/game_feedback.dart';

class FakeSfx implements SfxPlayer {
  final List<Sfx> played = [];

  @override
  Future<void> play(Sfx sfx) async => played.add(sfx);

  @override
  Future<void> dispose() async {}
}

class FakeHaptics implements HapticsDriver {
  final List<String> events = [];

  @override
  void selection() => events.add('selection');

  @override
  void light() => events.add('light');

  @override
  void heavy() => events.add('heavy');
}
