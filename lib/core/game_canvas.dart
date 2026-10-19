import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Space to keep clear of the status bar, camera hole and the back/home/
/// recent buttons. Left/right are mirrored (the larger on both sides) so an
/// inset on one edge doesn't push centered content off-center.
EdgeInsets safeContentInsets(BuildContext context) {
  final insets = MediaQuery.paddingOf(context);
  final horizontal = math.max(insets.left, insets.right);
  return EdgeInsets.fromLTRB(horizontal, insets.top, horizontal, insets.bottom);
}

/// A logical canvas that scales uniformly to fill any screen.
///
/// It keeps a fixed design *height* (720) and a minimum design *width* (1280),
/// but lets the logical size grow on whichever axis the device needs so the
/// content fills the whole screen with **no letterbox bands** and **no
/// cropping**. Because the scale is uniform (same factor on both axes),
/// proportions of shapes, drop targets and bars never distort, so there is
/// still no shape misalignment. One transform scales the whole layer, which is
/// cheap on low-end devices.
class GameCanvas extends StatelessWidget {
  static const double designWidth = 1280;
  static const double designHeight = 720;
  static const Size designSize = Size(designWidth, designHeight);

  final Widget child;
  final Color letterboxColor;

  const GameCanvas({
    super.key,
    required this.child,
    this.letterboxColor = const Color(0xFF12281A),
  });

  @override
  Widget build(BuildContext context) {
    // Keep the scaled content clear of the status bar, camera hole and nav
    // bar, while the letterbox color still paints edge-to-edge behind them.
    // Left/right insets are mirrored (the larger on both sides) so a camera
    // hole or nav bar on one edge doesn't push centered content off-center.
    return ColoredBox(
      color: letterboxColor,
      child: Padding(
        padding: safeContentInsets(context),
        child: MediaQuery.removePadding(
          context: context,
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxW = constraints.maxWidth;
              final maxH = constraints.maxHeight;
              // "contain" scale (the smaller of the two). Dividing the real screen
              // size by it yields a logical size that is >= the design on BOTH
              // axes, so the canvas exactly fills the screen with a single uniform
              // scale. The extra room goes to the longer axis, where flexible
              // layouts (Expanded/Row/Column) simply reflow into it.
              final scale = math.min(maxW / designWidth, maxH / designHeight);
              final logicalW = scale > 0 ? maxW / scale : designWidth;
              final logicalH = scale > 0 ? maxH / scale : designHeight;
              return SizedBox(
                width: maxW,
                height: maxH,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: logicalW,
                    height: logicalH,
                    // Transparent Material gives every screen a Material ancestor
                    // (required by TextField, ink splashes, etc.) without painting
                    // a background, since screens supply their own backgrounds.
                    // RepaintBoundary isolates the scaled layer to limit repaints.
                    child: Material(
                      type: MaterialType.transparency,
                      child: RepaintBoundary(child: child),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
