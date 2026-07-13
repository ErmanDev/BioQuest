/// Tabular stimulus material shown above a quiz prompt (e.g. pretest Q17–20).
class McTableStimulus {
  final String intro;
  final List<String> headers;
  final List<List<String>> rows;

  const McTableStimulus({
    required this.intro,
    required this.headers,
    required this.rows,
  });
}

/// A multiple-choice question. [correctIndex] is the 0-based index into
/// [options] (A=0, B=1, ...). Answers are never shown to the learner per the
/// design doc; only the final score is revealed.
class McQuestion {
  final String prompt;
  final List<String> options;
  final int correctIndex;

  /// Optional plain-text stimulus shown above the prompt.
  final String? stimulus;

  /// Optional data table stimulus shown above the prompt.
  final McTableStimulus? tableStimulus;

  const McQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.stimulus,
    this.tableStimulus,
  });
}
