import 'package:flutter/widgets.dart';

/// Languages the app ships. The first is the fallback.
const supportedLanguages = ['vi', 'en'];

/// The user's choice: follow the phone, or force one language.
enum LanguageSetting {
  auto,
  vi,
  en;

  static LanguageSetting parse(String? value) => LanguageSetting.values
      .firstWhere((e) => e.name == value, orElse: () => LanguageSetting.auto);
}

/// Maps the phone's language to one we ship (Vietnamese or English).
String resolveLanguage(LanguageSetting setting, String deviceLanguage) {
  switch (setting) {
    case LanguageSetting.vi:
      return 'vi';
    case LanguageSetting.en:
      return 'en';
    case LanguageSetting.auto:
      return deviceLanguage == 'vi' ? 'vi' : 'en';
  }
}

/// All UI text. One getter per string keeps both translations side by side
/// and the compiler honest: a missing translation cannot happen.
class Strings {
  const Strings(this.language);

  final String language;

  static const vi = Strings('vi');
  static const en = Strings('en');

  bool get isVi => language == 'vi';
  String _(String vi, String en) => isVi ? vi : en;

  // Home
  String get homeSubtitle => _('Chọn băng để chơi', 'Pick a cartridge');
  String get settings => _('Cài đặt', 'Settings');
  String get newGame => _('Game mới', 'New game');
  String bestLabel(int n) => _('Kỷ lục: $n', 'Best: $n');
  String gameCardSemantics(String title, int best) => best > 0
      ? _('$title, kỷ lục $best', '$title, best $best')
      : _('$title, chưa có kỷ lục', '$title, no record yet');

  // Game detail
  String get noRecordUpper => _('CHƯA CÓ KỶ LỤC', 'NO RECORD YET');
  String bestUpper(int n) => _('KỶ LỤC: $n', 'BEST: $n');
  String get rulesTitle => _('LUẬT CHƠI', 'HOW TO PLAY');
  String get controlsTitle => _('ĐIỀU KHIỂN', 'CONTROLS');
  String get buttonATitle => _('NÚT A', 'BUTTON A');
  String get buttonBTitle => _('NÚT B', 'BUTTON B');
  String get notUsed => _('Không dùng', 'Not used');
  String get play => 'PLAY';
  String get playSemantics => _('Chơi', 'Play');
  String get back => _('Quay lại', 'Back');

  // Game screen
  String get pressAToPlay => _('NHẤN A ĐỂ CHƠI', 'PRESS A TO PLAY');
  String get pause => _('Tạm dừng', 'Paused');
  String get pauseButton => _('Tạm dừng', 'Pause');
  String get resume => _('Tiếp tục', 'Resume');
  String get restart => _('Chơi lại', 'Play again');
  String get toMenu => _('Về menu', 'Back to menu');
  String get sound => _('Âm thanh', 'Sound');
  String get vibration => _('Rung', 'Vibration');
  String get perfect => _('Hoàn hảo!', 'Perfect!');
  String get gameOver => 'Game over';
  String get newRecord => _('★ KỶ LỤC MỚI! ★', '★ NEW RECORD! ★');
  String get scoreLabel => _('Điểm', 'Score');
  String get bestLabelShort => _('Kỷ lục (best)', 'Best');

  // Settings
  String get soundSub =>
      _('Bật/tắt hiệu ứng âm thanh', 'Turn sound effects on/off');
  String get vibrationSub =>
      _('Rung nhẹ khi nhấn nút', 'Light buzz when pressing buttons');
  String get privacyTitle => _('Quyền riêng tư quảng cáo', 'Ad privacy');
  String get privacySub =>
      _('Xem hoặc đổi lựa chọn đồng ý', 'Review or change your consent');
  String get languageTitle => _('Ngôn ngữ', 'Language');
  String get languageSub => _(
    'Tự động theo điện thoại hoặc chọn riêng',
    'Follow your phone, or pick one',
  );
  String get languageAuto => _('TỰ ĐỘNG', 'AUTO');
  String get on => _('BẬT', 'ON');
  String get off => _('TẮT', 'OFF');

  // Accessibility labels
  String buttonSemantics(String label) => _('Nút $label', 'Button $label');
  String get dpadSemantics => _('Phím điều hướng', 'Directional pad');
  String get adSemantics => _('Quảng cáo', 'Advertisement');
}

/// Makes [Strings] available to the whole widget tree (above the Navigator,
/// so every route and overlay sees it) and rebuilds dependants on change.
class StringsScope extends InheritedWidget {
  const StringsScope({super.key, required this.strings, required super.child});

  final Strings strings;

  @override
  bool updateShouldNotify(StringsScope old) =>
      old.strings.language != strings.language;
}

/// `context.s` anywhere, including layout callbacks. Falls back to Vietnamese
/// when no [StringsScope] is above (tests of small widgets).
extension StringsContext on BuildContext {
  Strings get s =>
      dependOnInheritedWidgetOfExactType<StringsScope>()?.strings ?? Strings.vi;
}
