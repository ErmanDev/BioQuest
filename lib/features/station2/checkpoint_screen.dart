import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/quiz_stimulus_table.dart';
import '../../data/station2_data.dart';
import '../../data/stations.dart';
import '../../models/mc_question.dart';
import '../../services/progress_service.dart';
import 'checkpoint_matching_activity.dart';

class Station2CheckpointScreen extends StatefulWidget {
  const Station2CheckpointScreen({super.key});

  @override
  State<Station2CheckpointScreen> createState() =>
      _Station2CheckpointScreenState();
}

class _Station2CheckpointScreenState extends State<Station2CheckpointScreen> {
  int _phase = 0; // 0 matching (part I), 1 MC (part II), 2 results
  int _part1Score = 0;
  int _part2Index = 0;
  late final List<int?> _part2Answers =
      List<int?>.filled(kStation2CheckpointPart1.length, null);
  late final List<List<int>> _part2OptionOrder;
  int _part2Score = 0;

  int get _matchingTotal => kStation2CheckpointPart2Items.length;
  int get _mcTotal => kStation2CheckpointPart1.length;
  int get _totalScore => _part1Score + _part2Score;
  int get _grandTotal => _matchingTotal + _mcTotal;

  @override
  void initState() {
    super.initState();
    _part2OptionOrder = List<List<int>>.generate(
      kStation2CheckpointPart1.length,
      (questionIndex) {
        final question = kStation2CheckpointPart1[questionIndex];
        final order = List<int>.generate(question.options.length, (i) => i);
        order.shuffle(math.Random(200 + questionIndex));
        return order;
      },
    );
  }

  int get _part2AnsweredCount =>
      _part2Answers.where((answer) => answer != null).length;

  int _scorePart2() {
    var score = 0;
    for (var i = 0; i < kStation2CheckpointPart1.length; i++) {
      if (_part2Answers[i] == kStation2CheckpointPart1[i].correctIndex) {
        score++;
      }
    }
    return score;
  }

  void _selectPart2Answer(int optionIndex) {
    if (_part2Answers[_part2Index] != null) return;
    setState(() => _part2Answers[_part2Index] = optionIndex);
  }

  void _nextPart2() {
    if (_part2Answers[_part2Index] == null) return;
    if (_part2Index < kStation2CheckpointPart1.length - 1) {
      setState(() => _part2Index++);
      return;
    }
    setState(() {
      _part2Score = _scorePart2();
      _phase = 2;
    });
  }

  Future<void> _claimBadge() async {
    final progress = context.read<ProgressService>();
    await progress.recordAssessment(
      'station2_checkpoint',
      _totalScore,
      _grandTotal,
    );
    await progress.completeStation('station2', _totalScore);
    if (mounted) context.go('/station2/badge');
  }

  @override
  Widget build(BuildContext context) {
    return BioScaffold(
      title: 'Trail Checkpoint',
      backgroundAsset: kStation2TrailCheckpointBg,
      backgroundLabel: 'Trail Checkpoint Station 2',
      fullBleedBackground: true,
      scrimOpacity: 0.12,
      onBack: () => context.go(stationHubRoute('station2')),
      body: switch (_phase) {
        0 => Station2CheckpointMatchingActivity(
            onComplete: (score, total) {
              setState(() {
                _part1Score = score;
                _phase = 1;
              });
            },
          ),
        1 => _part2Identification(),
        _ => _results(),
      },
    );
  }

  Widget _results() {
    return Center(
      child: Container(
        width: 560,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: BioColors.parchment.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BioColors.forest, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: BioColors.sun, size: 64),
            const SizedBox(height: 8),
            const Text(
              'Your Score',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: BioColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$_totalScore / $_grandTotal',
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: BioColors.forest,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Part I (Matching): $_part1Score / $_matchingTotal',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BioColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Part II (Identification): $_part2Score / $_mcTotal',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BioColors.ink,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Claim My Badge',
              icon: Icons.check,
              onTap: _claimBadge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _part2Identification() {
    final q = kStation2CheckpointPart1[_part2Index];
    final selected = _part2Answers[_part2Index];
    final answered = selected != null;
    final displayOrder = _part2OptionOrder[_part2Index];

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
                'Part II — Question ${_part2Index + 1} of '
                '${kStation2CheckpointPart1.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const Spacer(),
            Text(
              'Answered: $_part2AnsweredCount / ${kStation2CheckpointPart1.length}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: BioColors.forest,
              ),
            ),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Part II. Identification',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: BioColors.forest,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    kStation2CheckpointPart1Directions,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  if (q.tableStimulus != null || q.stimulus != null) ...[
                    _stimulus(q),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    '${_part2Index + 1}. ${q.prompt}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: BioColors.ink,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (var displayIndex = 0;
                      displayIndex < displayOrder.length;
                      displayIndex++)
                    _part2Option(
                      question: q,
                      optionIndex: displayOrder[displayIndex],
                      displayIndex: displayIndex,
                      selectedIndex: selected,
                      locked: answered,
                    ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      label: _part2Index == kStation2CheckpointPart1.length - 1
                          ? 'View Results'
                          : 'Next',
                      icon: Icons.arrow_forward,
                      onTap: answered ? _nextPart2 : null,
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

  Widget _stimulus(McQuestion q) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BioColors.bark),
      ),
      child: q.tableStimulus != null
          ? QuizStimulusTable(table: q.tableStimulus!)
          : Text(q.stimulus!, style: const TextStyle(fontSize: 15, height: 1.4)),
    );
  }

  Widget _part2Option({
    required McQuestion question,
    required int optionIndex,
    required int displayIndex,
    required int? selectedIndex,
    required bool locked,
  }) {
    final isSelected = selectedIndex == optionIndex;
    final isCorrect = optionIndex == question.correctIndex;
    Color background = Colors.white;
    Color border = BioColors.bark;
    Color text = BioColors.ink;

    if (locked) {
      if (isCorrect) {
        background = BioColors.correct;
        border = BioColors.correct;
        text = Colors.white;
      } else if (isSelected) {
        background = BioColors.danger;
        border = BioColors.danger;
        text = Colors.white;
      } else {
        background = Colors.white.withValues(alpha: 0.55);
      }
    } else if (isSelected) {
      background = BioColors.paleLeaf;
      border = BioColors.forest;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: locked ? null : () => _selectPart2Answer(optionIndex),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border, width: 2),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      locked && (isCorrect || isSelected)
                          ? Colors.white
                          : BioColors.forest,
                  child: Text(
                    String.fromCharCode(65 + displayIndex),
                    style: TextStyle(
                      color: locked && (isCorrect || isSelected)
                          ? (isCorrect ? BioColors.correct : BioColors.danger)
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.options[optionIndex],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: text,
                      height: 1.3,
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
}
