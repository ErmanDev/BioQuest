import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/audio_service.dart';
import '../../services/settings_service.dart';

/// Keeps looping background music alive for the whole session unless the
/// learner explicitly mutes it in settings.
class BackgroundMusicKeeper extends StatefulWidget {
  final Widget child;

  const BackgroundMusicKeeper({super.key, required this.child});

  @override
  State<BackgroundMusicKeeper> createState() => _BackgroundMusicKeeperState();
}

class _BackgroundMusicKeeperState extends State<BackgroundMusicKeeper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncMusic());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncMusic();
    }
  }

  void _syncMusic() {
    if (!mounted) return;
    final settings = context.read<SettingsService>();
    final audio = context.read<AudioService>();
    if (settings.musicOn) {
      audio.ensurePlaying();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: context.watch<SettingsService>(),
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _syncMusic());
        return child!;
      },
      child: widget.child,
    );
  }
}
