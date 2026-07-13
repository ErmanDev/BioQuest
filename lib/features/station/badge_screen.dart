import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/widgets/badge_card.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station_content.dart';
import '../../data/stations.dart';

/// Generic badge celebration shown after completing a station's checkpoint.
class StationBadgeScreen extends StatelessWidget {
  final String stationKey;
  const StationBadgeScreen({super.key, required this.stationKey});

  @override
  Widget build(BuildContext context) {
    final info = stationByKey(stationKey);
    final content = contentOf(stationKey);
    return BioScaffold(
      gradient: const [BioColors.forest, BioColors.sun],
      scrimOpacity: 0.1,
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
                assetName: content.badgeAsset,
                size: 150,
              ),
              const SizedBox(height: 16),
              Text(
                content.nextStationMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
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
