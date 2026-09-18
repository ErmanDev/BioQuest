import '../models/mc_question.dart';

/// Welcome script for Station 2 (spoken when the station is opened).
const String kStation2Intro =
    'Greetings, mountain researchers! In this station, you will explore across '
    'different elevations of the mountain to investigate how mosses are '
    'distributed from lowland to highland environments.\n\n'
    'As you explore moss communities along the mountain trail, you will also '
    'learn how researchers carefully gather samples in the field by learning '
    'how to:\n'
    '• Describe appropriate sampling procedures\n'
    '• Identify the population and sample in a research study\n\n'
    'Throughout this expedition, you will realize that proper sampling is '
    'essential in obtaining accurate and reliable research data from natural '
    'environments.';

/// Plain text for TTS (no bullet symbols).
String get kStation2IntroNarration => kStation2Intro.replaceAll('• ', '');

/// Discovery Stop reading content. Wrap key terms in ** for bold emphasis.
const String kStation2DiscoveryPart1 =
    'Mosses commonly grow in **moist and shaded environments** and are found to be '
    'highly sensitive to environmental conditions such as **temperature**, '
    '**humidity**, **sunlight**, and **water availability**. Because of these '
    'characteristics, mosses are often used by scientists as **indicators of '
    'environmental change**. One important factor that affects the growth and '
    'distribution of mosses is **elevation**.';

const String kStation2DiscoveryPart2 =
    '**Elevation** refers to the height of an area above sea level usually '
    'expressed in **masl** (meters above sea level). As elevation increases, '
    'environmental conditions also change. Higher elevations usually experience '
    'cooler temperatures, stronger winds, and greater moisture availability '
    'compared to lower elevations. These environmental differences influence the '
    'types of mosses that can survive and grow in a particular **habitat**. Some '
    'moss species are commonly found in lowland forests, while others thrive only '
    'in higher mountainous areas.';

/// Elevation zones diagram (shown after Part 2).
const String kStation2ElevationDiagramAsset =
    'assets/images/station2/elevation.png';

const String kStation2DiscoveryPart3 =
    'Scientists examine how moss species vary from one elevation zone to another '
    'to determine how environmental factors affect their growth and survival. '
    'However, studying all mosses found in an entire mountain ecosystem is '
    'difficult and time-consuming. Because of this, researchers use scientific '
    'methods in selecting representative groups of organisms for observation and '
    'study. This process involves the use of **samples** and **sampling '
    'procedures**.';

const String kStation2DiscoveryPart4 =
    'A **sample** refers to a portion or representative group taken from a '
    'larger **population** for analysis. In the study of moss distribution, the '
    'entire moss community found in the mountain serves as the **population**, '
    'while the moss colonies gathered from selected sampling areas serve as the '
    '**samples**. These samples provide information about the characteristics of '
    'mosses present in different elevations.';

/// Population vs. sample diagram (shown after Part 4).
const String kStation2PopulationSampleDiagramAsset =
    'assets/images/station2/population_sample.png';

const String kStation2DiscoveryPart5 =
    'To obtain reliable samples, researchers use a **sampling procedure**. A '
    '**sampling procedure** refers to the systematic method used in selecting and '
    'collecting samples from a study area. In moss distribution studies, '
    'researchers carefully identify specific sampling sites from low, mid, and '
    'high elevations to ensure that the collected data properly represent the '
    'entire population.';

const String kStation2DiscoveryPart6 =
    '**Sampling Procedures in Moss Studies** — Researchers use different sampling '
    'procedures to collect moss samples from selected areas and elevations.';

/// Three-column infographic: transect, quadrat, and stratified sampling.
const String kStation2SamplingProceduresAsset =
    'assets/images/station2/sampling_procedures_in_moss_studies.png';

const String kStation2DiscoveryPart7 =
    'In actual ecological and biodiversity studies, researchers may combine two '
    'or more sampling procedures to gather more accurate and reliable data. '
    'Combining sampling methods helps ensure that the collected samples properly '
    'represent the study area. One common example is the combination of transect '
    'sampling and quadrat sampling. In this method, researchers first establish a '
    'transect line across different elevations and then place quadrats at '
    'specific intervals along the line to collect moss samples. The choice of '
    'sampling procedure depends on the research problem, study area, '
    'environmental conditions, and available resources. Through the proper '
    'selection and combination of sampling procedures, researchers can obtain '
    'more organized and representative data in studying the elevational '
    'distribution of mosses.';

const String kStation2Content =
    '$kStation2DiscoveryPart1\n\n'
    '$kStation2DiscoveryPart2\n\n'
    '$kStation2DiscoveryPart3\n\n'
    '$kStation2DiscoveryPart4\n\n'
    '$kStation2DiscoveryPart5\n\n'
    '$kStation2DiscoveryPart6\n\n'
  // Infographic details are shown visually; narration covers the summary above
  // and the closing paragraph below.
    '$kStation2DiscoveryPart7';
/// Station 2 Research Mission intro background (parchment panel artwork).
const String kStation2MissionBackgroundAsset =
    'assets/images/station2/research_mission_bg_station_two.png';

/// Mission story footer banner (three task steps).
const String kStation2YourMissionsAsset =
    'assets/images/station2/your_missions.png';

const String kStation2MissionStory =
    'Congratulations!\n\n'
    'You have been hired as a **Junior Moss Researcher!**\n\n'
    'Your team\'s mission is to study how mosses are distributed from low to '
    'high elevations of the mountain.\n\n'
    'However, there are thousands of mosses in the area, and scientists cannot '
    'count every single moss one by one. Because of this, your research team '
    'will:\n'
    '• collect moss samples\n'
    '• choose proper sampling procedures\n'
    '• observe mosses in different elevation zones\n\n'
    'As a researcher, you must help the team collect accurate data for the '
    'investigation.\n\n'
    'Complete the missions carefully because the success of the moss study '
    'depends on your decisions!\n\n'
    'Your work will help scientists understand moss distribution and protect '
    'our ecosystem!';

/// Population vs. sample sorting activity (Research Mission step 1).
const String kStation2PopulationSampleActivityBg =
    'assets/images/station2/population_sample_activity_bg.png';

enum PopulationSampleAnswer { population, sample }

class Station2PopSampleCard {
  final String imageAsset;
  final String description;
  final PopulationSampleAnswer answer;

  const Station2PopSampleCard({
    required this.imageAsset,
    required this.description,
    required this.answer,
  });
}

const List<Station2PopSampleCard> kStation2PopSampleCards = [
  Station2PopSampleCard(
    imageAsset: 'assets/images/station2/cards/pop_sample_card1.png',
    description: 'A whole mountain covered with mosses.',
    answer: PopulationSampleAnswer.population,
  ),
  Station2PopSampleCard(
    imageAsset: 'assets/images/station2/cards/pop_sample_card2.png',
    description:
        'Researchers collecting mosses from **ONLY** one small area.',
    answer: PopulationSampleAnswer.sample,
  ),
  Station2PopSampleCard(
    imageAsset: 'assets/images/station2/cards/pop_sample_card3.png',
    description:
        'A garden **FULL OF DIFFERENT PLANT SPECIES**.',
    answer: PopulationSampleAnswer.population,
  ),
  Station2PopSampleCard(
    imageAsset: 'assets/images/station2/cards/pop_sample_card4.png',
    description: 'Mosses inside the square frame placed on the rock.',
    answer: PopulationSampleAnswer.sample,
  ),
  Station2PopSampleCard(
    imageAsset: 'assets/images/station2/cards/pop_sample_card5.png',
    description: 'Three selected moss patches among many mosses.',
    answer: PopulationSampleAnswer.sample,
  ),
];

/// Activity 1: Mountain Plant Diversity Investigation.
const String kStation2MountainDiversityBg =
    'assets/images/station2/mountain_diversity/study_area_bg.png';

enum Station2SamplingTool { quadrat, lineTransect, stratified }

class Station2PlantSpecies {
  final String id;
  final String name;
  final String description;
  final String imageAsset;

  const Station2PlantSpecies({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
  });
}

const List<Station2PlantSpecies> kStation2PlantSpecies = [
  Station2PlantSpecies(
    id: 'shrub',
    name: 'Shrub',
    description: 'Woody plant, many stems, no flowers.',
    imageAsset: 'assets/images/station2/mountain_diversity/species/shrub.png',
  ),
  Station2PlantSpecies(
    id: 'floweringPink',
    name: 'Flowering Plant A',
    description: 'Small pink flowers.',
    imageAsset:
        'assets/images/station2/mountain_diversity/species/flowering_pink.png',
  ),
  Station2PlantSpecies(
    id: 'floweringYellow',
    name: 'Flowering Plant B',
    description: 'Small yellow flowers.',
    imageAsset:
        'assets/images/station2/mountain_diversity/species/flowering_yellow.png',
  ),
  Station2PlantSpecies(
    id: 'moss',
    name: 'Moss',
    description: 'Low, soft, green, no flowers.',
    imageAsset: 'assets/images/station2/mountain_diversity/species/moss.png',
  ),
  Station2PlantSpecies(
    id: 'fern',
    name: 'Fern',
    description: 'Feathery green fronds.',
    imageAsset: 'assets/images/station2/mountain_diversity/species/fern.png',
  ),
];

class Station2SamplingToolInfo {
  final Station2SamplingTool tool;
  final String label;
  final String imageAsset;
  final String countRule;

  const Station2SamplingToolInfo({
    required this.tool,
    required this.label,
    required this.imageAsset,
    required this.countRule,
  });
}

const List<Station2SamplingToolInfo> kStation2SamplingTools = [
  Station2SamplingToolInfo(
    tool: Station2SamplingTool.quadrat,
    label: 'Quadrat',
    imageAsset:
        'assets/images/station2/mountain_diversity/tools/tool_quadrat.png',
    countRule: 'Count plants **inside** the square frame.',
  ),
  Station2SamplingToolInfo(
    tool: Station2SamplingTool.lineTransect,
    label: 'Line Transect',
    imageAsset:
        'assets/images/station2/mountain_diversity/tools/tool_line_transect.png',
    countRule: 'Count plants **touching** the transect line.',
  ),
  Station2SamplingToolInfo(
    tool: Station2SamplingTool.stratified,
    label: 'Stratified Sampling',
    imageAsset:
        'assets/images/station2/mountain_diversity/tools/tool_stratified.png',
    countRule:
        'Count plants in the **mid-elevation zone** only (between the two red lines).',
  ),
];

/// Plant markers on the study area (normalized 0–1 coordinates).
/// Plants across three elevation zones (high / mid / low).
/// Mid-elevation counts match [kStation2MountainDiversityAnswerKey].
const List<({String speciesId, double x, double y})> kStation2MountainPlantMarkers =
    [
  // High elevation
  (speciesId: 'shrub', x: 0.28, y: 0.16),
  (speciesId: 'moss', x: 0.55, y: 0.20),
  (speciesId: 'floweringPink', x: 0.78, y: 0.14),
  // Mid elevation (sample zone) — shrub 2, flowering A 3, moss 3, fern 1
  (speciesId: 'shrub', x: 0.25, y: 0.42),
  (speciesId: 'shrub', x: 0.48, y: 0.50),
  (speciesId: 'floweringPink', x: 0.35, y: 0.38),
  (speciesId: 'floweringPink', x: 0.55, y: 0.44),
  (speciesId: 'floweringPink', x: 0.72, y: 0.40),
  (speciesId: 'moss', x: 0.22, y: 0.55),
  (speciesId: 'moss', x: 0.60, y: 0.52),
  (speciesId: 'moss', x: 0.78, y: 0.58),
  (speciesId: 'fern', x: 0.40, y: 0.60),
  // Low elevation
  (speciesId: 'floweringYellow', x: 0.38, y: 0.82),
  (speciesId: 'moss', x: 0.68, y: 0.78),
];

/// Correct mid-elevation species counts for the data table.
const Map<String, int> kStation2MountainDiversityAnswerKey = {
  'shrub': 2,
  'floweringPink': 3,
  'floweringYellow': 0,
  'moss': 3,
  'fern': 1,
};

/// Elevation zone boundaries on the study area (y=0 top, y=1 bottom).
/// Two divider lines create high / mid / low bands.
const double kStation2ElevationHighMidY = 0.34;
const double kStation2ElevationMidLowY = 0.68;

bool station2InMidElevationZone(({String speciesId, double x, double y}) marker) =>
    marker.y >= kStation2ElevationHighMidY &&
    marker.y < kStation2ElevationMidLowY;

const String kStation2MountainDiversityIntro =
    'Researchers are studying different plant species found on a mountain. '
    'Different species are growing in different parts of the area.';

const List<String> kStation2MountainDiversitySteps = [
  'The mountain is divided into **ELEVATION ZONES**.',
  'Using stratified sampling, record the total number of individuals of each '
      'species counted in your sample collected from the mid-elevation zone.',
  'Use the plant species guide as your reference.',
  'Record your answers in the data table and submit.',
];

const String kStation2MountainDiversityReminder =
    '**REMEMBER:** For stratified sampling, count only the plants inside the '
    '**mid-elevation zone** (between the two red lines).';

/// Quadrat bounds on the study area (normalized).
const double kStation2QuadratLeft = 0.32;
const double kStation2QuadratTop = 0.25;
const double kStation2QuadratWidth = 0.36;
const double kStation2QuadratHeight = 0.42;

/// Line transect y-position and touch tolerance (normalized).
const double kStation2TransectY = 0.52;
const double kStation2TransectTolerance = 0.06;

bool station2PlantCounted(
  ({String speciesId, double x, double y}) marker,
  Station2SamplingTool tool,
) {
  switch (tool) {
    case Station2SamplingTool.quadrat:
      return marker.x >= kStation2QuadratLeft &&
          marker.x <= kStation2QuadratLeft + kStation2QuadratWidth &&
          marker.y >= kStation2QuadratTop &&
          marker.y <= kStation2QuadratTop + kStation2QuadratHeight;
    case Station2SamplingTool.lineTransect:
      return (marker.y - kStation2TransectY).abs() <= kStation2TransectTolerance;
    case Station2SamplingTool.stratified:
      return station2InMidElevationZone(marker);
  }
}

Map<String, int> station2ExpectedCounts(Station2SamplingTool tool) {
  final counts = <String, int>{};
  for (final species in kStation2PlantSpecies) {
    counts[species.id] = 0;
  }
  for (final marker in kStation2MountainPlantMarkers) {
    if (station2PlantCounted(marker, tool)) {
      counts[marker.speciesId] = (counts[marker.speciesId] ?? 0) + 1;
    }
  }
  return counts;
}

/// Activity 2 uses the same mountain study-area artwork as Activity 1.
const String kStation2StratifiedSamplingBg = kStation2MountainDiversityBg;

/// Mountain image covers 0–800 m for zone layout (y=0 top, y=1 bottom).
const double kStation2MaxElevationM = 800;

enum Station2StratifiedZone { upper, middle, lower, base }

class Station2StratifiedZoneInfo {
  final Station2StratifiedZone zone;
  final String label;
  final String elevationRange;

  const Station2StratifiedZoneInfo({
    required this.zone,
    required this.label,
    required this.elevationRange,
  });
}

const List<Station2StratifiedZoneInfo> kStation2StratifiedZones = [
  Station2StratifiedZoneInfo(
    zone: Station2StratifiedZone.upper,
    label: 'Upper Zone',
    elevationRange: '600 m and above',
  ),
  Station2StratifiedZoneInfo(
    zone: Station2StratifiedZone.middle,
    label: 'Middle Zone',
    elevationRange: '400–600 m',
  ),
  Station2StratifiedZoneInfo(
    zone: Station2StratifiedZone.lower,
    label: 'Lower Zone',
    elevationRange: '200–400 m',
  ),
  Station2StratifiedZoneInfo(
    zone: Station2StratifiedZone.base,
    label: 'Base Zone',
    elevationRange: '0–200 m',
  ),
];

const List<int> kStation2StratifiedElevationLines = [200, 400, 600];

const String kStation2StratifiedIntro =
    'Researchers are studying the distribution of moss in a mountain ecosystem. '
    'Your task is to use **stratified sampling**.';

const List<String> kStation2StratifiedSteps = [
  'The mountain is divided into **elevation zones**.',
  'Place **three horizontal lines** at **200 m**, **400 m**, and **600 m**.',
  'Each zone between the lines is a sampling area.',
  'In **each zone**, count **only the moss** plants inside that area.',
  'Record your answers in the data table.',
];

const String kStation2StratifiedReminder =
    '**REMEMBER:** Draw lines at the correct elevations and count **ONLY** '
    'the moss in each zone.';

/// Plants on the stratified-sampling mountain (moss is counted per zone).
const List<({String speciesId, double x, double y})> kStation2StratifiedMarkers =
    [
  (speciesId: 'moss', x: 0.22, y: 0.10),
  (speciesId: 'moss', x: 0.45, y: 0.08),
  (speciesId: 'moss', x: 0.68, y: 0.14),
  (speciesId: 'moss', x: 0.82, y: 0.06),
  (speciesId: 'shrub', x: 0.55, y: 0.18),
  (speciesId: 'moss', x: 0.20, y: 0.32),
  (speciesId: 'moss', x: 0.34, y: 0.36),
  (speciesId: 'moss', x: 0.55, y: 0.30),
  (speciesId: 'moss', x: 0.72, y: 0.40),
  (speciesId: 'moss', x: 0.40, y: 0.45),
  (speciesId: 'floweringPink', x: 0.65, y: 0.28),
  (speciesId: 'moss', x: 0.24, y: 0.55),
  (speciesId: 'moss', x: 0.42, y: 0.58),
  (speciesId: 'moss', x: 0.58, y: 0.52),
  (speciesId: 'moss', x: 0.76, y: 0.60),
  (speciesId: 'floweringYellow', x: 0.50, y: 0.68),
  (speciesId: 'moss', x: 0.28, y: 0.82),
  (speciesId: 'moss', x: 0.44, y: 0.78),
  (speciesId: 'moss', x: 0.58, y: 0.85),
  (speciesId: 'moss', x: 0.72, y: 0.80),
  (speciesId: 'moss', x: 0.36, y: 0.92),
  (speciesId: 'moss', x: 0.66, y: 0.93),
  (speciesId: 'fern', x: 0.48, y: 0.72),
];

double station2ElevationLineY(int meters) =>
    1 - meters / kStation2MaxElevationM;

Station2StratifiedZone station2StratifiedZoneForY(double y) {
  if (y >= station2ElevationLineY(200)) return Station2StratifiedZone.base;
  if (y >= station2ElevationLineY(400)) return Station2StratifiedZone.lower;
  if (y >= station2ElevationLineY(600)) return Station2StratifiedZone.middle;
  return Station2StratifiedZone.upper;
}

Map<Station2StratifiedZone, int> station2ExpectedMossPerZone() {
  final counts = {
    for (final z in Station2StratifiedZone.values) z: 0,
  };
  for (final marker in kStation2StratifiedMarkers) {
    if (marker.speciesId != 'moss') continue;
    final zone = station2StratifiedZoneForY(marker.y);
    counts[zone] = (counts[zone] ?? 0) + 1;
  }
  return counts;
}

int get kStation2ExpectedMossTotal =>
    station2ExpectedMossPerZone().values.fold(0, (a, b) => a + b);

const String kStation2TakeawayQ1Prompt =
    'What type of sampling technique is used on the previous activity?';

const List<String> kStation2TakeawayQ1Options = [
  'Random Sampling',
  'Quadrat Sampling',
  'Stratified Sampling',
  'Line Transect Sampling',
];

const int kStation2TakeawayQ1CorrectIndex = 2;

const String kStation2TakeawayQ2Prompt = 'Why do you say so?';

const String kStation2TakeawayInstruction =
    'Answer all three questions. Write complete sentences for Questions 2 '
    'and 3.';

const String kStation2TakeawayQ3Prompt =
    'Why do researchers collect samples instead of studying all organisms '
    'in a mountain ecosystem?';

const String kStation2TakeawayQ3Model =
    'Because there are too many organisms in a mountain ecosystem to study '
    'every one. Sampling is faster and more practical, and it helps '
    'researchers gather organized and reliable data.';

const String kStation2TakeawayModel =
    'Because the mountain was divided into different elevation/section areas '
    'using horizontal lines. The moss samples were counted separately in each '
    'sampling area or zone.';

/// Auto-scores the Question 2 explanation on a 0–5 rubric.
int scoreStation2TakeawayExplanation(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return 0;

  final lower = trimmed.toLowerCase();
  final words =
      lower.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return 0;

  if (_station2TakeawayIsIrrelevant(lower)) return 0;

  final mentionsZones = _station2ContainsAny(lower, [
    'zone',
    'zones',
    'elevation',
    'elevations',
    'section',
    'sections',
    'area',
    'areas',
  ]);
  final mentionsDivide = _station2ContainsAny(lower, [
    'divid',
    'separat',
    'split',
  ]);
  final mentionsCount = _station2ContainsAny(lower, [
    'count',
    'counted',
    'counting',
  ]);
  final mentionsSeparate = _station2ContainsAny(lower, [
    'separate',
    'separately',
    'each zone',
    'each area',
    'per zone',
    'every zone',
    'in each',
  ]);
  final mentionsSampling = _station2ContainsAny(lower, [
    'sampling',
    'sample',
    'samples',
  ]);
  final mentionsMoss = lower.contains('moss');
  final mentionsStratified = lower.contains('stratif');

  final hasDivideAndZones = mentionsDivide && mentionsZones;
  final hasSeparateCount =
      mentionsCount && (mentionsSeparate || mentionsZones);
  final fullExplanation = hasDivideAndZones &&
      hasSeparateCount &&
      (mentionsMoss || mentionsStratified);

  if (fullExplanation) {
    if (words.length < 6) return 1;
    if (_station2TakeawayHasMisspellings(lower)) return 4;
    return 5;
  }

  if (mentionsDivide && mentionsCount) return 4;

  if (mentionsZones || lower.contains('group')) return 3;

  if (mentionsSampling || mentionsCount) return 2;

  if (words.length < 8) return 1;
  return 1;
}

bool _station2ContainsAny(String lower, List<String> terms) =>
    terms.any(lower.contains);

bool _station2TakeawayIsIrrelevant(String lower) {
  const irrelevant = [
    'i don\'t know',
    'idk',
    'no idea',
    'nothing',
    'n/a',
    'none',
  ];
  if (irrelevant.any(lower.contains)) return true;

  final hasScienceTerm = _station2ContainsAny(lower, [
    'moss',
    'sampl',
    'count',
    'zone',
    'elevation',
    'stratif',
    'mountain',
    'area',
    'population',
  ]);
  return !hasScienceTerm && lower.length < 12;
}

bool _station2TakeawayHasMisspellings(String lower) {
  const misspellings = [
    'seperate',
    'seperately',
    'horizonal',
    'horizontel',
    'stratifyed',
    'stratifed',
    'elevaton',
    'sampeling',
    'sampel',
  ];
  return misspellings.any(lower.contains);
}

/// Legacy alias used by [StationContent].
const String kStation2TakeawayPrompt = kStation2TakeawayQ2Prompt;

const List<String> kStation2TakeawayKeywords = [
  'divided',
  'elevation',
  'zone',
  'counted',
  'separately',
  'horizontal',
  'area',
  'stratified',
];

const String kStation2TrailCheckpointBg =
    'assets/images/station2/trail_checkpoint_station_2.png';

const String kStation2BadgeBackgroundAsset =
    'assets/images/station2/station2_badge_bg.png';

const String kStation2BadgeAsset = 'badge_field_pathfinder.png';

/// Part II — Identification (multiple choice).
const String kStation2CheckpointPart1Directions =
    'Read each question carefully. Choose the best answer.';

/// Part II — Identification (multiple choice).
const List<McQuestion> kStation2CheckpointPart1 = [
  McQuestion(
    prompt: 'What is a population in a scientific investigation?',
    options: [
      'A line used in sampling',
      'The whole group being studied',
      'A tool used for counting organisms',
      'A small part taken from a study area',
    ],
    correctIndex: 1,
  ),
  McQuestion(
    prompt: 'Which of the following is an example of a sample?',
    options: [
      'All mosses on the mountain',
      'All organisms in the ecosystem',
      'Every plant species in the forest',
      'Mosses collected from one small area',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt: 'Which sampling tool uses a square frame?',
    options: ['Quadrat', 'Line Transect', 'Belt transect', 'Stratified sampling'],
    correctIndex: 0,
  ),
  McQuestion(
    prompt: 'In a line transect, researchers count organisms that:',
    options: [
      'touch the line',
      'are outside the study area',
      'are found only on rocks',
      'are inside a square frame',
    ],
    correctIndex: 0,
  ),
  McQuestion(
    prompt: 'Why do researchers use sampling techniques?',
    options: [
      'To avoid collecting data',
      'To study only one organism',
      'To make investigations longer',
      'To gather organized and reliable data',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt: 'What type of sampling divides the study area into zones or layers?',
    options: [
      'Random sampling',
      'Quadrat sampling',
      'Stratified sampling',
      'Line transect sampling',
    ],
    correctIndex: 2,
  ),
  McQuestion(
    prompt: 'In the activity, the mountain was divided using:',
    options: ['circles', 'vertical lines', 'horizontal lines', 'square quadrats'],
    correctIndex: 2,
  ),
  McQuestion(
    prompt: 'In moss distribution studies, what serves as the population?',
    options: [
      'Moss colonies gathered from quadrats',
      'Mosses collected from selected elevations',
      'Entire moss community within the mountain',
      'Researchers studying environmental conditions',
    ],
    correctIndex: 2,
  ),
  McQuestion(
    prompt: 'What is the purpose of elevation zones in stratified sampling?',
    options: [
      'To remove organisms',
      'To decorate the mountain',
      'To make counting difficult',
      'To divide the study area into groups',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt: 'Why do researchers collect samples instead of studying all organisms?',
    options: [
      'Because mountains are small',
      'Because all organisms are the same',
      'Because researchers do not need data',
      'Because sampling is faster and more practical',
    ],
    correctIndex: 3,
  ),
];

/// Legacy alias used by [StationContent].
const List<McQuestion> kStation2Checkpoint = kStation2CheckpointPart1;

const String kStation2CheckpointPart2Directions =
    'Read each statement carefully. Click a term on the right, then tap the '
    'matching statement on the left to complete it.';

/// Part I — Matching terms to statements.
class Station2CheckpointChoice {
  final String id;
  final String label;

  const Station2CheckpointChoice({required this.id, required this.label});
}

class Station2CheckpointMatchItem {
  final int number;
  final String statement;
  /// Correct choice [id] — update when the answer key is confirmed.
  final String correctChoiceId;

  const Station2CheckpointMatchItem({
    required this.number,
    required this.statement,
    required this.correctChoiceId,
  });
}

const List<Station2CheckpointChoice> kStation2CheckpointPart2Choices = [
  Station2CheckpointChoice(id: 'line_transect', label: 'LINE TRANSECT'),
  Station2CheckpointChoice(id: 'sample', label: 'SAMPLE'),
  Station2CheckpointChoice(
    id: 'stratified_sampling',
    label: 'STRATIFIED SAMPLING',
  ),
  Station2CheckpointChoice(id: 'quadrat', label: 'QUADRAT'),
  Station2CheckpointChoice(id: 'population', label: 'POPULATION'),
];

const List<Station2CheckpointMatchItem> kStation2CheckpointPart2Items = [
  Station2CheckpointMatchItem(
    number: 1,
    statement: 'Uses a square frame to study organisms in a fixed area.',
    correctChoiceId: 'quadrat',
  ),
  Station2CheckpointMatchItem(
    number: 2,
    statement: 'Uses a straight line across the study area.',
    correctChoiceId: 'line_transect',
  ),
  Station2CheckpointMatchItem(
    number: 3,
    statement:
        'Divides the study area into zones or groups before sampling.',
    correctChoiceId: 'stratified_sampling',
  ),
  Station2CheckpointMatchItem(
    number: 4,
    statement: 'Refers to the whole group being studied.',
    correctChoiceId: 'population',
  ),
  Station2CheckpointMatchItem(
    number: 5,
    statement: 'Refers to a smaller part taken from the population.',
    correctChoiceId: 'sample',
  ),
];

int scoreStation2CheckpointPart2(Map<int, String?> answersByNumber) {
  var score = 0;
  for (final item in kStation2CheckpointPart2Items) {
    if (answersByNumber[item.number] == item.correctChoiceId) score++;
  }
  return score;
}
