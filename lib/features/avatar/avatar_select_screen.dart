import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/animated_forest_background.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../models/explorer_avatar.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';
import '../../services/tts_service.dart';

class AvatarSelectScreen extends StatefulWidget {
  const AvatarSelectScreen({super.key});

  @override
  State<AvatarSelectScreen> createState() => _AvatarSelectScreenState();
}

class _AvatarSelectScreenState extends State<AvatarSelectScreen>
    with SingleTickerProviderStateMixin {
  static const _columns = 3;
  static const _rows = 2;
  static const _spacing = 8.0;
  static const _labelBand = 28.0;
  static const _avatarScale = 1.28;

  int _selected = 0;

  late final AnimationController _glowController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectIfAlreadyChosen());
  }

  void _redirectIfAlreadyChosen() {
    if (!mounted) return;
    final auth = context.read<AuthService>();
    if (auth.currentUser?.avatarChosen != true) return;
    final progress = context.read<ProgressService>();
    context.go(progress.hasTakenPretest ? '/map' : '/basecamp');
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _startAdventure() async {
    final avatarId = ExplorerAvatar.choices[_selected].id;
    final saved = await context.read<AuthService>().chooseAvatar(avatarId);
    if (!mounted) return;
    if (saved) {
      await context.read<TtsService>().configureForExplorer(avatarId);
      if (mounted) context.go('/basecamp');
    } else {
      _redirectIfAlreadyChosen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(
          child: AnimatedForestBackground(
            asset: 'assets/images/backgrounds/avatar_forest.jpg',
            label: 'Forest trail',
          ),
        ),
        Positioned.fill(
          child: ColoredBox(color: Colors.black.withValues(alpha: 0.18)),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
                child: Column(
                  children: [
                    _titleBar(),
                    const SizedBox(height: 4),
                    const Text(
                      'Pick your tour guide outfit.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 6),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final tileW = (constraints.maxWidth -
                                  _spacing * (_columns - 1)) /
                              _columns;
                          final tileH =
                              (constraints.maxHeight - _spacing * (_rows - 1)) /
                                  _rows;
                          final side = math.min(tileW, tileH - _labelBand);
                          final gridW =
                              side * _columns + _spacing * (_columns - 1);
                          final gridH = (side + _labelBand) * _rows +
                              _spacing * (_rows - 1);

                          return Center(
                            child: SizedBox(
                              width: gridW,
                              height: gridH,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _columns,
                                  mainAxisSpacing: _spacing,
                                  crossAxisSpacing: _spacing,
                                  childAspectRatio: side / (side + _labelBand),
                                ),
                                itemCount: ExplorerAvatar.choices.length,
                                itemBuilder: (context, i) =>
                                    _avatarTile(i, side),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 16,
                child: PrimaryButton(
                  label: 'Start My Adventure',
                  icon: Icons.explore,
                  color: BioColors.sun,
                  fontSize: 26,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 18,
                  ),
                  onTap: _startAdventure,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _titleBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        'Choose your Explorer Avatar',
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: BioColors.forest,
        ),
      ),
    );
  }

  Widget _avatarTile(int i, double side) {
    final explorer = ExplorerAvatar.choices[i];
    final selected = i == _selected;
    final genderTag =
        explorer.gender == ExplorerGender.female ? 'Female' : 'Male';

    return GestureDetector(
      onTap: () => setState(() => _selected = i),
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          final pulse = selected ? _glowController.value : 0.0;
          final glowStrength = 0.35 + pulse * 0.65;
          final blur = 10.0 + pulse * 22.0;
          final spread = pulse * 4.0;
          final borderWidth = selected ? 3.0 + pulse * 2.5 : 2.0;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected
                    ? Color.lerp(BioColors.sun, Colors.white, pulse * 0.35)!
                    : BioColors.bark.withValues(alpha: 0.35),
                width: borderWidth,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: BioColors.sun.withValues(alpha: glowStrength),
                        blurRadius: blur,
                        spreadRadius: spread,
                      ),
                      BoxShadow(
                        color: BioColors.correct
                            .withValues(alpha: glowStrength * 0.45),
                        blurRadius: blur * 1.6,
                        spreadRadius: spread * 0.6,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 2),
          child: Column(
            children: [
              Expanded(
                child: ClipRect(
                  child: Transform.scale(
                    scale: _avatarScale,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GameImage(
                        asset: explorer.assetPath,
                        label: explorer.label,
                        color: BioColors.moss,
                        fit: BoxFit.contain,
                        icon: Icons.emoji_people,
                        cacheWidth: (side * 2.5).round(),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                explorer.outfitName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: selected ? BioColors.forest : BioColors.ink,
                ),
              ),
              Text(
                genderTag,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? BioColors.forest : BioColors.bark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
