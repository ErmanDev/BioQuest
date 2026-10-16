import 'package:flutter/material.dart';

/// Lays out [child] (usually wrapped text) at the full available width and
/// shrinks it only if it would be taller than the space it is given, so text
/// in fixed-height rows never gets clipped.
class FitText extends StatelessWidget {
  const FitText({
    super.key,
    required this.child,
    this.alignment = Alignment.centerLeft,
  });

  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignment,
        child: SizedBox(width: box.maxWidth, child: child),
      ),
    );
  }
}
