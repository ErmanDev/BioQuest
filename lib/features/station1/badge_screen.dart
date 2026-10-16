import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/stations.dart';

/// Celebration screen shown after completing a station's checkpoint.
class Station1BadgeScreen extends StatelessWidget {
  const Station1BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final info = stationByKey('station1');
    return BioScaffold(
      backgroundAsset: 'assets/images/backgrounds/mission_forest_bg.png',
      backgroundLabel: 'Badge Earned',
      fullBleedBackground: true,
      gradient: const [BioColors.forest, BioColors.sun],
      scrimOpacity: 0.35,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final shortest = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;
          final badgeSize = (shortest * 0.55).clamp(220.0, 360.0);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Badge Earned!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                info.badgeName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: BioColors.sun,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: _circleBadge(
                    assetName: 'badge_research_beginner.png',
                    size: badgeSize,
                  ),
                ),
              ),
              const Text(
                'Great work, Young Researcher! Station 2 is now unlocked on the '
                'Expedition Map.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: PrimaryButton(
                  label: 'Back to Expedition Map',
                  icon: Icons.map,
                  fontSize: 24,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  onTap: () => context.go('/map'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _circleBadge({required String assetName, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: BioColors.sun, width: 8),
        boxShadow: [
          BoxShadow(
            color: BioColors.sun.withValues(alpha: 0.45),
            blurRadius: 28,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
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
          cacheWidth: 720,
          errorBuilder: (context, error, stack) => ColoredBox(
            color: BioColors.parchment,
            child: Icon(
              Icons.military_tech,
              color: BioColors.sun,
              size: size * 0.45,
            ),
          ),
        ),
      ),
    );
  }
}
