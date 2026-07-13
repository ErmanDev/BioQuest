import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Loads an asset image, but renders a labeled placeholder shape if the file
/// is missing. This lets the whole game run before any art is added, and the
/// `cacheWidth` cap keeps memory low on cheap devices.
class GameImage extends StatelessWidget {
  final String asset;
  final String label;
  final Color color;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final int? cacheWidth;
  final IconData icon;

  const GameImage({
    super.key,
    required this.asset,
    this.label = '',
    this.color = BioColors.leaf,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.cacheWidth,
    this.icon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      cacheWidth: cacheWidth,
      gaplessPlayback: true,
      errorBuilder: (context, error, stack) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 36),
            if (label.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: BioColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
