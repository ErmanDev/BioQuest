import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../game_canvas.dart';
import 'game_image.dart';

/// Where a full-screen artwork is drawn: the whole image, kept at its own
/// aspect ratio and centered, as large as the screen allows.
Rect artworkRect(Size screen, double aspect) {
  final scale = math.min(screen.width / aspect, screen.height);
  final w = scale * aspect;
  final h = scale;
  return Rect.fromLTWH((screen.width - w) / 2, (screen.height - h) / 2, w, h);
}

/// Full-screen background that always shows the whole artwork, kept clear of
/// the status bar, camera hole and system buttons. Any leftover
/// space (tablets, very wide phones) is filled with a blurred copy of the
/// same image instead of bars, so nothing important is ever cropped.
class ArtworkBackdrop extends StatelessWidget {
  const ArtworkBackdrop({
    super.key,
    required this.asset,
    required this.aspect,
    required this.label,
    this.color = const Color(0xFF1B5E20),
  });

  final String asset;
  final double aspect;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final safe = safeContentInsets(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final rect = artworkRect(
          safe.deflateSize(constraints.biggest),
          aspect,
        ).shift(Offset(safe.left, safe.top));
        return Stack(
          fit: StackFit.expand,
          children: [
            RepaintBoundary(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: GameImage(
                  asset: asset,
                  label: label,
                  fit: BoxFit.cover,
                  color: color,
                  icon: Icons.landscape,
                  cacheWidth: 320,
                ),
              ),
            ),
            Positioned.fromRect(
              rect: rect,
              child: GameImage(
                asset: asset,
                label: label,
                fit: BoxFit.fill,
                color: color,
                icon: Icons.landscape,
                cacheWidth: 1600,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// A child pinned to a region of the artwork, given as fractions of the
/// image (0–1 from its left/top edge).
class ArtworkSlot {
  const ArtworkSlot({
    required this.region,
    required this.child,
    this.interactive = true,
  });

  final Rect region;
  final Widget child;

  /// False for decorations (e.g. the avatar) so taps pass through them.
  final bool interactive;
}

/// Lays [slots] over an [ArtworkBackdrop] with the same [aspect]. Children
/// are laid out on a fixed design canvas ([designWidth] wide) that is scaled
/// to the artwork, so text wraps and sits the same way on every phone and
/// tablet. Taps outside the slots fall through to widgets underneath.
class ArtworkOverlay extends StatelessWidget {
  const ArtworkOverlay({
    super.key,
    required this.aspect,
    required this.slots,
    this.designWidth = defaultDesignWidth,
  });

  final double aspect;
  final List<ArtworkSlot> slots;
  final double designWidth;

  /// Design canvas width; matches the logical width of a typical landscape
  /// phone, so text sizes look the same as on the rest of the app.
  static const double defaultDesignWidth = 1600;

  @override
  Widget build(BuildContext context) {
    final designHeight = designWidth / aspect;
    final safe = safeContentInsets(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final rect = artworkRect(
          safe.deflateSize(constraints.biggest),
          aspect,
        ).shift(Offset(safe.left, safe.top));
        return Stack(
          children: [
            Positioned.fromRect(
              rect: rect,
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: designWidth,
                  height: designHeight,
                  // Ink effects (InkWell) in slots need a Material ancestor.
                  child: Material(
                    type: MaterialType.transparency,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        for (final slot in slots)
                          Positioned(
                            left: slot.region.left * designWidth,
                            top: slot.region.top * designHeight,
                            width: slot.region.width * designWidth,
                            height: slot.region.height * designHeight,
                            child: slot.interactive
                                ? slot.child
                                : IgnorePointer(child: slot.child),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Explorer figure that fills a slot's height, standing on its bottom edge.
/// The avatar PNGs carry transparent padding, so the art is drawn slightly
/// taller than the slot.
class SlotFigure extends StatelessWidget {
  const SlotFigure({
    super.key,
    required this.asset,
    required this.label,
    this.overscan = 1.15,
  });

  final String asset;
  final String label;
  final double overscan;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight * overscan;
        return OverflowBox(
          alignment: Alignment.bottomCenter,
          minHeight: h,
          maxHeight: h,
          maxWidth: h,
          child: GameImage(
            asset: asset,
            label: label,
            fit: BoxFit.fitHeight,
            alignment: Alignment.bottomCenter,
            color: const Color(0xFF4CAF50),
            icon: Icons.emoji_people,
            cacheWidth: 900,
          ),
        );
      },
    );
  }
}
