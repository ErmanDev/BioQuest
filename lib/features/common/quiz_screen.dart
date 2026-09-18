import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/quiz_stimulus_table.dart';
import '../../models/mc_question.dart';

/// Reusable multiple-choice quiz. Enable [showAnswerFeedback] to lock each
/// answer after selection and highlight correct (green) / wrong (red).
class QuizScreen extends StatefulWidget {
  final String title;
  final List<McQuestion> questions;
  final String continueLabel;
  final void Function(int score, int total) onComplete;
  final VoidCallback? onBack;
  final String? backgroundAsset;
  final String? backgroundLabel;
  final List<Color>? gradient;
  final double scrimOpacity;
  final bool fullBleedBackground;
  final bool showAnswerFeedback;
  final double promptFontSize;
  final double optionFontSize;
  final double stimulusFontSize;
  final double nextFontSize;
  final bool showNextIcon;
  final double titleFontSize;
  final double backButtonSize;

  const QuizScreen({
    super.key,
    required this.title,
    required this.questions,
    required this.onComplete,
    this.continueLabel = 'Continue',
    this.onBack,
    this.backgroundAsset,
    this.backgroundLabel,
    this.gradient,
    this.scrimOpacity = 0.25,
    this.fullBleedBackground = false,
    this.showAnswerFeedback = false,
    this.promptFontSize = 21,
    this.optionFontSize = 17,
    this.stimulusFontSize = 15,
    this.nextFontSize = 22,
    this.showNextIcon = true,
    this.titleFontSize = 20,
    this.backButtonSize = 46,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _index = 0;
  late final List<int?> _answers =
      List<int?>.filled(widget.questions.length, null);
  bool _finished = false;

  int get _score {
    var s = 0;
    for (var i = 0; i < widget.questions.length; i++) {
      if (_answers[i] == widget.questions[i].correctIndex) s++;
    }
    return s;
  }

  void _selectAnswer(int optionIndex) {
    if (widget.showAnswerFeedback && _answers[_index] != null) return;
    setState(() => _answers[_index] = optionIndex);
  }

  void _next() {
    if (_index < widget.questions.length - 1) {
      setState(() => _index++);
    } else {
      setState(() => _finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BioScaffold(
      title: widget.title,
      titleFontSize: widget.titleFontSize,
      backButtonSize: widget.backButtonSize,
      backgroundAsset: widget.backgroundAsset,
      backgroundLabel: widget.backgroundLabel ?? widget.title,
      gradient: widget.gradient ?? const [BioColors.deepSky, BioColors.leaf],
      scrimOpacity: widget.scrimOpacity,
      fullBleedBackground: widget.fullBleedBackground,
      onBack: widget.onBack,
      body: _finished ? _result() : _question(),
    );
  }

  Widget _question() {
    final q = widget.questions[_index];
    final selected = _answers[_index];
    final answered = selected != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: BioColors.sun,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Question ${_index + 1} of ${widget.questions.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.optionFontSize - 2,
                ),
              ),
            ),
            if (widget.showAnswerFeedback) ...[
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: BioColors.bark.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  'Score: $_score / ${widget.questions.length}',
                  style: TextStyle(
                    fontSize: widget.optionFontSize - 2,
                    fontWeight: FontWeight.w800,
                    color: BioColors.ink,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
              decoration: BoxDecoration(
                color: BioColors.parchment.withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (q.tableStimulus != null || q.stimulus != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: BioColors.bark),
                      ),
                      child: q.tableStimulus != null
                          ? QuizStimulusTable(
                              table: q.tableStimulus!,
                              fontSize: widget.stimulusFontSize,
                            )
                          : Text(
                              q.stimulus!,
                              style: TextStyle(
                                fontSize: widget.stimulusFontSize,
                                height: 1.4,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    q.prompt,
                    style: TextStyle(
                      fontSize: widget.promptFontSize,
                      fontWeight: FontWeight.bold,
                      color: BioColors.ink,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (var i = 0; i < q.options.length; i++)
                    _option(
                      optionIndex: i,
                      text: q.options[i],
                      selectedIndex: selected,
                      correctIndex: q.correctIndex,
                      locked: widget.showAnswerFeedback && answered,
                    ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      label:
                          _index == widget.questions.length - 1 ? 'Finish' : 'Next',
                      icon: widget.showNextIcon ? Icons.arrow_forward : null,
                      fontSize: widget.nextFontSize,
                      onTap: answered ? _next : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _OptionStyle _optionStyle({
    required int optionIndex,
    required int? selectedIndex,
    required int correctIndex,
  }) {
    final feedbackActive =
        widget.showAnswerFeedback && selectedIndex != null;

    if (feedbackActive) {
      if (optionIndex == correctIndex) {
        return const _OptionStyle(
          background: BioColors.correct,
          border: BioColors.correct,
          text: Colors.white,
          letterBackground: Colors.white,
          letterText: BioColors.correct,
          fontWeight: FontWeight.bold,
        );
      }
      // All incorrect options turn red once an answer is locked in.
      return const _OptionStyle(
        background: BioColors.danger,
        border: BioColors.danger,
        text: Colors.white,
        letterBackground: Colors.white,
        letterText: BioColors.danger,
        fontWeight: FontWeight.bold,
      );
    }

    final selected = optionIndex == selectedIndex;
    return _OptionStyle(
      background: selected ? BioColors.forest : Colors.white,
      border: selected ? BioColors.forest : BioColors.bark,
      text: selected ? Colors.white : BioColors.ink,
      letterBackground: selected ? Colors.white : BioColors.paleLeaf,
      letterText: BioColors.forest,
      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
    );
  }

  Widget _option({
    required int optionIndex,
    required String text,
    required int? selectedIndex,
    required int correctIndex,
    required bool locked,
  }) {
    const letters = ['A', 'B', 'C', 'D', 'E'];
    final style = _optionStyle(
      optionIndex: optionIndex,
      selectedIndex: selectedIndex,
      correctIndex: correctIndex,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: style.background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: locked ? null : () => _selectAnswer(optionIndex),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: style.border, width: 2),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: style.letterBackground,
                  child: Text(
                    letters[optionIndex],
                    style: TextStyle(
                      color: style.letterText,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.optionFontSize - 2,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: widget.optionFontSize,
                      color: style.text,
                      fontWeight: style.fontWeight,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _result() {
    final total = widget.questions.length;
    final score = _score;

    return Center(
      child: Container(
        width: 560,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: BioColors.parchment,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BioColors.forest, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: BioColors.sun, size: 64),
            const SizedBox(height: 8),
            Text(
              widget.showAnswerFeedback ? '${widget.title} Complete' : 'Your Score',
              style: TextStyle(
                fontSize: widget.promptFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$score / $total',
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: BioColors.forest,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: widget.continueLabel,
              icon: Icons.check,
              onTap: () => widget.onComplete(score, total),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionStyle {
  final Color background;
  final Color border;
  final Color text;
  final Color letterBackground;
  final Color letterText;
  final FontWeight fontWeight;

  const _OptionStyle({
    required this.background,
    required this.border,
    required this.text,
    required this.letterBackground,
    required this.letterText,
    required this.fontWeight,
  });
}
