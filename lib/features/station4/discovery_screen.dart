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
  /// Inner parchment margins on [kStation4DiscoveryBackgroundAsset].
  static const _parchmentContentLeft = 0.315;
  static const _parchmentContentRight = 0.645;
  static const _parchmentContentTop = 0.22;
  static const _parchmentContentHeight = 0.52;

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
          child: GameImage(
            asset: kStation4DiscoveryBackgroundAsset,
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
                                padding: const EdgeInsets.fromLTRB(2, 0, 10, 0),
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
                          .markDiscoveryComplete('station4');
                      if (context.mounted) {
                        context.go(stationHubRoute('station4'));
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
