import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station2_data.dart';

/// Part I matching: tap a choice on the right, then tap a statement on the left.
class Station2CheckpointMatchingActivity extends StatefulWidget {
  final void Function(int score, int total) onComplete;
  final String continueLabel;

  const Station2CheckpointMatchingActivity({
    super.key,
    required this.onComplete,
    this.continueLabel = 'Continue to Part II',
  });

  @override
  State<Station2CheckpointMatchingActivity> createState() =>
      _Station2CheckpointMatchingActivityState();
}

class _Station2CheckpointMatchingActivityState
    extends State<Station2CheckpointMatchingActivity> {
  String? _selectedChoiceId;
  late final List<Station2CheckpointChoice> _shuffledChoices;
  final Map<int, String?> _answers = {
    for (final item in kStation2CheckpointPart2Items) item.number: null,
  };
  bool _submitted = false;
  bool _readyToContinue = false;

  @override
  void initState() {
    super.initState();
    _shuffledChoices = List<Station2CheckpointChoice>.from(
      kStation2CheckpointPart2Choices,
    )..shuffle(math.Random(311));
  }

  Set<String> get _usedChoiceIds => _answers.values.whereType<String>().toSet();

  bool get _allFilled => _answers.values.every((answer) => answer != null);

  List<Station2CheckpointChoice> get _availableChoices => _shuffledChoices
      .where((choice) => !_usedChoiceIds.contains(choice.id))
      .toList(growable: false);

  void _selectChoice(String choiceId) {
    if (_submitted) return;
    setState(() {
      _selectedChoiceId = _selectedChoiceId == choiceId ? null : choiceId;
    });
  }

  void _tapBlank(int number) {
    if (_submitted) return;

    final current = _answers[number];
    if (_selectedChoiceId == null) {
      if (current != null) {
        setState(() => _answers[number] = null);
      }
      return;
    }

    setState(() {
      _answers[number] = _selectedChoiceId;
      _selectedChoiceId = null;
    });
  }

  void _submit() {
    if (!_allFilled) return;
    setState(() {
      _submitted = true;
      _readyToContinue = true;
    });
  }

  void _continue() {
    final score = scoreStation2CheckpointPart2(_answers);
    widget.onComplete(score, kStation2CheckpointPart2Items.length);
  }

  Station2CheckpointChoice? _choiceById(String? id) {
    if (id == null) return null;
    for (final choice in kStation2CheckpointPart2Choices) {
      if (choice.id == id) return choice;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _directionsCard(),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 11, child: _statementsColumn()),
              const SizedBox(width: 12),
              Expanded(flex: 10, child: _choicesColumn()),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (!_submitted)
          Center(
            child: PrimaryButton(
              label: 'Check Answers',
              icon: Icons.fact_check_outlined,
              onTap: _allFilled ? _submit : null,
            ),
          )
        else if (_readyToContinue)
          Center(
            child: PrimaryButton(
              label: widget.continueLabel,
              icon: Icons.arrow_forward,
              onTap: _continue,
            ),
          ),
      ],
    );
  }

  Widget _directionsCard() {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 120),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: BioColors.parchment.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BioColors.forest.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Part I. Matching',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: BioColors.forest,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                kStation2CheckpointPart2Directions,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 20, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statementsColumn() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.35)),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.separated(
          itemCount: kStation2CheckpointPart2Items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 5),
          itemBuilder: (context, index) {
            final item = kStation2CheckpointPart2Items[index];
            return _statementRow(item);
          },
        ),
      ),
    );
  }

  Widget _statementRow(Station2CheckpointMatchItem item) {
    final answerId = _answers[item.number];
    final choice = _choiceById(answerId);
    final isCorrect = _submitted && answerId == item.correctChoiceId;
    final isWrong =
        _submitted && answerId != null && answerId != item.correctChoiceId;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _tapBlank(item.number),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isCorrect
              ? BioColors.correct.withValues(alpha: 0.15)
              : isWrong
              ? BioColors.danger.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isCorrect
                ? BioColors.correct
                : isWrong
                ? BioColors.danger
                : BioColors.bark.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: BioColors.forest,
              child: Text(
                '${item.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.statement,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  color: BioColors.ink,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _blankSlot(choice?.label, highlighted: answerId == null),
          ],
        ),
      ),
    );
  }

  Widget _blankSlot(String? label, {required bool highlighted}) {
    final filled = label != null;
    return Container(
      constraints: const BoxConstraints(
        minWidth: 168,
        maxWidth: 210,
        minHeight: 44,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: filled
            ? BioColors.moss.withValues(alpha: 0.18)
            : highlighted && _selectedChoiceId != null
            ? BioColors.sun.withValues(alpha: 0.35)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlighted && _selectedChoiceId != null
              ? BioColors.sun
              : BioColors.bark,
          width: highlighted && _selectedChoiceId != null ? 2 : 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        filled ? label : '________',
        textAlign: TextAlign.center,
        maxLines: 2,
        softWrap: true,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
          height: 1.15,
          color: filled
              ? BioColors.forest
              : BioColors.ink.withValues(alpha: 0.45),
        ),
      ),
    );
  }

  Widget _choicesColumn() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The "Selected" hint shares the heading line so picking a term
          // never pushes the lists down.
          Row(
            children: [
              const Text(
                'Terms',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: BioColors.forest,
                ),
              ),
              if (!_submitted && _selectedChoiceId != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Selected: ${_choiceById(_selectedChoiceId)!.label} — '
                    'tap a statement',
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: BioColors.deepSky,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _availableChoices.length,
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                final choice = _availableChoices[index];
                final selected = _selectedChoiceId == choice.id;
                return Material(
                  color: selected ? BioColors.deepSky : BioColors.moss,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: _submitted ? null : () => _selectChoice(choice.id),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 44),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        choice.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 0.4,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
