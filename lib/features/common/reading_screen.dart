import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/text_format.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/narration_control.dart';
import '../../models/explorer_avatar.dart';
import '../../services/auth_service.dart';
import '../../services/narration_helper.dart';

/// Scrollable reading page with optional voiceover and a footer action.
/// Used for the orientation pages and each Discovery Stop.
class ReadingScreen extends StatefulWidget {
  final String title;
  final String content;
  final String? backgroundAsset;
  final String? backgroundLabel;
  final List<Color>? gradient;
  final Widget? footer;
  final bool autoNarrate;
  final double contentFontSize;
  final bool fullBleedBackground;
  final double backgroundOpacity;
  final double scrimOpacity;
  final EdgeInsets? padding;
  final bool showGuideAvatar;
  final bool compactLayout;

  const ReadingScreen({
    super.key,
    required this.title,
    required this.content,
    this.backgroundAsset,
    this.backgroundLabel,
    this.gradient,
    this.footer,
    this.autoNarrate = false,
    this.contentFontSize = 19,
    this.fullBleedBackground = false,
    this.backgroundOpacity = 1.0,
    this.scrimOpacity = 0.25,
    this.padding,
    this.showGuideAvatar = false,
    this.compactLayout = false,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen>
    with RouteAware, AutoNarrateOnEnter {
  @override
  String? get autoNarrateText =>
      widget.autoNarrate ? stripReadingMarkup(widget.content) : null;

  @override
  bool get shouldAutoNarrate => widget.autoNarrate;

  @override
  Widget build(BuildContext context) {
    return BioScaffold(
      title: widget.title,
      backgroundAsset: widget.backgroundAsset,
      backgroundLabel: widget.backgroundLabel,
      gradient: widget.gradient,
      fullBleedBackground: widget.fullBleedBackground,
      backgroundOpacity: widget.backgroundOpacity,
      scrimOpacity: widget.scrimOpacity,
      padding: widget.padding ?? const EdgeInsets.fromLTRB(12, 8, 12, 10),
      onBack: () {
        stopNarration(context).then((_) {
          if (!context.mounted) return;
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/basecamp');
          }
        });
      },
      actions: [NarrationControl(text: stripReadingMarkup(widget.content))],
      body: widget.compactLayout
          ? _compactBody()
          : Column(
              children: [
                Expanded(child: _contentPanel(expand: true)),
                if (widget.footer != null) ...[
                  const SizedBox(height: 12),
                  widget.footer!,
                ],
              ],
            ),
    );
  }

  Widget _compactBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final avatarSize = constraints.maxHeight * 0.52;
        const avatarScale = 1.75;
        final panelMaxW = constraints.maxWidth * 0.48;
        final panelMaxH = constraints.maxHeight * 0.72;

        return Column(
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.showGuideAvatar) ...[
                      _guideAvatar(avatarSize, avatarScale),
                      const SizedBox(width: 16),
                    ],
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: panelMaxW,
                        maxHeight: panelMaxH,
                      ),
                      child: _contentPanel(expand: false),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.footer != null) ...[
              const SizedBox(height: 12),
              widget.footer!,
            ],
          ],
        );
      },
    );
  }

  Widget _guideAvatar(double size, double scale) {
    final id = context.watch<AuthService>().currentUser?.avatarId ?? 0;
    final explorer = ExplorerAvatar.fromId(id);
    return SizedBox(
      width: size,
      height: size * scale,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: OverflowBox(
          alignment: Alignment.bottomCenter,
          maxHeight: size * scale,
          minHeight: size * scale,
          maxWidth: size * scale,
          child: SizedBox(
            height: size * scale,
            child: GameImage(
              asset: explorer.assetPath,
              label: explorer.label,
              color: BioColors.moss,
              fit: BoxFit.fitHeight,
              icon: Icons.emoji_people,
              cacheWidth: (size * scale * 2).round(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contentPanel({required bool expand}) {
    final panel = Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(
          alpha: widget.fullBleedBackground ? 0.94 : 0.96,
        ),
        borderRadius: BorderRadius.circular(18),
        border: widget.fullBleedBackground
            ? Border.all(color: BioColors.forest.withValues(alpha: 0.35), width: 2)
            : null,
        boxShadow: widget.fullBleedBackground
            ? const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 16,
                  offset: Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: expand
          ? Scrollbar(
              child: ListView(
                primary: true,
                children: [
                  SelectableText.rich(
                    readingTextSpan(
                      widget.content,
                      fontSize: widget.contentFontSize,
                      color: BioColors.ink,
                      indentFirstLine: true,
                    ),
                  ),
                ],
              ),
            )
          : Scrollbar(
              child: SingleChildScrollView(
                child: SelectableText.rich(
                  readingTextSpan(
                    widget.content,
                    fontSize: widget.contentFontSize,
                    color: BioColors.ink,
                    indentFirstLine: true,
                  ),
                ),
              ),
            ),
    );
    return panel;
  }
}
