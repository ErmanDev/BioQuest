import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Looping background music plus a short sound-effect player for answer
/// feedback. If an asset is missing, playback fails silently so the game
/// still runs.
class AudioService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer(playerId: 'bgm');
  final AudioPlayer _sfx = AudioPlayer(playerId: 'sfx');
  static const String _track = 'audio/theme.mp3';
  static const String _wrongSound = 'audio/wrong_soft.wav';
  static const double _sfxVolume = 0.5;
  static const double _normalVolume = 0.85;
  static const double _duckedVolume = 0.3;

  bool _enabled = true;
  bool _started = false;
  bool _ducked = false;
  StreamSubscription<PlayerState>? _stateSub;
  bool _recovering = false;

  bool get enabled => _enabled;

  Future<void> init() async {
    try {
      final audioContext = AudioContextConfig(
        focus: AudioContextConfigFocus.mixWithOthers,
      ).build();
      await AudioPlayer.global.setAudioContext(audioContext);
      await _player.setAudioContext(audioContext);
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(_normalVolume);
      await _sfx.setAudioContext(audioContext);
      await _sfx.setReleaseMode(ReleaseMode.stop);
      _stateSub = _player.onPlayerStateChanged.listen(_onPlayerStateChanged);
    } catch (_) {}
  }

  void _onPlayerStateChanged(PlayerState state) {
    if (!_enabled || _recovering) return;
    if (state == PlayerState.paused || state == PlayerState.stopped) {
      unawaited(ensurePlaying());
    }
  }

  /// Starts or resumes music when the learner has not muted it.
  Future<void> ensurePlaying() async {
    if (!_enabled) return;
    _recovering = true;
    try {
      final state = _player.state;
      if (!_started || state == PlayerState.stopped || state == PlayerState.completed) {
        await _player.play(
          AssetSource(_track),
          volume: _ducked ? _duckedVolume : _normalVolume,
        );
        _started = true;
      } else if (state == PlayerState.paused) {
        await _player.resume();
        await _player.setVolume(_ducked ? _duckedVolume : _normalVolume);
      }
    } catch (_) {
      // Missing/placeholder track - ignore.
    } finally {
      _recovering = false;
    }
  }

  Future<void> start() => ensurePlaying();

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    notifyListeners();
    try {
      if (value) {
        await ensurePlaying();
      } else {
        await _player.pause();
      }
    } catch (_) {}
  }

  /// Lowers music volume while narration plays.
  Future<void> duck() async {
    if (!_enabled) return;
    _ducked = true;
    try {
      await _player.setVolume(_duckedVolume);
    } catch (_) {}
  }

  Future<void> unduck() async {
    if (!_enabled) return;
    _ducked = false;
    try {
      await _player.setVolume(_normalVolume);
      await ensurePlaying();
    } catch (_) {}
  }

  /// Plays the soft warning tone used for wrong answers.
  Future<void> playWrong() async {
    try {
      await _sfx.stop();
      await _sfx.play(AssetSource(_wrongSound), volume: _sfxVolume);
    } catch (_) {}
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _player.dispose();
    _sfx.dispose();
    super.dispose();
  }
}
