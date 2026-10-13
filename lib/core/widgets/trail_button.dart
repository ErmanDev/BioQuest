import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Leaf-green wooden sign button (Discovery Stop "Proceed"), styled to match
/// the Word Quest sign: wood border, inner trim, and a faint grain texture.
class TrailButton extends StatelessWidget {
  const TrailButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.fontSize = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final double fontSize;
  final EdgeInsets padding;

  static const _greenLight = Color(0xFF9CCC65);
  static const _greenDark = Color(0xFF558B2F);
  static const _edge = Color(0xFF4E3018);
  static const _textShadow = [
    Shadow(color: Color(0xCC1B3A10), offset: Offset(0, 2), blurRadius: 3),
  ];

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final radius = BorderRadius.circular(16);
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
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
                colors: [_greenLight, _greenDark],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: CustomPaint(
                painter: _GrainPainter(),
                child: Container(
                  margin: const EdgeInsets.all(3),
                  padding: padding,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: const Color(0x99F1F8E9),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: Colors.white,
                          size: fontSize + 4,
                          shadows: _textShadow,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          shadows: _textShadow,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Faint wavy grain lines plus a soft top highlight.
class _GrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final highlight = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [Color(0x40FFFFFF), Color(0x00FFFFFF)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, highlight);

    final grain = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    const spacing = 7.0;
    var row = 0;
    for (var y = spacing / 2; y < size.height; y += spacing, row++) {
      grain.color = Color.fromRGBO(30, 70, 15, row.isEven ? 0.16 : 0.09);
      final path = Path()..moveTo(0, y);
      for (var x = 0.0; x <= size.width; x += 6) {
        final wave = math.sin((x / size.width) * math.pi * 3 + row * 1.7);
        path.lineTo(x, y + wave * 1.6);
      }
      canvas.drawPath(path, grain);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
