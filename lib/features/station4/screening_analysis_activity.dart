import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/text_format.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station4_data.dart';
import 'screening_bar_graph_question.dart';

/// Post-screening analysis: results table, bar graph (Q1), and guide questions (Q2–5).
class ScreeningAnalysisActivity extends StatefulWidget {
  final void Function(int score, int total) onComplete;

  const ScreeningAnalysisActivity({
    super.key,
    required this.onComplete,
  });

  @override
  State<ScreeningAnalysisActivity> createState() =>
      _ScreeningAnalysisActivityState();
}

class _ScreeningAnalysisActivityState extends State<ScreeningAnalysisActivity> {
  bool _barGraphDone = false;
  int _guideIndex = 0;
  late final List<TextEditingController> _answerControllers = [
    for (var _ in kStation4ScreeningGuideQuestions) TextEditingController(),
  ];
  final List<bool?> _guideCorrect =
      List<bool?>.filled(kStation4ScreeningGuideQuestions.length, null);

  ({String prompt, List<String> keywords, String modelAnswer, int minMatches})
      get _question => kStation4ScreeningGuideQuestions[_guideIndex];

  int get _score {
    var count = _barGraphDone ? 1 : 0;
    for (final correct in _guideCorrect) {
      if (correct == true) count++;
    }
    return count;
  }

  int get _totalScore => 1 + kStation4ScreeningGuideQuestions.length;

  @override
  void dispose() {
    for (final controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitGuideAnswer() {
    if (!_barGraphDone) return;

    final text = _answerControllers[_guideIndex].text.trim();
    if (text.isEmpty) return;

    final isLast =
        _guideIndex >= kStation4ScreeningGuideQuestions.length - 1;

    setState(() {
      _guideCorrect[_guideIndex] = true;
      if (!isLast) {
        _guideIndex++;
      }
    });

    if (isLast) {
      widget.onComplete(_score, _totalScore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _headerBanner(),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_barGraphDone) ...[
                  _introCard(),
                  const SizedBox(height: 10),
                  _resultsSection(),
                  const SizedBox(height: 12),
                ],
                if (!_barGraphDone)
                  ScreeningBarGraphQuestion(
                    onComplete: () => setState(() => _barGraphDone = true),
                  )
                else ...[
                  _resultsSection(),
                  const SizedBox(height: 12),
                  _guideQuestionSection(),
                ],
              ],
            ),
          ),
        ),
        if (_barGraphDone) ...[
          const SizedBox(height: 8),
          Center(
            child: PrimaryButton(
              label: _guideIndex < kStation4ScreeningGuideQuestions.length - 1
                  ? 'Next Question'
                  : 'Complete Analysis',
              icon: Icons.arrow_forward,
              color: BioColors.forest,
              fontSize: 16,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              onTap: _answerControllers[_guideIndex].text.trim().isNotEmpty
                  ? _submitGuideAnswer
                  : null,
            ),
          ),
        ],
      ],
    );
  }

  Widget _headerBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BioColors.forest,
            BioColors.forest.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            kStation4ScreeningAnalysisTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            kStation4ScreeningAnalysisSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.92),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _introCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.25)),
      ),
      child: Text.rich(
        readingTextSpan(
          kStation4ScreeningAnalysisIntro,
          fontSize: 14,
          color: BioColors.ink,
        ),
        style: const TextStyle(height: 1.45),
      ),
    );
  }

  Widget _resultsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 560;

        final table = _officialResultsTable();
        final legend = _legendBox();

        if (stacked) {
          return Column(
            children: [
              table,
              const SizedBox(height: 10),
              legend,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: table),
            const SizedBox(width: 10),
            Expanded(flex: 2, child: legend),
          ],
        );
      },
    );
  }

  Widget _officialResultsTable() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'OFFICIAL RESULTS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          _tableRow(
            'TEST PARAMETERS',
            'Genus Pyrrhobryum',
            'Genus Ectropothecium',
            header: true,
          ),
          const Divider(height: 1),
          for (var i = 0; i < kStation4ScreeningTests.length; i++) ...[
            _tableRow(
              station4CompoundLabel(kStation4ScreeningTests[i].compound),
              kStation4ScreeningTests[i].pyrrhobryumAnswer,
              kStation4ScreeningTests[i].ectropotheciumAnswer,
            ),
            if (i < kStation4ScreeningTests.length - 1)
              Divider(height: 1, color: BioColors.bark.withValues(alpha: 0.15)),
          ],
        ],
      ),
    );
  }

  Widget _tableRow(
    String label,
    String pyrrh,
    String ectro, {
    bool header = false,
  }) {
    final style = TextStyle(
      fontSize: header ? 11 : 13,
      fontWeight: header ? FontWeight.bold : FontWeight.w600,
      color: header ? BioColors.forest : BioColors.ink,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: style)),
          Expanded(
            flex: 2,
            child: Text(pyrrh, textAlign: TextAlign.center, style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(ectro, textAlign: TextAlign.center, style: style),
          ),
        ],
      ),
    );
  }

  Widget _legendBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LEGEND',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 8),
          for (final row in kStation4OfficialResultsLegend)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: BioColors.ink,
                  ),
                  children: [
                    TextSpan(
                      text: row.symbol,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' = ${row.meaning}'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _guideQuestionSection() {
    final questionNumber = _guideIndex + 2;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.search, color: BioColors.forest, size: 22),
              SizedBox(width: 8),
              Text(
                'GUIDE QUESTIONS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: BioColors.forest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Question $questionNumber of $_totalScore',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: BioColors.ink.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 6),
          Text.rich(
            readingTextSpan(
              _question.prompt,
              fontSize: 16,
              color: BioColors.ink,
            ),
            style: const TextStyle(fontWeight: FontWeight.bold, height: 1.35),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.edit, size: 18, color: BioColors.forest.withValues(alpha: 0.8)),
              const SizedBox(width: 6),
              Text(
                'Answer:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: BioColors.deepSky,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(
              minHeight: _guideIndex == kStation4ScreeningGuideQuestions.length - 1
                  ? 140
                  : 100,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BioColors.bark, width: 2),
            ),
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _answerControllers[_guideIndex],
              maxLines: _guideIndex == kStation4ScreeningGuideQuestions.length - 1
                  ? 8
                  : 4,
              style: const TextStyle(fontSize: 15, height: 1.4),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your answer here...',
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }
}
