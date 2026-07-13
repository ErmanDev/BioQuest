import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station1_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';

const List<Color> _designColors = [
  BioColors.deepSky, // Blue — Descriptive
  BioColors.moss, // Green — Correlational
  const Color(0xFFFF7043), // Orange — Quasi-Experimental
  BioColors.danger, // Red — Experimental
];

class Station1MissionScreen extends StatefulWidget {
  const Station1MissionScreen({super.key});

  @override
  State<Station1MissionScreen> createState() => _Station1MissionScreenState();
}

class _Station1MissionScreenState extends State<Station1MissionScreen>
    with SingleTickerProviderStateMixin {
  static const _backgroundAsset = 'assets/images/research_mission_bg.png';
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
    if (score <= 4) return kMossDyingAsset;
    if (score <= 7) return kMossThinAsset;
    if (score <= 9) return kMossThickAsset;
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
    final bgAsset =
        _started || _finished ? _activityBackgroundAsset : _backgroundAsset;
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: bgAsset,
            label: 'Research Mission',
            fit: BoxFit.cover,
            color: BioColors.forest,
            icon: Icons.landscape,
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              4,
              4,
              4,
              _started && !_finished ? 4 : 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _topBar(context),
                SizedBox(height: _started && !_finished ? 6 : 12),
                Expanded(
                  child: _finished
                      ? _result(context)
                      : _started
                          ? _activity()
                          : _story(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.go(stationHubRoute('station1')),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back, color: BioColors.forest, size: 26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _story() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        // Bounds aligned to the empty parchment panel in research_mission_bg.png.
        final panelLeft = w * 0.245;
        final panelWidth = w * 0.47;
        final panelTop = h * 0.26;
        final panelHeight = h * 0.52;
        final buttonWidth = panelWidth * 0.96;
        const buttonHeight = 108.0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: panelLeft,
              top: panelTop,
              width: panelWidth,
              height: panelHeight - buttonHeight - 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Mission Story',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: BioColors.forest,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          kStation1MissionStory,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            color: BioColors.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: panelLeft + (panelWidth - buttonWidth) / 2,
              bottom: h * 0.08,
              width: buttonWidth,
              child: PrimaryButton(
                label: 'Tap here to Start',
                color: BioColors.forest,
                fontSize: 20,
                expand: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                onTap: () {
                  _beginMission();
                  setState(() => _started = true);
                },
              ),
            ),
          ],
        );
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
                  _healthBar(),
                  const SizedBox(height: 8),
                  _directionsPanel(),
                  const SizedBox(height: 8),
                  _questionCard(item, total),
                  const SizedBox(height: 10),
                  Expanded(child: _answerRows()),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: BioColors.parchment,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: BioColors.sun,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_index + 1}/$total',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.statement,
              style: const TextStyle(
                fontSize: 20,
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

  Widget _answerRows() {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _designBox(0)),
              const SizedBox(width: 10),
              Expanded(child: _designBox(1)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _designBox(2)),
              const SizedBox(width: 10),
              Expanded(child: _designBox(3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _directionsPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: BioColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            kStation1MissionDirections,
            style: const TextStyle(
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w600,
              color: BioColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < kResearchDesignLabels.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _compactLegend(i)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _compactLegend(int index) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: _designColors[index],
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            kResearchDesigns[index],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: BioColors.ink,
            ),
          ),
        ),
      ],
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
                      Shadow(
                        color: Colors.white,
                        blurRadius: 12,
                      ),
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
    Color color = _designColors[designIndex];
    Widget? badge;
    if (answered) {
      if (isCorrect) {
        color = BioColors.correct;
        badge = const Icon(Icons.check_circle, color: Colors.white);
      } else if (isPicked) {
        color = BioColors.danger;
        badge = const Icon(Icons.cancel, color: Colors.white);
      } else {
        color = _designColors[designIndex];
      }
    }
    return GestureDetector(
      onTap: answered ? null : () => _pick(displaySlot),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                kResearchDesigns[designIndex],
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  height: 1.15,
                ),
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              SizedBox(width: 22, height: 22, child: badge),
            ],
          ],
        ),
      ),
    );
  }

  Widget _healthBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
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
          const Icon(Icons.favorite, color: BioColors.danger),
          const SizedBox(width: 8),
          const Text(
            'Moss Health',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _correct / kStation1Mission.length,
                minHeight: 16,
                backgroundColor: BioColors.paleLeaf,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(BioColors.correct),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$_correct / ${kStation1Mission.length}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  ({String asset, String label, Color color}) _mossState() {
    if (_correct <= 4) {
      return (
        asset: kMossDyingAsset,
        label: 'The moss is dying. Keep learning and try again!',
        color: BioColors.bark,
      );
    } else if (_correct <= 7) {
      return (
        asset: kMossThinAsset,
        label: 'The moss is healthy, but thin and short.',
        color: BioColors.leaf,
      );
    } else if (_correct <= 9) {
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
                await context
                    .read<ProgressService>()
                    .saveMissionScore('station1', _correct);
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
