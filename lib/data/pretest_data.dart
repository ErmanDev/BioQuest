import '../models/mc_question.dart';

/// Table stimulus for pretest questions 8–10.
const McTableStimulus kPretestMossShootTable = McTableStimulus(
  intro:
      'For Questions 8–10, refer to the hypothetical data below on the '
      'in vitro propagation of two moss species.\n\n'
      'Researchers observed the number of new shoots produced by two moss '
      'species over four weeks of in vitro propagation.',
  headers: ['Week', 'Moss Species A', 'Moss Species B'],
  rows: [
    ['Week 1', '5 shoots', '7 shoots'],
    ['Week 2', '8 shoots', '11 shoots'],
    ['Week 3', '11 shoots', '15 shoots'],
    ['Week 4', '14 shoots', '20 shoots'],
  ],
);

/// Table stimulus for summative questions 17–20 (same data, different prompt).
const McTableStimulus kSummativeMossShootTableSource = McTableStimulus(
  intro:
      'For numbers 17–20. Refer to the hypothetical data below about the '
      'in vitro propagation of two moss species.\n\n'
      'Researchers observed the number of new shoots produced by two moss '
      'species during 4 weeks of in vitro propagation.',
  headers: ['Week', 'Moss Species A', 'Moss Species B'],
  rows: [
    ['Week 1', '5 shoots', '7 shoots'],
    ['Week 2', '8 shoots', '11 shoots'],
    ['Week 3', '11 shoots', '15 shoots'],
    ['Week 4', '14 shoots', '20 shoots'],
  ],
);

/// 10-item pretest taken before the stations. Score is shown at the end but
/// answers are never revealed (per the design doc).
const List<McQuestion> kPretest = [
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
    prompt:
        'A student needs to measure the shoot height of a moss sample accurately. Which instrument should be used?',
    options: ['Ruler', 'Camera', 'Beaker', 'Stopwatch'],
    correctIndex: 0,
  ),
  McQuestion(
    prompt:
        'Which statistical tool is commonly used to determine the average value?',
    options: ['mode', 'mean', 'median', 'ANOVA'],
    correctIndex: 1,
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
    prompt:
        'Which example below is considered quantitative data in the investigation?',
    options: [
      'Name of the researcher conducting the study',
      'Type of bacteria used during experimentation',
      'Color appearance of the prepared agar plates',
      'Measurement of the inhibition zone in millimeters',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt:
        'Which statement best explains the trend shown by Moss Species B from Week 1 to Week 4?',
    tableStimulus: kPretestMossShootTable,
    options: [
      'Its growth changed randomly with no clear pattern',
      'Its growth steadily increased over the 4-week period.',
      'Its number of shoots gradually decreased each week.',
      'Its growth remained constant throughout the experiment.',
    ],
    correctIndex: 1,
  ),
  McQuestion(
    prompt:
        'Which type of graph is most appropriate for presenting the growth of the two moss species over 4 weeks?',
    tableStimulus: kPretestMossShootTable,
    options: ['Pie graph', 'Bar graph', 'Line graph', 'Scatter plot'],
    correctIndex: 2,
  ),
  McQuestion(
    prompt:
        'Which statement best compares the growth of Moss Species A and Moss Species B during the 4-week in vitro propagation experiment?',
    tableStimulus: kPretestMossShootTable,
    options: [
      'Both moss species produced the same number of shoots each week.',
      'Moss Species B consistently produced more shoots than Moss Species A.',
      'Moss Species A consistently produced more shoots than Moss Species B.',
      'Moss Species A and B showed decreasing growth throughout the experiment.',
    ],
    correctIndex: 1,
  ),
];
