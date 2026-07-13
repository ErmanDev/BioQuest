import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/text_format.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/narration_control.dart';
import '../../data/basecamp_data.dart';
import '../../models/explorer_avatar.dart';
import '../../services/auth_service.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';

/// General Instructions — structured layout with avatar and subparts flow.
class GeneralInstructionsScreen extends StatefulWidget {
  const GeneralInstructionsScreen({super.key});

  @override
  State<GeneralInstructionsScreen> createState() =>
      _GeneralInstructionsScreenState();
}

class _GeneralInstructionsScreenState extends State<GeneralInstructionsScreen>
    with RouteAware, AutoNarrateOnEnter {
  static const _subpartIcons = [
    Icons.auto_stories_rounded,
    Icons.backpack_rounded,
    Icons.fact_check_rounded,
  ];

  static const _ruleIcons = [
    Icons.check_circle_rounded,
    Icons.star_rounded,
  ];

  static const _bodyFontSize = 23.0;
  static const _cardShadow = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16,
      offset: Offset(0, 5),
    ),
  ];

  String get _narrationText => [
    stripReadingMarkup(kGeneralInstructionsIntro),
    'In every station, you must complete the following three subparts.',
    ...kGeneralInstructionsSubparts.map(
      (s) => '${s.title}. ${stripReadingMarkup(s.text)}',
    ),
    ...kGeneralInstructionsRules.map((r) => stripReadingMarkup(r.text)),
  ].join(' ');

  @override
  String? get autoNarrateText => _narrationText;

  @override
  bool get shouldAutoNarrate => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _guardAccess());
  }

  void _guardAccess() {
    if (!mounted) return;
    final progress = context.read<ProgressService>();
    if (!progress.hasTakenPretest && !progress.hasReadOverview) {
      context.go('/basecamp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BioScaffold(
      title: 'General Instructions',
      backgroundAsset: 'assets/images/backgrounds/short_overview_bg.png',
      backgroundLabel: 'Orientation trail',
      fullBleedBackground: true,
      backgroundOpacity: 0.72,
      scrimOpacity: 0.22,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      onBack: () {
        stopNarration(context).then((_) async {
          if (!context.mounted) return;
          await context
              .read<ProgressService>()
              .markOrientationRead(kOrientationInstructionsKey);
          if (!context.mounted) return;
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/basecamp');
          }
        });
      },
      actions: [NarrationControl(text: _narrationText)],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final avatarSize = constraints.maxHeight * 0.52;
          const avatarScale = 1.75;
          final cardMaxW = constraints.maxWidth * 0.58;
          final cardMaxH = constraints.maxHeight * 0.88;

          return Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _guideAvatar(avatarSize, avatarScale),
                const SizedBox(width: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: cardMaxW,
                    maxHeight: cardMaxH,
                  ),
                  child: _mainPanel(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _guideAvatar(double size, double scale) {
    final id = context.watch<AuthService>().currentUser?.avatarId ?? 0;
    final explorer = ExplorerAvatar.fromId(id);
    return SizedBox(
      width: size,
      height: size * scale,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: OverflowBox(
          alignment: Alignment.bottomCenter,
          maxHeight: size * scale,
          minHeight: size * scale,
          maxWidth: size * scale,
          child: SizedBox(
            height: size * scale,
            child: GameImage(
              asset: explorer.assetPath,
              label: explorer.label,
              color: BioColors.moss,
              fit: BoxFit.fitHeight,
              icon: Icons.emoji_people,
              cacheWidth: (size * scale * 2).round(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _parchmentCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: BioColors.forest.withValues(alpha: 0.35),
          width: 2,
        ),
        boxShadow: _cardShadow,
      ),
      child: child,
    );
  }

  Widget _mainPanel() {
    return _parchmentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _panelHeader('GENERAL INSTRUCTIONS'),
          const SizedBox(height: 10),
          _leafDivider(),
          const SizedBox(height: 12),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SelectableText.rich(
                      readingTextSpan(
                        kGeneralInstructionsIntro,
                        fontSize: _bodyFontSize,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _subpartsBanner(),
                    const SizedBox(height: 14),
                    _subpartsFlow(),
                    const SizedBox(height: 16),
                    _leafDivider(),
                    const SizedBox(height: 14),
                    for (var i = 0; i < kGeneralInstructionsRules.length; i++) ...[
                      if (i > 0) const SizedBox(height: 12),
                      _ruleRow(
                        icon: _ruleIcons[i],
                        text: kGeneralInstructionsRules[i].text,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panelHeader(String title) {
    const titleStyle = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: BioColors.forest,
      letterSpacing: 1.1,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.eco, size: 16, color: BioColors.moss.withValues(alpha: 0.85)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: titleStyle,
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.eco, size: 16, color: BioColors.moss.withValues(alpha: 0.85)),
      ],
    );
  }

  Widget _leafDivider() {
    final lineColor = BioColors.moss.withValues(alpha: 0.45);
    return Row(
      children: [
        Expanded(child: Divider(color: lineColor, thickness: 1, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.eco, size: 14, color: BioColors.moss),
        ),
        Expanded(child: Divider(color: lineColor, thickness: 1, height: 1)),
      ],
    );
  }

  Widget _subpartsBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: BioColors.forest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'IN EVERY STATION, YOU MUST COMPLETE THE FOLLOWING THREE SUBPARTS:',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.35,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _subpartsFlow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < kGeneralInstructionsSubparts.length; i++) ...[
          if (i > 0)
            Padding(
              padding: const EdgeInsets.only(top: 36, left: 4, right: 4),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: BioColors.moss.withValues(alpha: 0.8),
                size: 22,
              ),
            ),
          Expanded(
            child: _subpartCard(
              icon: _subpartIcons[i],
              title: kGeneralInstructionsSubparts[i].title,
              text: kGeneralInstructionsSubparts[i].text,
            ),
          ),
        ],
      ],
    );
  }

  Widget _subpartCard({
    required IconData icon,
    required String title,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: BioColors.sand.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: BioColors.forest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: BioColors.forest,
              letterSpacing: 0.4,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              height: 1.35,
              color: BioColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ruleRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: BioColors.forest.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
          ),
          child: Icon(icon, color: BioColors.forest, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SelectableText.rich(
            readingTextSpan(
              text,
              fontSize: _bodyFontSize,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
