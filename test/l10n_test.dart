import 'package:flutter_test/flutter_test.dart';
import 'package:nostalplay/core/l10n/strings.dart';
import 'package:nostalplay/games/snake/snake_game.dart';

void main() {
  test(
    'Auto follows the phone: Vietnamese stays, everything else is English',
    () {
      expect(resolveLanguage(LanguageSetting.auto, 'vi'), 'vi');
      expect(resolveLanguage(LanguageSetting.auto, 'en'), 'en');
      expect(resolveLanguage(LanguageSetting.auto, 'fr'), 'en');
      expect(resolveLanguage(LanguageSetting.vi, 'en'), 'vi');
      expect(resolveLanguage(LanguageSetting.en, 'vi'), 'en');
    },
  );

  test('unknown stored value falls back to Auto', () {
    expect(LanguageSetting.parse(null), LanguageSetting.auto);
    expect(LanguageSetting.parse('xx'), LanguageSetting.auto);
    expect(LanguageSetting.parse('vi'), LanguageSetting.vi);
  });

  test('every string is non-empty in both languages', () {
    for (final s in [Strings.vi, Strings.en]) {
      for (final v in [
        s.homeSubtitle,
        s.settings,
        s.newGame,
        s.bestLabel(1),
        s.noRecordUpper,
        s.rulesTitle,
        s.controlsTitle,
        s.buttonATitle,
        s.buttonBTitle,
        s.notUsed,
        s.playSemantics,
        s.back,
        s.pressAToPlay,
        s.pause,
        s.pauseButton,
        s.resume,
        s.restart,
        s.toMenu,
        s.sound,
        s.vibration,
        s.perfect,
        s.newRecord,
        s.scoreLabel,
        s.bestLabelShort,
        s.soundSub,
        s.vibrationSub,
        s.privacyTitle,
        s.privacySub,
        s.languageTitle,
        s.languageSub,
        s.languageAuto,
        s.on,
        s.off,
        s.dpadSemantics,
        s.adSemantics,
        s.buttonSemantics('A'),
        s.gameCardSemantics('X', 0),
      ]) {
        expect(v, isNotEmpty);
      }
    }
  });

  test('game texts: translations win, base fields are the fallback', () {
    expect(snakeGame.textsFor('vi').dpadHint, 'Đổi hướng');
    expect(snakeGame.textsFor('en').dpadHint, 'Change direction');
    expect(snakeGame.textsFor('fr').dpadHint, 'Change direction');
  });
}
