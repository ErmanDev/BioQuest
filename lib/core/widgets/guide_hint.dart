import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Bouncing, blinking arrow hint to draw attention to the next step.
class GuideHint extends StatefulWidget {
  final Widget child;
  final String? label;
  final bool arrowAbove;
  final bool enabled;

  const GuideHint({
    super.key,
    required this.child,
    this.label,
    this.arrowAbove = true,
    this.enabled = true,
  });

  @override
  State<GuideHint> createState() => _GuideHintState();
}

class _GuideHintState extends State<GuideHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final bounce = -10 * _c.value;
        final blink = 0.45 + _c.value * 0.55;
        final arrow = Transform.translate(
          offset: Offset(0, bounce),
          child: Opacity(
            opacity: blink,
            child: Icon(
              widget.arrowAbove
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: BioColors.sun,
              size: 34,
              shadows: const [
                Shadow(color: Colors.black54, blurRadius: 6),
              ],
            ),
          ),
        );

        final label = widget.label == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Opacity(
                  opacity: blink,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: BioColors.sun,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.label!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: BioColors.ink,
                      ),
                    ),
                  ),
                ),
              );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.arrowAbove
              ? [arrow, label, child!]
              : [child!, label, arrow],
        );
      },
      child: widget.child,
    );
  }
}

/// Floating map marker hint — bouncing arrow with optional label.
class MapGuidePin extends StatefulWidget {
  final String label;
  final double width;

  const MapGuidePin({
    super.key,
    required this.label,
    this.width = 120,
  });

  @override
  State<MapGuidePin> createState() => _MapGuidePinState();
}

class _MapGuidePinState extends State<MapGuidePin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final bounce = -8 * _c.value;
        final blink = 0.5 + _c.value * 0.5;
        return Transform.translate(
          offset: Offset(0, bounce),
          child: Opacity(
            opacity: blink,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.arrow_downward_rounded,
                  color: BioColors.sun,
                  size: 36,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                ),
                Container(
                  width: widget.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: BioColors.sun,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: BioColors.ink,
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
}
