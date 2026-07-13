import '../models/mc_question.dart';
import 'station1_data.dart';
import 'station2_data.dart';
import 'station3_data.dart';
import 'station4_data.dart';
import 'station5_data.dart';

/// All per-station text content and assessment data, keyed by station key.
/// Screens (intro, discovery, takeaway, checkpoint, badge) read from here so
/// they can be fully generic across stations.
class StationContent {
  final String intro;
  final String content;
  final String discoveryTitle;
  final String takeawayPrompt;
  final String takeawayModel;
  final List<String> takeawayKeywords;
  final List<McQuestion> checkpoint;
  final String badgeAsset;
  final String nextStationMessage;

  const StationContent({
    required this.intro,
    required this.content,
    required this.discoveryTitle,
    required this.takeawayPrompt,
    required this.takeawayModel,
    required this.takeawayKeywords,
    required this.checkpoint,
    required this.badgeAsset,
    required this.nextStationMessage,
  });
}

const Map<String, StationContent> kStationContent = {
  'station1': StationContent(
    intro: kStation1Intro,
    content: kStation1Content,
    discoveryTitle: 'Discovery Stop: The World of Mosses',
    takeawayPrompt: kStation1TakeawayPrompt,
    takeawayModel: kStation1TakeawayModel,
    takeawayKeywords: kStation1TakeawayKeywords,
    checkpoint: kStation1Checkpoint,
    badgeAsset: 'badge_research_beginner.png',
    nextStationMessage:
        'Great work, Young Researcher! Station 2 is now unlocked on the Expedition Map.',
  ),
  'station2': StationContent(
    intro: kStation2Intro,
    content: kStation2Content,
    discoveryTitle: 'Discovery Stop: Moss Distribution',
    takeawayPrompt: kStation2TakeawayPrompt,
    takeawayModel: kStation2TakeawayModel,
    takeawayKeywords: kStation2TakeawayKeywords,
    checkpoint: kStation2Checkpoint,
    badgeAsset: kStation2BadgeAsset,
    nextStationMessage:
        'Excellent sampling! Station 3 is now unlocked on the Expedition Map.',
  ),
  'station3': StationContent(
    intro: kStation3Intro,
    content: kStation3Content,
    discoveryTitle: 'Discovery Stop: In Vitro Propagation',
    takeawayPrompt: kStation3TakeawayPrompt,
    takeawayModel: kStation3TakeawayModel,
    takeawayKeywords: kStation3TakeawayKeywords,
    checkpoint: kStation3Checkpoint,
    badgeAsset: kStation3BadgeAsset,
    nextStationMessage: kStation3BadgeNextMessage,
  ),
  'station4': StationContent(
    intro: kStation4Intro,
    content: kStation4Content,
    discoveryTitle: 'Discovery Stop: Phytochemical Screening',
    takeawayPrompt: kStation4TakeawayPrompt,
    takeawayModel: kStation4TakeawayModel,
    takeawayKeywords: kStation4TakeawayKeywords,
    checkpoint: kStation4Checkpoint,
    badgeAsset: kStation4BadgeAsset,
    nextStationMessage: kStation4BadgeNextMessage,
  ),
  'station5': StationContent(
    intro: kStation5Intro,
    content: kStation5Content,
    discoveryTitle: 'Discovery Stop: Antibacterial Assay',
    takeawayPrompt: kStation5TakeawayPrompt,
    takeawayModel: kStation5TakeawayModel,
    takeawayKeywords: kStation5TakeawayKeywords,
    checkpoint: kStation5Checkpoint,
    badgeAsset: kStation5BadgeAsset,
    nextStationMessage: kStation5BadgeNextMessage,
  ),
};

StationContent contentOf(String key) => kStationContent[key]!;
