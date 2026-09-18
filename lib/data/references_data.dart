/// Bibliographic references shown from the Expedition Map.
///
/// Each entry is a list of text runs. Mark italicized titles/journal names
/// with [italic]: true so the UI can render APA-style citations.
class ReferenceRun {
  final String text;
  final bool italic;

  const ReferenceRun(this.text, {this.italic = false});
}

const List<List<ReferenceRun>> kReferences = [
  [
    ReferenceRun(
      'Asakawa, Y., & Ludwiczuk, A. (2018). Chemical constituents of '
      'bryophytes: structures and biological activity. ',
    ),
    ReferenceRun('Journal of Natural Products, 81', italic: true),
    ReferenceRun(
      '(3), 641–660. https://doi.org/10.1021/acs.jnatprod.6b01046',
    ),
  ],
  [
    ReferenceRun('Bevans, R. (2023, June 22). '),
    ReferenceRun(
      'Hypothesis testing: A step-by-step guide with easy examples.',
      italic: true,
    ),
    ReferenceRun(
      ' Scribbr. https://www.scribbr.com/statistics/hypothesis-testing/',
    ),
  ],
  [
    ReferenceRun('Glime, J. M. (2017). '),
    ReferenceRun('Meet the bryophytes.', italic: true),
    ReferenceRun(
      ' Michigan Technological University; International Association of '
      'Bryologists. https://digitalcommons.mtu.edu/bryophyte-ecology1/',
    ),
  ],
  [
    ReferenceRun(
      'Maheshwaran, L., Nadarajah, L., Senadeera, S. P. N. N., Ranaweera, '
      'C. B., Chandana, A. K., & Pathirana, R. N. (2024). Phytochemical '
      'testing methodologies and principles for preliminary '
      'screening/qualitative testing. ',
    ),
    ReferenceRun('Asian Plant Research Journal, 12', italic: true),
    ReferenceRun('(5), 11–38.'),
  ],
  [
    ReferenceRun(
      'Sabovljević, M. S., Nikolić, N., Vujičić, M., Šinžar-Sekulić, J., '
      'Pantović, J., Papp, B., & Sabovljević, A. D. (2018). Ecology, '
      'distribution, in vitro propagation, ex situ conservation and native '
      'population strengthening of the rare and threatened halophyte moss ',
    ),
    ReferenceRun('Entosthodon hungaricus', italic: true),
    ReferenceRun(' in Serbia. '),
    ReferenceRun('Wulfenia, 25', italic: true),
    ReferenceRun(', 117–130.'),
  ],
  [
    ReferenceRun(
      'Sabovljević, M. S., Sabovljević, A. D., Ikram, N. K. K., Peramuna, A., '
      'Bae, H., & Simonsen, H. T. (2016). Bryophytes – an emerging source for '
      'herbal remedies and chemical production. ',
    ),
    ReferenceRun('Plant Genetic Resources, 14', italic: true),
    ReferenceRun(
      '(4), 314–327. https://doi.org/10.1017/s1479262116000320',
    ),
  ],
  [
    ReferenceRun('SurveyMonkey. (n.d.). '),
    ReferenceRun(
      'Types of quantitative research: Examples + tips.',
      italic: true,
    ),
    ReferenceRun(
      ' SurveyMonkey. https://www.surveymonkey.com/market-research/'
      'resources/quantitative-research-types',
    ),
  ],
];
