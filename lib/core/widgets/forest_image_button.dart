import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'game_image.dart';

/// Tappable forest-themed PNG button with press scale feedback.
class ForestImageButton extends StatefulWidget {
  final String asset;
  final String label;
  final VoidCallback onTap;
  final double height;
  final BoxFit fit;

  const ForestImageButton({
    super.key,
    required this.asset,
    required this.label,
    required this.onTap,
    this.height = 72,
    this.fit = BoxFit.contain,
  });

  @override
  State<ForestImageButton> createState() => _ForestImageButtonState();
}

class _ForestImageButtonState extends State<ForestImageButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: widget.height,
              width: double.infinity,
              child: GameImage(
                asset: widget.asset,
                label: widget.label,
                color: BioColors.moss,
                fit: widget.fit,
                icon: Icons.touch_app,
                cacheWidth: 640,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Non-interactive forest-themed PNG banner for titles and labels on the map.
class ForestImageDisplay extends StatelessWidget {
  final String asset;
  final String label;
  final double height;
  final BoxFit fit;

  const ForestImageDisplay({
    super.key,
    required this.asset,
    required this.label,
    this.height = 72,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: GameImage(
            asset: asset,
            label: label,
            color: BioColors.moss,
            fit: fit,
            icon: Icons.explore_rounded,
            cacheWidth: 640,
          ),
        ),
      ),
    );
  }
}
