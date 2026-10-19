import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/badge_card.dart';
import '../../core/widgets/game_image.dart';
import '../../data/badge_data.dart';
import '../../services/progress_service.dart';

/// Modal overlay showing earned and locked expedition badges.
class BadgeWardrobeOverlay extends StatelessWidget {
  final ProgressService progress;
  final VoidCallback onClose;

  const BadgeWardrobeOverlay({
    super.key,
    required this.progress,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final earnedCount = kExpeditionBadges
        .where((badge) => progress.progressOf(badge.stationKey).badgeEarned)
        .length;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 760,
        height: 520,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BioColors.sun, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 28,
              offset: Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: GameImage(
                asset: kBadgeWardrobeBackgroundAsset,
                label: 'Badge wardrobe',
                fit: BoxFit.cover,
                color: BioColors.bark,
                icon: Icons.checkroom,
                cacheWidth: 1280,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.18),
                      Colors.black.withValues(alpha: 0.42),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.military_tech,
                        color: BioColors.sun,
                        size: 32,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Badge Wardrobe',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Earned $earnedCount of ${kExpeditionBadges.length}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onClose,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: BioColors.parchment.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: BioColors.forest.withValues(alpha: 0.45),
                          width: 2,
                        ),
                      ),
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.72,
                            ),
                        itemCount: kExpeditionBadges.length,
                        itemBuilder: (context, index) {
                          final badge = kExpeditionBadges[index];
                          final earned = progress
                              .progressOf(badge.stationKey)
                              .badgeEarned;
                          return BadgeCard(
                            badgeName: badge.badgeName,
                            assetName: badge.assetName,
                            size: 88,
                            earned: earned,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
