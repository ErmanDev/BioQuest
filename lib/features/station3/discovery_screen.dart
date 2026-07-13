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
  /// Inner parchment margins on [kStation3DiscoveryBackgroundAsset].
  static const _parchmentContentLeft = 0.288;
  static const _parchmentContentRight = 0.680;
  static const _parchmentContentTop = 0.20;
  static const _parchmentContentHeight = 0.55;

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
          child: GameImage(
            asset: kStation3DiscoveryBackgroundAsset,
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
                          .markDiscoveryComplete('station3');
                      if (context.mounted) {
                        context.go(stationHubRoute('station3'));
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

  List<Widget> _discoveryContent(double maxWidth) {
    const fontSize = 16.5;
    const gap = 10.0;

    Text bodyText(String text) => Text.rich(
          readingTextSpan(text, fontSize: fontSize, color: BioColors.ink),
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
      ResearchInstrumentsTable(fontSize: fontSize - 1.5),
      const SizedBox(height: gap),
      bodyText(kStation3DiscoveryPart5),
      const SizedBox(height: 8),
    ];
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
