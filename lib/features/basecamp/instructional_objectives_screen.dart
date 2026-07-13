import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/narration_control.dart';
import '../../data/basecamp_data.dart';
import '../../models/explorer_avatar.dart';
import '../../services/auth_service.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';

/// Instructional Objectives — three-column layout with avatar (no target
/// competencies sidebar).
class InstructionalObjectivesScreen extends StatefulWidget {
  const InstructionalObjectivesScreen({super.key});

  @override
  State<InstructionalObjectivesScreen> createState() =>
      _InstructionalObjectivesScreenState();
}

class _InstructionalObjectivesScreenState
    extends State<InstructionalObjectivesScreen>
    with RouteAware, AutoNarrateOnEnter {
  static const _columnIcons = [
    Icons.auto_stories_rounded,
    Icons.biotech_rounded,
    Icons.volunteer_activism_rounded,
  ];

  static const _columnColors = [
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFF6A1B9A),
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
    kObjectivesIntro,
    ...kInstructionalObjectiveColumns.expand(
      (column) => [
        column.title,
        ...column.items,
      ],
    ),
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
    if (!progress.hasTakenPretest && !progress.hasReadInstructions) {
      context.go('/basecamp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BioScaffold(
      title: 'Instructional Objectives',
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
              .markOrientationRead(kOrientationObjectivesKey);
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
          final cardMaxW = constraints.maxWidth * 0.68;
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
                  child: _objectivesCard(),
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

  Widget _objectivesCard() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _cardHeader(),
          const SizedBox(height: 10),
          _leafDivider(),
          const SizedBox(height: 12),
          _introBanner(),
          const SizedBox(height: 14),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0;
                        i < kInstructionalObjectiveColumns.length;
                        i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      Expanded(
                        child: _objectiveColumn(
                          title: kInstructionalObjectiveColumns[i].title,
                          items: kInstructionalObjectiveColumns[i].items,
                          icon: _columnIcons[i],
                          color: _columnColors[i],
                        ),
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
        const Text('INSTRUCTIONAL OBJECTIVES', style: titleStyle),
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

  Widget _introBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: BioColors.forest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        kObjectivesIntro,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1.35,
        ),
      ),
    );
  }

  Widget _objectiveColumn({
    required String title,
    required List<String> items,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.3,
                height: 1.25,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  _objectiveItem(items[i]),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _objectiveItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.circle, size: 7, color: BioColors.ink),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SelectableText(
            text,
            style: const TextStyle(
              fontSize: _bodyFontSize,
              height: 1.45,
              color: BioColors.ink,
            ),
          ),
        ),
      ],
    );
  }
}
