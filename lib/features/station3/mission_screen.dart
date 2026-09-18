import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/text_format.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station3_data.dart';
import '../../data/stations.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/widgets/voiceover_toggle.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';
import '../station/widgets/mission_cards.dart';
import 'procedure_order_activity.dart';
import 'instrument_match_activity.dart';
import 'moss_shoot_height_activity.dart';

class Station3MissionScreen extends StatefulWidget {
  const Station3MissionScreen({super.key});

  @override
  State<Station3MissionScreen> createState() => _Station3MissionScreenState();
}

class _Station3MissionScreenState extends State<Station3MissionScreen>
    with SingleTickerProviderStateMixin, RouteAware, AutoNarrateOnEnter {
  /// Story / Part I panel bounds — wide centered parchment (~78% × tall).
  static const _storyContentLeft = 0.11;
  static const _storyContentRight = 0.89;
  static const _storyContentTop = 0.28;
  static const _storyContentBottom = 0.92;

  /// Part I activity panel sits on the same parchment, slightly taller.
  static const _activityContentTop = 0.24;
  static const _activityContentBottom = 0.92;

  /// Mission 3 content panel on [kStation3Mission3BackgroundAsset].
  static const _mission3ContentLeft = 0.025;
  static const _mission3ContentRight = 0.975;
  static const _mission3ContentTop = 0.155;
  static const _mission3ContentBottom = 0.94;

  int _phase = 0; // 0 story, 1 order, 2 match, 3 mission3, 4 done
  bool _orderDone = false;
  bool _matchDone = false;
  bool _measureDone = false;
  int _score = 0;
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
  bool _showScrollHint = true;

  @override
  String? get autoNarrateText =>
      _phase == 0 ? stripReadingMarkup(kStation3MissionStory) : null;

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
      0 || 1 || 2 => kStation3MissionBackgroundAsset,
      3 => kStation3Mission3BackgroundAsset,
      _ => kStation3Mission3BackgroundAsset,
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
            cacheWidth: 1280,
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: switch (_phase) {
                  // Story/activity panels use full-canvas fractions aligned to BG.
                  0 => _story(),
                  1 => _order(),
                  2 => _match(),
                  3 => _mission3(),
                  _ => Padding(
                      padding: const EdgeInsets.fromLTRB(4, 72, 4, 4),
                      child: _done(),
                    ),
                },
              ),
              Positioned(
                left: 8,
                top: 8,
                right: 8,
                child: _topBar(context),
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
            onTap: () => context.go(stationHubRoute('station3')),
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

  /// Cream parchment panel matching the lab mission look (not the BG art).
  Widget _parchmentBox({required Widget child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: BioColors.bark.withValues(alpha: 0.55),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: child,
      ),
    );
  }

  Widget _story() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final boxLeft = w * _storyContentLeft;
        final boxW = w * (_storyContentRight - _storyContentLeft);
        final boxTop = h * _storyContentTop;
        final boxH = (h * _storyContentBottom - boxTop).clamp(120.0, h);

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: boxLeft,
              top: boxTop,
              width: boxW,
              height: boxH,
              child: _parchmentBox(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'MISSION STORY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: BioColors.forest,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 0, 4, 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: _storyContent(),
                                  ),
                                ),
                              ),
                              if (_showScrollHint) _scrollDownHint(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        label: 'Tap here to Start',
                        color: BioColors.forest,
                        fontSize: 20,
                        expand: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        onTap: () async {
                          await stopNarration(context);
                          if (mounted) setState(() => _phase = 1);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _storyContent() {
    const fontSize = 18.0;
    const bodyStyle = TextStyle(fontSize: fontSize, height: 1.4, color: BioColors.ink);

    return [
      _storyPart(
        icon: Icons.calendar_today,
        child: Text.rich(
          readingTextSpan(
            kStation3MissionStoryPart1,
            fontSize: fontSize,
            color: BioColors.ink,
          ),
          style: bodyStyle,
        ),
      ),
      _storyDivider(),
      _storyPart(
        icon: Icons.assignment,
        child: Text.rich(
          TextSpan(
            style: bodyStyle,
            children: [
              const TextSpan(
                text:
                    'The scientists discovered that several moss cultures were '
                    'growing differently, but the research records were ',
              ),
              TextSpan(
                text: 'incomplete',
                style: bodyStyle.copyWith(
                  color: BioColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(
                text: ' and some laboratory instruments were ',
              ),
              TextSpan(
                text: 'misplaced',
                style: bodyStyle.copyWith(
                  color: BioColors.danger,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(
                text:
                    '. Without accurate data, the investigation could not be '
                    'completed.',
              ),
            ],
          ),
        ),
      ),
      _storyDivider(),
      _storyPart(
        icon: Icons.person,
        child: Text.rich(
          TextSpan(
            style: bodyStyle,
            children: [
              TextSpan(
                children: readingTextSpan(
                  'Because of your research skills, you were selected to become a '
                  '**Junior Moss Investigator**. Your mission is to enter the '
                  'laboratory, organize the data collection procedure, use the '
                  'correct scientific instruments, and help the research team gather ',
                  fontSize: fontSize,
                  color: BioColors.ink,
                ).children,
              ),
              TextSpan(
                text: 'reliable evidence',
                style: bodyStyle.copyWith(
                  color: BioColors.deepSky,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(
                text: ' before the moss cultures are lost.',
              ),
            ],
          ),
        ),
      ),
      _storyDivider(),
      _storyPart(
        icon: Icons.emoji_events,
        child: Text.rich(
          TextSpan(
            style: bodyStyle,
            children: [
              const TextSpan(text: 'The success of the investigation now '),
              TextSpan(
                text: 'depends on you',
                style: bodyStyle.copyWith(
                  color: BioColors.correct,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      _yourMissionsPanel(fontSize),
    ];
  }

  Widget _storyPart({required IconData icon, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: BioColors.paleLeaf,
            shape: BoxShape.circle,
            border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
          ),
          child: Icon(icon, size: 18, color: BioColors.forest),
        ),
        const SizedBox(width: 10),
        Expanded(child: child),
      ],
    );
  }

  Widget _storyDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: BioColors.bark.withValues(alpha: 0.35),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.eco, size: 16, color: BioColors.moss),
          ),
          Expanded(
            child: Divider(
              color: BioColors.bark.withValues(alpha: 0.35),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _yourMissionsPanel(double fontSize) {
    const missionIcons = [
      Icons.search,
      Icons.science_outlined,
      Icons.edit_note,
      Icons.groups,
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BioColors.paleLeaf.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: BioColors.forest.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: BioColors.forest,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'YOUR MISSION:',
                style: TextStyle(
                  fontSize: fontSize + 1,
                  fontWeight: FontWeight.w900,
                  color: BioColors.forest,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < kStation3YourMissions.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(missionIcons[i], size: 20, color: BioColors.forest),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    kStation3YourMissions[i],
                    style: TextStyle(
                      fontSize: fontSize,
                      height: 1.35,
                      color: BioColors.ink,
                    ),
                  ),
                ),
              ],
            ),
            if (i < kStation3YourMissions.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
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

  Widget _activityPanel(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final panelLeft = w * _storyContentLeft;
        final panelW = w * (_storyContentRight - _storyContentLeft);
        final panelTop = h * _activityContentTop;
        final panelH = h * _activityContentBottom - panelTop;

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: panelLeft,
              top: panelTop,
              width: panelW,
              height: panelH,
              child: _parchmentBox(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _order() {
    return _activityPanel(
      ProcedureOrderActivity(
        onCompleted: () {
          if (!_orderDone) {
            setState(() {
              _orderDone = true;
              _score++;
            });
          }
        },
        onNext: () => setState(() => _phase = 2),
      ),
    );
  }

  Widget _match() {
    return _activityPanel(
      InstrumentMatchActivity(
        onCompleted: () {
          if (!_matchDone) {
            setState(() {
              _matchDone = true;
              _score++;
            });
          }
        },
        onNext: () => setState(() => _phase = 3),
      ),
    );
  }

  Widget _mission3Panel(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        final panelLeft = w * _mission3ContentLeft;
        final panelW = w * (_mission3ContentRight - _mission3ContentLeft);
        final panelTop = h * _mission3ContentTop;
        final panelH = h * _mission3ContentBottom - panelTop;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: panelLeft,
              top: panelTop,
              width: panelW,
              height: panelH,
              child: child,
            ),
          ],
        );
      },
    );
  }

  Widget _mission3() {
    return _mission3Panel(
      MossShootHeightActivity(
        onCompleted: () {
          if (!_measureDone) {
            setState(() {
              _measureDone = true;
              _score++;
            });
          }
        },
        onNext: () => setState(() => _phase = 4),
      ),
    );
  }

  Widget _done() {
    return MissionCompleteCard(
      score: _score,
      total: 3,
      message: _score == 3
          ? 'Excellent! You organized the procedure, matched every '
              'instrument, and measured each moss replicate accurately.'
          : 'Nice work! Review the procedure, instrument matches, and ruler '
              'readings, then continue.',
      onContinue: () async {
        final progress = context.read<ProgressService>();
        final router = GoRouter.of(context);
        await progress.saveMissionScore('station3', _score);
        router.go('/station3/takeaway');
      },
    );
  }
}
