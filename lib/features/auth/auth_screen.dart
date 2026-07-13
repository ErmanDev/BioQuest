import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../services/audio_service.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/settings_service.dart';
import '../../services/tts_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _username = TextEditingController();
  final _displayName = TextEditingController();
  final _password = TextEditingController();
  bool _registerMode = false;
  bool _busy = false;
  bool _passwordVisible = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsService>();
      if (settings.musicOn) context.read<AudioService>().start();
    });
  }

  @override
  void dispose() {
    _username.dispose();
    _displayName.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = context.read<AuthService>();
    final result = _registerMode
        ? await auth.register(
            _username.text,
            _password.text,
            _displayName.text,
          )
        : await auth.login(_username.text, _password.text);
    if (!mounted) return;
    if (result.ok) {
      final userId = auth.currentUser!.id;
      final progress = context.read<ProgressService>();
      await progress.loadForUser(userId);
      await context.read<TtsService>().configureForExplorer(auth.currentUser!.avatarId);
      if (!mounted) return;
      setState(() => _busy = false);
      final user = auth.currentUser!;
      if (!user.avatarChosen) {
        context.go('/avatar');
      } else if (!progress.hasTakenPretest) {
        context.go('/basecamp');
      } else {
        context.go('/map');
      }
    } else {
      setState(() {
        _busy = false;
        _error = result.error;
      });
    }
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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
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
                      const SizedBox(height: 40),
                      Container(
                        width: 760,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 40),
                        decoration: BoxDecoration(
                          color: BioColors.parchment,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: BioColors.forest, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _registerMode
                                  ? 'Create your explorer account'
                                  : 'Welcome back, explorer!',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: BioColors.forest,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 28),
                            _toggle(),
                            const SizedBox(height: 28),
                            _field(_username, 'Username', Icons.person),
                            if (_registerMode) ...[
                              const SizedBox(height: 20),
                              _field(
                                _displayName,
                                'Display name',
                                Icons.badge_outlined,
                              ),
                            ],
                            const SizedBox(height: 20),
                            _field(_password, 'Password', Icons.lock,
                                passwordToggle: true),
                            if (_error != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: BioColors.danger,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                            const SizedBox(height: 28),
                            PrimaryButton(
                              label: _busy
                                  ? 'Please wait...'
                                  : (_registerMode ? 'Register' : 'Log In'),
                              icon: Icons.login,
                              fontSize: 32,
                              expand: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 36, vertical: 20),
                              onTap: _busy ? null : _submit,
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
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

  Widget _toggle() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: BioColors.forest, width: 3),
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleChip('Log In', !_registerMode, () => setState(() {
                  _registerMode = false;
                  _error = null;
                  _passwordVisible = false;
                })),
          ),
          Expanded(
            child: _toggleChip('Register', _registerMode, () => setState(() {
                  _registerMode = true;
                  _error = null;
                  _passwordVisible = false;
                })),
          ),
        ],
      ),
    );
  }

  Widget _toggleChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: active ? BioColors.forest : Colors.transparent,
          borderRadius: BorderRadius.circular(36),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.white : BioColors.forest,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, IconData icon,
      {bool passwordToggle = false}) {
    return TextField(
      controller: c,
      obscureText: passwordToggle ? !_passwordVisible : false,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: BioColors.forest, size: 30),
        suffixIcon: passwordToggle
            ? IconButton(
                icon: Icon(
                  _passwordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: BioColors.forest,
                  size: 30,
                ),
                onPressed: () =>
                    setState(() => _passwordVisible = !_passwordVisible),
              )
            : null,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 24, color: BioColors.bark),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BioColors.forest, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BioColors.bark, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BioColors.forest, width: 3),
        ),
      ),
    );
  }
}
