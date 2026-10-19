import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/artwork_stage.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station1_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';

class Station1MissionScreen extends StatefulWidget {
  const Station1MissionScreen({super.key});

  @override
  State<Station1MissionScreen> createState() => _Station1MissionScreenState();
}

class _Station1MissionScreenState extends State<Station1MissionScreen>
    with SingleTickerProviderStateMixin {
  static const _backgroundAsset = 'assets/images/research_mission_bg.png';

  /// Mission Story parchment on [_backgroundAsset], as fractions of the
  /// artwork, so the story stays on the parchment on any screen shape.
  static const double _storyArtAspect = 1024 / 458;
  static const Rect _storyTextRegion = Rect.fromLTRB(0.29, 0.355, 0.715, 0.71);
  static const Rect _storyButtonRegion = Rect.fromLTRB(0.36, 0.78, 0.64, 0.89);
  static const _activityBackgroundAsset =
      'assets/images/backgrounds/mission_forest_bg.png';
  static const _startButtonAsset = 'assets/images/ui/tap_here_to_start.png';

  bool _started = false;
  int _index = 0;
  int _correct = 0;
  int? _picked;
  bool _finished = false;
  List<MissionItem> _mission = [];
  List<int> _designOrder = const [0, 1, 2, 3];
  final _random = Random();
  Timer? _advanceTimer;

  static const _advanceDelay = Duration(milliseconds: 900);

  late final AnimationController _heartCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  );

  @override
  void dispose() {
    _advanceTimer?.cancel();
    _heartCtrl.dispose();
    super.dispose();
  }

  String _mossAssetForScore(int score) {
    if (score <= 2) return kMossDyingAsset;
    if (score <= 3) return kMossThinAsset;
    if (score <= 4) return kMossThickAsset;
    return kMossCapsuleAsset;
  }

  void _beginMission() {
    _advanceTimer?.cancel();
    _mission = List<MissionItem>.from(kStation1Mission)..shuffle(_random);
    _index = 0;
    _correct = 0;
    _picked = null;
    _finished = false;
    _shuffleDesignOrder();
  }

  void _shuffleDesignOrder() {
    _designOrder = List<int>.generate(kResearchDesigns.length, (i) => i)
      ..shuffle(_random);
  }

  void _pick(int displaySlot) {
    if (_picked != null) return;
    final designIndex = _designOrder[displaySlot];
    final isCorrect = designIndex == _mission[_index].correctDesign;
    setState(() {
      _picked = displaySlot;
      if (isCorrect) {
        _correct++;
        _heartCtrl.forward(from: 0);
      }
    });
    _advanceTimer?.cancel();
    _advanceTimer = Timer(_advanceDelay, () {
      if (!mounted || _picked == null) return;
      _next();
    });
  }

  void _next() {
    if (_index < _mission.length - 1) {
      setState(() {
        _index++;
        _picked = null;
        _shuffleDesignOrder();
      });
    } else {
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgAsset = _started || _finished
        ? _activityBackgroundAsset
        : _backgroundAsset;
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: _onStory
              ? ArtworkBackdrop(
                  asset: bgAsset,
                  aspect: _storyArtAspect,
                  label: 'Research Mission',
                )
              : GameImage(
                  asset: bgAsset,
                  label: 'Research Mission',
                  fit: BoxFit.cover,
                  color: BioColors.forest,
                  icon: Icons.landscape,
                ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    4,
                    96,
                    4,
                    _started && !_finished ? 4 : 10,
                  ),
                  child: _finished
                      ? _result(context)
                      : _started
                      ? _activity()
                      : const SizedBox.shrink(),
                ),
              ),
              Positioned(
                left: 24,
                top: 12,
                right: 24,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _backButton(context),
                    if (_started && !_finished) ...[
                      const SizedBox(width: 14),
                      Expanded(child: _healthBar()),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_onStory)
          Positioned.fill(
            child: ArtworkOverlay(
              aspect: _storyArtAspect,
              slots: [
                ArtworkSlot(region: _storyTextRegion, child: _storyText()),
                ArtworkSlot(
                  region: _storyButtonRegion,
                  child: Center(child: _startButton()),
                ),
              ],
            ),
          ),
      ],
    );
  }

  bool get _onStory => !_started && !_finished;

  Widget _backButton(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black45,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.go(stationHubRoute('station1')),
        child: const SizedBox(
          width: 72,
          height: 72,
          child: Icon(Icons.arrow_back, color: BioColors.forest, size: 40),
        ),
      ),
    );
  }

  Widget _storyText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Mission Story',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: BioColors.forest,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                kStation1MissionStory,
                style: const TextStyle(
                  fontSize: 25,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  color: BioColors.ink,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _startButton() {
    return PrimaryButton(
      label: 'Tap here to Start',
      color: BioColors.forest,
      fontSize: 26,
      expand: true,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      onTap: () {
        _beginMission();
        setState(() => _started = true);
      },
    );
  }

  Widget _activity() {
    final item = _mission[_index];
    final total = _mission.length;
    return LayoutBuilder(
      builder: (context, constraints) {
        final hPad = constraints.maxWidth * 0.05;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _directionsPanel(),
                  const SizedBox(height: 10),
                  _questionCard(item, total),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _answerRows(constraints.maxHeight),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.01),
                ],
              ),
            ),
            _heartBurst(),
          ],
        );
      },
    );
  }

  Widget _questionCard(MissionItem item, int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: BioColors.parchment,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: BioColors.sun,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_index + 1}/$total',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.statement,
              style: const TextStyle(
                fontSize: 32,
                height: 1.3,
                fontWeight: FontWeight.w700,
                color: BioColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerRows(double maxHeight) {
    final boxHeight = (maxHeight * 0.12).clamp(64.0, 84.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          SizedBox(
            height: boxHeight,
            width: double.infinity,
            child: _designBox(i),
          ),
        ],
      ],
    );
  }

  Widget _directionsPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: BioColors.parchment,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Directions:',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: BioColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            kStation1MissionDirections,
            style: const TextStyle(
              fontSize: 28,
              height: 1.35,
              fontWeight: FontWeight.w600,
              color: BioColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _heartBurst() {
    return AnimatedBuilder(
      animation: _heartCtrl,
      builder: (context, child) {
        if (_heartCtrl.value == 0) return const SizedBox.shrink();
        final t = Curves.easeOut.transform(_heartCtrl.value);
        final fade = (1 - _heartCtrl.value).clamp(0.0, 1.0);
        return Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Opacity(
                opacity: fade,
                child: Transform.scale(
                  scale: 0.6 + t * 0.9,
                  child: Icon(
                    Icons.favorite,
                    size: 96,
                    color: BioColors.danger.withValues(alpha: 0.85),
                    shadows: const [
                      Shadow(color: Colors.white, blurRadius: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _designBox(int displaySlot) {
    final designIndex = _designOrder[displaySlot];
    final correctIndex = _mission[_index].correctDesign;
    final answered = _picked != null;
    final isPicked = _picked == displaySlot;
    final isCorrect = designIndex == correctIndex;

    Color fill = Colors.white;
    Color border = BioColors.bark.withValues(alpha: 0.45);
    Color textColor = BioColors.ink;
    Widget? badge;

    if (answered) {
      if (isCorrect) {
        fill = BioColors.correct;
        border = BioColors.correct;
        textColor = Colors.white;
        badge = const Icon(Icons.check_circle, color: Colors.white);
      } else {
        fill = BioColors.danger;
        border = BioColors.danger;
        textColor = Colors.white;
        if (isPicked) {
          badge = const Icon(Icons.cancel, color: Colors.white);
        }
      }
    }

    return GestureDetector(
      onTap: answered ? null : () => _pick(displaySlot),
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 2.5),
          boxShadow: answered
              ? null
              : const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                kResearchDesigns[designIndex],
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  height: 1.15,
                ),
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 10),
              SizedBox(width: 28, height: 28, child: badge),
            ],
          ],
        ),
      ),
    );
  }

  Widget _healthBar() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: GameImage(
              asset: _mossAssetForScore(_correct),
              label: 'Moss health',
              fit: BoxFit.contain,
              color: BioColors.moss,
              icon: Icons.grass,
              cacheWidth: 192,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.favorite, color: BioColors.danger, size: 26),
          const SizedBox(width: 8),
          const Text(
            'Moss Health',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _correct / kStation1Mission.length,
                minHeight: 16,
                backgroundColor: BioColors.paleLeaf,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  BioColors.correct,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$_correct / ${kStation1Mission.length}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  ({String asset, String label, Color color}) _mossState() {
    if (_correct <= 2) {
      return (
        asset: kMossDyingAsset,
        label: 'The moss is dying. Keep learning and try again!',
        color: BioColors.bark,
      );
    } else if (_correct <= 3) {
      return (
        asset: kMossThinAsset,
        label: 'The moss is healthy, but thin and short.',
        color: BioColors.leaf,
      );
    } else if (_correct <= 4) {
      return (
        asset: kMossThickAsset,
        label: 'The moss is healthy, tall, and thick!',
        color: BioColors.moss,
      );
    }
    return (
      asset: kMossCapsuleAsset,
      label: 'Perfect! The moss fully grew and produced a mature capsule!',
      color: BioColors.forest,
    );
  }

  Widget _result(BuildContext context) {
    final state = _mossState();
    return Center(
      child: Container(
        width: 720,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: BioColors.parchment,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: state.color, width: 4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              width: 280,
              child: GameImage(
                asset: state.asset,
                label: state.label,
                fit: BoxFit.contain,
                color: BioColors.moss,
                icon: Icons.grass,
                cacheWidth: 560,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: $_correct / ${kStation1Mission.length}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: BioColors.forest,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              state.label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Continue to Takeaway',
              icon: Icons.edit_note,
              color: BioColors.sun,
              onTap: () async {
                await context.read<ProgressService>().saveMissionScore(
                  'station1',
                  _correct,
                );
                if (context.mounted) context.go('/station1/takeaway');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Transparent tap-to-start image — no backing box, scales to width.
class _TapHereToStartButton extends StatefulWidget {
  final String asset;
  final double height;
  final VoidCallback onTap;

  const _TapHereToStartButton({
    required this.asset,
    required this.height,
    required this.onTap,
  });

  @override
  State<_TapHereToStartButton> createState() => _TapHereToStartButtonState();
}

class _TapHereToStartButtonState extends State<_TapHereToStartButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Tap Here to Start',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: Image.asset(
              widget.asset,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              gaplessPlayback: true,
              errorBuilder: (context, error, stack) => GameImage(
                asset: widget.asset,
                label: 'Tap Here to Start',
                fit: BoxFit.contain,
                color: BioColors.moss,
                icon: Icons.play_arrow_rounded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
