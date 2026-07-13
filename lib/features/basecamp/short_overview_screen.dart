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

/// Short Overview — parchment card with three icon rows and a guide avatar.
class ShortOverviewScreen extends StatefulWidget {
  const ShortOverviewScreen({super.key});

  @override
  State<ShortOverviewScreen> createState() => _ShortOverviewScreenState();
}

class _ShortOverviewScreenState extends State<ShortOverviewScreen>
    with RouteAware, AutoNarrateOnEnter {
  static const _sectionIcons = [
    Icons.auto_stories_rounded,
    Icons.biotech_rounded,
    Icons.groups_rounded,
  ];

  static const _cardShadow = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16,
      offset: Offset(0, 5),
    ),
  ];

  String get _narrationText => kShortOverviewSections
      .map((s) => stripReadingMarkup(s.text))
      .join(' ');

  @override
  String? get autoNarrateText => _narrationText;

  @override
  bool get shouldAutoNarrate => true;

  @override
  Widget build(BuildContext context) {
    return BioScaffold(
      title: 'Short Overview',
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
              .markOrientationRead(kOrientationOverviewKey);
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
          final cardMaxW = constraints.maxWidth * 0.52;
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
                  child: _overviewCard(),
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

  Widget _overviewCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: BioColors.forest.withValues(alpha: 0.35),
          width: 2,
        ),
        boxShadow: _cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _cardHeader(),
          const SizedBox(height: 10),
          _leafDivider(),
          const SizedBox(height: 12),
          Flexible(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < kShortOverviewSections.length; i++) ...[
                      if (i > 0) ...[
                        const SizedBox(height: 12),
                        _leafDivider(),
                        const SizedBox(height: 12),
                      ],
                      _overviewRow(
                        icon: _sectionIcons[i],
                        text: kShortOverviewSections[i].text,
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

  Widget _cardHeader() {
    const titleStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w900,
      color: BioColors.forest,
      letterSpacing: 1.4,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.eco, size: 18, color: BioColors.moss.withValues(alpha: 0.85)),
        const SizedBox(width: 10),
        const Text('SHORT OVERVIEW', style: titleStyle),
        const SizedBox(width: 10),
        Icon(Icons.eco, size: 18, color: BioColors.moss.withValues(alpha: 0.85)),
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

  Widget _overviewRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: BioColors.forest,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SelectableText.rich(
            readingTextSpan(
              text,
              fontSize: 23,
              height: 1.5,
              color: BioColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
