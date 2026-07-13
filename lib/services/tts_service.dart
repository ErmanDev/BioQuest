import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/explorer_avatar.dart';

/// Wraps the device's offline text-to-speech engine. Narration "depends on the
/// instruction": callers pass the text of the current screen/instruction.
/// Voice gender follows the player's chosen explorer avatar.
class TtsService extends ChangeNotifier {
  final FlutterTts _tts = FlutterTts();
  bool _speaking = false;
  bool _ready = false;
  ExplorerGender? _gender;
  int _generation = 0;
  Completer<void>? _activeUtterance;

  bool get isSpeaking => _speaking;

  bool get _onAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> init() async {
    try {
      await _tts.awaitSpeakCompletion(false);
      await _prepareEngine();
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.45);
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      _tts.setCompletionHandler(_onUtteranceEnded);
      _tts.setCancelHandler(_onUtteranceEnded);
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  void _onUtteranceEnded() {
    _speaking = false;
    _completeActiveUtterance();
    notifyListeners();
  }

  void _completeActiveUtterance() {
    final done = _activeUtterance;
    if (done != null && !done.isCompleted) {
      done.complete();
    }
    _activeUtterance = null;
  }

  Future<void> _prepareEngine() async {
    if (!_onAndroid) return;
    try {
      final engines = await _tts.getEngines;
      if (engines is List) {
        for (final engine in engines) {
          final name = engine is Map ? '${engine['name']}' : '$engine';
          if (name.contains('google')) {
            await _tts.setEngine(name);
            return;
          }
        }
      }
      await _tts.setEngine('com.google.android.tts');
    } catch (_) {}
  }

  /// Sets male or female TTS voice to match the tour-guide avatar.
  Future<void> configureForExplorer(int avatarId) async {
    await setExplorerGender(ExplorerAvatar.fromId(avatarId).gender);
  }

  Future<void> setExplorerGender(ExplorerGender gender) async {
    _gender = gender;
    if (!_ready) return;
    await _applyGenderVoice(gender);
  }

  Future<void> _applyGenderVoice(ExplorerGender gender) async {
    final wantMale = gender == ExplorerGender.male;
    await _prepareEngine();

    try {
      final raw = await _tts.getVoices;
      if (raw is List && raw.isNotEmpty) {
        Map? best;
        var bestScore = -1;

        for (final entry in raw) {
          if (entry is! Map) continue;
          final score = _scoreVoice(entry, wantMale);
          if (score > bestScore) {
            bestScore = score;
            best = entry;
          }
        }

        if (best != null && bestScore > 0) {
          await _setVoiceMap(best);
          await _tts.setPitch(wantMale ? 0.95 : 1.05);
          return;
        }

        // Only pick voices with an explicit gender match — never an unknown voice.
        for (final entry in raw) {
          if (entry is! Map) continue;
          final locale = '${entry['locale'] ?? ''}'.toLowerCase();
          if (!locale.startsWith('en')) continue;
          final detected = _detectGender(
            '${entry['name'] ?? ''}',
            '${entry['gender'] ?? ''}',
            '${entry['identifier'] ?? ''}',
          );
          if (detected == null) continue;
          if (wantMale && detected) {
            await _setVoiceMap(entry);
            await _tts.setPitch(0.95);
            return;
          }
          if (!wantMale && !detected) {
            await _setVoiceMap(entry);
            await _tts.setPitch(1.05);
            return;
          }
        }
      }
    } catch (_) {}

    // Emulator often ships one female voice — lower pitch heavily for male avatars.
    await _tts.setPitch(wantMale ? (_onAndroid ? 0.52 : 0.75) : 1.22);
  }

  int _scoreVoice(Map entry, bool wantMale) {
    final name = '${entry['name'] ?? ''}';
    final locale = '${entry['locale'] ?? ''}'.toLowerCase();
    final genderField = '${entry['gender'] ?? ''}';
    final identifier = '${entry['identifier'] ?? ''}';

    if (!locale.startsWith('en')) return -1;

    final detected = _detectGender(name, genderField, identifier);
    if (detected == null) return -1;
    if (detected != wantMale) return -1;

    var score = 10;
    if (locale == 'en-us' || locale.startsWith('en-us')) score += 30;
    if (genderField.isNotEmpty) score += 50;

    final lower = '$name $identifier'.toLowerCase();
    if (_onAndroid) {
      if (wantMale && _isAndroidMaleVoice(lower)) score += 60;
      if (!wantMale && _isAndroidFemaleVoice(lower)) score += 60;
    } else if (wantMale) {
      if (lower.contains('david') ||
          lower.contains('mark') ||
          lower.contains('guy')) {
        score += 40;
      }
    } else {
      if (lower.contains('zira') || lower.contains('hazel')) score += 40;
    }
    return score;
  }

  /// Returns true = male, false = female, null = unknown.
  bool? _detectGender(String name, String genderField, String identifier) {
    final g = genderField.toLowerCase().trim();
    if (g.contains('male') && !g.contains('female')) return true;
    if (g.contains('female') || g == 'f' || g == '0') return false;
    if (g == 'm' || g == '1') return true;

    final combined = '$name $identifier'.toLowerCase();

    if (_onAndroid) {
      if (_isAndroidFemaleVoice(combined)) return false;
      if (_isAndroidMaleVoice(combined)) return true;
    }

    if (_isFemaleVoiceName(combined)) return false;
    if (_isMaleVoiceName(combined)) return true;

    return null;
  }

  /// Google Android TTS local/network voice codes (common on emulators).
  bool _isAndroidMaleVoice(String name) =>
      RegExp(r'x-iom|x-iog|x-iob|x-iod|x-ioo|#male|male_|-male').hasMatch(name) ||
      _isMaleVoiceName(name);

  bool _isAndroidFemaleVoice(String name) =>
      RegExp(r'x-tpf|x-tpd|x-tpc|x-tta|x-sfg|x-sdf|x-tdf|#female|female_|-female')
          .hasMatch(name) ||
      _isFemaleVoiceName(name);

  bool _isMaleVoiceName(String name) =>
      name.contains('daniel') ||
      name.contains('david') ||
      name.contains('mark') ||
      name.contains('george') ||
      name.contains('aaron') ||
      name.contains('fred') ||
      name.contains('james') ||
      name.contains('gordon') ||
      name.contains('ryan') ||
      name.contains('richard') ||
      name.contains('christopher') ||
      name.contains('steven') ||
      name.contains('eric');

  bool _isFemaleVoiceName(String name) =>
      name.contains('samantha') ||
      name.contains('karen') ||
      name.contains('victoria') ||
      name.contains('zira') ||
      name.contains('hazel') ||
      name.contains('susan') ||
      name.contains('jenny') ||
      name.contains('aria') ||
      name.contains('michelle') ||
      name.contains('linda') ||
      name.contains('heera') ||
      name.contains('sonia');

  Future<void> _setVoiceMap(Map entry) async {
    final voice = <String, String>{
      'name': '${entry['name']}',
      'locale': '${entry['locale']}',
    };
    final id = entry['identifier'];
    if (id != null && '$id'.isNotEmpty) {
      voice['identifier'] = '$id';
    }
    await _tts.setVoice(voice);
  }

  Future<void> _ensureVoice() async {
    if (_gender != null) await _applyGenderVoice(_gender!);
  }

  Future<void> _haltSpeech() async {
    if (!_ready) return;
    try {
      await _tts.stop();
    } catch (_) {}
    try {
      await _tts.pause();
    } catch (_) {}
    try {
      await _tts.stop();
    } catch (_) {}
  }

  /// Immediately invalidates in-flight speech; use when leaving a screen.
  void stopImmediately() {
    _generation++;
    _speaking = false;
    _completeActiveUtterance();
    notifyListeners();
    if (_ready) {
      _tts.stop();
      _tts.pause();
    }
  }

  Future<void> speak(String text) async {
    if (!_ready || text.trim().isEmpty) return;

    final generation = ++_generation;
    await _haltSpeech();
    if (generation != _generation) return;

    await _ensureVoice();
    if (generation != _generation) return;

    _activeUtterance = Completer<void>();
    _speaking = true;
    notifyListeners();

    try {
      await _tts.speak(text);
      if (generation != _generation) return;
      await _activeUtterance!.future;
    } catch (_) {
      // Ignore platform errors; state is cleared in finally.
    } finally {
      if (generation == _generation) {
        _speaking = false;
        _completeActiveUtterance();
        notifyListeners();
      }
    }
  }

  Future<void> pause() async {
    if (!_ready || !_speaking) return;
    try {
      await _tts.pause();
    } catch (_) {}
    _speaking = false;
    notifyListeners();
  }

  Future<void> stop() async {
    stopImmediately();
    await _haltSpeech();
  }

  @override
  void dispose() {
    stopImmediately();
    super.dispose();
  }
}
