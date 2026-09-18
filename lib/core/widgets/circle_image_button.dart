import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'game_image.dart';

/// Tappable circular PNG badge with press-scale feedback.
class CircleImageButton extends StatefulWidget {
  final String asset;
  final String label;
  final VoidCallback? onTap;
  final double size;
  final Color borderColor;

  const CircleImageButton({
    super.key,
    required this.asset,
    required this.label,
    this.onTap,
    this.size = 88,
    this.borderColor = BioColors.sun,
  });

  @override
  State<CircleImageButton> createState() => _CircleImageButtonState();
}

class _CircleImageButtonState extends State<CircleImageButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return Semantics(
      button: enabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: enabled ? widget.borderColor : Colors.white54,
                    width: 4,
                  ),
                  boxShadow: enabled
                      ? const [
                          BoxShadow(
                            color: Color(0x40000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: ClipOval(
                  child: SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: enabled
                        ? GameImage(
                            asset: widget.asset,
                            label: widget.label,
                            fit: BoxFit.cover,
                            icon: Icons.map_rounded,
                            cacheWidth: 256,
                          )
                        : ColorFiltered(
                            colorFilter: const ColorFilter.matrix([
                              0.35, 0.35, 0.35, 0, 0,
                              0.35, 0.35, 0.35, 0, 0,
                              0.35, 0.35, 0.35, 0, 0,
                              0, 0, 0, 0.65, 0,
                            ]),
                            child: GameImage(
                              asset: widget.asset,
                              label: widget.label,
                              fit: BoxFit.cover,
                              icon: Icons.map_rounded,
                              cacheWidth: 256,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: widget.size + 20,
                child: Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: enabled ? Colors.white : Colors.white60,
                    shadows: const [
                      Shadow(
                        color: Color(0x99000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
