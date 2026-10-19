import '../models/mc_question.dart';
import '../models/vocab_word.dart';

const String kStation4Intro =
    'Welcome, young researchers! In this station, you will enter the Bioactive '
    'Discovery Laboratory, where scientists investigate the hidden chemical '
    'compounds found inside moss through a process called phytochemical '
    'screening.\n\n'
    'But this station is not only about identifying bioactive compounds. More '
    'importantly, it will train you to think and work like real researchers by '
    'learning how to organize and present scientific data using tables and '
    'appropriate graphs, and interpret data based on observed patterns and '
    'results.\n\n'
    'As you explore the fascinating bioactive secrets of mosses, you will '
    'discover that scientific investigations become meaningful only when data '
    'are properly presented and carefully interpreted.';

const String kStation4DiscoveryBackgroundAsset =
    'assets/images/station4/dstop_station4.png';

const String kStation4DiscoveryPart1 =
    'Mosses may appear small and simple, but recent studies have revealed that '
    'they contain important **bioactive compounds** that help them survive in '
    'different environmental conditions. These **naturally occurring substances** '
    'help protect mosses from harmful microorganisms, environmental stress, and '
    'predators. Some compounds may also possess **antioxidant**, **antimicrobial**, '
    'and **medicinal properties**, making mosses valuable in scientific and '
    'biological research.';

const String kStation4DiscoveryPart2 =
    'To find out and study these compounds, scientists perform a laboratory '
    'process called **phytochemical screening**. **Phytochemical profiling** is '
    'used to identify and study the naturally occurring chemical compounds '
    'present in plants, including mosses. Through this laboratory process, '
    'scientists are able to examine the different bioactive compounds found in '
    'moss samples and better understand their possible functions, ecological '
    'importance, and potential applications in science and medicine.';

const String kStation4DiscoveryTableIntro =
    'Below are some common phytochemicals found in mosses and their functions:';

const String kStation4DiscoveryTableSource =
    '(Information adapted from Biologically Active Compounds from Bryophytes by '
    'Y. Asakawa (2007); Bryophyte Ecology: Chemical Defense and Secondary '
    'Metabolites by J. M. Glime (2017); and Secondary Metabolites in Bryophytes: '
    'An Ecological Aspect by C. F. Xie et al. (2009).)';

const String kStation4DiscoveryPart3 =
    'In phytochemical studies of mosses, researchers gather scientific evidence '
    'to find out, analyze, interpret and compare the bioactive compounds present '
    'in different moss species and evaluate patterns recorded during the '
    'investigation. And, to communicate these findings clearly and accurately, '
    'scientists organize the collected observations using appropriate **tabular '
    'and graphical forms**.';

const String kStation4DiscoveryPart4 =
    'One common way of presenting scientific data is through **tables**. Tables '
    'organize information into rows and columns, making it easier for researchers '
    'to compare observations among moss samples. In phytochemical screening '
    'studies, tables may show the **presence or absence** of compounds in '
    'different moss species. Organized tables help simplify large amounts of '
    'information and allow researchers to identify similarities and differences '
    'more clearly. Aside from tables, researchers also use';

const String kStation4DiscoveryPart5 =
    '**graphs** to visually present research findings. Graphs help researchers '
    'observe **patterns**, **trends**, and **relationships** in the gathered data.';

const String kStation4DiscoveryFormsIntro =
    'Below are some common tabular and graphical forms used in phytochemical '
    'screening studies:';

const String kStation4DiscoveryFormsTableAsset =
    'assets/images/station4/tabular_st4.png';

const String kStation4DiscoveryPart6 =
    '**Data interpretation** is another important skill in scientific '
    'investigations. Interpreting data means explaining the meaning of the '
    'results based on the information presented in tables and graphs. Researchers '
    'analyze patterns, identify relationships, and draw **conclusions supported '
    'by evidence** gathered during the investigation. For example, if one moss '
    'species shows a higher number of detected phytochemicals than another, '
    'scientists may conclude that the species has greater **bioactive potential**. '
    'Proper interpretation helps researchers communicate scientific findings '
    'accurately and meaningfully.';

const String kStation4DiscoveryPart7 =
    'Let us say, for example, that researchers conducted phytochemical screening '
    'on five moss species and recorded the number of detected phytochemicals '
    'found in each sample.';

const String kStation4DiscoveryPart8 =
    'The data above may be presented using a **bar graph** to compare the number '
    'of phytochemicals detected in each moss species. Through the graph, '
    'researchers can easily identify which sample contains the highest or lowest '
    'number of detected compounds.';

const String kStation4DiscoveryPart9 =
    '**Interpretation:** The bar graph shows the number of detected '
    'phytochemicals present in five moss species. Among the samples, **Moss D** '
    'has the highest number of detected phytochemicals with a total of 8 compounds '
    'while **Moss B** has the lowest number with only 3 compounds detected. '
    '**Moss C** has 6 detected phytochemicals, whereas **Moss A** and **Moss E** '
    'both have 5. This shows that the phytochemical content varies among the moss '
    'species, with Moss D showing the richest phytochemical composition among the '
    'five samples.';

const String kStation4DiscoveryPart10 =
    'From the example given above, it is evident that **tables and graphs** help '
    'researchers organize data systematically, compare results easily, and '
    'interpret scientific findings more clearly and accurately.\n\n'
    'Remember, young researchers, successful scientific investigations depend on '
    'how carefully data are organized, presented, and interpreted using appropriate '
    '**tabular and graphical forms**. Through accurate **data presentation** and '
    '**interpretation**, researchers are able to communicate findings clearly, '
    'identify meaningful patterns, and draw **reliable scientific conclusions** '
    'based on evidence gathered during the research investigation.';

/// Example moss screening counts for the Discovery Stop data table and bar graph.
const List<({String species, int count})> kStation4MossScreeningRows = [
  (species: 'Moss A', count: 5),
  (species: 'Moss B', count: 3),
  (species: 'Moss C', count: 6),
  (species: 'Moss D', count: 8),
  (species: 'Moss E', count: 5),
];

const int kStation4MossScreeningChartMax = 10;

/// Tabular/graphical forms for the Discovery Stop research table.
const List<({String name, String purpose})> kStation4ResearchFormRows = [
  (
    name: 'Data Table',
    purpose:
        'Organizes and summarizes data into rows and columns for easier analysis',
  ),
  (
    name: 'Bar Graph',
    purpose: 'Compares data among different categories or groups',
  ),
  (
    name: 'Pie Graph',
    purpose: 'Shows proportions or percentages of parts within a whole',
  ),
  (
    name: 'Line Graph',
    purpose: 'Presents changes, trends, or patterns over time',
  ),
  (
    name: 'Frequency Table',
    purpose: 'Summarizes the number of times observations or responses occur',
  ),
];

/// Phytochemical rows for the Discovery Stop table (name, function).
const List<({String name, String function})> kStation4PhytochemicalRows = [
  (
    name: 'Alkaloids',
    function: 'Help protect mosses against microorganisms and predators',
  ),
  (
    name: 'Flavonoids',
    function:
        'Function as antioxidants and protect cells from environmental stress',
  ),
  (
    name: 'Tannins',
    function: 'Provide defense against pathogens and herbivores',
  ),
  (name: 'Saponins', function: 'Possess antimicrobial properties'),
  (name: 'Terpenoids', function: 'Help mosses adapt to environmental stress'),
  (
    name: 'Phenolic Compounds',
    function: 'Help protect cells from oxidative damage',
  ),
];

/// Discovery Stop reading content. Wrap key terms in ** for bold emphasis.
/// Word Quest vocabulary shown in the Discovery Stop overlay.
const List<VocabWord> kStation4Vocabulary = [
  VocabWord(
    term: 'Phytochemical Screening',
    definition:
        'A laboratory process used to identify chemical compounds present in '
        'a plant sample.',
    context:
        'Scientists use phytochemical screening to identify the bioactive '
        'compounds found in moss samples.',
  ),
  VocabWord(
    term: 'Bioactive Compounds',
    definition:
        'Chemical substances that can produce an effect on living organisms.',
    context:
        'Mosses contain bioactive compounds that may help protect them from '
        'microorganisms and environmental stress.',
  ),
  VocabWord(
    term: 'Reagent',
    definition:
        'A chemical substance used to detect or cause a chemical reaction.',
    context:
        'When a reagent is added to a moss extract, reactions such as color '
        'changes, foam, or precipitate formation may occur.',
  ),
  VocabWord(
    term: 'Precipitate',
    definition:
        'A solid substance that forms during a chemical reaction in a liquid.',
    context:
        'A reddish-brown precipitate forms when alkaloids are detected using '
        'Wagner\u2019s test.',
  ),
  VocabWord(
    term: 'Intensity',
    definition: 'The strength or degree of something.',
    context:
        'Students analyze the intensity of the laboratory reaction to '
        'determine whether a phytochemical is weakly, moderately, or strongly '
        'present.',
  ),
];

const String kStation4Content =
    '$kStation4DiscoveryPart1\n\n'
    '$kStation4DiscoveryPart2\n\n'
    '$kStation4DiscoveryTableIntro\n\n'
    'Alkaloids — Help protect mosses against microorganisms and predators. '
    'Flavonoids — Function as antioxidants and protect cells from environmental '
    'stress. Tannins — Provide defense against pathogens and herbivores. '
    'Saponins — Possess antimicrobial properties. Terpenoids — Help mosses '
    'adapt to environmental stress. Phenolic Compounds — Help protect cells '
    'from oxidative damage.\n\n'
    '$kStation4DiscoveryPart3\n\n'
    '$kStation4DiscoveryPart4\n\n'
    '$kStation4DiscoveryPart5\n\n'
    '$kStation4DiscoveryFormsIntro\n\n'
    'Data Table — Organizes and summarizes data into rows and columns for easier '
    'analysis. Bar Graph — Compares data among different categories or groups. '
    'Pie Graph — Shows proportions or percentages of parts within a whole. '
    'Line Graph — Presents changes, trends, or patterns over time. Frequency '
    'Table — Summarizes the number of times observations or responses occur.\n\n'
    '$kStation4DiscoveryPart6\n\n'
    '$kStation4DiscoveryPart7\n\n'
    'Moss A, 5 phytochemicals. Moss B, 3. Moss C, 6. Moss D, 8. Moss E, 5.\n\n'
    '$kStation4DiscoveryPart8\n\n'
    '$kStation4DiscoveryPart9\n\n'
    '$kStation4DiscoveryPart10';

/// Station 4 Research Mission intro background (parchment panel artwork).
const String kStation4MissionBackgroundAsset =
    'assets/images/station4/research_mission_bg_station_four.png';

/// Activity 2 phytochemical screening laboratory background.
const String kStation4Activity2BackgroundAsset =
    'assets/images/station4/activity2_lab_bg.png';

/// Trail Checkpoint background (parchment scroll on forest lab scene).
const String kStation4TrailCheckpointBackgroundAsset =
    'assets/images/station4/trail_checkpoint_station4.png';

/// Takeaway question background (question text baked into artwork).
const String kStation4TakeawayBackgroundAsset =
    'assets/images/station4/takeaway_question_station4.png';

const String kStation4BadgeBackgroundAsset =
    kStation4TrailCheckpointBackgroundAsset;

const String kStation4BadgeAsset = 'badge_bioactive.png';

const String kStation4BadgeNextMessage =
    'Secrets decoded! Station 5 is now unlocked on the Expedition Map.';

/// Moss sample illustrations for Activity 2 screening.
const String kStation4MossPyrrhobryumAsset =
    'assets/images/station4/moss/moss_pyrrhobryum.png';
const String kStation4MossEctropotheciumAsset =
    'assets/images/station4/moss/moss_ectropothecium.png';

const String kStation4MissionStory =
    'A team of scientists recently completed a major phytochemical '
    'investigation on different moss species collected from remote forest '
    'ecosystems. The study aimed to discover important bioactive compounds '
    'that may have scientific and medicinal value.\n\n'
    'However, before the researchers could finalize their report, the '
    'laboratory\'s digital research system suddenly malfunctioned, **causing '
    'graphs, tables, interpretations, and laboratory records to become '
    'scattered and incomplete.**\n\n'
    'To save the investigation, the laboratory has called for a group of '
    'skilled young researchers to help recover and reconstruct the missing '
    'scientific data.\n\n'
    'As newly appointed Junior Phytochemical Investigators, your mission is '
    'to **analyze** the remaining laboratory evidence, **organize** research '
    'findings using appropriate **tabular and graphical forms**, **interpret** '
    'scientific data, and **unlock** hidden research files throughout the '
    'investigation.\n\n'
    'Each completed activity will restore a portion of the lost research '
    'report. **Work carefully, analyze the evidence accurately, and help the '
    'laboratory complete the final phytochemical investigation before the '
    'research deadline expires.**';

/// Mission Activity 1: choose the correct tabular or graphical form per question.
const String kStation4GraphMatchTitle = 'Activity 1: Choose the Form';

const String kStation4GraphMatchInstruction =
    'Tap the correct tabular or graphical form, then tap the answer box for '
    'each question.';

const List<({String description, String answer})> kStation4GraphMatch = [
  (
    description:
        'This graphical form is used to compare data among different '
        'categories or groups.',
    answer: 'Bar Graph',
  ),
  (
    description:
        'This graphical form shows proportions or percentages of parts '
        'within a whole.',
    answer: 'Pie Graph',
  ),
  (
    description:
        'A scientist records the increase in detected phytochemicals in a '
        'moss culture over five weeks and wants to show the changes over time.',
    answer: 'Line Graph',
  ),
  (
    description:
        'A researcher wants to summarize how many times specific observations '
        'appeared during the investigation using tally marks and frequencies.',
    answer: 'Frequency Table',
  ),
  (
    description:
        'A researcher wants to organize laboratory observations '
        'systematically before making graphs and interpretations.',
    answer: 'Data Table',
  ),
];

const List<String> kStation4GraphTokens = [
  'Bar Graph',
  'Pie Graph',
  'Line Graph',
  'Frequency Table',
  'Data Table',
];

/// Activity 1 choice icons for each tabular or graphical form.
const Map<String, String> kStation4GraphFormAssets = {
  'Data Table': 'assets/images/station4/forms/form_data_table.png',
  'Bar Graph': 'assets/images/station4/forms/form_bar_graph.png',
  'Pie Graph': 'assets/images/station4/forms/form_pie_graph.png',
  'Line Graph': 'assets/images/station4/forms/form_line_graph.png',
  'Frequency Table': 'assets/images/station4/forms/form_frequency_table.png',
};

/// Mission Activity 2 overview before phytochemical screening.
const String kStation4Activity2Title =
    'Activity 2: Phytochemical Screening Laboratory';

const String kStation4Activity2Subtitle = 'Analyze. Observe. Record. Discover.';

const String kStation4Activity2OverviewPart1 =
    'In this activity, you will analyze the phytochemical screening results '
    'obtained from two moss samples, **Genus Pyrrhobryum** and **Genus '
    'Ectropothecium**. You will carefully observe the laboratory reactions '
    'produced during different phytochemical tests and determine whether the '
    'compounds are **negative (-)**, **weakly present (+)**, **moderately '
    'present (++)**, or **strongly present (+++)**.';

const String kStation4Activity2OverviewPart2 =
    'Using laboratory observations such as foam formation, color changes, and '
    'precipitate formation, you will analyze the intensity of the reactions '
    'and record your findings in a scientific results table just like real '
    'researchers do during phytochemical investigation.';

const String kStation4Activity2OverviewPart3 =
    'Before starting the activity, let us have an overview first on how '
    'scientists analyze the phytochemicals present in every plant sample.';

const String kStation4Activity2OverviewPart4 =
    'Scientists use different laboratory tests to identify the presence of '
    'bioactive compounds in plant samples. When a reagent is added to a moss '
    'extract, observable reactions may occur such as: formation of foam, color '
    'changes, precipitates, or visible layers. The strength of the reaction '
    'helps determine the level of phytochemicals present in the sample.';

const List<String> kStation4Activity2Goals = [
  'Determine the level of phytochemicals present.',
  'Record your findings in a scientific results table.',
  'Compare the results of the two moss samples.',
  'Interpret the data and draw conclusions.',
];

/// General guidelines for interpreting phytochemical screening reactions.
const List<({String symbol, String observation})>
kStation4InterpretationGuidelines = [
  (symbol: '-', observation: 'No visible reaction'),
  (symbol: '+', observation: 'Weak or faint reaction observed'),
  (symbol: '++', observation: 'Clear and noticeable reaction'),
  (symbol: '+++', observation: 'Very intense reaction observed'),
];

/// Common phytochemical tests reference chart for Activity 2 overview.
const String kStation4CommonPhytochemicalTestsAsset =
    'assets/images/station4/common_phytochemical_tests.png';

const String kStation4Activity2InstructionsStep1 =
    'Carefully observe the laboratory reactions shown for each moss sample.';

const List<String> kStation4Activity2InstructionsSteps = [
  'Analyze the intensity of the reaction based on the guide provided.',
  'Determine whether the phytochemical is:',
  'Record your observations in the scientific results table.',
  'Compare the phytochemical contents of the two moss samples.',
  'Answer the interpretation guide questions after completing the table.',
];

const List<String> kStation4Activity2PhytochemicalLevels = [
  'Negative (-)',
  'Weakly Positive (+)',
  'Moderately Positive (++)',
  'Strongly Positive (+++)',
];

/// Mission Activity 2: rate each phytochemical reaction for Genus Pyrrhobryum.
/// Symbols: - (negative), + (weak), ++ (moderate), +++ (strong).

/// Alkaloids (Wagner's Test) reaction intensity illustrations.
const List<({String label, String asset})> kStation4AlkaloidsReactionAssets = [
  (
    label: 'Negative',
    asset: 'assets/images/phytochem/alkaloids/alkaloids_negative.png',
  ),
  (
    label: 'Weakly Positive',
    asset: 'assets/images/phytochem/alkaloids/alkaloids_weakly_positive.png',
  ),
  (
    label: 'Moderately Positive',
    asset:
        'assets/images/phytochem/alkaloids/alkaloids_moderately_positive.png',
  ),
  (
    label: 'Strongly Positive',
    asset: 'assets/images/phytochem/alkaloids/alkaloids_strongly_positive.png',
  ),
];

/// Flavonoids (Alkaline Reagent Test) reaction intensity illustrations.
const List<({String label, String asset})> kStation4FlavonoidsReactionAssets = [
  (
    label: 'Negative',
    asset: 'assets/images/phytochem/flavonoids/flavonoids_negative.png',
  ),
  (
    label: 'Weakly Positive',
    asset: 'assets/images/phytochem/flavonoids/flavonoids_weakly_positive.png',
  ),
  (
    label: 'Moderately Positive',
    asset:
        'assets/images/phytochem/flavonoids/flavonoids_moderately_positive.png',
  ),
  (
    label: 'Strongly Positive',
    asset:
        'assets/images/phytochem/flavonoids/flavonoids_strongly_positive.png',
  ),
];

/// Tannins (Ferric Chloride Test) reaction intensity illustrations.
const List<({String label, String asset})> kStation4TanninsReactionAssets = [
  (
    label: 'Negative',
    asset: 'assets/images/phytochem/tannins/tannins_negative.png',
  ),
  (
    label: 'Weakly Positive',
    asset: 'assets/images/phytochem/tannins/tannins_weakly_positive.png',
  ),
  (
    label: 'Moderately Positive',
    asset: 'assets/images/phytochem/tannins/tannins_moderately_positive.png',
  ),
  (
    label: 'Strongly Positive',
    asset: 'assets/images/phytochem/tannins/tannins_strongly_positive.png',
  ),
];

/// Saponins (Foam Test) reaction intensity illustrations.
const List<({String label, String asset})> kStation4SaponinsReactionAssets = [
  (
    label: 'Negative',
    asset: 'assets/images/phytochem/saponins/saponins_negative.png',
  ),
  (
    label: 'Weakly Positive',
    asset: 'assets/images/phytochem/saponins/saponins_weakly_positive.png',
  ),
  (
    label: 'Moderately Positive',
    asset: 'assets/images/phytochem/saponins/saponins_moderately_positive.png',
  ),
  (
    label: 'Strongly Positive',
    asset: 'assets/images/phytochem/saponins/saponins_strongly_positive.png',
  ),
];

/// Glycosides (Keller-Kiliani Test) reaction intensity illustrations.
const List<({String label, String asset})> kStation4GlycosidesReactionAssets = [
  (
    label: 'Negative',
    asset: 'assets/images/phytochem/glycosides/glycosides_negative.png',
  ),
  (
    label: 'Weakly Positive',
    asset: 'assets/images/phytochem/glycosides/glycosides_weakly_positive.png',
  ),
  (
    label: 'Moderately Positive',
    asset:
        'assets/images/phytochem/glycosides/glycosides_moderately_positive.png',
  ),
  (
    label: 'Strongly Positive',
    asset:
        'assets/images/phytochem/glycosides/glycosides_strongly_positive.png',
  ),
];

const List<String> kStation4RatingTokens = ['-', '+', '++', '+++'];

/// One phytochemical screening test (Activity 2 main task).
const List<
  ({
    String compound,
    String testName,
    String observation,
    String pyrrhobryumAnswer,
    String ectropotheciumAnswer,
  })
>
kStation4ScreeningTests = [
  (
    compound: "Alkaloid's Test",
    testName: "Wagner's Test",
    observation: 'A faint reddish-brown precipitate barely forms.',
    pyrrhobryumAnswer: '+',
    ectropotheciumAnswer: '+',
  ),
  (
    compound: "Flavonoid's Test",
    testName: 'Alkaline Reagent Test',
    observation: 'A clear and noticeable yellow coloration develops.',
    pyrrhobryumAnswer: '++',
    ectropotheciumAnswer: '++',
  ),
  (
    compound: "Tannin's Test",
    testName: 'Ferric Chloride Test',
    observation: 'A clear, noticeable blue-black coloration appears.',
    pyrrhobryumAnswer: '++',
    ectropotheciumAnswer: '++',
  ),
  (
    compound: "Saponin's Test",
    testName: 'Foam Test',
    observation: 'A weak, small amount of foam forms after shaking.',
    pyrrhobryumAnswer: '+',
    ectropotheciumAnswer: '+',
  ),
  (
    compound: "Glycosides Test",
    testName: 'Keller-Killiani Test',
    observation: 'No visible reaction or ring is observed.',
    pyrrhobryumAnswer: '-',
    ectropotheciumAnswer: '-',
  ),
];

/// Reaction tube illustrations per screening test (same order as [kStation4ScreeningTests]).
const List<List<({String label, String asset})>>
kStation4ScreeningReactionSets = [
  kStation4AlkaloidsReactionAssets,
  kStation4FlavonoidsReactionAssets,
  kStation4TanninsReactionAssets,
  kStation4SaponinsReactionAssets,
  kStation4GlycosidesReactionAssets,
];

const String kStation4ScreeningInstruction =
    'Tap a rating symbol, then tap the matching table cell. '
    'Wrong answers will not be accepted.';

/// Reaction tube asset for a screening test and rating symbol.
String station4ReactionAsset(int testIndex, String rating) {
  final idx = kStation4RatingTokens.indexOf(rating);
  if (idx < 0) return kStation4ScreeningReactionSets[testIndex].first.asset;
  return kStation4ScreeningReactionSets[testIndex][idx].asset;
}

/// Short compound label for the official results table (e.g. "Alkaloids").
String station4CompoundLabel(String compound) =>
    compound.replaceAll("'s Test", '');

const String kStation4ScreeningAnalysisTitle =
    'PHYTOCHEMICAL SCREENING ANALYSIS';

const String kStation4ScreeningAnalysisSubtitle =
    'ANALYZE. INTERPRET. DISCOVER.';

const String kStation4ScreeningAnalysisIntro =
    'Now that you have successfully completed the phytochemical screening table, '
    'the next step is to analyze and interpret the collected data just like real '
    'researchers do in scientific investigations.\n\n'
    'This time, you will examine the phytochemical results obtained from '
    '**Genus Pyrrhobryum** and **Genus Ectropothecium** and identify patterns, '
    'similarities, and differences observed in the investigation.';

/// Legend for the official results table.
const List<({String symbol, String meaning})> kStation4OfficialResultsLegend = [
  (symbol: '-', meaning: 'Not Detected'),
  (symbol: '+', meaning: 'Weakly Present'),
  (symbol: '++', meaning: 'Moderately Present'),
  (symbol: '+++', meaning: 'Strongly Present'),
];

/// Numeric scale for constructing the screening bar graph.
const List<({int value, String label})> kStation4BarGraphValueScale = [
  (value: 0, label: '- = 0'),
  (value: 1, label: '+ = 1'),
  (value: 2, label: '++ = 2'),
  (value: 3, label: '+++ = 3'),
];

const String kStation4BarGraphQuestionPrompt =
    'Construct a bar graph based on the phytochemical screening results of '
    '**Genus Pyrrhobryum** and **Genus Ectropothecium**. Use the following '
    'numerical values for the symbols: (- = 0, + = 1, ++ = 2, +++ = 3). '
    'Use blue bars for Genus Pyrrhobryum and orange bars for Genus '
    'Ectropothecium.';

/// Converts a screening rating symbol to its bar-graph height (0–3).
int station4RatingToBarValue(String rating) {
  final idx = kStation4RatingTokens.indexOf(rating);
  return idx < 0 ? 0 : idx;
}

/// Expected bar heights per test index for each moss genus.
int station4ExpectedPyrrhobryumBarValue(int testIndex) =>
    station4RatingToBarValue(
      kStation4ScreeningTests[testIndex].pyrrhobryumAnswer,
    );

int station4ExpectedEctropotheciumBarValue(int testIndex) =>
    station4RatingToBarValue(
      kStation4ScreeningTests[testIndex].ectropotheciumAnswer,
    );

/// Guide questions 2–5: written answers checked against sample-answer keywords.
const List<
  ({String prompt, List<String> keywords, String modelAnswer, int minMatches})
>
kStation4ScreeningGuideQuestions = [
  (
    prompt:
        'Which phytochemicals showed moderately present results in both moss samples?',
    keywords: ['flavonoid', 'tannin'],
    modelAnswer: 'Flavonoids and tannins',
    minMatches: 2,
  ),
  (
    prompt:
        'Which phytochemical compound was absent in both Genus Pyrrhobryum and Genus Ectropothecium?',
    keywords: ['glycoside'],
    modelAnswer: 'Glycosides',
    minMatches: 1,
  ),
  (
    prompt:
        'Which phytochemicals were only weakly present in both moss samples?',
    keywords: ['alkaloid', 'saponin'],
    modelAnswer: 'Alkaloids and saponins',
    minMatches: 2,
  ),
  (
    prompt:
        'What can you conclude about the phytochemical composition of the two '
        'moss species based on the results?',
    keywords: [
      'similar',
      'same',
      'flavonoid',
      'tannin',
      'moderate',
      'alkaloid',
      'saponin',
      'weak',
      'glycoside',
      'absent',
      'composition',
      'both',
    ],
    modelAnswer:
        'Based on the results, both Genus Pyrrhobryum and Genus Ectropothecium '
        'have very similar phytochemical compositions because they showed the same '
        'level of presence for all tested compounds. Flavonoids and tannins were '
        'moderately present (++), indicating that these compounds may be abundant '
        'in both moss species. Alkaloids and saponins were only weakly present (+), '
        'while glycosides were absent (-) in both samples. These similarities suggest '
        'that the two moss species may possess comparable chemical properties and '
        'potential biological activities.',
    minMatches: 7,
  ),
];

/// True when [input] mentions enough [keywords] from the sample answer (not verbatim).
bool station4GuideAnswerMatches(
  String input,
  List<String> keywords, {
  required int minMatches,
}) {
  final normalized = input.toLowerCase();
  final hits = keywords.where(normalized.contains).length;
  return hits >= minMatches;
}

const List<({String phytochemical, String observation, String answer})>
kStation4Reactions = [
  (
    phytochemical: 'Alkaloids (Wagner\'s Test)',
    observation: 'A faint reddish-brown precipitate barely forms.',
    answer: '+',
  ),
  (
    phytochemical: 'Flavonoids (Alkaline Reagent Test)',
    observation: 'A clear and noticeable yellow coloration develops.',
    answer: '++',
  ),
  (
    phytochemical: 'Tannins (Ferric Chloride Test)',
    observation: 'A clear, noticeable blue-black coloration appears.',
    answer: '++',
  ),
  (
    phytochemical: 'Saponins (Foam Test)',
    observation: 'A weak, small amount of foam forms after shaking.',
    answer: '+',
  ),
  (
    phytochemical: 'Glycosides (Keller-Killiani Test)',
    observation: 'No visible reaction or ring is observed.',
    answer: '-',
  ),
];

const String kStation4TakeawayPrompt =
    'Why is it important to present your data in tabular or graphical form '
    'in scientific investigations?';

const String kStation4TakeawayInstruction =
    'Write in your own words. Your answer should include the main ideas from '
    'the sample answer — it does not need to be word for word.';

const String kStation4TakeawayModel =
    'Tables and graphs help researchers organize data systematically, compare '
    'results easily, and interpret scientific findings more clearly. They make '
    'it easier to identify patterns and draw reliable conclusions based on '
    'evidence gathered during the investigation.';

const List<String> kStation4TakeawayKeywords = [
  'organize',
  'compare',
  'interpret',
  'pattern',
  'clear',
  'data',
  'table',
  'graph',
  'conclusion',
  'evidence',
];

const int kStation4TakeawayMinKeywordMatches = 3;

/// Scores a takeaway answer by how many sample-answer keywords appear.
int scoreStation4TakeawayAnswer(String text) {
  final lower = text.toLowerCase();
  final hits = kStation4TakeawayKeywords.where((k) => lower.contains(k)).length;
  if (hits >= 5) return 5;
  if (hits >= 4) return 4;
  if (hits >= kStation4TakeawayMinKeywordMatches) return 3;
  if (hits >= 2) return 2;
  if (hits >= 1) return 1;
  return 0;
}

bool station4TakeawayAnswerAcceptable(String text) =>
    scoreStation4TakeawayAnswer(text) >= 3;

const String _s4Table =
    'Phytochemical results (Genus Pyrrhobryum / Genus Ectropothecium):\n'
    'Alkaloids: + / +\n'
    'Flavonoids: ++ / ++\n'
    'Tannins: ++ / ++\n'
    'Saponins: + / +\n'
    'Glycosides: - / -\n'
    '(- absent, + weak, ++ moderate, +++ strong)';

const List<McQuestion> kStation4Checkpoint = [
  McQuestion(
    prompt:
        'What laboratory process is used to identify bioactive compounds present in mosses?',
    options: [
      'Soil Profiling',
      'Ecological Mapping',
      'Photosynthesis Analysis',
      'Phytochemical Screening',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt:
        'Which type of graph is BEST used to compare phytochemical results between two moss species?',
    options: ['Pie Graph', 'Line Graph', 'Scatter Plot', 'Bar Graph'],
    correctIndex: 3,
  ),
  McQuestion(
    prompt:
        'Which type of graph is MOST suitable for showing changes or trends in data over time?',
    options: ['Pie Graph', 'Bar Graph', 'Line Graph', 'Pictograph'],
    correctIndex: 2,
  ),
  McQuestion(
    prompt: 'Why do scientists organize data into tables?',
    options: [
      'To avoid interpreting results',
      'To decorate research papers',
      'To make investigations longer',
      'To organize information clearly',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt: 'What is the main purpose of interpreting scientific data?',
    options: [
      'To make graphs colorful',
      'To shorten the investigation',
      'To repeat experiments only',
      'To explain the meaning of the results',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt:
        'Which phytochemicals showed moderately present results in both moss samples?',
    stimulus: _s4Table,
    options: [
      'Alkaloids and Saponins',
      'Alkaloids and Glycosides',
      'Glycosides and Tannins',
      'Flavonoids and Tannins',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt: 'Which phytochemical compound was absent in both moss samples?',
    stimulus: _s4Table,
    options: ['Saponins', 'Alkaloids', 'Glycosides', 'Flavonoids'],
    correctIndex: 2,
  ),
  McQuestion(
    prompt: 'Which phytochemicals were weakly present in both moss samples?',
    stimulus: _s4Table,
    options: [
      'Alkaloids and Saponins',
      'Flavonoids and Glycosides',
      'Glycosides and Tannins',
      'Flavonoids and Tannins',
    ],
    correctIndex: 0,
  ),
  McQuestion(
    prompt:
        'What can be concluded from the phytochemical results of the two moss species?',
    stimulus: _s4Table,
    options: [
      'Only one moss species contains bioactive compounds',
      'The moss species have completely different compositions',
      'Both moss species showed similar phytochemical compositions',
      'Glycosides were strongly present in both samples',
    ],
    correctIndex: 2,
  ),
  McQuestion(
    prompt:
        'Why is it important to present scientific data in tabular or graphical form?',
    options: [
      'To make the investigation more difficult',
      'To avoid drawing conclusions from evidence',
      'To help organize, compare, and interpret data clearly',
      'To confuse the readers with more information',
    ],
    correctIndex: 2,
  ),
];
