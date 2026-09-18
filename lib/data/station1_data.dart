import '../core/text_format.dart';
import '../models/mc_question.dart';

/// Welcome script for Station 1 (spoken when the station is opened).
const String kStation1Intro =
    'Welcome, young explorers! In this first station, you will begin your '
    'mountain research journey by discovering the fascinating world of mosses.\n\n'
    'As you investigate their characteristics, habitats, and ecological '
    'importance, you will also begin thinking like real researchers by learning '
    'how to choose an appropriate quantitative research design '
    '(**CS_RS12-IIa-c-1**):\n'
    '• Identify the characteristics and purposes of different quantitative '
    'research designs.\n'
    '• Choose the appropriate quantitative research design for a given '
    'research situation.\n'
    '• Recognize the importance of selecting an appropriate quantitative '
    'research design in conducting research.\n\n'
    'Through this exploration, you will discover that every successful '
    'scientific investigation starts with a well-planned research design that '
    'guides the entire study.';

/// Plain text for TTS (no bullet symbols).
String get kStation1IntroNarration =>
    stripReadingMarkup(kStation1Intro.replaceAll('• ', ''));

/// Discovery Stop reading content — four paragraphs with a moss diagram
/// between the second and third sections in the UI.
const String kStation1DiscoveryPart1 =
    'Mosses are small, **non-vascular plants** that belong to a group of plants '
    'called **Bryophytes**. This group of plants are unique as they do not have '
    '**true roots, stem or vascular tissues** such as **xylem** and **phloem**. '
    'Instead, they possess root-like structure called **rhizoids** that help them '
    'attach to the surfaces and absorb moisture from its surroundings. Due to '
    'their unique structure, they commonly grow in **moist and shaded environments** '
    'such as the forest floor, rocks, trees, tree trunks and riverbanks as they '
    'required water for reproduction and survival.';

const String kStation1DiscoveryPart2 =
    'Despite their small size, mosses contribute significantly to **environmental '
    'stability** and **biodiversity** in an ecosystem. They help retain moisture in '
    'the soil, reduce erosion, recycle nutrients, and provide microhabitats for '
    'microorganisms and small invertebrates. Mosses are also considered excellent '
    '**bioindicators**, which means that they can be used to monitor environmental '
    'conditions such as **pollution** and **climate change** as they are highly '
    'sensitive to the changes in their surroundings (Sabovljević et al., 2016). '
    'Thus, their ecological importance makes them valuable organisms in '
    'environmental and biodiversity studies.';

const String kStation1DiscoveryPart3 =
    'Aside from their ecological functions, mosses are also gaining attention '
    'because of their great potential in the field of **medicine**. Recent studies '
    'have shown that some moss species have various **secondary metabolites** such '
    'as **alkaloids**, **terpenoids**, **phenolic compounds**, and **steroids** to '
    'name a few. More interestingly, these compounds are found to have '
    '**antibacterial**, **antifungal**, **antioxidant**, and **anti-inflammatory** '
    'activities (Asakawa et al., 2018).';

const String kStation1DiscoveryPart4 =
    'Because of the unique and interesting characteristics of mosses, many '
    'scientific studies can be conducted in this field. For example, researchers '
    'study mosses to understand their distribution, diversity, ecological '
    'importance, habitat specificity, and possible medicinal properties to name a '
    'few. Since these studies have different goals and methods of investigation, '
    'it is important for researchers to choose the most appropriate **quantitative '
    'research design**.';

const String kStation1DiscoveryPart5 =
    'A **Quantitative Research Design** is a systematic way of collecting and '
    'analyzing **numerical data** to produce **reliable scientific results**. '
    'There are four main types of **quantitative research** as shown in the table below:';

/// Four main quantitative research types (Discovery Stop table).
const McTableStimulus kStation1QuantitativeResearchTable = McTableStimulus(
  intro: '',
  headers: [
    'Type of Quantitative Research',
    'Description',
    'Key Question it answers',
    'When to use',
    'Sample Studies',
  ],
  rows: [
    [
      'Descriptive Research',
      'Describes existing conditions, characteristics, or situations through observation and data collection.',
      'What is present or happening?',
      'Use when the study only aims to describe or identify something.',
      '• Counting the number of mosses growing on rocks\n'
          '• Assessing the distribution of moss species across different elevations of a mountain ecosystem',
    ],
    [
      'Correlational Research',
      'Determines whether a relationship exists between two variables without manipulating them.',
      'Are these two variables related?',
      'Use when the study aims to determine whether two variables are related but no groups or treatments are compared.',
      '• Studying if colder areas have more mosses\n'
          '• Determining the relationship between elevation and moss species distribution in a mountain ecosystem',
    ],
    [
      'Quasi-Experimental Research',
      'Compares two or more existing groups or conditions to observe possible effects without complete control or random grouping.',
      'Which condition or group show better results?',
      'Use when comparing groups or environments where not all variables can be controlled.',
      '• Comparing moss growth on tree bark and rocks\n'
          '• Comparing moss abundance and diversity between disturbed and undisturbed forest areas',
    ],
    [
      'Experimental Research',
      'Tests cause-and-effect relationships by manipulating variables under controlled conditions.',
      'What happens if a treatment is applied?',
      'Use when treatments or variables are applied in a controlled setup.',
      '• Testing moss growth in different nutrient solutions\n'
          '• Evaluating the effectiveness of moss extracts at different concentrations against bacterial growth',
    ],
  ],
);

/// Moss structure diagram shown beside paragraphs 3–4.
const String kStation1MossDiagramAsset =
    'assets/images/moss_structure.png';

/// Full Discovery Stop text (TTS and shared station content).
const String kStation1Content =
    '$kStation1DiscoveryPart1\n\n'
    '$kStation1DiscoveryPart2\n\n'
    '$kStation1DiscoveryPart3\n\n'
    '$kStation1DiscoveryPart4\n\n'
    '$kStation1DiscoveryPart5';

/// Moss health visuals shown after the Research Mission (score out of 5).
const String kMossDyingAsset = 'assets/images/moss_mission/moss_dying.png';
const String kMossThinAsset = 'assets/images/moss_mission/moss_thin.png';
const String kMossThickAsset = 'assets/images/moss_mission/moss_thick.png';
const String kMossCapsuleAsset = 'assets/images/moss_mission/moss_capsule.png';

/// Research Mission intro story.
const String kStation1MissionStory =
    'A rare moss species inside the virtual bryophyte laboratory is slowly '
    'losing its health. To restore the moss and help it produce a healthy '
    'capsule, you must correctly identify the appropriate quantitative '
    'research design in each challenge.\n\n'
    'Every correct answer restores the moss health meter. If you get a '
    'perfect score, the moss will fully grow and produce a mature capsule!';

/// Directions shown during the Research Mission activity.
const String kStation1MissionDirections =
    'Read each research scenario carefully, then tap the box containing the '
    'correct quantitative research design.';

/// Color-coded labels for each tap target (same order as [kResearchDesigns]).
const List<String> kResearchDesignLabels = [
  'Descriptive Research Design',
  'Correlational Research Design',
  'Quasi-Experimental Research Design',
  'Experimental Research Design',
];

/// The four research-design choices (tap targets), in fixed order.
const List<String> kResearchDesigns = [
  'Descriptive Research',
  'Correlational Research',
  'Quasi-Experimental Research',
  'Experimental Research',
];

class MissionItem {
  final String statement;
  final int correctDesign; // index into kResearchDesigns
  const MissionItem(this.statement, this.correctDesign);
}

/// Research Mission: tap the correct design for each statement (5 items).
const List<MissionItem> kStation1Mission = [
  MissionItem(
    'A researcher identifies the different moss species growing on rocks near a river.',
    0,
  ),
  MissionItem(
    'A researcher studies whether colder places have greater moss abundance.',
    1,
  ),
  MissionItem(
    'A researcher tests the effect of different nutrient solutions on moss growth inside the laboratory.',
    3,
  ),
  MissionItem(
    'Determining the relationship between elevation and moss species distribution in a mountain ecosystem.',
    1,
  ),
  MissionItem(
    'Testing the antibacterial activity of moss extracts against bacterial growth under laboratory conditions.',
    3,
  ),
];

/// Takeaway free-text question + rubric for auto-scoring.
const String kStation1TakeawayPrompt =
    'Why is it important to choose the correct research design in a scientific investigation?';

const String kStation1TakeawayInstruction =
    'Explain your answer in 2-3 sentences.';

const String kStation1TakeawayBackgroundAsset =
    'assets/images/backgrounds/takeaway_station1_bg.png';

const String kStation1TakeawayModel =
    'Choosing the correct research design is important because it helps '
    'researchers gather accurate and reliable data. Different studies have '
    'different objectives, so the appropriate research design helps organize the '
    'investigation properly.';

/// Keywords used by the heuristic rubric scorer.
const List<String> kStation1TakeawayKeywords = [
  'accurate',
  'reliable',
  'organize',
  'data',
  'design',
  'objective',
  'investigation',
  'proper',
];

/// Trail Checkpoint: 5 multiple-choice questions.
const List<McQuestion> kStation1Checkpoint = [
  McQuestion(
    prompt:
        'Which quantitative research design is used when a study only describes existing conditions or characteristics?',
    options: [
      'Correlational Research',
      'Experimental Research',
      'Descriptive Research',
      'Quasi-Experimental Research',
    ],
    correctIndex: 2,
  ),
  McQuestion(
    prompt:
        'A researcher studies whether colder places have greater moss abundance. What research design is most appropriate?',
    options: [
      'Descriptive Research',
      'Correlational Research',
      'Experimental Research',
      'Quasi-Experimental Research',
    ],
    correctIndex: 1,
  ),
  McQuestion(
    prompt:
        'What makes correlational research different from descriptive research?',
    options: [
      'It allows to compare groups or environments.',
      'It studies relationships between variables.',
      'It uses treatments and experiments.',
      'It only describes existing conditions.',
    ],
    correctIndex: 1,
  ),
  McQuestion(
    prompt: 'Which study title is an example of descriptive research?',
    options: [
      'Identifying moss species found on tree trunks',
      'Comparing moss abundance in two forest areas',
      'Testing the effect of nutrient solutions on moss growth',
      'Determining the relationship between moisture and moss diversity',
    ],
    correctIndex: 0,
  ),
  McQuestion(
    prompt:
        'Why is it important to choose the correct research design in a scientific study?',
    options: [
      'To make the study longer and better',
      'To avoid long duration of collecting data',
      'To produce organized and reliable results',
      'To reduce the number of variables and conditions',
    ],
    correctIndex: 2,
  ),
];
