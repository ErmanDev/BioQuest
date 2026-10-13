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
import '../../data/station4_data.dart';
import '../../data/stations.dart';
import '../../models/explorer_avatar.dart';
import '../../services/auth_service.dart';
import '../../services/narration_helper.dart';
import '../../services/progress_service.dart';
import 'phytochemical_table.dart';
import 'moss_screening_example.dart';

/// Station 4 Discovery Stop — guide avatar and phytochemical reading content.
class Station4DiscoveryScreen extends StatefulWidget {
  const Station4DiscoveryScreen({super.key});

  @override
  State<Station4DiscoveryScreen> createState() =>
      _Station4DiscoveryScreenState();
}

class _Station4DiscoveryScreenState extends State<Station4DiscoveryScreen>
    with RouteAware, AutoNarrateOnEnter {
  /// Background aspect and regions (fractions of the artwork) so the
  /// text and avatar stay on the same spot of the picture on any screen.
  static const double _artAspect = 3072 / 1376;
  static const Rect _textRegion = Rect.fromLTRB(0.325, 0.23, 0.69, 0.78);
  static const Rect _avatarRegion = Rect.fromLTRB(0.05, 0.16, 0.27, 0.86);
  static const double _textWidth =
      ArtworkOverlay.defaultDesignWidth * (0.69 - 0.325);

  @override
  String? get autoNarrateText => stripReadingMarkup(kStation4Content);

  @override
  bool get shouldAutoNarrate => true;

  void _onBack(BuildContext context) {
    stopNarration(context).then((_) {
      if (!context.mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/station/station4/splash');
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
            asset: kStation4DiscoveryBackgroundAsset,
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
                              .markDiscoveryComplete('station4');
                          if (context.mounted) {
                            context.go(stationHubRoute('station4'));
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
                            kStation4Vocabulary,
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
                    padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
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
    const fontSize = 13.0;
    const gap = 7.0;

    Text bodyText(String text) => Text.rich(
      readingTextSpan(
        text,
        fontSize: fontSize,
        color: BioColors.ink,
        indentFirstLine: true,
      ),
      style: const TextStyle(height: 1.35),
    );

    Text smallText(String text) => Text(
      text,
      style: TextStyle(
        fontSize: fontSize - 2,
        height: 1.3,
        color: BioColors.ink.withValues(alpha: 0.85),
        fontStyle: FontStyle.italic,
      ),
    );

    Widget formsTableImage() => SizedBox(
      width: maxWidth,
      child: GameImage(
        asset: kStation4DiscoveryFormsTableAsset,
        label: 'Tabular and graphical forms',
        fit: BoxFit.fitWidth,
        color: BioColors.moss,
        icon: Icons.table_chart,
        cacheWidth: 960,
      ),
    );

    return [
      bodyText(kStation4DiscoveryPart1),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryPart2),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryTableIntro),
      const SizedBox(height: 6),
      const PhytochemicalTable(fontSize: 10.5),
      const SizedBox(height: 6),
      smallText(kStation4DiscoveryTableSource),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryPart3),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryPart4),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryPart5),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryFormsIntro),
      const SizedBox(height: 6),
      formsTableImage(),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryPart6),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryPart7),
      const SizedBox(height: 6),
      const MossScreeningDataTable(fontSize: 10),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryPart8),
      const SizedBox(height: 6),
      MossScreeningBarChart(width: maxWidth, fontSize: 9.5),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryPart9),
      const SizedBox(height: gap),
      bodyText(kStation4DiscoveryPart10),
      const SizedBox(height: 8),
    ];
  }

  Widget _guideAvatar() {
    final id = context.watch<AuthService>().currentUser?.avatarId ?? 0;
    final explorer = ExplorerAvatar.fromId(id);
    return SlotFigure(asset: explorer.assetPath, label: explorer.label);
  }
}
