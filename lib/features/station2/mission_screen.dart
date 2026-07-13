import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/text_format.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station2_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';
import 'population_sample_activity.dart';
import 'mountain_diversity_activity.dart';

class Station2MissionScreen extends StatefulWidget {
  const Station2MissionScreen({super.key});

  @override
  State<Station2MissionScreen> createState() => _Station2MissionScreenState();
}

class _Station2MissionScreenState extends State<Station2MissionScreen>
    with SingleTickerProviderStateMixin {
  static const _activityBackgroundAsset =
      'assets/images/backgrounds/mission_forest_bg.png';
  static const _yourMissionsAspect = 184 / 1024;

  /// Inner parchment text bounds on [kStation2MissionBackgroundAsset].
  static const _storyContentLeft = 0.355;
  static const _storyContentRight = 0.575;
  static const _storyContentTop = 0.27;
  static const _storyContentBottom = 0.68;

  int _phase = 0; // 0 story, 1 pop/sample, 2 diversity
  final _storyScrollCtrl = ScrollController();
  late final AnimationController _scrollHintCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _scrollHintBounce = Tween<double>(
    begin: 0,
    end: 10,
  ).animate(CurvedAnimation(
    parent: _scrollHintCtrl,
    curve: Curves.easeInOut,
  ));
  int _score = 0;
  bool _showScrollHint = true;

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
    final atBottom = _storyScrollCtrl.position.pixels >=
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
      0 => kStation2MissionBackgroundAsset,
      1 => kStation2PopulationSampleActivityBg,
      2 => kStation2MountainDiversityBg,
      _ => _activityBackgroundAsset,
    };
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
            padding: EdgeInsets.fromLTRB(4, 4, 4, _phase == 0 ? 10 : 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _topBar(context),
                SizedBox(height: _phase == 0 ? 12 : 6),
                Expanded(
                  child: switch (_phase) {
                    0 => _story(),
                    1 => PopulationSampleActivity(
                          onComplete: (cardScore) {
                            setState(() {
                              _score += cardScore;
                              _phase = 2;
                            });
                          },
                        ),
                    2 => MountainDiversityActivity(
                          onComplete: (activityScore) async {
                            final progress = context.read<ProgressService>();
                            final router = GoRouter.of(context);
                            final finalScore = _score + activityScore;
                            await progress.saveMissionScore(
                              'station2',
                              finalScore,
                            );
                            if (mounted) router.go('/station2/takeaway');
                          },
                        ),
                    _ => const SizedBox.shrink(),
                  },
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
            onTap: () => context.go(stationHubRoute('station2')),
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

        final textLeft = w * _storyContentLeft;
        final textW = w * (_storyContentRight - _storyContentLeft);
        final textTop = h * _storyContentTop;
        final textH = h * _storyContentBottom - textTop;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: textLeft,
              top: textTop,
              width: textW,
              height: textH,
              child: ClipRect(
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'MISSION STORY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: BioColors.forest,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
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
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text.rich(
                                    readingTextSpan(
                                      kStation2MissionStory,
                                      fontSize: 16,
                                      color: BioColors.ink,
                                    ),
                                    style: const TextStyle(height: 1.45),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: textW,
                                    height: textW * _yourMissionsAspect,
                                    child: GameImage(
                                      asset: kStation2YourMissionsAsset,
                                      label: 'Your missions',
                                      fit: BoxFit.contain,
                                      color: BioColors.moss,
                                      icon: Icons.assignment,
                                      cacheWidth: 1024,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_showScrollHint) _scrollDownHint(),
                        ],
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: textLeft,
              bottom: h * 0.08,
              width: textW,
              child: PrimaryButton(
                label: 'Tap here to Start',
                color: BioColors.forest,
                fontSize: 20,
                expand: true,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                onTap: () => setState(() => _phase = 1),
              ),
            ),
          ],
        );
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

}
