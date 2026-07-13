import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/badge_card.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station4_data.dart';
import '../../data/stations.dart';

/// Celebration screen shown after completing Station 4's checkpoint.
class Station4BadgeScreen extends StatelessWidget {
  const Station4BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final info = stationByKey('station4');
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: kStation4BadgeBackgroundAsset,
            label: 'Badge Earned',
            fit: BoxFit.cover,
            color: BioColors.forest,
            icon: Icons.landscape,
            cacheWidth: 1280,
          ),
        ),
        Positioned.fill(
          child: ColoredBox(
            color: Colors.black.withValues(alpha: 0.12),
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Center(
            child: Container(
              width: 620,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: BioColors.parchment,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: BioColors.sun, width: 4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Badge Earned!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: BioColors.forest,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BadgeCard(
                    badgeName: info.badgeName,
                    assetName: kStation4BadgeAsset,
                    size: 150,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    kStation4BadgeNextMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: 'Back to Expedition Map',
                    icon: Icons.map,
                    onTap: () => context.go('/map'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
