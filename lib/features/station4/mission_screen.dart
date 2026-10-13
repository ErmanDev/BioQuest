import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/text_format.dart';
import '../../core/widgets/artwork_stage.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station4_data.dart';
import '../../data/stations.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/widgets/voiceover_toggle.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';
import 'activity2_instructions.dart';
import 'activity2_overview.dart';
import 'graph_form_match_activity.dart';
import 'phytochemical_screening_activity.dart';
import 'screening_analysis_activity.dart';
import '../station/widgets/mission_cards.dart';

class Station4MissionScreen extends StatefulWidget {
  const Station4MissionScreen({super.key});

  @override
  State<Station4MissionScreen> createState() => _Station4MissionScreenState();
}

class _Station4MissionScreenState extends State<Station4MissionScreen>
    with SingleTickerProviderStateMixin, RouteAware, AutoNarrateOnEnter {
  static const _activityBackgroundAsset =
      'assets/images/backgrounds/mission_forest_bg.png';

  /// Mission Story parchment on [kStation4MissionBackgroundAsset], as
  /// fractions of the artwork, so the story stays on the parchment on any
  /// screen shape.
  static const double _storyArtAspect = 3072 / 1376;
  static const Rect _storyTextRegion = Rect.fromLTRB(0.345, 0.37, 0.69, 0.70);
  static const Rect _storyButtonRegion = Rect.fromLTRB(
    0.36,
    0.715,
    0.675,
    0.79,
  );
  static const _storyHorizontalPad = 18.0;

  int _phase =
      0; // 0 story, 1 graph, 2 overview, 3 instructions, 4 screening, 5 analysis, 6 done
  bool _graphActivityDone = false;
  bool _screeningDone = false;
  int _score = 0;
  final _storyScrollCtrl = ScrollController();
  late final AnimationController _scrollHintCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _scrollHintBounce = Tween<double>(
    begin: 0,
    end: 10,
  ).animate(CurvedAnimation(parent: _scrollHintCtrl, curve: Curves.easeInOut));
  bool _showScrollHint = true;

  @override
  String? get autoNarrateText =>
      _phase == 0 ? stripReadingMarkup(kStation4MissionStory) : null;

  @override
  bool get shouldAutoNarrate => _phase == 0;

  @override
  void initState() {
    super.initState();
    _storyScrollCtrl.addListener(_onStoryScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onStoryScroll();
    });
    _scrollHintCtrl.repeat(reverse: true);
  }

  void _setScrollHintVisible(bool show) {
    if (show == _showScrollHint) return;
    setState(() => _showScrollHint = show);
    if (show) {
      _scrollHintCtrl.repeat(reverse: true);
    } else {
      _scrollHintCtrl.stop();
    }
  }

  void _onStoryScroll() {
    if (!_storyScrollCtrl.hasClients) return;
    final canScroll = _storyScrollCtrl.position.maxScrollExtent > 8;
    final atBottom =
        _storyScrollCtrl.position.pixels >=
        _storyScrollCtrl.position.maxScrollExtent - 16;
    _setScrollHintVisible(canScroll && !atBottom);
  }

  @override
  void dispose() {
    _scrollHintCtrl.dispose();
    _storyScrollCtrl.removeListener(_onStoryScroll);
    _storyScrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgAsset = switch (_phase) {
      0 => kStation4MissionBackgroundAsset,
      2 || 3 || 4 || 5 => kStation4Activity2BackgroundAsset,
      _ => _activityBackgroundAsset,
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: _phase == 0
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
                  cacheWidth: 1280,
                ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.fromLTRB(4, 4, 4, _phase == 0 ? 10 : 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_phase != 2 &&
                    _phase != 3 &&
                    _phase != 4 &&
                    _phase != 5) ...[
                  _topBar(context),
                  SizedBox(height: _phase == 0 ? 12 : 6),
                ],
                Expanded(
                  child: switch (_phase) {
                    0 => const SizedBox.shrink(),
                    1 => _graphMatch(),
                    2 => Activity2Overview(
                      onBack: () {
                        stopNarration(context).then((_) {
                          if (context.mounted) {
                            context.go(stationHubRoute('station4'));
                          }
                        });
                      },
                      onContinue: () => setState(() => _phase = 3),
                    ),
                    3 => Activity2Instructions(
                      onBack: () => setState(() => _phase = 2),
                      onContinue: () => setState(() => _phase = 4),
                    ),
                    4 => _screening(),
                    5 => _analysis(),
                    _ => _done(),
                  },
                ),
              ],
            ),
          ),
        ),
        if (_phase == 0)
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

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              stopNarration(context).then((_) {
                if (context.mounted) {
                  context.go(stationHubRoute('station4'));
                }
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back, color: BioColors.forest, size: 26),
            ),
          ),
        ),
        const Spacer(),
        if (_phase == 0) const VoiceoverToggle(),
      ],
    );
  }

  Widget _storyText() {
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _onStoryScroll();
          });
          return false;
        },
        child: Stack(
          children: [
            Scrollbar(
              controller: _storyScrollCtrl,
              child: SingleChildScrollView(
                controller: _storyScrollCtrl,
                padding: const EdgeInsets.fromLTRB(
                  _storyHorizontalPad,
                  0,
                  _storyHorizontalPad,
                  8,
                ),
                child: Text.rich(
                  readingTextSpan(
                    kStation4MissionStory,
                    fontSize: 16,
                    color: BioColors.ink,
                  ),
                  style: const TextStyle(height: 1.45),
                ),
              ),
            ),
            if (_showScrollHint) _scrollDownHint(),
          ],
        ),
      ),
    );
  }

  Widget _startButton() {
    return PrimaryButton(
      label: 'Start Activity',
      color: BioColors.forest,
      fontSize: 20,
      expand: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      onTap: () async {
        await stopNarration(context);
        if (mounted) setState(() => _phase = 1);
      },
    );
  }

  Widget _scrollDownHint() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 6,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _scrollHintBounce,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _scrollHintBounce.value),
            child: child,
          ),
          child: const Text(
            'Scroll down',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: BioColors.forest,
            ),
          ),
        ),
      ),
    );
  }

  Widget _graphMatch() {
    return Column(
      children: [
        Expanded(
          child: GraphFormMatchActivity(
            onAllCorrect: () => setState(() {
              _graphActivityDone = true;
              _score++;
            }),
          ),
        ),
        if (_graphActivityDone) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: PrimaryButton(
              label: 'Next: Activity 2 Overview',
              icon: Icons.science,
              color: BioColors.sun,
              onTap: () => setState(() => _phase = 2),
            ),
          ),
        ],
      ],
    );
  }

  Widget _screening() {
    return Column(
      children: [
        Expanded(
          child: PhytochemicalScreeningActivity(
            onComplete: () => setState(() {
              _screeningDone = true;
              _score++;
            }),
          ),
        ),
        if (_screeningDone) ...[
          const SizedBox(height: 8),
          Center(
            child: PrimaryButton(
              label: 'Proceed to Analysis',
              icon: Icons.arrow_forward,
              onTap: () => setState(() => _phase = 5),
            ),
          ),
        ],
      ],
    );
  }

  Widget _analysis() {
    return ScreeningAnalysisActivity(
      onComplete: (score, total) => setState(() {
        if (score == total) _score++;
        _phase = 6;
      }),
    );
  }

  Widget _done() {
    return MissionCompleteCard(
      score: _score,
      total: 3,
      continueLabel: 'Continue to Takeaway',
      message: _score == 3
          ? 'Brilliant! You matched the data displays, completed the screening '
                'table, and interpreted every guide question correctly.'
          : _score >= 2
          ? 'Good work on the investigation. Review the official results '
                'if any guide questions were missed.'
          : 'Good effort decoding the data. Continue to the takeaway.',
      onContinue: () async {
        final progress = context.read<ProgressService>();
        final router = GoRouter.of(context);
        await progress.saveMissionScore('station4', _score);
        router.go('/station4/takeaway');
      },
    );
  }
}
