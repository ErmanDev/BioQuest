import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station2_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';

class Station2TakeawayScreen extends StatefulWidget {
  const Station2TakeawayScreen({super.key});

  @override
  State<Station2TakeawayScreen> createState() => _Station2TakeawayScreenState();
}

class _Station2TakeawayScreenState extends State<Station2TakeawayScreen> {
  final _explanationCtrl = TextEditingController();
  final _q3Ctrl = TextEditingController();
  int? _q1Index;
  int? _score;

  @override
  void dispose() {
    _explanationCtrl.dispose();
    _q3Ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_q1Index == null) {
      await _alert('Answer Question 1', 'Select a sampling technique first.');
      return;
    }

    final explanation = _explanationCtrl.text.trim();
    if (explanation.isEmpty) {
      await _alert('Answer Question 2', 'Write your explanation before submitting.');
      return;
    }

    final q3Answer = _q3Ctrl.text.trim();
    if (q3Answer.isEmpty) {
      await _alert('Answer Question 3', 'Write your answer before submitting.');
      return;
    }

    final s = scoreStation2TakeawayExplanation(explanation);
    setState(() => _score = s);
    await context
        .read<ProgressService>()
        .recordAssessment('station2_takeaway', s, 5);
  }

  Future<void> _alert(String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: BioColors.parchment,
        title: Text(
          title,
          style: const TextStyle(
            color: BioColors.forest,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message, style: const TextStyle(fontSize: 16, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: BioColors.forest,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = stationByKey('station2');
    return BioScaffold(
      title: 'Takeaway Questions',
      backgroundAsset: kStation2MountainDiversityBg,
      backgroundLabel: info.title,
      gradient: [info.color, BioColors.leaf],
      onBack: () => context.go(stationHubRoute('station2')),
      body: _score == null ? _form() : _feedback(),
    );
  }

  Widget _form() {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _instructionCard(),
            const SizedBox(height: 14),
            _question1(),
            const SizedBox(height: 14),
            _question2(),
            const SizedBox(height: 14),
            _question3(),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Submit Answers',
              icon: Icons.send,
              color: BioColors.sun,
              fontSize: 18,
              expand: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _instructionCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.25)),
      ),
      child: Text(
        kStation2TakeawayInstruction,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, height: 1.4, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _question1() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'QUESTION 1',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            kStation2TakeawayQ1Prompt,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.35),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < kStation2TakeawayQ1Options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _q1Option(i),
            ),
        ],
      ),
    );
  }

  Widget _q1Option(int index) {
    final selected = _q1Index == index;
    final answered = _q1Index != null;
    final correct = index == kStation2TakeawayQ1CorrectIndex;
    Color border = BioColors.bark.withValues(alpha: 0.3);
    Color bg = Colors.white;

    if (answered && selected) {
      border = correct ? BioColors.correct : BioColors.danger;
      bg = (correct ? BioColors.correct : BioColors.danger).withValues(alpha: 0.12);
    } else if (answered && correct) {
      border = BioColors.correct;
      bg = BioColors.correct.withValues(alpha: 0.08);
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _q1Index = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border, width: selected ? 2.5 : 1.5),
          ),
          child: Text(
            kStation2TakeawayQ1Options[index],
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: answered && selected && !correct
                  ? BioColors.danger
                  : BioColors.ink,
            ),
          ),
        ),
      ),
    );
  }

  Widget _question2() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'QUESTION 2',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            kStation2TakeawayQ2Prompt,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.35),
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(minHeight: 160),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BioColors.bark, width: 2),
            ),
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _explanationCtrl,
              maxLines: 8,
              style: const TextStyle(fontSize: 17, height: 1.45),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your explanation here...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _question3() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'QUESTION 3',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            kStation2TakeawayQ3Prompt,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.35),
          ),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(minHeight: 140),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BioColors.bark, width: 2),
            ),
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _q3Ctrl,
              maxLines: 6,
              style: const TextStyle(fontSize: 17, height: 1.45),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your answer here...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedback() {
    final q1Correct = _q1Index == kStation2TakeawayQ1CorrectIndex;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: BioColors.sun, size: 32),
              const SizedBox(width: 8),
              Text(
                'Question 2 score: $_score / 5',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: BioColors.forest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            q1Correct
                ? 'Question 1: Correct — Stratified Sampling'
                : 'Question 1: The correct answer is Stratified Sampling.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: q1Correct ? BioColors.correct : BioColors.danger,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Sample answer for Question 2:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    kStation2TakeawayModel,
                    style: const TextStyle(fontSize: 17, height: 1.45),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sample answer for Question 3:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    kStation2TakeawayQ3Model,
                    style: const TextStyle(fontSize: 17, height: 1.45),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Proceed Outside',
            icon: Icons.exit_to_app,
            expand: true,
            onTap: () async {
              final progress = context.read<ProgressService>();
              final router = GoRouter.of(context);
              await progress.markTakeawayComplete('station2');
              if (!context.mounted) return;
              router.go(stationHubRoute('station2'));
            },
          ),
        ],
      ),
    );
  }
}
