import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/widgets/badge_card.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station2_data.dart';
import '../../data/stations.dart';

/// Celebration screen shown after completing Station 2's checkpoint.
class Station2BadgeScreen extends StatelessWidget {
  const Station2BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final info = stationByKey('station2');
    return BioScaffold(
      backgroundAsset: kStation2BadgeBackgroundAsset,
      backgroundLabel: 'Badge Earned',
      fullBleedBackground: true,
      scrimOpacity: 0.08,
      gradient: const [BioColors.forest, BioColors.sun],
      body: Center(
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
                assetName: kStation2BadgeAsset,
                size: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                'Excellent sampling! Station 3 is now unlocked on the '
                'Expedition Map.',
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
    );
  }
}
