import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'core/widgets/background_music_keeper.dart';
import 'services/audio_service.dart';
import 'services/auth_service.dart';
import 'services/db_service.dart';
import 'services/progress_service.dart';
import 'services/settings_service.dart';
import 'services/tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Landscape only.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final db = DbService();
  final settings = SettingsService();
  final tts = TtsService();
  final audio = AudioService();
  final auth = AuthService(db);
  final progress = ProgressService(db);

  await settings.load();
  await db.database;
  await tts.init();
  await audio.init();
  await auth.restoreSession();
  if (auth.isLoggedIn) {
    await progress.loadForUser(auth.currentUser!.id);
    await tts.configureForExplorer(auth.currentUser!.avatarId);
  }
  // Don't start playback here: the engine isn't ready to grant audio focus
  // before the first frame, and a silent early play would still mark the
  // stream as "started". The cover screen kicks off playback after first
  // frame instead. Only honor an explicit "music off" preference up front.
  if (!settings.musicOn) await audio.setEnabled(false);

  runApp(BioQuestApp(
    db: db,
    auth: auth,
    progress: progress,
    router: createAppRouter(auth: auth, progress: progress),
    settings: settings,
    tts: tts,
    audio: audio,
  ));
}

class BioQuestApp extends StatelessWidget {
  final DbService db;
  final AuthService auth;
  final ProgressService progress;
  final GoRouter router;
  final SettingsService settings;
  final TtsService tts;
  final AudioService audio;

  const BioQuestApp({
    super.key,
    required this.db,
    required this.auth,
    required this.progress,
    required this.router,
    required this.settings,
    required this.tts,
    required this.audio,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DbService>.value(value: db),
        ChangeNotifierProvider<SettingsService>.value(value: settings),
        ChangeNotifierProvider<TtsService>.value(value: tts),
        ChangeNotifierProvider<AudioService>.value(value: audio),
        ChangeNotifierProvider<AuthService>.value(value: auth),
        ChangeNotifierProvider<ProgressService>.value(value: progress),
      ],
      child: BackgroundMusicKeeper(
        child: MaterialApp.router(
          title: 'BioQuest',
          debugShowCheckedModeBanner: false,
          theme: BioTheme.build(),
          routerConfig: router,
        ),
      ),
    );
  }
}
