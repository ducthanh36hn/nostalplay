import 'package:shared_preferences/shared_preferences.dart';

/// Local persistence. Keys are versioned (`v1:`) so a future schema change
/// never touches data written by older versions.
class AppStorage {
  AppStorage(this._prefs);

  final SharedPreferences _prefs;

  static Future<AppStorage> load() async =>
      AppStorage(await SharedPreferences.getInstance());

  static String bestKey(String gameId) => 'v1:$gameId:best';
  static const soundKey = 'v1:settings:sound';
  static const hapticsKey = 'v1:settings:haptics';

  int bestScore(String gameId) => _prefs.getInt(bestKey(gameId)) ?? 0;

  Future<void> setBestScore(String gameId, int score) =>
      _prefs.setInt(bestKey(gameId), score);

  bool get soundEnabled => _prefs.getBool(soundKey) ?? true;
  bool get hapticsEnabled => _prefs.getBool(hapticsKey) ?? true;

  Future<void> setSoundEnabled(bool value) => _prefs.setBool(soundKey, value);
  Future<void> setHapticsEnabled(bool value) =>
      _prefs.setBool(hapticsKey, value);
}
