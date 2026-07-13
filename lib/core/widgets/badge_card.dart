import 'package:flutter/material.dart';
import '../../app/theme.dart';
class BadgeCard extends StatelessWidget {
  final String badgeName;
  final String assetName; // file under assets/images/ui/
  final double size;
  final bool earned;

  const BadgeCard({
    super.key,
    required this.badgeName,
    required this.assetName,
    this.size = 120,
    this.earned = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: earned
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/ui/$assetName',
                      fit: BoxFit.cover,
                      width: size,
                      height: size,
                      gaplessPlayback: true,
                      cacheWidth: 320,
                      errorBuilder: (context, error, stack) => const ColoredBox(
                        color: BioColors.parchment,
                        child: Icon(
                          Icons.military_tech,
                          color: BioColors.sun,
                          size: 72,
                        ),
                      ),
                    ),
                  ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: Icon(
                    Icons.lock,
                    color: Colors.grey.shade500,
                    size: size * 0.45,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: size + 40,
          child: Text(
            badgeName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: earned ? BioColors.ink : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
