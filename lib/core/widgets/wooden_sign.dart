import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Wooden trail-sign button: a round [badge] on the left, a bold [title] and
/// optional [subtitle] on a light-wood plank with a dark border and trim.
class WoodenSignButton extends StatelessWidget {
  const WoodenSignButton({
    super.key,
    required this.badge,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.titleSize = 22,
  });

  final Widget badge;
  final String title;
  final String? subtitle;
  final double titleSize;
  final VoidCallback onTap;

  static const _woodLight = Color(0xFFEBD3A0);
  static const _woodDark = Color(0xFFC79A5B);
  static const _edge = Color(0xFF4E3018);
  static const _trim = Color(0xFF8A5C2E);
  static const textDark = Color(0xFF3B2210);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: _edge, width: 3),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_woodLight, _woodDark],
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.fromLTRB(6, 6, 20, 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _trim.withValues(alpha: 0.7),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                badge,
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: titleSize,
                        letterSpacing: 1,
                        height: 1.1,
                        shadows: const [
                          Shadow(
                            color: Color(0x66FFFFFF),
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          color: textDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Round wooden badge with a green ring holding [child].
class SignBadge extends StatelessWidget {
  const SignBadge({super.key, required this.child, this.size = 58});

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF8C5A2B), Color(0xFF5A3517)],
        ),
        border: Border.all(color: BioColors.forest, width: 3.5),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

/// Brass compass with a red north needle, drawn to fill its box.
class CompassFace extends StatelessWidget {
  const CompassFace({super.key});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _CompassFacePainter(), size: Size.infinite);
}

class _CompassFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;

    // Brass rim and cream dial.
    canvas.drawCircle(c, r * 0.86, Paint()..color = const Color(0xFFD4A64A));
    canvas.drawCircle(c, r * 0.74, Paint()..color = const Color(0xFFFFF3D6));

    // Tick marks at the 8 points.
    final tick = Paint()
      ..color = const Color(0xFF5A3517)
      ..strokeWidth = r * 0.05
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final len = i.isEven ? 0.16 : 0.09;
      final dir = Offset(math.sin(a), -math.cos(a));
      canvas.drawLine(c + dir * r * 0.72, c + dir * r * (0.72 - len), tick);
    }

    // Needle: red north half, white south half, tilted like the reference.
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(math.pi / 5);
    final w = r * 0.17;
    final len = r * 0.6;
    final north = Path()
      ..moveTo(0, -len)
      ..lineTo(w, 0)
      ..lineTo(-w, 0)
      ..close();
    final south = Path()
      ..moveTo(0, len)
      ..lineTo(w, 0)
      ..lineTo(-w, 0)
      ..close();
    canvas.drawPath(north, Paint()..color = const Color(0xFFD32F2F));
    canvas.drawPath(south, Paint()..color = const Color(0xFFF5F5F5));
    final outline = Paint()
      ..color = const Color(0xFF3B2210)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.03;
    canvas.drawPath(north, outline);
    canvas.drawPath(south, outline);
    canvas.restore();

    canvas.drawCircle(c, r * 0.07, Paint()..color = const Color(0xFF3B2210));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
