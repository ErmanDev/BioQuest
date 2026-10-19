import '../models/mc_question.dart';
import '../models/vocab_word.dart';

const String kStation5DiscoveryBackgroundAsset =
    'assets/images/station5/discovery_stop_station_5.png';

const String kStation5DiscoveryContentImageAsset =
    'assets/images/station5/station_5_content_image.jpg';

const String kStation5DiscoveryGraphicalAsset =
    'assets/images/station5/graphical_presentation_station5.png';

const String kStation5MissionBackgroundAsset =
    'assets/images/station5/station5.png';

const String kStation5TakeawayBackgroundAsset =
    'assets/images/station5/station5_takeaway_question.png';

const String kStation5TrailCheckpointBackgroundAsset =
    'assets/images/station5/trail_checkpoint_station_5.png';

const String kStation5CheckpointDirections =
    'Read each question carefully and choose the letter of the best answer.';

const String kStation5BadgeBackgroundAsset =
    kStation5TrailCheckpointBackgroundAsset;

const String kStation5BadgeAsset = 'badge_data_decoding.png';

const String kStation5BadgeNextMessage =
    'Mission complete! The Discovery Summit is now unlocked on the Expedition Map.';

const String kStation5Activity1Title = 'ACTIVITY: PLAN THE DATA ANALYSIS';

const String kStation5Activity1Instruction =
    'Researchers follow specific steps when planning data analysis using '
    'statistics and hypothesis testing.\n\n'
    '**Your task:** Arrange the steps in the correct order from 1 to 6.';

const String kStation5Activity1Tip =
    'A good data analysis follows a logical flow—from collecting data to '
    'making a conclusion based on evidence.';

/// Welcome script for Station 5 (spoken by the avatar when the station opens).
/// Word Quest vocabulary shown in the Discovery Stop overlay. Context
/// sentences use **bold** and *italic* markup.
const List<VocabWord> kStation5Vocabulary = [
  VocabWord(
    term: 'Antibacterial Assay',
    definition:
        'A laboratory test used to determine whether a substance can prevent '
        'or stop the growth of bacteria.',
    context:
        'Scientists use an **antibacterial assay** to determine whether moss '
        'extracts can inhibit the growth of harmful bacteria.',
  ),
  VocabWord(
    term: 'Zone of Inhibition',
    definition: 'The clear area around a substance where bacteria do not grow.',
    context:
        'After incubation, a **zone of inhibition** may appear around the '
        'paper disk containing moss extract, indicating antibacterial '
        'activity.',
  ),
  VocabWord(
    term: 'Hypothesis',
    definition:
        'A testable prediction about the possible outcome of a research '
        'investigation.',
    context:
        'The researcher formulates a **hypothesis** to predict whether '
        '*Pyrrhobryum* and *Ectropothecium* will have different antibacterial '
        'effects.',
  ),
  VocabWord(
    term: 'Replicate',
    definition:
        'A repeated trial or measurement of the same treatment in an '
        'experiment.',
    context:
        'Researchers conducted five **replicates** for each treatment to make '
        'the results more reliable.',
  ),
  VocabWord(
    term: 'Statistical Significance',
    definition:
        'A result that shows a difference is unlikely to have occurred simply '
        'by chance.',
    context:
        'A statistical test is used to determine whether the difference in '
        'antibacterial activity between the two moss genera is '
        '**statistically significant**.',
  ),
  VocabWord(
    term: 'Null Hypothesis',
    definition:
        'A statement that predicts there is no significant difference or '
        'effect between groups being studied.',
    context:
        'The **null hypothesis** states that there is no significant '
        'difference between the antibacterial effects of *Pyrrhobryum* and '
        '*Ectropothecium*.',
  ),
];

const String kStation5Intro =
    'Welcome, young researchers! In this station, you will enter the Defense '
    'Laboratory, where scientists investigate the antibacterial properties of '
    'moss through a process called antibacterial assay. Here, you will '
    'discover that mosses produce natural compounds which help protect them '
    'from harmful bacteria in their environment.\n\n'
    'But this station is not only about testing moss extracts against '
    'bacteria. More importantly, it will train you to think and work like real '
    'researchers by learning how to:\n'
    '• Plan data analysis using statistics and hypothesis testing\n\n'
    'As you explore the fascinating antibacterial properties of mosses, you '
    'will also discover that successful scientific investigations require '
    'proper data analysis, careful interpretation of results, and logical '
    'decision-making based on scientific evidence.';

/// Research Mission story shown before the first activity.
const String kStation5MissionStory =
    'Welcome, young researchers!\n\n'
    'You are now officially part of the Moss Detectives Research Team. A '
    'mysterious bacterial outbreak has affected a nearby community laboratory, '
    'and scientists need your help to identify which moss genus may contain '
    'stronger antibacterial properties.\n\n'
    'Your mission is to investigate the antibacterial activity of the moss '
    'genera Pyrrhobryum and Ectropothecium against Escherichia coli using '
    'scientific reasoning, statistics, and hypothesis testing.\n\n'
    'Will your team successfully identify the stronger antibacterial moss?\n'
    'Let the investigation begin!';

/// Voiceover script when opening Station 5 (splash / intro).
String get kStation5IntroNarration => kStation5Intro.replaceAll('• ', '');

/// Discovery Stop reading content. Wrap key terms in ** for bold emphasis.
const String kStation5DiscoveryPart1 =
    'Mosses are small plants that usually grow in **moist and shaded places** '
    'where **bacteria** and other **microorganisms** are commonly present. '
    'Because mosses are constantly exposed to these microorganisms, some '
    'species produce **natural compounds** that help protect them from harmful '
    'bacteria and allow them to survive in their environment. These compounds '
    'may have **antibacterial properties** that can inhibit or prevent bacterial '
    'growth. Due to this ability, scientists study mosses to determine whether '
    'their extracts can be used as possible **natural antibacterial agents**.';

const String kStation5DiscoveryPart2 =
    'One commonly used method in studying antibacterial activity is the '
    '**Kirby-Bauer Method**, also known as the **disk diffusion method**. In '
    'this procedure, paper disks soaked with **moss extract** are placed on '
    '**agar plates** containing bacterial cultures. After **incubation**, a '
    'clear area surrounding the disk called the **zone of inhibition** may '
    'appear. This clear zone shows that the bacteria were unable to grow near '
    'the moss extract because of its antibacterial effect. Generally, **larger '
    'zones of inhibition** show **stronger antibacterial activity**.';

const String kStation5DiscoveryPart3 =
    'In scientific investigations like this, researchers do not rely on '
    'observations alone; rather, they carefully **organize**, **analyze**, and '
    '**interpret** the gathered data to make **evidence-based conclusions**. So, '
    'to ensure that the gathered data is properly analyzed and interpreted, '
    'researchers follow several important steps in planning data analysis using '
    '**statistics** and **hypothesis testing**.';

const String kStation5DiscoveryStepsIntro =
    'Here are the steps researchers follow in planning data analysis using '
    'statistics and hypothesis testing:';

const String kStation5DiscoverySampleIntro =
    'To better understand these steps, let us refer to a sample antibacterial '
    'investigation created for the purpose of helping us understand how data '
    'analysis is planned in an experiment. In this example, the moss genera '
    'Pyrrhobryum and Ectropothecium were tested against Escherichia coli using '
    'the Kirby-Bauer Method.';

const String kStation5DiscoverySampleContinuation =
    'The investigation also included a **positive control** containing a known '
    'antibacterial agent and a **negative control** containing a substance '
    'without antibacterial properties. To make the results more reliable, '
    '**five replicates** were conducted for each treatment. After incubation, '
    'the zones of inhibition produced by the moss extracts and controls were '
    'measured and recorded.';

const String kStation5DiscoveryDetailStep1 =
    '**Step 1 – Identify the Data to be Gathered**\n\n'
    'In this step, the researcher identifies the information needed from the '
    'investigation. This helps the researcher determine the measurements that '
    'are important in answering the research problem.\n\n'
    '**Example:** The researcher measures and records the diameters of the '
    'zones of inhibition produced by **Pyrrhobryum**, **Ectropothecium**, and '
    'the controls against **Escherichia coli** for all five replicates.';

const String kStation5DiscoveryDetailStep2 =
    '**Step 2 – Formulate the Hypothesis**\n\n'
    'In this step, the researcher formulates a hypothesis or scientific '
    'prediction about the possible outcome of the investigation. A hypothesis '
    'is important because it guides the researcher in analyzing and '
    'interpreting the gathered data.\n\n'
    '**Example:**\n\n'
    '**Null Hypothesis (H₀):** There is no significant difference between the '
    'antibacterial effects of the moss genera Pyrrhobryum and Ectropothecium '
    'against Escherichia coli.\n\n'
    '**Alternative Hypothesis (H₁):** There is a significant difference '
    'between the antibacterial effects of the moss genera Pyrrhobryum and '
    'Ectropothecium against Escherichia coli.';

const String kStation5DiscoveryDetailStep3Intro =
    '**Step 3 – Organize the Gathered Data**\n\n'
    'After collecting the measurements, the researcher organizes the data into '
    'tables for easier comparison and interpretation. Organizing the data helps '
    'the researcher identify patterns and differences among treatments.\n\n'
    '**Example:**';

const String kStation5DiscoveryDetailStep3Note =
    '(Note: The data presented above are hypothetical or sample data created '
    'only for the purpose of demonstrating how data may be organized and '
    'analyzed in an antibacterial investigation).';

const String kStation5DiscoveryDetailStep4Intro =
    '**Step 4 – Choose the Appropriate Statistical Tool**\n\n'
    'In this step, the researcher selects the appropriate statistical tools to '
    'analyze and present the collected data accurately. These tools help '
    'summarize results, compare treatments, and determine whether differences '
    'in measurements are likely significant or due to chance.\n\n'
    'In antibacterial investigations like this, researchers often use the '
    '**mean** (average) to summarize repeated measurements into one value, '
    'making the data easier to compare. The mean shows the overall '
    'antibacterial activity observed for each treatment based on the gathered '
    'data.';

const String kStation5DiscoveryDetailStep4Tools =
    'Other statistical tools commonly used in experimental research include '
    '**percentage**, **t-test**, and **Analysis of Variance (ANOVA)**. '
    'Graphical presentations such as **bar graphs** may also be used to '
    'visually compare the gathered data.\n\n'
    '**Example:** In this investigation, the researcher computes the mean zone '
    'of inhibition from the five replicates to determine the antibacterial '
    'activity of Pyrrhobryum and Ectropothecium against Escherichia coli.';

const String kStation5DiscoveryMeanFormula =
    'For example, the mean for Pyrrhobryum is computed as:\n\n'
    'Mean = (18 + 17 + 19 + 18 + 18) / 5 = **18.0 mm**\n\n'
    'The computed means may then be presented using a bar graph to visually '
    'compare the antibacterial effects of the treatments. Since the '
    'investigation compares the antibacterial activities of two moss genera, '
    'a **t-test** may also be used to determine whether the difference between '
    'their antibacterial effects is significant.';

const String kStation5DiscoveryDetailStep5 =
    '**Step 5 – Compare and Interpret the Results**\n\n'
    'In this step, the researcher examines the results to determine which moss '
    'genus shows stronger antibacterial activity based on the observed mean '
    'values. This step helps the researcher explain the findings clearly using '
    'scientific evidence.\n\n'
    '**Example:** Pyrrhobryum produced a larger mean zone of inhibition than '
    'Ectropothecium. This suggests that Pyrrhobryum may have stronger '
    'antibacterial activity against Escherichia coli than Ectropothecium in '
    'this sample investigation.\n\n'
    '(Note: The positive control was not included in the main interpretation '
    'because its purpose is to confirm that the antibacterial assay is working '
    'properly. The negative control shows whether bacterial growth occurs '
    'normally without treatment. These controls help ensure that the results '
    'of the moss treatments are valid and reliable.)';

const String kStation5DiscoveryDetailStep6 =
    '**Step 6 – Accept or Reject the Hypothesis**\n\n'
    'In this step, the researcher uses the analyzed results and statistical '
    'tests to determine whether the evidence supports or rejects the '
    'hypothesis. This ensures that conclusions are based on scientific '
    'evidence and not merely on chance differences in the data.\n\n'
    'The **mean** alone is not enough to accept or reject a hypothesis. '
    'Researchers must use statistical tests such as the **t-test** or **ANOVA** '
    'to determine whether the observed differences are truly significant.\n\n'
    '**Example:** When comparing the antibacterial activity of Pyrrhobryum and '
    'Ectropothecium against Escherichia coli, a t-test showed that the '
    'difference between their mean zones of inhibition was significant. '
    'Therefore, the researcher **rejects the null hypothesis**.\n\n'
    'Young researchers, remember that successful investigations depend not '
    'only on conducting experiments properly, but also on how carefully you '
    '**organize**, **analyze**, and **interpret data** using **statistics** and '
    '**hypothesis testing**.';

const List<String> kStation5DiscoveryReplicateHeaders = [
  'Treatment',
  'Replicate 1',
  'Replicate 2',
  'Replicate 3',
  'Replicate 4',
  'Replicate 5',
];

const List<String> kStation5DiscoveryMeanHeaders = [
  'Treatment',
  'Replicate 1',
  'Replicate 2',
  'Replicate 3',
  'Replicate 4',
  'Replicate 5',
  'Mean (mm)',
];

const List<({String treatment, List<String> values, String? mean})>
kStation5DiscoveryRawZoneRows = [
  (
    treatment: 'Pyrrhobryum',
    values: ['18 mm', '17 mm', '19 mm', '18 mm', '18 mm'],
    mean: null,
  ),
  (
    treatment: 'Ectropothecium',
    values: ['12 mm', '11 mm', '13 mm', '12 mm', '12 mm'],
    mean: null,
  ),
  (
    treatment: 'Positive Control',
    values: ['22 mm', '21 mm', '22 mm', '23 mm', '22 mm'],
    mean: null,
  ),
  (
    treatment: 'Negative Control',
    values: ['0 mm', '0 mm', '0 mm', '0 mm', '0 mm'],
    mean: null,
  ),
];

const List<({String treatment, List<String> values, String? mean})>
kStation5DiscoveryMeanZoneRows = [
  (
    treatment: 'Pyrrhobryum',
    values: ['18 mm', '17 mm', '19 mm', '18 mm', '18 mm'],
    mean: '18.0 mm',
  ),
  (
    treatment: 'Ectropothecium',
    values: ['12 mm', '11 mm', '13 mm', '12 mm', '12 mm'],
    mean: '12.0 mm',
  ),
  (
    treatment: 'Positive Control',
    values: ['22 mm', '21 mm', '22 mm', '23 mm', '22 mm'],
    mean: '22.0 mm',
  ),
  (
    treatment: 'Negative Control',
    values: ['0 mm', '0 mm', '0 mm', '0 mm', '0 mm'],
    mean: '0 mm',
  ),
];

const String kStation5Content =
    '$kStation5DiscoveryPart1\n\n'
    '$kStation5DiscoveryPart2\n\n'
    '$kStation5DiscoveryPart3\n\n'
    '$kStation5DiscoveryStepsIntro\n\n'
    '$kStation5DiscoverySampleIntro\n\n'
    '$kStation5DiscoverySampleContinuation\n\n'
    '$kStation5DiscoveryDetailStep1\n\n'
    '$kStation5DiscoveryDetailStep2\n\n'
    '$kStation5DiscoveryDetailStep3Intro\n\n'
    '$kStation5DiscoveryDetailStep3Note\n\n'
    '$kStation5DiscoveryDetailStep4Intro\n\n'
    '$kStation5DiscoveryDetailStep4Tools\n\n'
    '$kStation5DiscoveryMeanFormula\n\n'
    '$kStation5DiscoveryDetailStep5\n\n'
    '$kStation5DiscoveryDetailStep6';

/// Mission Activity 1: order the 6 steps of planning data analysis.
const List<String> kStation5Steps = [
  'Identify the Data to be Gathered',
  'Formulate the Hypothesis',
  'Organize the Gathered Data',
  'Choose the Appropriate Statistical Tool',
  'Compare and Interpret the Results',
  'Accept or Reject the Hypothesis',
];

/// Mission Activity 2: interactive data sorting — drag items to folders.
const String kStation5SortTitle = 'INTERACTIVE DATA SORTING';
const String kStation5SortQuestion =
    'What data should be gathered in an antibacterial assay investigation?';
const String kStation5SortInstruction = 'Drag each item to the correct folder.';
const String kStation5SortNeedLabel = 'NEED (DATA TO BE COLLECTED)';
const String kStation5SortNotNeedLabel =
    'NOT NECESSARILY NEEDED (NOT ESSENTIAL FOR THE INVESTIGATION)';
const String kStation5SortTrayLabel = 'ITEMS TO SORT (DRAGGABLE)';

/// Each item: label and whether it belongs in the NEED folder.
const List<({String label, bool important})> kStation5DataItems = [
  (label: 'Zone of inhibition measurements', important: true),
  (label: 'Number of replicates', important: true),
  (label: 'Type of bacteria used', important: true),
  (label: 'Moss extract used', important: true),
  (label: 'Positive control results', important: true),
  (label: 'Mean of measurements', important: true),
  (label: 'Shape of bacterial colony', important: false),
  (label: 'Color of agar plate', important: false),
  (label: 'Name of researcher', important: false),
  (label: 'Laboratory room color', important: false),
];

/// Mission Activity 3: write null and alternative hypotheses from the overview.
const String kStation5HypothesisMissionTitle = 'RESEARCH MISSION';
const String kStation5HypothesisChallenge = 'MAKE A SCIENTIFIC PREDICTION!';
const String kStation5HypothesisDirectionsTitle = 'DIRECTIONS:';
const List<String> kStation5HypothesisDirections = [
  'Read and understand the research overview carefully.',
  'Based on the research overview, write your own NULL HYPOTHESIS (H₀) and '
      'ALTERNATIVE HYPOTHESIS (H₁) in the spaces provided.',
  'Make sure your hypotheses are testable and related to the antibacterial '
      'investigation.',
];
const String kStation5ResearchOverviewTitle = 'RESEARCH OVERVIEW';
const String kStation5ResearchOverview =
    'The antibacterial activity of Pyrrhobryum moss extract will be tested '
    'using the disc diffusion method against Escherichia coli. Two '
    'concentrations of the extract will be used: 100% and 50%. The 100% '
    'concentration contains only the moss extract with no added water. The 50% '
    'concentration contains moss extract mixed with water. Both concentrations '
    'will be applied to paper discs and placed on agar plates inoculated with '
    'Escherichia coli. After incubation, the zones of inhibition around each '
    'disc will be measured. The zones of inhibition are used to determine the '
    'strength of antibacterial activity.';
const String kStation5NullHypothesisLabel = 'NULL HYPOTHESIS';
const String kStation5AlternativeHypothesisLabel = 'ALTERNATIVE HYPOTHESIS';

const String kStation5NullHypothesisModel =
    'There is no significant difference in the antibacterial activity of the '
    '100% and 50% concentrations of Pyrrhobryum moss extract against '
    'Escherichia coli.';

const String kStation5AlternativeHypothesisModel =
    'There is a significant difference in the antibacterial activity of the '
    '100% and 50% concentrations of Pyrrhobryum moss extract against '
    'Escherichia coli.';

const List<String> kStation5NullHypothesisKeywords = [
  'no significant difference',
  'no difference',
  'not significant',
  '100',
  '50',
  'pyrrhobryum',
  'escherichia',
  'coli',
  'antibacterial',
  'concentration',
];

const List<String> kStation5AlternativeHypothesisKeywords = [
  'significant difference',
  '100',
  '50',
  'pyrrhobryum',
  'escherichia',
  'coli',
  'antibacterial',
  'concentration',
];

const int kStation5NullHypothesisMinMatches = 4;
const int kStation5AlternativeHypothesisMinMatches = 4;

/// Scores one hypothesis field (0–2) by keyword overlap with the sample answer.
int scoreStation5HypothesisField(
  String input,
  List<String> keywords, {
  required int minMatches,
  bool Function(String normalized)? isInvalid,
}) {
  final normalized = input.toLowerCase().trim();
  if (normalized.isEmpty) return 0;
  if (isInvalid != null && isInvalid(normalized)) return 0;
  final hits = keywords.where(normalized.contains).length;
  if (hits >= minMatches + 2) return 2;
  if (hits >= minMatches) return 1;
  return 0;
}

bool _station5NullHypothesisInvalid(String normalized) {
  if (normalized.contains('no significant difference')) return false;
  if (normalized.contains('no difference')) return false;
  if (normalized.contains('not significant')) return false;
  return normalized.contains('significant difference');
}

bool _station5AlternativeHypothesisInvalid(String normalized) =>
    normalized.contains('no significant difference');

/// Mission point for Activity 3: 1 when both hypotheses align well enough with
/// the sample answers; 0 otherwise. Empty answers are allowed but score 0.
int scoreStation5HypothesisAnswers(
  String nullHypothesis,
  String altHypothesis,
) {
  final nullScore = scoreStation5HypothesisField(
    nullHypothesis,
    kStation5NullHypothesisKeywords,
    minMatches: kStation5NullHypothesisMinMatches,
    isInvalid: _station5NullHypothesisInvalid,
  );
  final altScore = scoreStation5HypothesisField(
    altHypothesis,
    kStation5AlternativeHypothesisKeywords,
    minMatches: kStation5AlternativeHypothesisMinMatches,
    isInvalid: _station5AlternativeHypothesisInvalid,
  );
  if (nullScore >= 1 && altScore >= 1) return 1;
  return 0;
}

/// Mission Activity 4: compute means and place bars on the graph.
const String kStation5MeanBarTitle = 'DATA ANALYSIS MISSION!';
const String kStation5MeanBarSubtitle =
    'COMPUTE THE MEAN AND DRAW YOUR BAR GRAPH';
const String kStation5MeanBarSuppose =
    'Researchers tested two concentrations (100% and 50%) of Pyrrhobryum moss '
    'extract against Escherichia coli using the disc diffusion method. The '
    'zones of inhibition were measured in millimeters across five replicates.';
const String kStation5MeanBarTableTitle =
    'GATHERED DATA: ZONE OF INHIBITION (mm)';
const List<int> kStation5MeanBar100Values = [18, 20, 19, 21, 20];
const List<int> kStation5MeanBar50Values = [11, 12, 10, 13, 11];
const int kStation5MeanBarReplicateCount = 5;
const double kStation5MeanBar100Mean = 19.6;
const double kStation5MeanBar50Mean = 11.4;
const double kStation5MeanBarMeanTolerance = 0.6;
const double kStation5MeanBarGraphMax = 30;

bool station5MeanValueCorrect(String input, double expected) {
  final value = double.tryParse(input.trim());
  if (value == null) return false;
  return (value - expected).abs() <= kStation5MeanBarMeanTolerance;
}

/// Mission point: 1 when both means and both bar placements are correct.
int scoreStation5MeanBarActivity({
  required String mean100,
  required String mean50,
  required int? barOn50Slot,
  required int? barOn100Slot,
}) {
  final meansOk =
      station5MeanValueCorrect(mean100, kStation5MeanBar100Mean) &&
      station5MeanValueCorrect(mean50, kStation5MeanBar50Mean);
  final barsOk = barOn50Slot == 0 && barOn100Slot == 1;
  if (meansOk && barsOk) return 1;
  return 0;
}

/// Mission Activity 5: interpret the mean and bar graph results.
const String kStation5InterpretationTitle = 'INTERPRET YOUR RESULTS';
const int kStation5InterpretationMaxScore = 9;

const List<({String prompt, String modelAnswer})>
kStation5InterpretationQuestions = [
  (
    prompt:
        'Which concentration of Pyrrhobryum moss extract produced the larger '
        'mean zone of inhibition?',
    modelAnswer: '100% concentration',
  ),
  (
    prompt:
        'What does the difference in the height of the bars indicate about the '
        'antibacterial activity of the two concentrations?',
    modelAnswer:
        'The difference in the height of the bars indicates that the two '
        'concentrations have different levels of antibacterial activity. A '
        'taller bar means stronger antibacterial activity and a larger zone of '
        'inhibition.',
  ),
  (
    prompt:
        'Based on the results, which concentration appears to be more effective '
        'against Escherichia coli?',
    modelAnswer:
        'Based on the results, the 100% concentration appears to be more '
        'effective against Escherichia coli.',
  ),
];

bool station5AnswerMentions100Percent(String input) {
  final normalized = input.toLowerCase().trim();
  if (normalized.isEmpty) return false;
  return normalized.contains('100%') ||
      normalized.contains('100 percent') ||
      RegExp(r'\b100\b').hasMatch(normalized);
}

/// Q1 — 2 points when the answer mentions 100%.
int scoreStation5InterpretationQ1(String input) {
  return station5AnswerMentions100Percent(input) ? 2 : 0;
}

/// Q2 — up to 5 points for the full interpretation (same thought as sample).
int scoreStation5InterpretationQ2(String input) {
  final normalized = input.toLowerCase().trim();
  if (normalized.isEmpty) return 0;

  final hasDifferentActivity =
      normalized.contains('different') &&
      (normalized.contains('antibacterial') || normalized.contains('activity'));
  final hasTallerStronger =
      (normalized.contains('taller') ||
          normalized.contains('higher') ||
          normalized.contains('greater')) &&
      (normalized.contains('stronger') ||
          normalized.contains('more') ||
          normalized.contains('greater'));
  final hasZoneIdea =
      normalized.contains('zone of inhibition') ||
      (normalized.contains('inhibition') &&
          (normalized.contains('larger') ||
              normalized.contains('bigger') ||
              normalized.contains('greater')));

  if (hasDifferentActivity && hasTallerStronger && hasZoneIdea) return 5;
  if (hasDifferentActivity && (hasTallerStronger || hasZoneIdea)) return 3;
  if (hasDifferentActivity || hasTallerStronger || hasZoneIdea) return 1;
  return 0;
}

/// Q3 — 2 points when the answer mentions 100%.
int scoreStation5InterpretationQ3(String input) {
  return station5AnswerMentions100Percent(input) ? 2 : 0;
}

/// Returns 0–9 points for the three interpretation answers.
int scoreStation5InterpretationActivity(List<String> answers) {
  if (answers.length != kStation5InterpretationQuestions.length) return 0;
  return scoreStation5InterpretationQ1(answers[0]) +
      scoreStation5InterpretationQ2(answers[1]) +
      scoreStation5InterpretationQ3(answers[2]);
}

/// Mission Activity 6: reject/accept H₀ and write a scientific conclusion.
const String kStation5FinalDecisionTitle = 'FINAL DECISION CHALLENGE!';
const String kStation5FinalDecisionSubtitle =
    'USE THE RESULTS TO MAKE A STATISTICAL DECISION';
const String kStation5FinalDecisionFindingsTitle = 'RESEARCH FINDINGS';
const String kStation5FinalDecisionFindingsIntro =
    'A statistician analyzed the gathered data from the antibacterial '
    'investigation comparing the 100% and 50% concentrations of Pyrrhobryum '
    'moss extract against Escherichia coli.';
const String kStation5FinalDecisionFindingsResult =
    'After performing statistical analysis, the results showed that there is '
    'a SIGNIFICANT DIFFERENCE between the antibacterial activities of the two '
    'concentrations.';
const String kStation5FinalDecisionPrompt =
    'Based on the statistical results, should the researchers:';
const String kStation5FinalDecisionRejectLabel =
    'REJECT THE NULL HYPOTHESIS (H₀)';
const String kStation5FinalDecisionAcceptLabel =
    'ACCEPT THE NULL HYPOTHESIS (H₀)';
const String kStation5FinalDecisionConclusionTitle = 'WRITE YOUR CONCLUSION';
const String kStation5FinalDecisionConclusionPrompt =
    'Using the results of the investigation, write your scientific conclusion '
    'in the space provided below.';
const String kStation5FinalDecisionConclusionModel =
    'The results of the investigation showed that the 100% concentration of '
    'Pyrrhobryum moss extract produced a larger mean zone of inhibition '
    'compared to the 50% concentration against Escherichia coli. This indicates '
    'that the higher concentration exhibited stronger antibacterial activity. '
    'Therefore, the researchers reject the Null Hypothesis (H₀) because there '
    'is a significant difference between the antibacterial activities of the '
    'two concentrations.';

const List<String> kStation5FinalDecisionConclusionKeywords = [
  '100',
  '50',
  'larger',
  'greater',
  'zone of inhibition',
  'inhibition',
  'stronger',
  'antibacterial',
  'reject',
  'null',
  'h0',
  'h₀',
  'significant',
  'difference',
  'escherichia',
  'coli',
];

const int kStation5FinalDecisionReject = 0;
const int kStation5FinalDecisionAccept = 1;
const int kStation5FinalDecisionCorrect = kStation5FinalDecisionReject;
const int kStation5FinalDecisionDecisionPoints = 2;
const int kStation5FinalDecisionConclusionMaxPoints = 5;

int scoreStation5FinalDecisionChoice(int? decision) {
  if (decision == kStation5FinalDecisionCorrect) {
    return kStation5FinalDecisionDecisionPoints;
  }
  return 0;
}

bool station5ConclusionCorrectConcentration(String input) {
  final normalized = input.toLowerCase().trim();
  if (station5ConclusionWrongConcentration(input)) return false;

  final higherConcentration =
      normalized.contains('higher concentration') ||
      normalized.contains('full concentration') ||
      normalized.contains('100% concentration');
  final positiveOutcome =
      normalized.contains('stronger') ||
      normalized.contains('more effective') ||
      normalized.contains('more antibacterial') ||
      ((normalized.contains('larger') ||
              normalized.contains('greater') ||
              normalized.contains('bigger')) &&
          (normalized.contains('zone') ||
              normalized.contains('inhibition') ||
              normalized.contains('activity')));

  if (higherConcentration && positiveOutcome) return true;
  if (!station5AnswerMentions100Percent(normalized)) return false;

  return positiveOutcome ||
      (normalized.contains('compared') &&
          (normalized.contains('larger') ||
              normalized.contains('greater') ||
              normalized.contains('higher'))) ||
      (normalized.contains('effective') &&
          !normalized.contains('less effective'));
}

bool station5ConclusionWrongConcentration(String input) {
  final normalized = input.toLowerCase().trim();

  final fiftyPositive =
      (normalized.contains('50%') ||
          RegExp(r'\b50\s*%').hasMatch(normalized)) &&
      (normalized.contains('stronger') ||
          normalized.contains('more effective') ||
          normalized.contains('larger') ||
          normalized.contains('greater') ||
          normalized.contains('better'));

  final hundredPositive =
      station5AnswerMentions100Percent(normalized) &&
      (normalized.contains('stronger') ||
          normalized.contains('more effective') ||
          normalized.contains('larger') ||
          normalized.contains('greater') ||
          normalized.contains('better') ||
          (normalized.contains('effective') && !normalized.contains('less')));

  if (fiftyPositive && !hundredPositive) return true;

  if (normalized.contains('accept') &&
      (normalized.contains('null') ||
          normalized.contains('h0') ||
          normalized.contains('h₀'))) {
    return true;
  }

  return false;
}

bool station5ConclusionRejectsNull(String input) {
  final normalized = input.toLowerCase().trim();
  return (normalized.contains('reject') || normalized.contains('rejected')) &&
      (normalized.contains('null') ||
          normalized.contains('h0') ||
          normalized.contains('h₀'));
}

bool station5ConclusionMentionsSignificantDifference(String input) {
  final normalized = input.toLowerCase().trim();
  return normalized.contains('significant') &&
      normalized.contains('difference');
}

bool station5ConclusionExplainsZoneLink(String input) {
  final normalized = input.toLowerCase().trim();
  final hasZoneIdea =
      normalized.contains('zone of inhibition') ||
      (normalized.contains('inhibition') &&
          (normalized.contains('zone') || normalized.contains('mean')));
  final hasLarger =
      normalized.contains('larger') ||
      normalized.contains('greater') ||
      normalized.contains('bigger') ||
      normalized.contains('higher');
  final hasStrongerActivity =
      normalized.contains('stronger') ||
      normalized.contains('antibacterial') ||
      normalized.contains('more effective');
  final hasCausalLink =
      normalized.contains('indicate') ||
      normalized.contains('indicates') ||
      normalized.contains('means') ||
      normalized.contains('shows') ||
      normalized.contains('demonstrate') ||
      normalized.contains('suggest');

  if (hasZoneIdea && hasLarger && hasStrongerActivity) return true;
  if (hasZoneIdea && hasStrongerActivity && hasCausalLink) return true;
  if (normalized.contains('zone of inhibition') &&
      normalized.contains('stronger antibacterial')) {
    return true;
  }
  return false;
}

bool station5ConclusionMentionsAntibacterial(String input) {
  final normalized = input.toLowerCase().trim();
  return normalized.contains('antibacterial') ||
      normalized.contains('zone of inhibition') ||
      (normalized.contains('inhibition') && !normalized.contains('null'));
}

bool station5ConclusionIsUnrelated(String input) {
  final normalized = input.toLowerCase().trim();
  if (normalized.isEmpty) return true;
  return !station5ConclusionMentionsAntibacterial(input) &&
      !station5AnswerMentions100Percent(normalized) &&
      !normalized.contains('50') &&
      !normalized.contains('hypothesis') &&
      !normalized.contains('null') &&
      !normalized.contains('concentration') &&
      !normalized.contains('moss') &&
      !normalized.contains('extract');
}

/// Scores the conclusion essay 0–5 using the condition-for-scoring rubric:
/// 5 — 100% stronger, significant difference, reject H₀, zone→activity link.
/// 4 — correct concentration + (significant difference OR reject H₀).
/// 3 — correct concentration, partial understanding.
/// 2 — antibacterial mentioned but results explained incorrectly.
/// 1 — very unclear or incomplete science response.
/// 0 — empty or unrelated.
int scoreStation5FinalDecisionConclusion(String conclusion) {
  if (station5ConclusionIsUnrelated(conclusion)) return 0;

  final normalized = conclusion.toLowerCase().trim();
  final correctConcentration = station5ConclusionCorrectConcentration(
    conclusion,
  );
  final hasSignificant = station5ConclusionMentionsSignificantDifference(
    conclusion,
  );
  final hasReject = station5ConclusionRejectsNull(conclusion);
  final hasZoneLink = station5ConclusionExplainsZoneLink(conclusion);
  final wrongConcentration = station5ConclusionWrongConcentration(conclusion);
  final mentionsAntibacterial = station5ConclusionMentionsAntibacterial(
    conclusion,
  );

  if (correctConcentration && hasSignificant && hasReject && hasZoneLink) {
    return 5;
  }
  if (correctConcentration && (hasSignificant || hasReject)) {
    return 4;
  }
  if (correctConcentration) {
    return 3;
  }
  if (mentionsAntibacterial &&
      (wrongConcentration ||
          normalized.contains('no significant') ||
          normalized.contains('not significant'))) {
    return 2;
  }
  if (mentionsAntibacterial && normalized.length > 15) {
    return 2;
  }
  return 1;
}

int scoreStation5FinalDecisionActivity({
  required int? decision,
  required String conclusion,
}) {
  return scoreStation5FinalDecisionChoice(decision) +
      scoreStation5FinalDecisionConclusion(conclusion);
}

const int kStation5FinalDecisionMaxScore =
    kStation5FinalDecisionDecisionPoints +
    kStation5FinalDecisionConclusionMaxPoints;

const String kStation5TakeawayPrompt =
    'Why is it important to use statistics and hypothesis testing when '
    'analyzing research data?';

const String kStation5TakeawayModel =
    'Statistics and hypothesis testing are important because they help '
    'researchers analyze data objectively and determine whether observed '
    'differences are significant or due to chance. Hypothesis testing allows '
    'researchers to accept or reject the null hypothesis based on evidence. '
    'Using statistics ensures that research conclusions are reliable, valid, '
    'and scientifically supported.';

const List<String> kStation5TakeawayKeywords = [
  'statistics',
  'hypothesis',
  'significant',
  'evidence',
  'reliable',
  'conclusions',
  'analyze',
  'analysis',
  'chance',
  'data',
  'objective',
  'valid',
  'null',
  'reject',
  'accept',
];

/// Scores a takeaway answer by how many sample-answer keywords appear.
int scoreStation5TakeawayAnswer(String text) {
  final lower = text.toLowerCase().trim();
  if (lower.isEmpty) return 0;

  final hits = kStation5TakeawayKeywords.where((k) => lower.contains(k)).length;
  if (hits >= 5) return 5;
  if (hits >= 4) return 4;
  if (hits >= 3) return 3;
  if (hits >= 2) return 2;
  if (hits >= 1) return 1;
  return 0;
}

const String kStation5CheckpointTableNote =
    'For questions 8–10, refer to the data table below.';

const McTableStimulus kStation5CheckpointTable = McTableStimulus(
  intro: 'Antibacterial Activity Against Staphylococcus aureus',
  headers: [
    'Treatment',
    'Replicate 1',
    'Replicate 2',
    'Replicate 3',
    'Replicate 4',
    'Replicate 5',
  ],
  rows: [
    ['Pyrrhobryum', '16 mm', '17 mm', '15 mm', '16 mm', '16 mm'],
    ['Ectropothecium', '10 mm', '11 mm', '10 mm', '12 mm', '11 mm'],
  ],
);

const List<McQuestion> kStation5Checkpoint = [
  McQuestion(
    prompt:
        'What is the main purpose of planning data analysis in a research investigation?',
    options: [
      'To organize and interpret data scientifically',
      'To shorten and simplify the whole experiment',
      'To decorate and improve the research paper',
      'To increase the number of laboratory materials',
    ],
    correctIndex: 0,
  ),
  McQuestion(
    prompt:
        'Which step should researchers accomplish first before organizing gathered data?',
    options: [
      'Identifying the data that must be gathered',
      'Recording all experimental observations carefully',
      'Computing the final interpretation of the results',
      'Organizing the tables and graphical presentations',
    ],
    correctIndex: 0,
  ),
  McQuestion(
    prompt:
        'Why is identifying the needed data important before conducting the experiment?',
    options: [
      'To prepare the bacterial cultures properly',
      'To identify measurements needed in research',
      'To determine the treatment groups accurately',
      'To organize experimental materials systematically',
    ],
    correctIndex: 1,
  ),
  McQuestion(
    prompt: 'Which statement best describes a scientific hypothesis?',
    options: [
      'A summary of gathered measurements',
      'A prediction based on scientific reasoning',
      'A conclusion formed after experimentation',
      'A detailed explanation of laboratory methods',
    ],
    correctIndex: 1,
  ),
  McQuestion(
    prompt: 'Why do researchers organize gathered data into tables?',
    options: [
      'To compare experimental results more easily',
      'To calculate all measurements without statistics',
      'To improve the appearance of laboratory reports',
      'To prevent recording errors during experimentation',
    ],
    correctIndex: 0,
  ),
  McQuestion(
    prompt: 'Why is the positive control included in the investigation?',
    options: [
      'To compare the treatments carefully',
      'To provide additional bacterial samples',
      'To confirm the assay functions correctly',
      'To increase the inhibition zone measurements',
    ],
    correctIndex: 2,
  ),
  McQuestion(
    prompt: 'What does a larger zone of inhibition usually indicate?',
    options: [
      'Smaller bacterial colonies produced',
      'Weaker antibacterial activity observed',
      'Lower reliability of experimental results',
      'Greater effectiveness against bacteria',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt: 'What is the mean zone of inhibition produced by Pyrrhobryum?',
    options: ['14.0 mm', '15.0 mm', '16.0 mm', '17.0 mm'],
    correctIndex: 2,
  ),
  McQuestion(
    prompt:
        'Based on the computed means, which moss genus showed stronger '
        'antibacterial activity against Staphylococcus aureus?',
    options: [
      'Pyrrhobryum showed stronger activity',
      'Ectropothecium showed stronger activity',
      'Both moss genera showed equal activity',
      'Neither moss genus showed antibacterial activity',
    ],
    correctIndex: 0,
  ),
  McQuestion(
    prompt:
        'If the researcher performed a t-test and found that the difference '
        'between the two moss genera was significant, what should happen to the '
        'null hypothesis?',
    options: [
      'Accept the null hypothesis completely',
      'Reject the null hypothesis immediately',
      'Repeat the experiment without statistics',
      'Ignore the hypothesis during interpretation',
    ],
    correctIndex: 1,
  ),
];
