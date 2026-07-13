import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../services/auth_service.dart';
import '../../services/audio_service.dart';
import '../../services/narration_helper.dart';
import '../../services/settings_service.dart';
import '../../services/tts_service.dart';

/// Voiceover control shown on narratable screens. Lets the learner turn the
/// voiceover on/off (per the design doc) and play/stop the current text.
/// While speaking, background music is ducked.
class NarrationControl extends StatelessWidget {
  final String text;
  const NarrationControl({super.key, required this.text});

  Future<void> _play(BuildContext context) async {
    final tts = context.read<TtsService>();
    final audio = context.read<AudioService>();
    final user = context.read<AuthService>().currentUser;
    if (user != null) await tts.configureForExplorer(user.avatarId);
    await audio.duck();
    await tts.speak(text);
    await audio.unduck();
  }

  Future<void> _pause(BuildContext context) async {
    await context.read<TtsService>().pause();
    await context.read<AudioService>().unduck();
  }

  Future<void> _stop(BuildContext context) async {
    await stopNarration(context);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final tts = context.watch<TtsService>();
    final speaking = tts.isSpeaking;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: BioColors.forest, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _roundButton(
            icon: settings.voiceoverOn ? Icons.volume_up : Icons.volume_off,
            color: settings.voiceoverOn ? BioColors.forest : Colors.grey,
            tooltip: settings.voiceoverOn ? 'Mute voiceover' : 'Unmute voiceover',
            onTap: () async {
              final turnOff = settings.voiceoverOn;
              await settings.setVoiceover(!turnOff);
              if (turnOff) {
                await stopNarration(context);
              }
            },
          ),
          if (settings.voiceoverOn) ...[
            const SizedBox(width: 6),
            _roundButton(
              icon: Icons.play_circle_fill,
              color: speaking ? Colors.grey : BioColors.correct,
              tooltip: 'Read aloud',
              onTap: speaking ? null : () => _play(context),
            ),
            if (speaking) ...[
              const SizedBox(width: 6),
              _roundButton(
                icon: Icons.pause_circle_filled,
                color: BioColors.forest,
                tooltip: 'Pause',
                onTap: () => _pause(context),
              ),
            ],
            const SizedBox(width: 6),
            _roundButton(
              icon: Icons.stop_circle,
              color: BioColors.danger,
              tooltip: 'Stop',
              onTap: () => _stop(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback? onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color, size: 44),
          ),
        ),
      ),
    );
  }
}
