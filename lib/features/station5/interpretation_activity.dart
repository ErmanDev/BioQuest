import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station5_data.dart';

/// Activity 5 — answer three questions about the mean and bar graph results.
class InterpretationActivity extends StatefulWidget {
  final void Function(int score) onCompleted;
  final VoidCallback? onNext;

  const InterpretationActivity({
    super.key,
    required this.onCompleted,
    this.onNext,
  });

  @override
  State<InterpretationActivity> createState() => _InterpretationActivityState();
}

class _InterpretationActivityState extends State<InterpretationActivity> {
  late final List<TextEditingController> _controllers = [
    for (var _ in kStation5InterpretationQuestions) TextEditingController(),
  ];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _allAnswered =>
      _controllers.every((controller) => controller.text.trim().isNotEmpty);

  void _finish() {
    if (!_allAnswered) return;
    final answers = _controllers.map((c) => c.text).toList(growable: false);
    final score = scoreStation5InterpretationActivity(answers);
    widget.onCompleted(score);
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          kStation5InterpretationTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: kStation5InterpretationQuestions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _questionCard(index),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (!_allAnswered)
          Text(
            'Please write an answer in every box before continuing.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: BioColors.ink.withValues(alpha: 0.65),
            ),
          ),
        if (!_allAnswered) const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: PrimaryButton(
            label: 'Next Activity',
            icon: Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: 13,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: _allAnswered ? _finish : null,
          ),
        ),
      ],
    );
  }

  Widget _questionCard(int index) {
    final question = kStation5InterpretationQuestions[index];
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: BioColors.forest,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.prompt,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    color: BioColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: index == 1 ? 96 : 72,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: BioColors.bark.withValues(alpha: 0.35)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: TextField(
              controller: _controllers[index],
              minLines: index == 1 ? 4 : 2,
              maxLines: index == 1 ? 8 : 5,
              style: const TextStyle(fontSize: 12.5, height: 1.35),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your answer for Question ${index + 1}...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: BioColors.ink.withValues(alpha: 0.45),
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }
}
