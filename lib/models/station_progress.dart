enum StationStatus { locked, unlocked, completed }

class StationProgress {
  final String stationKey;
  StationStatus status;
  int missionScore;
  int checkpointScore;
  bool badgeEarned;
  bool discoveryComplete;
  bool takeawayComplete;

  StationProgress({
    required this.stationKey,
    this.status = StationStatus.locked,
    this.missionScore = 0,
    this.checkpointScore = 0,
    this.badgeEarned = false,
    this.discoveryComplete = false,
    this.takeawayComplete = false,
  });
}
