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
import '../../core/widgets/word_quest.dart';
import '../../data/station2_data.dart';
import '../../data/stations.dart';
import '../../models/explorer_avatar.dart';
import '../../services/auth_service.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';

/// Station 2 Discovery Stop — guide avatar on the left and moss sampling
/// reading content in the central parchment area (same layout as Station 1).
class Station2DiscoveryScreen extends StatefulWidget {
  const Station2DiscoveryScreen({super.key});

  @override
  State<Station2DiscoveryScreen> createState() =>
      _Station2DiscoveryScreenState();
}

class _Station2DiscoveryScreenState extends State<Station2DiscoveryScreen>
    with RouteAware, AutoNarrateOnEnter {
  static const _backgroundAsset = 'assets/images/discovery_stop.png';

  /// Inner parchment margins on [discovery_stop.png] (fractions of canvas size).
  static const _parchmentContentLeft = 0.32;
  static const _parchmentContentRight = 0.78;
  static const _parchmentContentTop = 0.15;
  static const _parchmentContentHeight = 0.53;

  @override
  String? get autoNarrateText => stripReadingMarkup(kStation2Content);

  @override
  bool get shouldAutoNarrate => true;

  void _onBack(BuildContext context) {
    stopNarration(context).then((_) {
      if (!context.mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/station/station2/splash');
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

                      final textLeft = w * _parchmentContentLeft;
                      final textW =
                          w * (_parchmentContentRight - _parchmentContentLeft);
                      final textTop = h * _parchmentContentTop;
                      final textH = h * _parchmentContentHeight;

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
                              clipBehavior: Clip.hardEdge,
                              child: ListView(
                                padding: const EdgeInsets.only(right: 4),
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Center(
                      child: PrimaryButton(
                        label: 'Proceed',
                        color: BioColors.forest,
                        fontSize: 34,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        onTap: () async {
                          await stopNarration(context);
                          if (!context.mounted) return;
                          await context
                              .read<ProgressService>()
                              .markDiscoveryComplete('station2');
                          if (context.mounted) {
                            context.go(stationHubRoute('station2'));
                          }
                        },
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: WordQuestButton(
                        onTap: () =>
                            showWordQuestOverlay(context, kStation2Vocabulary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _discoveryContent(double maxWidth) {
    const fontSize = 28.0;
    const gap = 10.0;

    Text bodyText(String text) => Text.rich(
          readingTextSpan(
            text,
            fontSize: fontSize,
            color: BioColors.ink,
            indentFirstLine: true,
          ),
          style: const TextStyle(height: 1.4),
        );

    Widget diagram(String asset, String label, double aspect) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SizedBox(
              width: maxWidth,
              height: maxWidth * aspect,
              child: _zoomableImage(
                asset: asset,
                label: label,
              ),
            ),
          ),
        );

    return [
      bodyText(kStation2DiscoveryPart1),
      const SizedBox(height: gap),
      bodyText(kStation2DiscoveryPart2),
      const SizedBox(height: gap),
      diagram(kStation2ElevationDiagramAsset, 'Elevation zones diagram', 684 / 1024),
      const SizedBox(height: gap),
      bodyText(kStation2DiscoveryPart3),
      const SizedBox(height: gap),
      bodyText(kStation2DiscoveryPart4),
      const SizedBox(height: gap),
      diagram(
        kStation2PopulationSampleDiagramAsset,
        'Population and sample diagram',
        699 / 1024,
      ),
      const SizedBox(height: gap),
      bodyText(kStation2DiscoveryPart5),
      const SizedBox(height: gap),
      bodyText(kStation2DiscoveryPart6),
      const SizedBox(height: gap),
      diagram(
        kStation2SamplingProceduresAsset,
        'Sampling procedures in moss studies',
        632 / 1024,
      ),
      const SizedBox(height: gap),
      bodyText(kStation2DiscoveryPart7),
      const SizedBox(height: 8),
    ];
  }

  Widget _zoomableImage({required String asset, required String label}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openImageZoom(asset: asset, label: label),
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned.fill(
              child: GameImage(
                asset: asset,
                label: label,
                fit: BoxFit.contain,
                color: BioColors.moss,
                icon: Icons.landscape,
                cacheWidth: 1024,
              ),
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

  void _openImageZoom({required String asset, required String label}) {
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
                        asset: asset,
                        label: label,
                        fit: BoxFit.contain,
                        color: BioColors.moss,
                        icon: Icons.landscape,
                        cacheWidth: 1600,
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
