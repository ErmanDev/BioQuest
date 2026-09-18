import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../game_canvas.dart';
import 'game_image.dart';

/// Standard screen frame: fixed 1280x720 canvas, optional background image
/// (with a readability scrim), an optional top bar (back, title, actions),
/// and a padded body.
class BioScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final double titleFontSize;
  final String? backgroundAsset;
  final String? backgroundLabel;
  final List<Color>? gradient;
  final double scrimOpacity;
  final double backgroundOpacity;
  final VoidCallback? onBack;
  final double backButtonSize;
  final List<Widget> actions;
  final EdgeInsets padding;
  /// When true, the background image and scrim extend edge-to-edge behind
  /// system bars; only the foreground UI respects [GameCanvas] safe area.
  final bool fullBleedBackground;

  const BioScaffold({
    super.key,
    required this.body,
    this.title,
    this.titleFontSize = 20,
    this.backgroundAsset,
    this.backgroundLabel,
    this.gradient,
    this.scrimOpacity = 0.25,
    this.backgroundOpacity = 1.0,
    this.onBack,
    this.backButtonSize = 46,
    this.actions = const [],
    this.padding = const EdgeInsets.fromLTRB(28, 16, 28, 24),
    this.fullBleedBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasTopBar = onBack != null || title != null || actions.isNotEmpty;
    final foreground = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasTopBar) _topBar(context),
          if (hasTopBar) const SizedBox(height: 12),
          Expanded(child: body),
        ],
      ),
    );

    if (fullBleedBackground) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: _background()),
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: scrimOpacity),
                ),
              ),
              Positioned.fill(
                child: GameCanvas(
                  letterboxColor: Colors.transparent,
                  child: foreground,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GameCanvas(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _background(),
          Positioned.fill(
            child: ColoredBox(color: Colors.black.withValues(alpha: scrimOpacity)),
          ),
          foreground,
        ],
      ),
    );
  }

  Widget _background() {
    if (backgroundAsset != null) {
      return Opacity(
        opacity: backgroundOpacity,
        child: GameImage(
          asset: backgroundAsset!,
          label: backgroundLabel ?? '',
          fit: BoxFit.cover,
          color: BioColors.forest,
          icon: Icons.landscape,
          cacheWidth: 1280,
        ),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradient ?? const [BioColors.sky, BioColors.leaf],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        if (onBack != null)
          _circleButton(Icons.arrow_back, onBack!)
        else
          SizedBox(width: backButtonSize),
        const SizedBox(width: 12),
        Expanded(
          child: title == null
              ? const SizedBox.shrink()
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: BioColors.forest,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 12),
        ...actions,
      ],
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    final iconSize = backButtonSize * 0.55;
    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black26,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: backButtonSize,
          height: backButtonSize,
          child: Icon(icon, color: BioColors.forest, size: iconSize),
        ),
      ),
    );
  }
}
