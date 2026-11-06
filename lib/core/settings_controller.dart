import 'package:flutter/foundation.dart';

import 'storage/app_storage.dart';

/// Sound and vibration switches, applied immediately and persisted.
class SettingsController extends ChangeNotifier {
  SettingsController(this._storage)
    : _sound = _storage.soundEnabled,
      _haptics = _storage.hapticsEnabled;

  final AppStorage _storage;
  bool _sound;
  bool _haptics;

  bool get soundEnabled => _sound;
  bool get hapticsEnabled => _haptics;

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
