/// Avatar welcome script (entices the learner) - shown at the Basecamp.
const String kBasecampWelcome =
    'Welcome, Young Researcher Explorer! Welcome to BioQuest: A Journey Toward '
    'Research Discovery! Get ready to begin an exciting adventure filled with '
    'exploration, challenges, and scientific discovery. Throughout this '
    'interactive learning journey, you will strengthen your research skills, '
    'critical thinking, and scientific understanding through fun and engaging '
    'activities.\n\n'
    'To help you prepare for this journey, read the following: the Short '
    'Overview, the General Instructions, and the Instructional Objectives.';

/// Script shown after the three orientation icons are read.
const String kBasecampReady =
    'Your mission briefing is now complete!\n\n'
    'Get ready to explore, investigate, and discover as you begin your exciting '
    'journey toward the Summit of Discovery. Adventure, challenges, and '
    'scientific discoveries await you, Young Researcher Explorer!';

/// Progress keys for the sequential basecamp orientation flow.
const String kOrientationOverviewKey = 'orientation_overview';
const String kOrientationInstructionsKey = 'orientation_instructions';
const String kOrientationObjectivesKey = 'orientation_objectives';

/// Short Overview sections (icon + text rows inside the parchment card).
const List<({String text})> kShortOverviewSections = [
  (
    text:
        '**BioQuest: A Journey Toward Research Discovery** is an interactive '
        'learning material designed to help you develop the essential '
        'competencies in Practical Research 2 through exciting scientific '
        'investigations and research-based activities.',
  ),
  (
    text:
        'In this journey, you will explore the fascinating world of mosses, '
        'particularly the genera *Ectropothecium* and *Pyrrhobryum*. You will '
        'investigate moss distribution, in vitro propagation, phytochemical '
        'analysis, and antibacterial properties while applying important '
        'research skills such as data gathering, analysis, interpretation, and '
        'scientific investigation.',
  ),
  (
    text:
        'Through different research stations, challenges, and activities, this '
        'interactive material aims to strengthen your critical thinking, '
        'problem-solving, communication, and scientific inquiry skills while '
        'making learning more fun, meaningful, and engaging.',
  ),
];

const String kGeneralInstructions =
    'How to play BioQuest:\n\n'
    '1. Start at the Basecamp and take the short pretest first.\n'
    '2. On the Expedition Map, tap the glowing station to enter it.\n'
    '3. In each station, complete the Discovery Stop, then the Research '
    'Mission, then the Trail Checkpoint.\n'
    '4. Read carefully and follow each activity instruction. Tap or drag items '
    'as directed.\n'
    '5. You will receive your score automatically after each quiz.\n'
    '6. Earn a badge after every station and unlock the next one.\n\n'
    'Tip: You can turn the voiceover ON or OFF anytime using the speaker '
    'button, and the background music can also be turned off in settings if you '
    'prefer to read quietly.';

/// General Instructions — intro paragraph.
const String kGeneralInstructionsIntro =
    'This interactive material is divided into **five research stations** '
    'designed to help you develop the essential competencies in **Practical '
    'Research 2**.';

/// Three subparts every station requires.
const List<({String title, String text})> kGeneralInstructionsSubparts = [
  (
    title: 'DISCOVERY STOP',
    text: 'Learn important concepts and research ideas.',
  ),
  (
    title: 'RESEARCH MISSION',
    text: 'Complete activities and apply what you learned.',
  ),
  (
    title: 'TRAIL CHECKPOINT',
    text: 'Answer the assessment and check your understanding.',
  ),
];

/// Progression rules shown below the subparts flow.
const List<({String text})> kGeneralInstructionsRules = [
  (
    text:
        'Complete all tasks in one station before moving to the next to earn '
        'a **Research Badge**.',
  ),
  (
    text:
        'Collect all five badges to unlock the **Summit of Discovery** for a '
        'final Summative Test and receive your **Young Researcher Explorer '
        'Certificate**.',
  ),
];

/// Instructional Objectives — intro banner text.
const String kObjectivesIntro =
    'At the end of this interactive learning journey, you are expected to:';

/// Three objective columns (Knowledge, Skills, Values).
const List<({String title, List<String> items})>
kInstructionalObjectiveColumns = [
  (
    title: 'KNOWLEDGE OBJECTIVES',
    items: [
      'understand the basic concepts of quantitative research and scientific '
          'investigation;',
      'explain moss distribution, in vitro propagation, phytochemical '
          'profiling, and antibacterial properties of mosses.',
    ],
  ),
  (
    title: 'SKILLS OBJECTIVES',
    items: [
      'apply Practical Research 2 competencies in conducting research-based '
          'activities and investigations;',
      'collect, organize, present, and analyze scientific data using '
          'appropriate research tools and techniques.',
    ],
  ),
  (
    title: 'VALUES OBJECTIVES',
    items: [
      'practice honesty, responsibility, and objectivity in conducting '
          'research activities;',
      'appreciate biodiversity, environmental conservation, and the importance '
          'of scientific inquiry.',
    ],
  ),
];
