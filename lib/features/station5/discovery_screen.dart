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
import '../../data/station5_data.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';
import 'discovery_zone_table.dart';

/// Station 5 Discovery Stop — reading content in the central panel artwork.
class Station5DiscoveryScreen extends StatefulWidget {
  const Station5DiscoveryScreen({super.key});

  @override
  State<Station5DiscoveryScreen> createState() =>
      _Station5DiscoveryScreenState();
}

class _Station5DiscoveryScreenState extends State<Station5DiscoveryScreen>
    with RouteAware, AutoNarrateOnEnter {
  /// Inner panel margins on [kStation5DiscoveryBackgroundAsset].
  static const _contentLeft = 0.305;
  static const _contentRight = 0.692;
  static const _contentTop = 0.165;
  static const _contentHeight = 0.59;

  @override
  String? get autoNarrateText => stripReadingMarkup(kStation5Content);

  @override
  bool get shouldAutoNarrate => true;

  void _onBack(BuildContext context) {
    stopNarration(context).then((_) {
      if (!context.mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/station/station5/splash');
      }
    });
  }

  Future<void> _goToResearchMission() async {
    await stopNarration(context);
    if (!mounted) return;
    await context.read<ProgressService>().markDiscoveryComplete('station5');
    if (!mounted) return;
    context.go('/station5/mission');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: kStation5DiscoveryBackgroundAsset,
            label: 'Discovery Stop',
            fit: BoxFit.cover,
            color: BioColors.forest,
            icon: Icons.landscape,
            cacheWidth: 1280,
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
                      final textLeft = w * _contentLeft;
                      final textW = w * (_contentRight - _contentLeft);
                      final textTop = h * _contentTop;
                      final textH = h * _contentHeight;

                      return Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Positioned(
                            left: textLeft,
                            top: textTop,
                            width: textW,
                            height: textH,
                            child: ClipRect(
                              clipBehavior: Clip.hardEdge,
                              child: ListView(
                                padding: const EdgeInsets.fromLTRB(6, 4, 18, 6),
                                children: [
                                  ..._discoveryContent(textW),
                                  const SizedBox(height: 12),
                                  Center(
                                    child: PrimaryButton(
                                      label: 'Go to Research Mission',
                                      icon: Icons.science,
                                      color: BioColors.sun,
                                      fontSize: 16,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 12,
                                      ),
                                      onTap: _goToResearchMission,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
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

  List<Widget> _discoveryContent(double maxWidth) {
    const fontSize = 15.5;
    const tableFontSize = 10.5;
    const gap = 8.0;

    Text bodyText(String text) => Text.rich(
          readingTextSpan(text, fontSize: fontSize, color: BioColors.ink),
          style: const TextStyle(height: 1.35),
        );

    Text noteText(String text) => Text(
          text,
          style: TextStyle(
            fontSize: fontSize - 1.5,
            height: 1.35,
            color: BioColors.ink.withValues(alpha: 0.85),
            fontStyle: FontStyle.italic,
          ),
        );

    Widget kirbyBauerSection() => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: bodyText(kStation5DiscoveryPart2)),
            const SizedBox(width: 8),
            SizedBox(
              width: maxWidth * 0.32,
              child: GameImage(
                asset: kStation5DiscoveryContentImageAsset,
                label: 'Kirby-Bauer disk diffusion',
                fit: BoxFit.contain,
                color: BioColors.moss,
                icon: Icons.biotech,
                cacheWidth: 480,
              ),
            ),
          ],
        );

    Widget barGraphImage() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: GameImage(
            asset: kStation5DiscoveryGraphicalAsset,
            label: 'Graphical presentation of antibacterial activity',
            fit: BoxFit.fitWidth,
            color: BioColors.moss,
            icon: Icons.bar_chart,
            cacheWidth: 960,
          ),
        );

    return [
      bodyText(kStation5DiscoveryPart1),
      const SizedBox(height: gap),
      kirbyBauerSection(),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryPart3),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryStepsIntro),
      const SizedBox(height: gap),
      Text(
        kStation5DiscoverySampleIntro,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.35,
          color: BioColors.ink.withValues(alpha: 0.9),
          fontStyle: FontStyle.italic,
        ),
      ),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoverySampleContinuation),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryDetailStep1),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryDetailStep2),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryDetailStep3Intro),
      const SizedBox(height: 6),
      DiscoveryZoneTable(
        headers: kStation5DiscoveryReplicateHeaders,
        rows: kStation5DiscoveryRawZoneRows,
        fontSize: tableFontSize,
      ),
      const SizedBox(height: 6),
      noteText(kStation5DiscoveryDetailStep3Note),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryDetailStep4Intro),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryDetailStep4Tools),
      const SizedBox(height: 6),
      DiscoveryZoneTable(
        headers: kStation5DiscoveryMeanHeaders,
        rows: kStation5DiscoveryMeanZoneRows,
        fontSize: tableFontSize,
      ),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryMeanFormula),
      const SizedBox(height: 6),
      barGraphImage(),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryDetailStep5),
      const SizedBox(height: gap),
      bodyText(kStation5DiscoveryDetailStep6),
    ];
  }
}
