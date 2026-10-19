import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station5_data.dart';

/// Activity 3 — read the research overview and write H₀ and H₁.
class HypothesisWritingActivity extends StatefulWidget {
  final void Function(int score) onCompleted;
  final VoidCallback? onNext;

  const HypothesisWritingActivity({
    super.key,
    required this.onCompleted,
    this.onNext,
  });

  @override
  State<HypothesisWritingActivity> createState() =>
      _HypothesisWritingActivityState();
}

class _HypothesisWritingActivityState extends State<HypothesisWritingActivity> {
  final _nullCtrl = TextEditingController();
  final _altCtrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _nullCtrl.dispose();
    _altCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_submitted) return;
    _submitted = true;
    final score = scoreStation5HypothesisAnswers(_nullCtrl.text, _altCtrl.text);
    widget.onCompleted(score);
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _missionHeader(),
        const SizedBox(height: 6),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 28, child: _directionsPanel()),
              const SizedBox(width: 8),
              Expanded(
                flex: 52,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 5, child: _overviewPanel()),
                    const SizedBox(height: 8),
                    Expanded(flex: 4, child: _hypothesisInputs()),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: PrimaryButton(
            label: 'Next Activity',
            icon: Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: 13,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: _submit,
          ),
        ),
      ],
    );
  }

  Widget _missionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          kStation5HypothesisMissionTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: BioColors.deepSky,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: BioColors.forest.withValues(alpha: 0.25),
                offset: const Offset(0, 1),
                blurRadius: 0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'MISSION CHALLENGE: $kStation5HypothesisChallenge',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _directionsPanel() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: BioColors.deepSky.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.deepSky.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment, color: BioColors.deepSky, size: 18),
              const SizedBox(width: 6),
              Text(
                kStation5HypothesisDirectionsTitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: BioColors.deepSky,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < kStation5HypothesisDirections.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${i + 1}. ${kStation5HypothesisDirections[i]}',
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                          color: BioColors.ink,
                        ),
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

  Widget _overviewPanel() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: BioColors.correct.withValues(alpha: 0.1),
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
              kStation5ResearchOverviewTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                kStation5ResearchOverview,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  color: BioColors.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hypothesisInputs() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _hypothesisBox(
            symbol: 'H₀',
            label: kStation5NullHypothesisLabel,
            accent: BioColors.deepSky,
            controller: _nullCtrl,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _hypothesisBox(
            symbol: 'H₁',
            label: kStation5AlternativeHypothesisLabel,
            accent: BioColors.forest,
            controller: _altCtrl,
          ),
        ),
      ],
    );
  }

  Widget _hypothesisBox({
    required String symbol,
    required String label,
    required Color accent,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.55), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    color: accent,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              readOnly: _submitted,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(fontSize: 11.5, height: 1.35),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                hintText: 'Write your $label here...',
                hintStyle: TextStyle(
                  fontSize: 10.5,
                  color: BioColors.ink.withValues(alpha: 0.45),
                ),
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accent.withValues(alpha: 0.35)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accent.withValues(alpha: 0.35)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: accent, width: 2),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }
}
