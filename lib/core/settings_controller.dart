import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

import 'l10n/strings.dart';
import 'storage/app_storage.dart';

/// Sound, vibration and language, applied immediately and persisted.
class SettingsController extends ChangeNotifier {
  SettingsController(this._storage)
    : _sound = _storage.soundEnabled,
      _haptics = _storage.hapticsEnabled,
      _language = LanguageSetting.parse(_storage.languageSetting);

  final AppStorage _storage;
  bool _sound;
  bool _haptics;
  LanguageSetting _language;

  bool get soundEnabled => _sound;
  bool get hapticsEnabled => _haptics;
  LanguageSetting get language => _language;

  /// The language actually shown ('vi' or 'en').
  String get languageCode => resolveLanguage(
    _language,
    ui.PlatformDispatcher.instance.locale.languageCode,
  );

  Strings get strings => Strings(languageCode);

  Future<void> setLanguage(LanguageSetting value) async {
    if (value == _language) return;
    _language = value;
    notifyListeners();
    await _storage.setLanguageSetting(value.name);
  }

  Future<void> setSound(bool value) async {
    if (value == _sound) return;
    _sound = value;
    notifyListeners();
    await _storage.setSoundEnabled(value);
  }

  Future<void> setHaptics(bool value) async {
    if (value == _haptics) return;
    _haptics = value;
    notifyListeners();
    await _storage.setHapticsEnabled(value);
  }
}
