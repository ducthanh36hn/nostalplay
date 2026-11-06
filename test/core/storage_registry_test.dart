import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/core/game_definition.dart';
import 'package:nostalplay/core/settings_controller.dart';
import 'package:nostalplay/core/storage/app_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

GameDefinition _fake(String id) => GameDefinition(
  id: id,
  title: id.toUpperCase(),
  rules: 'rules',
  dpadHint: 'move',
  aHint: 'action',
  builder: (_, __, ___) => const SizedBox(),
);

void main() {
  group('AppStorage', () {
    test('defaults', () async {
      SharedPreferences.setMockInitialValues({});
      final s = await AppStorage.load();
      expect(s.bestScore('snake'), 0);
      expect(s.soundEnabled, isTrue);
      expect(s.hapticsEnabled, isTrue);
    });

    test('uses versioned keys and persists per game', () async {
      SharedPreferences.setMockInitialValues({});
      final s = await AppStorage.load();
      await s.setBestScore('snake', 120);
      await s.setBestScore('pong', 7);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('v1:snake:best'), 120);
      expect(prefs.getInt('v1:pong:best'), 7);
      expect(s.bestScore('snake'), 120);
      expect(s.bestScore('pong'), 7);
    });
  });

  group('SettingsController', () {
    test('toggles apply immediately and persist', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = await AppStorage.load();
      final settings = SettingsController(storage);
      var notified = 0;
      settings.addListener(() => notified++);

      await settings.setSound(false);
      await settings.setHaptics(false);
      await settings.setSound(false); // no change, no notification

      expect(settings.soundEnabled, isFalse);
      expect(settings.hapticsEnabled, isFalse);
      expect(notified, 2);

      final reloaded = SettingsController(await AppStorage.load());
      expect(reloaded.soundEnabled, isFalse);
      expect(reloaded.hapticsEnabled, isFalse);
    });
  });

  group('GameRegistry', () {
    test('lists games and finds them by id', () {
      final r = GameRegistry([_fake('snake'), _fake('pong')]);
      expect(r.games.map((g) => g.id), ['snake', 'pong']);
      expect(r.byId('pong')?.title, 'PONG');
      expect(r.byId('nope'), isNull);
    });

    test('adding a game needs no change to core (FR-11)', () {
      final base = [_fake('snake')];
      final r = GameRegistry([...base, _fake('brick_breaker')]);
      expect(r.games, hasLength(2));
    });

    test('rejects duplicate ids', () {
      expect(
        () => GameRegistry([_fake('snake'), _fake('snake')]),
        throwsArgumentError,
      );
    });

    test('game list is unmodifiable', () {
      final r = GameRegistry([_fake('snake')]);
      expect(() => r.games.add(_fake('x')), throwsUnsupportedError);
    });
  });
}
