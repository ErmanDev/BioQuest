import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/text_format.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/voiceover_toggle.dart';
import '../../data/station1_data.dart';
import '../../data/stations.dart';
import '../../models/explorer_avatar.dart';
import '../../services/auth_service.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';

/// Station 1 Discovery Stop — full artwork background with guide avatar
/// on the left and moss reading content in the central parchment area.
class Station1DiscoveryScreen extends StatefulWidget {
  const Station1DiscoveryScreen({super.key});

  @override
  State<Station1DiscoveryScreen> createState() =>
      _Station1DiscoveryScreenState();
}

class _Station1DiscoveryScreenState extends State<Station1DiscoveryScreen>
    with RouteAware, AutoNarrateOnEnter {
  static const _backgroundAsset =
      'assets/images/backgrounds/discovery_stop.png';

  @override
  String? get autoNarrateText => stripReadingMarkup(kStation1Content);

  @override
  bool get shouldAutoNarrate => true;

  void _onBack(BuildContext context) {
    stopNarration(context).then((_) {
      if (!context.mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/station/station1');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: _backgroundAsset,
            label: 'Discovery Stop',
            fit: BoxFit.cover,
            color: BioColors.forest,
            icon: Icons.landscape,
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _onBack(context),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.arrow_back,
                            color: BioColors.forest,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const VoiceoverToggle(),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      final avatarW = w * 0.24;
                      const avatarScale = 1.75;

                      // Parchment text bounds (aligned to reference red lines).
                      final textLeft = avatarW + w * 0.008;
                      final textW = w * 0.47;
                      final textTop = h * 0.16;
                      final textH = h * 0.50;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 0,
                            bottom: 0,
                            width: avatarW,
                            child: _guideAvatar(avatarW, avatarScale),
                          ),
                          Positioned(
                            left: textLeft,
                            top: textTop,
                            width: textW,
                            height: textH,
                            child: ClipRect(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: _discoveryContent(textW),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Center(
                  child: PrimaryButton(
                    label: 'Proceed',
                    icon: Icons.arrow_forward_rounded,
                    color: BioColors.forest,
                    fontSize: 22,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    onTap: () async {
                      await stopNarration(context);
                      if (!context.mounted) return;
                      await context
                          .read<ProgressService>()
                          .markDiscoveryComplete('station1');
                      if (context.mounted) {
                        context.go(stationHubRoute('station1'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _discoveryContent(double width) {
    const fontSize = 18.0;
    const gap = 10.0;
    const table = kStation1QuantitativeResearchTable;

    TextSpan body(String text) =>
        readingTextSpan(text, fontSize: fontSize, color: BioColors.ink);

    Text bodyText(String text) => Text.rich(
          body(text),
          style: const TextStyle(height: 1.45),
        );

    return [
      bodyText(kStation1DiscoveryPart1),
      const SizedBox(height: gap),
      bodyText(kStation1DiscoveryPart2),
      const SizedBox(height: gap),
      bodyText(kStation1DiscoveryPart3),
      const SizedBox(height: gap),
      bodyText(kStation1DiscoveryPart4),
      const SizedBox(height: gap),
      Center(
        child: GameImage(
          asset: kStation1MossDiagramAsset,
          label: 'Structure of moss',
          fit: BoxFit.contain,
          color: BioColors.moss,
          icon: Icons.grass,
        ),
      ),
      const SizedBox(height: gap),
      bodyText(kStation1DiscoveryPart5),
      const SizedBox(height: gap),
      for (var i = 0; i < table.rows.length; i++) ...[
        _researchTypeCard(
          title: table.rows[i][0],
          description: table.rows[i][1],
          question: table.rows[i][2],
          whenToUse: table.rows[i][3],
          samples: table.rows[i][4],
          fontSize: fontSize - 2,
        ),
        if (i < table.rows.length - 1) const SizedBox(height: 8),
      ],
      const SizedBox(height: 8),
    ];
  }

  Widget _researchTypeCard({
    required String title,
    required String description,
    required String question,
    required String whenToUse,
    required String samples,
    required double fontSize,
  }) {
    Widget label(String text) => Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: BioColors.forest,
          ),
        );

    Widget value(String text) => Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            height: 1.35,
            color: BioColors.ink,
          ),
        );

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize + 1,
              fontWeight: FontWeight.w900,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 6),
          label('Description'),
          value(description),
          const SizedBox(height: 4),
          label('Key Question'),
          value(question),
          const SizedBox(height: 4),
          label('When to use'),
          value(whenToUse),
          const SizedBox(height: 4),
          label('Sample Studies'),
          value(samples),
        ],
      ),
    );
  }

  Widget _guideAvatar(double width, double scale) {
    final id = context.watch<AuthService>().currentUser?.avatarId ?? 0;
    final explorer = ExplorerAvatar.fromId(id);
    final height = width * scale;
    return SizedBox(
      width: width,
      height: height,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: OverflowBox(
          alignment: Alignment.bottomCenter,
          maxHeight: height,
          minHeight: height,
          maxWidth: height,
          child: SizedBox(
            height: height,
            child: GameImage(
              asset: explorer.assetPath,
              label: explorer.label,
              color: BioColors.moss,
              fit: BoxFit.fitHeight,
              icon: Icons.emoji_people,
              cacheWidth: (height * 2).round(),
            ),
          ),
        ),
      ),
    );
  }
}
