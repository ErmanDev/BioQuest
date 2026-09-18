import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_service.dart';
import 'auth_service.dart';
import 'settings_service.dart';
import 'tts_service.dart';

/// Plays [text] when voiceover is enabled and ducks background music.
Future<void> autoNarrateIfEnabled(BuildContext context, String text) async {
  if (!context.mounted || text.trim().isEmpty) return;

  final settings = context.read<SettingsService>();
  final audio = context.read<AudioService>();
  final tts = context.read<TtsService>();
  final user = context.read<AuthService>().currentUser;

  if (user != null) {
    await tts.configureForExplorer(user.avatarId);
  }
  if (!context.mounted || !settings.voiceoverOn) return;

  await audio.duck();
  await tts.speak(text);
  if (context.mounted) {
    await audio.unduck();
  }
}

/// Stops narration and restores background music volume.
///
/// Uses a short timeout so a wedged TTS plugin (common after hot reload)
/// cannot block navigation forever.
Future<void> stopNarration(BuildContext context) async {
  final tts = context.read<TtsService>();
  final audio = context.read<AudioService>();
  tts.stopImmediately();
  try {
    await tts.stop().timeout(const Duration(milliseconds: 400));
  } catch (_) {}
  try {
    await audio.unduck().timeout(const Duration(milliseconds: 400));
  } catch (_) {}
}

/// Stops narration, then pops the current route.
Future<void> popAfterStoppingNarration(BuildContext context) async {
  await stopNarration(context);
  if (context.mounted && context.canPop()) {
    context.pop();
  }
}

/// Stops any current narration, then navigates with [push].
Future<void> pushAfterStoppingNarration(
  BuildContext context,
  String location,
) async {
  await stopNarration(context);
  if (context.mounted) {
    await context.push(location);
  }
}
