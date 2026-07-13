import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/text_format.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station2_data.dart';

/// Five-card "Population or Sample?" sorting activity for Station 2.
class PopulationSampleActivity extends StatefulWidget {
  final void Function(int score) onComplete;

  const PopulationSampleActivity({super.key, required this.onComplete});

  @override
  State<PopulationSampleActivity> createState() =>
      _PopulationSampleActivityState();
}

class _PopulationSampleActivityState extends State<PopulationSampleActivity> {
  final List<PopulationSampleAnswer?> _picks =
      List<PopulationSampleAnswer?>.filled(kStation2PopSampleCards.length, null);
  final List<bool> _answered =
      List<bool>.filled(kStation2PopSampleCards.length, false);
  int _score = 0;

  bool get _allAnswered => _answered.every((a) => a);

  void _pick(int index, PopulationSampleAnswer choice) {
    if (_answered[index]) return;
    final card = kStation2PopSampleCards[index];
    final correct = choice == card.answer;
    setState(() {
      _picks[index] = choice;
      _answered[index] = true;
      if (correct) _score++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 8),
        Expanded(child: _cardRow()),
        const SizedBox(height: 10),
        Center(
          child: PrimaryButton(
            label: 'Next Activity',
            icon: Icons.arrow_forward,
            color: BioColors.moss,
            fontSize: 18,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            onTap: _allAnswered ? () => widget.onComplete(_score) : null,
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          const Text(
            'POPULATION OR SAMPLE?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text.rich(
            readingTextSpan(
              'Look at each situation below. Decide whether it shows a '
              '**POPULATION** or a **SAMPLE**.',
              fontSize: 14,
              color: BioColors.ink,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _cardRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < kStation2PopSampleCards.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _card(i)),
        ],
      ],
    );
  }

  Widget _card(int index) {
    final card = kStation2PopSampleCards[index];
    final answered = _answered[index];
    final pick = _picks[index];
    final wasCorrect = answered && pick == card.answer;

    return Container(
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: answered
              ? (wasCorrect ? BioColors.correct : BioColors.danger)
              : BioColors.bark.withValues(alpha: 0.2),
          width: answered ? 2.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: BioColors.forest,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GameImage(
                  asset: card.imageAsset,
                  label: card.description,
                  fit: BoxFit.cover,
                  color: BioColors.moss,
                  icon: Icons.eco,
                  cacheWidth: 640,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text.rich(
              readingTextSpan(
                card.description,
                fontSize: 11,
                color: BioColors.ink,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: [
                _answerButton(
                  index: index,
                  label: 'POPULATION',
                  choice: PopulationSampleAnswer.population,
                  pick: pick,
                  answered: answered,
                  correctAnswer: card.answer,
                  color: BioColors.moss,
                ),
                const SizedBox(height: 4),
                _answerButton(
                  index: index,
                  label: 'SAMPLE',
                  choice: PopulationSampleAnswer.sample,
                  pick: pick,
                  answered: answered,
                  correctAnswer: card.answer,
                  color: BioColors.bark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerButton({
    required int index,
    required String label,
    required PopulationSampleAnswer choice,
    required PopulationSampleAnswer? pick,
    required bool answered,
    required PopulationSampleAnswer correctAnswer,
    required Color color,
  }) {
    final isPick = pick == choice;
    final isCorrect = choice == correctAnswer;
    Color bg = color;
    if (answered) {
      if (isCorrect) {
        bg = BioColors.correct;
      } else if (isPick) {
        bg = BioColors.danger;
      } else {
        bg = color.withValues(alpha: 0.35);
      }
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: answered ? null : () => _pick(index, choice),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
