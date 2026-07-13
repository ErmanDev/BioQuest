import 'station_content.dart';
import 'stations.dart';

const String kBadgeWardrobeBackgroundAsset =
    'assets/images/backgrounds/badge_wardrobe.png';

/// Badge display info for each station on the Expedition Map wardrobe.
class ExpeditionBadgeInfo {
  final String stationKey;
  final String badgeName;
  final String assetName;

  const ExpeditionBadgeInfo({
    required this.stationKey,
    required this.badgeName,
    required this.assetName,
  });
}

final List<ExpeditionBadgeInfo> kExpeditionBadges = [
  for (final station in kStations)
    ExpeditionBadgeInfo(
      stationKey: station.key,
      badgeName: station.badgeName,
      assetName: contentOf(station.key).badgeAsset,
    ),
];
