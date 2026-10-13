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
import '../../data/station3_data.dart';
import '../../data/stations.dart';
import '../../models/explorer_avatar.dart';
import '../../services/auth_service.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';
import 'research_instruments_table.dart';

/// Station 3 Discovery Stop — guide avatar on the left and reading content in
/// the central parchment area (jar illustration inline between paragraphs).
class Station3DiscoveryScreen extends StatefulWidget {
  const Station3DiscoveryScreen({super.key});

  @override
  State<Station3DiscoveryScreen> createState() =>
      _Station3DiscoveryScreenState();
}

class _Station3DiscoveryScreenState extends State<Station3DiscoveryScreen>
    with RouteAware, AutoNarrateOnEnter {
  /// Background aspect and regions (fractions of the artwork) so the
  /// text and avatar stay on the same spot of the picture on any screen.
  static const double _artAspect = 3072 / 1376;
  static const Rect _textRegion = Rect.fromLTRB(0.325, 0.26, 0.69, 0.74);
  static const Rect _avatarRegion = Rect.fromLTRB(0.05, 0.3, 0.25, 0.9);
  static const double _textWidth =
      ArtworkOverlay.defaultDesignWidth * (0.69 - 0.325);

  @override
  String? get autoNarrateText => stripReadingMarkup(kStation3Content);

  @override
  bool get shouldAutoNarrate => true;

  void _onBack(BuildContext context) {
    stopNarration(context).then((_) {
      if (!context.mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/station/station3/splash');
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
            asset: kStation3DiscoveryBackgroundAsset,
            aspect: _artAspect,
            label: 'Discovery Stop',
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
                const Expanded(child: SizedBox.shrink()),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Center(
                      child: TrailButton(
                        label: 'Proceed',
                        icon: Icons.arrow_forward_rounded,
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
                              .markDiscoveryComplete('station3');
                          if (context.mounted) {
                            context.go(stationHubRoute('station3'));
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
                            kStation3Vocabulary,
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
    const fontSize = 22.0;
    const gap = 12.0;

    Text bodyText(String text) => Text.rich(
      readingTextSpan(
        text,
        fontSize: fontSize,
        color: BioColors.ink,
        indentFirstLine: true,
      ),
      style: const TextStyle(height: 1.4),
    );

    Widget jarIllustration() => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: SizedBox(
          width: maxWidth * 0.42,
          height: maxWidth * 0.55,
          child: GameImage(
            asset: kStation3JarAsset,
            label: 'In vitro moss jar',
            fit: BoxFit.contain,
            color: BioColors.moss,
            icon: Icons.science,
            cacheWidth: 512,
          ),
        ),
      ),
    );

    return [
      bodyText(kStation3DiscoveryPart1),
      const SizedBox(height: gap),
      jarIllustration(),
      const SizedBox(height: gap),
      bodyText(kStation3DiscoveryPart2),
      const SizedBox(height: gap),
      bodyText(kStation3DiscoveryPart3),
      const SizedBox(height: gap),
      bodyText(kStation3DiscoveryPart4),
      const SizedBox(height: gap),
      ResearchInstrumentsTable(fontSize: fontSize - 2),
      const SizedBox(height: gap),
      bodyText(kStation3DiscoveryPart5),
      const SizedBox(height: 8),
    ];
  }

  Widget _guideAvatar() {
    final id = context.watch<AuthService>().currentUser?.avatarId ?? 0;
    final explorer = ExplorerAvatar.fromId(id);
    return SlotFigure(asset: explorer.assetPath, label: explorer.label);
  }
}
