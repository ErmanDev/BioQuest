import 'package:flutter/material.dart';

import '../core/text_format.dart';
import '../models/mc_question.dart';

/// Welcome script for Station 3 (shown + spoken on the station splash).
const String kStation3Intro =
    'Welcome, young researchers! In this station, you will enter the Green '
    'Growth Laboratory, where scientists carefully grow moss inside sterile '
    'containers through a process called *in vitro* propagation.\n\n'
    'But this station is not only about growing moss. More importantly, it will '
    'train you to think and work like real researchers by learning how to:\n'
    '• Plan data collection procedure (**CS_RS12-IIa-c-5**)\n'
    '• Collect data using appropriate research instruments (**CS_RS12-IId-g-1**)\n\n'
    'As you explore the fascinating process of moss propagation, you will also '
    'discover that successful scientific investigations depend on organized '
    'planning and reliable data gathering.';

/// Plain text for TTS (no bullet/markup symbols).
String get kStation3IntroNarration => stripReadingMarkup(
      kStation3Intro.replaceAll('• ', ''),
    );

/// Discovery Stop reading content. Wrap key terms in ** for bold emphasis.
const String kStation3DiscoveryBackgroundAsset =
    'assets/images/station3/dstop_station_3.png';

const String kStation3JarAsset = 'assets/images/station3/jar.png';

const String kStation3MissionBackgroundAsset =
    'assets/images/station3/station_3_RM.png';

const String kStation3Mission3BackgroundAsset =
    'assets/images/station3/mission_3.png';

/// Placeholder until the full mission story is provided.
const String kStation3MissionStoryPart1 =
    'One week before the **International Moss Research Expo**, the '
    '**Green Growth Laboratory** experienced a major problem.';

const String kStation3MissionStoryPart2 =
    'The scientists discovered that several moss cultures were growing '
    'differently, but the research records were incomplete and some laboratory '
    'instruments were misplaced. Without accurate data, the investigation could '
    'not be completed.';

const String kStation3MissionStoryPart3 =
    'Because of your research skills, you were selected to become a '
    '**Junior Moss Investigator**. Your mission is to enter the laboratory, '
    'organize the data collection procedure, use the correct scientific '
    'instruments, and help the research team gather reliable evidence before '
    'the moss cultures are lost.';

const String kStation3MissionStoryPart4 =
    'The success of the investigation now depends on you.';

const List<String> kStation3YourMissions = [
  'Organize the data collection procedure.',
  'Use the correct scientific instruments.',
  'Gather accurate observations and record reliable data.',
  'Help the research team complete the investigation in time!',
];

String get kStation3MissionStory {
  final missions = kStation3YourMissions
      .asMap()
      .entries
      .map((entry) => '${entry.key + 1}. ${entry.value}')
      .join('\n');
  return '$kStation3MissionStoryPart1\n\n'
      '$kStation3MissionStoryPart2\n\n'
      '$kStation3MissionStoryPart3\n\n'
      '$kStation3MissionStoryPart4\n\n'
      'Your mission:\n'
      '$missions';
}

const String kStation3DiscoveryPart1 =
    'The term **in vitro** comes from a Latin phrase meaning "within glass." In '
    'science, it refers to growing organisms inside a **controlled laboratory '
    'environment** using glass containers, culture bottles, petri dishes, or any '
    '**sterile containers**. **In vitro propagation of moss** is a technique '
    'where small moss parts such as **spores**, **leaves**, or **stem fragments** '
    'are grown under **sterile conditions** with the proper **media**, '
    '**nutrients**, **moisture**, and **light**.\n\n'
    'Through this method, scientists can produce large numbers of moss plants, '
    'study their **growth and development**, preserve **rare species**, and '
    'observe how moss **responds** to different **environmental conditions**. '
    'Unlike moss growing naturally on rocks or tree trunks, in vitro propagation '
    'allows researchers to carefully control environmental factors and observe '
    'changes more **systematically**.';

const String kStation3DiscoveryPart2 =
    'In moss in vitro propagation, researchers do not simply observe moss '
    'growing inside culture containers. Instead, they gather **scientific '
    'evidence** to understand how different environmental factors affect moss '
    'growth and development. Researchers may investigate whether a nutrient '
    'solution promotes faster growth, whether light intensity affects moss color '
    'and size, or how long moss takes to develop under controlled laboratory '
    'conditions.\n\n'
    'To answer these research questions accurately, scientists must first plan '
    'a systematic **data collection procedure** and use **appropriate '
    'instruments** that will help them gather reliable observations and '
    'measurements throughout the investigation.';

const String kStation3DiscoveryPart3 =
    'A **data collection procedure** serves as a guide for how information will '
    'be gathered throughout the investigation. Before starting the experiment, '
    'researchers must first decide what type of **data** should be collected. In '
    'moss propagation studies, the data may include moss height, number of new '
    '**shoots**, moisture levels, or growth rate over time.\n\n'
    'Researchers must also determine when the data should be collected. Some '
    'experiments require daily observations, while others may involve recording '
    'data every three days or once a week. **Consistent timing** is important '
    'because it helps ensure **fairness** and **accuracy** in the investigation.';

const String kStation3DiscoveryPart4 =
    'After planning the data collection procedure, researchers must then select '
    'the most appropriate **research instruments** for gathering accurate '
    'observations and measurements. The instruments used in the investigation '
    'depend on the type of data needed during the experiment. Using suitable '
    'research instruments improves the **validity** and **reliability** of the '
    'collected information.';

const String kStation3DiscoveryInstrumentsIntro =
    'Below are some common research instruments that can be used in this study:';

class Station3ResearchInstrument {
  final String name;
  final String imageFile;
  final String purpose;

  const Station3ResearchInstrument({
    required this.name,
    required this.imageFile,
    required this.purpose,
  });

  String get imageAsset =>
      'assets/images/station3/research_instruments/$imageFile';
}

const List<Station3ResearchInstrument> kStation3ResearchInstruments = [
  Station3ResearchInstrument(
    name: 'Ruler',
    imageFile: 'ruler.png',
    purpose: 'Measures moss height or spread',
  ),
  Station3ResearchInstrument(
    name: 'Thermometer',
    imageFile: 'thermometer.png',
    purpose: 'Measures temperature inside the laboratory',
  ),
  Station3ResearchInstrument(
    name: 'Hygrometer',
    imageFile: 'hygrometer.png',
    purpose: 'Measures humidity level',
  ),
  Station3ResearchInstrument(
    name: 'Digital weighing scale',
    imageFile: 'digital_weighing_scale.png',
    purpose: 'Measures biomass or mass',
  ),
  Station3ResearchInstrument(
    name: 'Camera or smartphone',
    imageFile: 'camera.png',
    purpose: 'Documents visual changes',
  ),
  Station3ResearchInstrument(
    name: 'Observation sheet',
    imageFile: 'observation_sheet.png',
    purpose: 'Records daily observations',
  ),
  Station3ResearchInstrument(
    name: 'Stopwatch or timer',
    imageFile: 'stopwatch.png',
    purpose: 'Monitors time intervals',
  ),
  Station3ResearchInstrument(
    name: 'Graduated cylinder',
    imageFile: 'graduated_cylinder.png',
    purpose: 'Measures volume of liquid accurately',
  ),
  Station3ResearchInstrument(
    name: 'Microscope',
    imageFile: 'microscope.png',
    purpose: 'Observes tiny moss structures',
  ),
];

const String kStation3DiscoveryPart5 =
    'Remember, young researchers: successful investigations do not only depend '
    'on growing moss properly. They also depend on how carefully you **collect**, '
    '**record**, and **analyze** your data using the appropriate **research '
    'instruments**.';

const String _kStation3InstrumentsNarration =
    'Ruler: Measures moss height or spread\n'
    'Thermometer: Measures temperature inside the laboratory\n'
    'Hygrometer: Measures humidity level\n'
    'Digital weighing scale: Measures biomass or mass\n'
    'Camera or smartphone: Documents visual changes\n'
    'Observation sheet: Records daily observations\n'
    'Stopwatch or timer: Monitors time intervals\n'
    'Graduated cylinder: Measures volume of liquid accurately\n'
    'Microscope: Observes tiny moss structures';

const String kStation3Content =
    '$kStation3DiscoveryPart1\n\n'
    '$kStation3DiscoveryPart2\n\n'
    '$kStation3DiscoveryPart3\n\n'
    '$kStation3DiscoveryPart4\n\n'
    '$kStation3DiscoveryInstrumentsIntro\n'
    '$_kStation3InstrumentsNarration\n\n'
    '$kStation3DiscoveryPart5';

/// Mission Activity 1: order the data collection procedure correctly.
class Station3ProcedureStep {
  final String label;
  final IconData icon;

  const Station3ProcedureStep({
    required this.label,
    required this.icon,
  });
}

const List<Station3ProcedureStep> kStation3ProcedureSteps = [
  Station3ProcedureStep(
    label: 'Identify the data needed',
    icon: Icons.checklist_rtl,
  ),
  Station3ProcedureStep(
    label: 'Determine the schedule of observation',
    icon: Icons.calendar_today,
  ),
  Station3ProcedureStep(
    label: 'Select the appropriate instruments',
    icon: Icons.science_outlined,
  ),
  Station3ProcedureStep(
    label: 'Observe the moss cultures',
    icon: Icons.search,
  ),
  Station3ProcedureStep(
    label: 'Record observations in a data sheet',
    icon: Icons.edit_note,
  ),
  Station3ProcedureStep(
    label: 'Organize and analyze the gathered data',
    icon: Icons.bar_chart,
  ),
];

const List<String> kStation3Procedure = [
  'Identify the data needed',
  'Determine the schedule of observation',
  'Select the appropriate instruments',
  'Observe the moss cultures',
  'Record observations in a data sheet',
  'Organize and analyze the gathered data',
];

/// Mission Activity 2: match each laboratory task to the correct instrument.
class Station3InstrumentMatchTask {
  final String task;
  final String instrumentFile;

  const Station3InstrumentMatchTask({
    required this.task,
    required this.instrumentFile,
  });
}

const List<Station3InstrumentMatchTask> kStation3InstrumentMatchTasks = [
  Station3InstrumentMatchTask(
    task: 'Measure the height of moss growth.',
    instrumentFile: 'ruler.png',
  ),
  Station3InstrumentMatchTask(
    task: 'Measure the weight of mass.',
    instrumentFile: 'digital_weighing_scale.png',
  ),
  Station3InstrumentMatchTask(
    task: 'Observe tiny moss structures.',
    instrumentFile: 'microscope.png',
  ),
  Station3InstrumentMatchTask(
    task: 'Measure laboratory temperature.',
    instrumentFile: 'thermometer.png',
  ),
  Station3InstrumentMatchTask(
    task: 'Record daily observations.',
    instrumentFile: 'observation_sheet.png',
  ),
  Station3InstrumentMatchTask(
    task: 'Measure humidity level.',
    instrumentFile: 'hygrometer.png',
  ),
  Station3InstrumentMatchTask(
    task: 'Document physical changes in moss.',
    instrumentFile: 'camera.png',
  ),
  Station3InstrumentMatchTask(
    task: 'Measure volume of liquids accurately.',
    instrumentFile: 'graduated_cylinder.png',
  ),
];

Station3ResearchInstrument? station3InstrumentByFile(String imageFile) {
  for (final instrument in kStation3ResearchInstruments) {
    if (instrument.imageFile == imageFile) return instrument;
  }
  return null;
}

/// Mission Activity 3: measure Pyrrhobryum moss shoot heights with a ruler.
const String kStation3MossBaseImage = 'moss_r3.png';
const double kStation3MossReferenceHeightCm = 5.5;

const String kStation3MossBaseAsset =
    'assets/images/station3/moss_replicates/$kStation3MossBaseImage';

class Station3MossReplicate {
  final String label;
  final double initialHeight;
  final double afterHarvestHeight;

  const Station3MossReplicate({
    required this.label,
    required this.initialHeight,
    required this.afterHarvestHeight,
  });

  double get heightDifference => afterHarvestHeight - initialHeight;
}

const List<Station3MossReplicate> kStation3MossReplicates = [
  Station3MossReplicate(
    label: 'R1',
    initialHeight: 1.0,
    afterHarvestHeight: 4.0,
  ),
  Station3MossReplicate(
    label: 'R2',
    initialHeight: 3.5,
    afterHarvestHeight: 5.0,
  ),
  Station3MossReplicate(
    label: 'R3',
    initialHeight: 3.0,
    afterHarvestHeight: 5.5,
  ),
  Station3MossReplicate(
    label: 'R4',
    initialHeight: 2.5,
    afterHarvestHeight: 3.5,
  ),
  Station3MossReplicate(
    label: 'R5',
    initialHeight: 1.5,
    afterHarvestHeight: 4.5,
  ),
];

class Station3Mission3Instrument {
  final String id;
  final String label;
  final String hint;
  final String? imageFile;
  final bool isCorrect;

  const Station3Mission3Instrument({
    required this.id,
    required this.label,
    required this.hint,
    this.imageFile,
    required this.isCorrect,
  });

  String? get imageAsset => imageFile == null
      ? null
      : 'assets/images/station3/research_instruments/$imageFile';
}

const List<Station3Mission3Instrument> kStation3Mission3Instruments = [
  Station3Mission3Instrument(
    id: 'ruler',
    label: 'Ruler',
    hint: 'Best for measuring short heights accurately.',
    imageFile: 'ruler.png',
    isCorrect: true,
  ),
];

/// Legacy alias used by checkpoint table narration.
const List<({String label, double height})> kStation3Plants = [
  (label: 'R1', height: 4.0),
  (label: 'R2', height: 5.0),
  (label: 'R3', height: 5.5),
  (label: 'R4', height: 3.5),
  (label: 'R5', height: 4.5),
];

const String kStation3TakeawayBackgroundAsset =
    'assets/images/station3/station_3_takeaway.png';

const String kStation3TrailCheckpointBackgroundAsset =
    'assets/images/station3/trail_checkpoint_station_3.png';

const String kStation3BadgeBackgroundAsset =
    'assets/images/station3/trail_checkpoint_station_3.png';

const String kStation3BadgeAsset = 'badge_data_collection.png';

const String kStation3BadgeNextMessage =
    'Data collected! Station 4 is now unlocked on the Expedition Map.';

const String kStation3CheckpointInstructions =
    'Read each question carefully. Tap the correct answer. '
    'Each correct answer powers up the laboratory!';

const String kStation3TakeawayPrompt =
    'Why is choosing the correct instrument important when collecting '
    'scientific data?';

const String kStation3TakeawayInstruction =
    'Explain your answer in 2–3 sentences.';

const String kStation3TakeawayMaxSentencesNote =
    'MAXIMUM OF 3 SENTENCES ONLY.';

const String kStation3TakeawayModel =
    'Choosing the correct instrument is important because it helps researchers '
    'collect accurate and reliable data. Using the wrong tool can lead to '
    'incorrect measurements and unreliable conclusions. The right instrument '
    'ensures that observations truly reflect what happened in the investigation.';

const List<String> kStation3TakeawayKeywords = [
  'accurate',
  'reliable',
  'instrument',
  'correct',
  'data',
  'measure',
  'valid',
  'scientific',
  'wrong',
  'conclusion',
];

/// Laboratory shoot-height data for Trail Checkpoint questions 7–9.
const List<List<String>> kStation3CheckpointTableRows = [
  ['R1', '1.0 cm', '4.0 cm'],
  ['R2', '3.5 cm', '6.5 cm'],
  ['R3', '3.0 cm', '5.0 cm'],
  ['R4', '2.5 cm', '6.0 cm'],
  ['R5', '1.5 cm', '4.5 cm'],
];

/// Expected height differences (after harvest − before planting), in cm.
const List<double> kStation3CheckpointHeightDifferences = [
  3.0,
  3.0,
  2.0,
  3.5,
  3.0,
];

const McTableStimulus kStation3CheckpointTable = McTableStimulus(
  intro:
      'Analyze the laboratory data carefully and answer the questions that follow.',
  headers: [
    'REPLICATE',
    'BEFORE PLANTING',
    'AFTER HARVEST',
    'HEIGHT DIFFERENCE',
  ],
  rows: kStation3CheckpointTableRows,
);

const List<McQuestion> kStation3Checkpoint = [
  McQuestion(
    prompt:
        'A student needs to measure the shoot height of a moss sample accurately. Which instrument should be used?',
    options: ['Ruler', 'Camera', 'Beaker', 'Stopwatch'],
    correctIndex: 0,
  ),
  McQuestion(
    prompt:
        'During the investigation, the researcher wants to compare the mass of moss samples before and after harvest. Which instrument is most appropriate?',
    options: ['Thermometer', 'Tape Measure', 'Digital caliper', 'Digital Balance'],
    correctIndex: 3,
  ),
  McQuestion(
    prompt:
        'A learner wants to observe very small moss structures that cannot be seen clearly by the naked eye. Which instrument should be used?',
    options: ['Beaker', 'Hygrometer', 'Stopwatch', 'Microscope'],
    correctIndex: 3,
  ),
  McQuestion(
    prompt: 'Why is choosing the correct instrument important in scientific investigations?',
    options: [
      'To finish slowly',
      'To avoid observations',
      'To make the laboratory colorful',
      'To collect accurate scientific data',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt:
        'A researcher wants to compare the physical appearance of moss cultures every week. Which tool would provide the best visual record?',
    options: ['Ruler', 'Beaker', 'Camera', 'Stopwatch'],
    correctIndex: 2,
  ),
  McQuestion(
    prompt:
        'A group collected measurements using different instruments incorrectly. What is the most likely effect on their investigation?',
    options: [
      'Faster moss growth',
      'More colorful cultures',
      'Less reliable research data',
      'More laboratory equipment',
    ],
    correctIndex: 2,
  ),
  McQuestion(
    prompt: 'Which replicate showed the greatest increase in shoot height?',
    tableStimulus: kStation3CheckpointTable,
    options: ['R1', 'R3', 'R4', 'R5'],
    correctIndex: 2,
  ),
  McQuestion(
    prompt: 'Which replicate had the tallest moss after harvest?',
    tableStimulus: kStation3CheckpointTable,
    options: ['R2', 'R3', 'R4', 'R5'],
    correctIndex: 0,
  ),
  McQuestion(
    prompt: 'Based on the table, what can be concluded about the moss samples after one month?',
    tableStimulus: kStation3CheckpointTable,
    options: [
      'All moss samples died',
      'Moss samples showed no changes',
      'Most moss samples increased in height',
      'Moss samples became shorter and bigger',
    ],
    correctIndex: 2,
  ),
  McQuestion(
    prompt: 'Why is organizing collected data in tables important during scientific investigations?',
    options: [
      'To analyze data easily',
      'To make the report longer',
      'To avoid laboratory work',
      'To make the table colorful',
    ],
    correctIndex: 0,
  ),
];
