import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/widgets/avatar_speech_bubble.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/guide_hint.dart';
import '../../core/widgets/narration_control.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/basecamp_data.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';

class BasecampScreen extends StatefulWidget {
  /// When true, opened from the Expedition Map — skip the entrance tap and
  /// offer a return-to-map button instead of the pretest.
  final bool fromMap;
  const BasecampScreen({super.key, this.fromMap = false});

  @override
  State<BasecampScreen> createState() => _BasecampScreenState();
}

class _BasecampScreenState extends State<BasecampScreen>
    with SingleTickerProviderStateMixin, RouteAware, AutoNarrateOnEnter {
  late bool _entered = widget.fromMap;
  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  static const _speechShadow = [
    BoxShadow(color: Color(0x33000000), blurRadius: 18, offset: Offset(0, 6)),
  ];

  @override
  String? get autoNarrateText {
    if (!_entered) return null;
    return _orientationSpeechText(context.read<ProgressService>());
  }

  @override
  bool get shouldAutoNarrate => _entered;

  String _orientationSpeechText(ProgressService progress) {
    if (!widget.fromMap && progress.orientationComplete) {
      return kBasecampReady;
    }
    return kBasecampWelcome;
  }

  @override
  void didPopNext() {
    if (mounted) setState(() {});
    super.didPopNext();
  }

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  Future<void> _enter() async {
    setState(() => _entered = true);
    scheduleAutoNarrate();
  }

  @override
  Widget build(BuildContext context) {
    return BioScaffold(
      backgroundAsset: 'assets/images/backgrounds/basecamp_bg.jpg',
      backgroundLabel: 'Basecamp',
      fullBleedBackground: true,
      backgroundOpacity: 0.62,
      scrimOpacity: 0.32,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      body: _entered ? _orientation(context) : _entrance(),
    );
  }

  Widget _entrance() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _bob,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, -10 * _bob.value),
              child: child,
            ),
            child: const Icon(Icons.south, color: BioColors.sun, size: 64),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _enter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 28),
              decoration: BoxDecoration(
                color: BioColors.bark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BioColors.sun, width: 4),
                boxShadow: _speechShadow,
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cabin, color: Colors.white, size: 64),
                  SizedBox(height: 6),
                  Text(
                    'BASECAMP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: BioColors.parchment.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _speechShadow,
            ),
            child: const Text(
              'Tap the Basecamp to begin your mission!',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orientationHeader(ProgressService progress) {
    final speechText = _orientationSpeechText(progress);
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: BioColors.parchment.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: BioColors.forest.withValues(alpha: 0.35),
              ),
              boxShadow: _speechShadow,
            ),
            child: const Text(
              'Basecamp: The Mission Orientation',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: BioColors.forest,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        NarrationControl(text: speechText),
      ],
    );
  }

  Widget _orientation(BuildContext context) {
    final progress = context.watch<ProgressService>();
    final sequential = !widget.fromMap && !progress.hasTakenPretest;
    final canProceedToPretest = widget.fromMap || progress.orientationComplete;

    final showOverviewGuide = sequential && !progress.hasReadOverview;
    final showInstructionsGuide =
        sequential && progress.hasReadOverview && !progress.hasReadInstructions;
    final showObjectivesGuide =
        sequential &&
        progress.hasReadInstructions &&
        !progress.hasReadObjectives;
    final showPretestGuide = sequential && progress.orientationComplete;

    final speechText = _orientationSpeechText(progress);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _orientationHeader(progress),
        const SizedBox(height: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalH = constraints.maxHeight;
              final totalW = constraints.maxWidth;
              // Size against the flex area (not the full screen) so the CTA
              // row below never pushes past the bottom.
              const ctaReserve = 100.0;
              final bodyH = (totalH - ctaReserve).clamp(100.0, totalH);
              final avatarSize = bodyH * 0.42;
              const avatarScale = 1.75;
              const menuWidth = 220.0;
              final speechMaxWidth =
                  (totalW - avatarSize - menuWidth - 56).clamp(260.0, 500.0);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AvatarSpeechBubble(
                                key: ValueKey(speechText),
                                text: speechText,
                                avatarSize: avatarSize,
                                avatarScale: avatarScale,
                                alignSpeechTop: true,
                                centerContent: true,
                                avatarOffsetY: 22,
                                speechMaxWidth: speechMaxWidth,
                                fontSize: 24,
                                speechBackground:
                                    BioColors.parchment.withValues(
                                  alpha: 0.94,
                                ),
                                speechBorderColor: BioColors.forest
                                    .withValues(alpha: 0.35),
                                speechBorderWidth: 1.5,
                                speechShadow: _speechShadow,
                              ),
                              const SizedBox(width: 16),
                              _menuPanel(
                                context,
                                buttonWidth: menuWidth,
                                progress: progress,
                                sequential: sequential,
                                showOverviewGuide: showOverviewGuide,
                                showInstructionsGuide: showInstructionsGuide,
                                showObjectivesGuide: showObjectivesGuide,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: GuideHint(
                        enabled: showPretestGuide,
                        label: 'Take the Pretest next',
                        child: PrimaryButton(
                          label: widget.fromMap
                              ? 'Back to Expedition Map'
                              : 'Proceed to Pretest',
                          icon: widget.fromMap
                              ? Icons.map
                              : Icons.arrow_forward,
                          color: BioColors.sun,
                          fontSize: 25,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                            vertical: 13,
                          ),
                          onTap: canProceedToPretest
                              ? () => context.go(
                                  widget.fromMap ? '/map' : '/pretest',
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _menuPanel(
    BuildContext context, {
    required double buttonWidth,
    required ProgressService progress,
    required bool sequential,
    required bool showOverviewGuide,
    required bool showInstructionsGuide,
    required bool showObjectivesGuide,
  }) {
    const gap = 12.0;

    final instructionsEnabled = !sequential || progress.hasReadOverview;
    final objectivesEnabled = !sequential || progress.hasReadInstructions;

    Widget menuItem({
      required String label,
      required IconData icon,
      required bool enabled,
      required bool completed,
      required bool showGuide,
      required String guideLabel,
      required Future<void> Function()? onTap,
    }) {
      final button = _menuButton(
        label: label,
        icon: icon,
        enabled: enabled,
        completed: completed,
        width: buttonWidth,
        onTap: onTap,
      );
      if (!showGuide) return button;
      return GuideHint(enabled: true, label: guideLabel, child: button);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          menuItem(
            label: 'Short Overview',
            icon: Icons.auto_stories_rounded,
            enabled: true,
            completed: progress.hasReadOverview,
            showGuide: showOverviewGuide,
            guideLabel: 'Read this first',
            onTap: () =>
                pushAfterStoppingNarration(context, '/basecamp/overview'),
          ),
          const SizedBox(height: gap),
          menuItem(
            label: 'General Instructions',
            icon: Icons.article_rounded,
            enabled: instructionsEnabled,
            completed: progress.hasReadInstructions,
            showGuide: showInstructionsGuide,
            guideLabel: 'Read this next',
            onTap: instructionsEnabled
                ? () => pushAfterStoppingNarration(
                    context,
                    '/basecamp/instructions',
                  )
                : null,
          ),
          const SizedBox(height: gap),
          menuItem(
            label: 'Instructional Objectives',
            icon: Icons.flag_rounded,
            enabled: objectivesEnabled,
            completed: progress.hasReadObjectives,
            showGuide: showObjectivesGuide,
            guideLabel: 'Read this next',
            onTap: objectivesEnabled
                ? () => pushAfterStoppingNarration(
                    context,
                    '/basecamp/objectives',
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _menuButton({
    required String label,
    required IconData icon,
    required bool enabled,
    required double width,
    bool completed = false,
    required Future<void> Function()? onTap,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled && onTap != null ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: enabled
                    ? const [BioColors.forest, Color(0xFF2E7D32)]
                    : [
                        BioColors.bark.withValues(alpha: 0.55),
                        BioColors.bark.withValues(alpha: 0.45),
                      ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: enabled
                  ? const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      icon,
                      color: enabled ? BioColors.sun : Colors.white54,
                      size: 30,
                    ),
                    if (!enabled)
                      const Positioned(
                        right: -10,
                        top: -6,
                        child: Icon(Icons.lock, size: 16, color: Colors.white70),
                      ),
                    if (completed)
                      const Positioned(
                        right: -10,
                        top: -6,
                        child: Icon(
                          Icons.check_circle,
                          size: 16,
                          color: BioColors.correct,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: enabled ? Colors.white : Colors.white60,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
