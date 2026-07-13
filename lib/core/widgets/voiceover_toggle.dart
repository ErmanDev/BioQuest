import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../services/narration_helper.dart';
import '../../services/settings_service.dart';

/// Circular mute/unmute control — same style as the login music toggle.
class VoiceoverToggle extends StatelessWidget {
  const VoiceoverToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 4,
      child: Tooltip(
        message: settings.voiceoverOn ? 'Mute voiceover' : 'Unmute voiceover',
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () async {
            final turnOff = settings.voiceoverOn;
            await settings.setVoiceover(!turnOff);
            if (turnOff && context.mounted) {
              await stopNarration(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Icon(
              settings.voiceoverOn
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
