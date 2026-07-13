import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'game_image.dart';

/// Forest background with slow drift, light shimmer, and falling leaves.
class AnimatedForestBackground extends StatefulWidget {
  final String asset;
  final String label;

  const AnimatedForestBackground({
    super.key,
    required this.asset,
    this.label = 'Forest',
  });

  @override
  State<AnimatedForestBackground> createState() =>
      _AnimatedForestBackgroundState();
}

class _AnimatedForestBackgroundState extends State<AnimatedForestBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  late final List<_Leaf> _leaves = List.generate(18, (i) => _Leaf(i));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final swayX = math.sin(t * math.pi * 2) * 10;
        final swayY = math.cos(t * math.pi * 2) * 5;
        final scale = 1.04 + math.sin(t * math.pi * 2) * 0.015;

        return Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset(swayX, swayY),
              child: Transform.scale(
                scale: scale,
                child: GameImage(
                  asset: widget.asset,
                  label: widget.label,
                  fit: BoxFit.cover,
                  color: BioColors.forest,
                  icon: Icons.forest,
                  cacheWidth: 1280,
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.08 + math.sin(t * math.pi * 2) * 0.03),
                    Colors.black.withValues(alpha: 0.22),
                    BioColors.forest.withValues(alpha: 0.18),
                  ],
                ),
              ),
            ),
            CustomPaint(
              painter: _ForestLeafPainter(leaves: _leaves, time: t),
            ),
          ],
        );
      },
    );
  }
}

class _Leaf {
  _Leaf(int seed)
      : x = _rand(seed, 0.05, 0.95),
        startY = _rand(seed + 1, -0.2, 1.0),
        speed = _rand(seed + 2, 0.08, 0.2),
        size = _rand(seed + 3, 8, 16),
        drift = _rand(seed + 4, -28, 28),
        rotation = _rand(seed + 5, 0, math.pi * 2),
        spin = _rand(seed + 6, -1.5, 1.5),
        color = Color.lerp(
          BioColors.leaf,
          BioColors.paleLeaf,
          _rand(seed + 7, 0.2, 1.0),
        )!;

  final double x;
  final double startY;
  final double speed;
  final double size;
  final double drift;
  final double rotation;
  final double spin;
  final Color color;

  static double _rand(int seed, double min, double max) {
    final n = math.sin(seed * 12.9898) * 43758.5453;
    final f = n - n.floor();
    return min + f * (max - min);
  }
}

class _ForestLeafPainter extends CustomPainter {
  final List<_Leaf> leaves;
  final double time;

  const _ForestLeafPainter({required this.leaves, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    for (final leaf in leaves) {
      final progress = (time * leaf.speed + leaf.startY) % 1.2;
      final y = (progress * 1.15 - 0.08) * size.height;
      final x = leaf.x * size.width +
          math.sin((time + leaf.startY) * math.pi * 2) * leaf.drift;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(leaf.rotation + time * leaf.spin * math.pi * 2);
      paint.color = leaf.color.withValues(alpha: 0.55);
      _drawLeaf(canvas, paint, leaf.size);
      canvas.restore();
    }
  }

  void _drawLeaf(Canvas canvas, Paint paint, double size) {
    final path = Path()
      ..moveTo(0, -size * 0.5)
      ..quadraticBezierTo(size * 0.55, -size * 0.15, size * 0.45, size * 0.45)
      ..quadraticBezierTo(0, size * 0.2, -size * 0.45, size * 0.45)
      ..quadraticBezierTo(-size * 0.55, -size * 0.15, 0, -size * 0.5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ForestLeafPainter oldDelegate) =>
      oldDelegate.time != time;
}
