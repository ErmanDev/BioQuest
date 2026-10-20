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

  /// Single target-competency statement (with DepEd code), shown above the
  /// objectives in the Mission Targets overlay. Null for stations that don't
  /// have one recorded yet.
  final String? targetCompetency;
  final List<String> missionTargets;

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
    this.targetCompetency,
    required this.missionTargets,
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
    targetCompetency:
        'Chooses appropriate quantitative research design (CS_RS12-IIa-c-1)',
    missionTargets: [
      'Identify the characteristics and purposes of different quantitative research designs.',
      'Choose the appropriate quantitative research design for a given research situation.',
      'Recognize the importance of selecting an appropriate quantitative research design in conducting research.',
    ],
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
    targetCompetency:
        'Describes sampling procedure and the sample (CS_RS12-IIa-c-2)',
    missionTargets: [
      'Describe appropriate sampling procedures used in a research study.',
      'Identify the population and sample in a given research situation.',
      'Recognize the importance of proper sampling in obtaining accurate '
          'and reliable research data.',
    ],
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
    targetCompetency:
        'Plans data collection procedure (CS_RS12-IIa-c-5)\n'
        'Collect data using appropriate research instruments (CS_RS12-IId-g-1)',
    missionTargets: [
      '**Identify** appropriate research instruments and their purposes in data collection.',
      '**Plan** an appropriate data collection procedure using suitable research instruments.',
      '**Recognize** the importance of accurate and reliable data collection in scientific investigations.',
    ],
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
    targetCompetency:
        'Presents and interprets data in tabular and graphical forms (CS_RS12-IId-g-2)',
    missionTargets: [
      'Identify appropriate tabular and graphical forms for presenting scientific data.',
      'Present scientific data using appropriate tables and graphs.',
      'Recognize the importance of accurate data presentation and interpretation in communicating scientific findings.',
    ],
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
    targetCompetency:
        'Plans data analysis using statistics and hypothesis testing (CS_RS12-IIa-c-6)',
    missionTargets: [
      'Identify the steps involved in planning data analysis using statistics and hypothesis testing.',
      'Analyze experimental data using appropriate statistical tools and hypothesis testing.',
      'Recognize the importance of statistical analysis in making evidence-based scientific conclusions.',
    ],
  ),
};

StationContent contentOf(String key) => kStationContent[key]!;
