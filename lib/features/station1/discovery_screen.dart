import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/text_format.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/quiz_stimulus_table.dart';
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
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 36),
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
                      final textLeft = avatarW + w * 0.06;
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
                const SizedBox(height: 8),
                Center(
                  child: PrimaryButton(
                    label: 'Proceed',
                    color: BioColors.forest,
                    fontSize: 28,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
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
    const fontSize = 24.0;
    const gap = 10.0;
    const table = kStation1QuantitativeResearchTable;

    TextSpan body(String text) => readingTextSpan(
          text,
          fontSize: fontSize,
          color: BioColors.ink,
          indentFirstLine: true,
        );

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
        child: _zoomableMossDiagram(),
      ),
      const SizedBox(height: gap),
      bodyText(kStation1DiscoveryPart5),
      const SizedBox(height: gap),
      Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: width < 640 ? 780 : width,
            child: QuizStimulusTable(
              table: table,
              fontSize: 16,
              bodyTextAlign: TextAlign.left,
              boldFirstColumn: true,
            ),
          ),
        ),
      ),
      const SizedBox(height: 8),
    ];
  }

  Widget _zoomableMossDiagram() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _openMossZoom,
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            GameImage(
              asset: kStation1MossDiagramAsset,
              label: 'Structure of moss',
              fit: BoxFit.contain,
              color: BioColors.moss,
              icon: Icons.grass,
            ),
            Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.zoom_in_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMossZoom() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (dialogContext) {
        final size = MediaQuery.sizeOf(dialogContext);
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: SizedBox(
            width: size.width,
            height: size.height * 0.88,
            child: Stack(
              children: [
                Positioned.fill(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    child: Center(
                      child: GameImage(
                        asset: kStation1MossDiagramAsset,
                        label: 'Structure of moss',
                        fit: BoxFit.contain,
                        color: BioColors.moss,
                        icon: Icons.grass,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(dialogContext).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.close,
                          color: BioColors.forest,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
