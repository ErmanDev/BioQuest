import '../models/mc_question.dart';
import 'pretest_data.dart';

const String kSummitSummativeBackgroundAsset =
    'assets/images/summit/summit_summative_bg.png';

const String kSummitCertificateAsset =
    'assets/images/summit/summit_certificate.png';

/// Script font for the recipient name on the summit certificate.
const String kSummitCertificateNameFont = 'GreatVibes';

const String kSummitCitation = 'Emerging Scientific Researcher';

const String kSummitSummativeDirections =
    'Read each question carefully and choose the letter of the best answer.';

const McTableStimulus kSummativeMossShootTable =
    kSummativeMossShootTableSource;

/// 20-item summative test at the Discovery Summit (question order from answer key).
const List<McQuestion> kSummative = [
  McQuestion(
    prompt:
        'A student needs to measure the shoot height of a moss sample accurately. Which instrument should be used?',
    options: ['Ruler', 'Camera', 'Beaker', 'Stopwatch'],
    correctIndex: 0,
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
    prompt:
        'Which statistical tool is commonly used to determine the average value?',
    options: ['mode', 'mean', 'median', 'ANOVA'],
    correctIndex: 1,
  ),
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
        'In the antibacterial assay investigation, what will be measured by the researchers?',
    options: [
      'The amount of moss collected',
      'The temperature inside the room',
      'The diameter of the zone of inhibition',
      'The number of bacteria found in the plate',
    ],
    correctIndex: 2,
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
        'A researcher tests the antibacterial activity of moss extracts against bacteria. Which research design should be used?',
    options: [
      'Experimental Research',
      'Descriptive Research',
      'Correlational Research',
      'Quasi-Experimental Research',
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
        'Which research design involves manipulating variables under controlled laboratory conditions?',
    options: [
      'Descriptive Research',
      'Correlational Research',
      'Experimental Research',
      'Quasi-Experimental Research',
    ],
    correctIndex: 2,
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
        'Why is choosing the correct instrument important in scientific investigations?',
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
        'Why is organizing collected data in tables important during scientific investigations?',
    options: [
      'To make the report colorful',
      'To collect the data in a correct way',
      'To make the report longer and better',
      'To compare and analyze data easily',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt:
        'Why do researchers usually perform several replicates in an experiment?',
    options: [
      'To shorten the duration of the investigation',
      'To increase the reliability of gathered results',
      'To reduce the preparation of laboratory tools',
      'To replace the original hypothesis completely',
    ],
    correctIndex: 1,
  ),
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
        'What does the mean represent in scientific investigations and experiments?',
    options: [
      'The middle value after arranging all scores',
      'The conclusion written after data interpretation',
      'The smallest value among all measurements taken',
      'The average obtained from repeated measurements',
    ],
    correctIndex: 3,
  ),
  McQuestion(
    prompt:
        'Which statement best explains the trend shown by Moss Species B from Week 1 to Week 4?',
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
    options: ['Pie graph', 'Bar graph', 'Line graph', 'Scatter plot'],
    correctIndex: 2,
  ),
  McQuestion(
    prompt:
        'Which statement best compares the growth of Moss Species A and Moss Species B during the 4-week in vitro propagation experiment?',
    options: [
      'Both moss species produced the same number of shoots each week.',
      'Moss Species B consistently produced more shoots than Moss Species A.',
      'Moss Species A consistently produced more shoots than Moss Species B.',
      'Moss Species A and B showed decreasing growth throughout the experiment.',
    ],
    correctIndex: 1,
  ),
  McQuestion(
    prompt:
        'If the experiment continued for two more weeks and the trend remained the same, what is the most reasonable prediction for Moss Species A?',
    options: [
      'Its number of shoots would suddenly decrease',
      'Its growth would likely continue increasing gradually.',
      'Its growth would remain exactly at 14 shoots forever.',
      'Its growth would become lower than Week 1 results.',
    ],
    correctIndex: 1,
  ),
];

const String kReferences =
    'Asakawa, Y., & Ludwiczuk, A. (2018). Chemical constituents of bryophytes: '
    'structures and biological activity. Journal of Natural Products, 81(3), '
    '641-660. https://doi.org/10.1021/acs.jnatprod.6b01046\n\n'
    'Bevans, R. (2023, June 22). Hypothesis testing: A step-by-step guide with '
    'easy examples. Scribbr. https://www.scribbr.com/statistics/hypothesis-testing/\n\n'
    'Glime, J. M. (2017). Meet the bryophytes. Michigan Technological '
    'University; International Association of Bryologists. '
    'https://digitalcommons.mtu.edu/bryophyte-ecology1/\n\n'
    'Maheshwaran, L., Nadarajah, L., Senadeera, S. P. N. N., Ranaweera, C. B., '
    'Chandana, A. K., & Pathirana, R. N. (2024). Phytochemical testing '
    'methodologies and principles for preliminary screening/qualitative '
    'testing. Asian Plant Research Journal, 12(5), 11-38.\n\n'
    'SurveyMonkey. (n.d.). Types of quantitative research: Examples + tips. '
    'SurveyMonkey. '
    'https://www.surveymonkey.com/market-research/resources/quantitative-research-types';
