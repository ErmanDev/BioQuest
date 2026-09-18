import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../services/audio_service.dart';
import '../../services/settings_service.dart';

/// Opening title card. The artwork already includes branding and TAP TO START.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _splashAsset = 'assets/images/backgrounds/splash.jpg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsService>();
      if (settings.musicOn) context.read<AudioService>().start();
    });
  }

  void _continue() => context.go('/auth');

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFF4EFE4)),
        Positioned.fill(
          child: Semantics(
            button: true,
            label: 'Tap to start',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _continue,
              child: const GameImage(
                asset: _splashAsset,
                label: 'BioQuest splash',
                fit: BoxFit.contain,
                color: BioColors.forest,
                icon: Icons.landscape,
                cacheWidth: 1280,
              ),
            ),
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                right: 24,
                bottom: 20,
                child: _musicToggle(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _musicToggle(BuildContext context) {
    final settings = context.watch<SettingsService>();
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      child: Tooltip(
        message: settings.musicOn ? 'Mute music' : 'Unmute music',
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () async {
            final audio = context.read<AudioService>();
            final on = !settings.musicOn;
            await settings.setMusic(on);
            await audio.setEnabled(on);
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Icon(
              settings.musicOn
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
              color: BioColors.forest,
              size: 44,
            ),
          ),
        ),
      ),
    );
  }
}
