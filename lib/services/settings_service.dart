import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the voiceover (TTS) and background-music toggles.
class SettingsService extends ChangeNotifier {
  static const _kVoiceover = 'voiceover_on';
  static const _kMusic = 'music_on';

  SharedPreferences? _prefs;
  bool _voiceoverOn = true;
  bool _musicOn = true;

  bool get voiceoverOn => _voiceoverOn;
  bool get musicOn => _musicOn;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _voiceoverOn = _prefs?.getBool(_kVoiceover) ?? true;
    _musicOn = _prefs?.getBool(_kMusic) ?? true;
    notifyListeners();
  }

  Future<void> setVoiceover(bool value) async {
    _voiceoverOn = value;
    await _prefs?.setBool(_kVoiceover, value);
    notifyListeners();
  }

  Future<void> setMusic(bool value) async {
    _musicOn = value;
    await _prefs?.setBool(_kMusic, value);
    notifyListeners();
  }
}
