import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station5_data.dart';

/// Activity 6 — reject or accept H₀, then write a scientific conclusion.
class FinalDecisionActivity extends StatefulWidget {
  final void Function(int score) onCompleted;
  final VoidCallback? onNext;

  const FinalDecisionActivity({
    super.key,
    required this.onCompleted,
    this.onNext,
  });

  @override
  State<FinalDecisionActivity> createState() => _FinalDecisionActivityState();
}

class _FinalDecisionActivityState extends State<FinalDecisionActivity> {
  final _conclusionCtrl = TextEditingController();
  int? _decision;

  bool get _canContinue =>
      _decision != null && _conclusionCtrl.text.trim().isNotEmpty;

  @override
  void dispose() {
    _conclusionCtrl.dispose();
    super.dispose();
  }

  void _pickDecision(int choice) {
    if (_decision != null) return;
    setState(() => _decision = choice);
  }

  void _finish() {
    if (!_canContinue) return;
    final score = scoreStation5FinalDecisionActivity(
      decision: _decision,
      conclusion: _conclusionCtrl.text,
    );
    widget.onCompleted(score);
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 6),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 42, child: _findingsPanel()),
              const SizedBox(width: 8),
              Expanded(
                flex: 48,
                child: Column(
                  children: [
                    Expanded(flex: 5, child: _decisionPanel()),
                    const SizedBox(height: 8),
                    Expanded(flex: 4, child: _conclusionPanel()),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        if (!_canContinue)
          Text(
            _decision == null
                ? 'Choose Reject or Accept, then write your conclusion.'
                : 'Write your conclusion before continuing.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: BioColors.ink.withValues(alpha: 0.65),
            ),
          ),
        if (!_canContinue) const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: PrimaryButton(
            label: 'Takeaway Question',
            icon: Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: 13,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: _canContinue ? _finish : null,
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          kStation5FinalDecisionTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: BioColors.deepSky,
          ),
        ),
        Text(
          kStation5FinalDecisionSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _findingsPanel() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: BioColors.forest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              kStation5FinalDecisionFindingsTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    kStation5FinalDecisionFindingsIntro,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: BioColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 1,
                    color: BioColors.forest.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    kStation5FinalDecisionFindingsResult,
                    style: const TextStyle(
                      fontSize: 11.5,
                      height: 1.4,
                      fontWeight: FontWeight.w800,
                      color: BioColors.forest,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _decisionPanel() {
    final answered = _decision != null;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.deepSky.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            kStation5FinalDecisionPrompt,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: BioColors.ink,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _decisionButton(
                    choice: kStation5FinalDecisionReject,
                    label: kStation5FinalDecisionRejectLabel,
                    answered: answered,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: BioColors.ink,
                    ),
                  ),
                ),
                Expanded(
                  child: _decisionButton(
                    choice: kStation5FinalDecisionAccept,
                    label: kStation5FinalDecisionAcceptLabel,
                    answered: answered,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _decisionButton({
    required int choice,
    required String label,
    required bool answered,
  }) {
    final picked = _decision == choice;
    final correct = choice == kStation5FinalDecisionCorrect;
    Color color = BioColors.deepSky;
    Widget? mark;

    if (answered) {
      if (correct) {
        color = BioColors.correct;
        mark = const Icon(Icons.check_circle, color: Colors.white, size: 22);
      } else if (picked) {
        color = BioColors.danger;
        mark = const Icon(Icons.cancel, color: Colors.white, size: 22);
      } else {
        color = BioColors.deepSky.withValues(alpha: 0.45);
      }
    }

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: answered ? null : () => _pickDecision(choice),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  height: 1.25,
                ),
              ),
              if (mark != null) ...[const SizedBox(height: 6), mark],
            ],
          ),
        ),
      ),
    );
  }

  Widget _conclusionPanel() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.edit, color: BioColors.forest, size: 18),
              const SizedBox(width: 6),
              Text(
                kStation5FinalDecisionConclusionTitle,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: BioColors.forest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            kStation5FinalDecisionConclusionPrompt,
            style: const TextStyle(fontSize: 10.5, height: 1.35),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: BioColors.bark.withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _conclusionCtrl,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 11.5, height: 1.35),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your scientific conclusion here...',
                  hintStyle: TextStyle(
                    fontSize: 11,
                    color: BioColors.ink.withValues(alpha: 0.45),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
