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
import '../../models/vocab_word.dart';
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
                Stack(
                  alignment: Alignment.center,
                  children: [
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
                    Positioned(
                      right: 0,
                      child: _WordQuestButton(onTap: _showWordQuestOverlay),
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

  void _showWordQuestOverlay() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 14),
            decoration: BoxDecoration(
              color: BioColors.parchment,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: BioColors.deepSky, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_stories,
                      color: BioColors.deepSky,
                      size: 26,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'WORD QUEST',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: BioColors.deepSky,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close, color: BioColors.deepSky),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Learn new words from this station:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: BioColors.ink,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: kStation1Vocabulary.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 22,
                      color: BioColors.leaf,
                    ),
                    itemBuilder: (context, i) =>
                        _VocabItem(word: kStation1Vocabulary[i]),
                  ),
                ),
              ],
            ),
          ),
        ),
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

/// Bottom-right button that opens the Word Quest vocabulary overlay.
class _WordQuestButton extends StatelessWidget {
  const _WordQuestButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BioColors.deepSky,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_stories, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Word Quest',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Tap to learn new words!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One vocabulary entry (term, definition, in-context sentence) in the
/// Word Quest overlay.
class _VocabItem extends StatelessWidget {
  const _VocabItem({required this.word});

  final VocabWord word;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          word.term,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: BioColors.deepSky,
          ),
        ),
        const SizedBox(height: 4),
        _VocabLine(label: 'Definition: ', text: word.definition),
        const SizedBox(height: 4),
        _VocabLine(label: 'In Context: ', text: word.context),
      ],
    );
  }
}

class _VocabLine extends StatelessWidget {
  const _VocabLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          height: 1.35,
          color: BioColors.ink,
        ),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}
