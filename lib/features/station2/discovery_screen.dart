import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/text_format.dart';
import '../../core/widgets/artwork_stage.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/trail_button.dart';
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
  /// Background aspect and regions (fractions of the artwork) so the
  /// text and avatar stay on the same spot of the picture on any screen.
  static const double _artAspect = 1024 / 458;
  static const Rect _textRegion = Rect.fromLTRB(0.29, 0.29, 0.73, 0.7);
  static const Rect _avatarRegion = Rect.fromLTRB(0.02, 0.16, 0.25, 0.94);
  static const double _textWidth =
      ArtworkOverlay.defaultDesignWidth * (0.73 - 0.29);

  static const _backgroundAsset = 'assets/images/discovery_stop.png';

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
          child: ArtworkBackdrop(
            asset: _backgroundAsset,
            aspect: _artAspect,
            label: 'Discovery Stop',
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
                const Expanded(child: SizedBox.shrink()),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Center(
                      child: TrailButton(
                        label: 'Proceed',
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
                    // A normal (non-positioned) child so the row grows to fit
                    // the whole button; overflowing parts don't receive taps.
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 48, bottom: 20),
                        child: WordQuestButton(
                          onTap: () => showWordQuestOverlay(
                            context,
                            kStation2Vocabulary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: ArtworkOverlay(
            aspect: _artAspect,
            slots: [
              ArtworkSlot(
                region: _avatarRegion,
                interactive: false,
                child: _guideAvatar(),
              ),
              ArtworkSlot(
                region: _textRegion,
                child: ClipRect(
                  child: ListView(
                    padding: const EdgeInsets.only(right: 4),
                    children: _discoveryContent(_textWidth),
                  ),
                ),
              ),
            ],
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
          child: _zoomableImage(asset: asset, label: label),
        ),
      ),
    );

    return [
      bodyText(kStation2DiscoveryPart1),
      const SizedBox(height: gap),
      bodyText(kStation2DiscoveryPart2),
      const SizedBox(height: gap),
      diagram(
        kStation2ElevationDiagramAsset,
        'Elevation zones diagram',
        684 / 1024,
      ),
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

  Widget _guideAvatar() {
    final id = context.watch<AuthService>().currentUser?.avatarId ?? 0;
    final explorer = ExplorerAvatar.fromId(id);
    return SlotFigure(asset: explorer.assetPath, label: explorer.label);
  }
}
