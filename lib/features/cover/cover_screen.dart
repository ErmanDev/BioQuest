import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../services/audio_service.dart';
import '../../services/settings_service.dart';

class CoverScreen extends StatefulWidget {
  const CoverScreen({super.key});

  @override
  State<CoverScreen> createState() => _CoverScreenState();
}

class _CoverScreenState extends State<CoverScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsService>();
      if (settings.musicOn) context.read<AudioService>().start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(
          child: GameImage(
            asset: 'assets/images/backgrounds/cover.jpg',
            label: 'Cover background',
            fit: BoxFit.cover,
            color: BioColors.forest,
            icon: Icons.forest,
            cacheWidth: 1280,
          ),
        ),
        Positioned.fill(
          child: ColoredBox(color: Colors.black.withValues(alpha: 0.42)),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'BioQuest',
                      style: TextStyle(
                        fontSize: 112,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      decoration: BoxDecoration(
                        color: BioColors.sun,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'A Journey Toward Research Discovery!',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: BioColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 56),
                    PrimaryButton(
                      label: 'Start',
                      icon: Icons.play_arrow_rounded,
                      fontSize: 40,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 22),
                      onTap: () => context.go('/auth'),
                    ),
                  ],
                ),
              ),
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
