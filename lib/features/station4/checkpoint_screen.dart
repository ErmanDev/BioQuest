import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/artwork_stage.dart';
import '../../core/widgets/fit_text.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station4_data.dart';
import '../../data/stations.dart';
import '../../models/mc_question.dart';
import '../../services/progress_service.dart';

class Station4CheckpointScreen extends StatefulWidget {
  const Station4CheckpointScreen({super.key});

  @override
  State<Station4CheckpointScreen> createState() =>
      _Station4CheckpointScreenState();
}

class _Station4CheckpointScreenState extends State<Station4CheckpointScreen> {
  /// Background artwork aspect; panels are placed as fractions of the
  /// artwork so they stay on the drawn frame on any screen shape.
  static const double _artAspect = 3072 / 1376;

  int _index = 0;
  late final List<int?> _answers = List<int?>.filled(
    kStation4Checkpoint.length,
    null,
  );
  bool _finished = false;

  int get _score {
    var score = 0;
    for (var i = 0; i < kStation4Checkpoint.length; i++) {
      if (_answers[i] == kStation4Checkpoint[i].correctIndex) score++;
    }
    return score;
  }

  void _selectAnswer(int optionIndex) {
    if (_answers[_index] != null) return;
    setState(() => _answers[_index] = optionIndex);
  }

  void _next() {
    if (_answers[_index] == null) return;
    if (_index < kStation4Checkpoint.length - 1) {
      setState(() => _index++);
      return;
    }
    setState(() => _finished = true);
  }

  Future<void> _claimBadge() async {
    final progress = context.read<ProgressService>();
    final router = GoRouter.of(context);
    final score = _score;
    final total = kStation4Checkpoint.length;
    await progress.recordAssessment('station4_checkpoint', score, total);
    await progress.completeStation('station4', score);
    if (!mounted) return;
    router.go('/station4/badge');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: ArtworkBackdrop(
            asset: kStation4TrailCheckpointBackgroundAsset,
            aspect: _artAspect,
            label: 'Background',
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Column(
              children: [
                _topBar(context),
                const SizedBox(height: 6),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: ArtworkOverlay(
            aspect: _artAspect,
            slots: [
              ArtworkSlot(
                region: Rect.fromLTRB(0.25, 0.36, 0.75, 0.88),
                child: _finished ? _result() : _question(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.go(stationHubRoute('station4')),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back, color: BioColors.forest, size: 26),
            ),
          ),
        ),
        const Spacer(),
        Text(
          _finished
              ? 'Complete'
              : 'Question ${_index + 1} / ${kStation4Checkpoint.length}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _question() {
    final q = kStation4Checkpoint[_index];
    final selected = _answers[_index];
    final answered = selected != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          // Shrinks the question slightly (instead of hiding answers below
          // the fold) when long answers don't fit the scroll.
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
            child: FitText(
              alignment: Alignment.topCenter,
              // With a results block, show it beside the question so all four
              // answers stay visible without scrolling.
              child: q.stimulus == null
                  ? _promptAndOptions(q, selected, answered)
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _stimulusBox(q.stimulus!)),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 7,
                          child: _promptAndOptions(q, selected, answered),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.center,
          child: PrimaryButton(
            label: _index == kStation4Checkpoint.length - 1 ? 'Finish' : 'Next',
            icon: Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: 15,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            onTap: answered ? _next : null,
          ),
        ),
      ],
    );
  }

  Widget _stimulusBox(String text) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13.5, height: 1.25)),
    );
  }

  Widget _promptAndOptions(McQuestion q, int? selected, bool answered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          q.prompt,
          style: const TextStyle(
            fontSize: 19.5,
            fontWeight: FontWeight.w800,
            height: 1.3,
            color: BioColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < q.options.length; i++)
          _optionTile(
            question: q,
            optionIndex: i,
            selectedIndex: selected,
            locked: answered,
          ),
      ],
    );
  }

  Widget _optionTile({
    required McQuestion question,
    required int optionIndex,
    required int? selectedIndex,
    required bool locked,
  }) {
    final isSelected = selectedIndex == optionIndex;
    final isCorrect = optionIndex == question.correctIndex;

    Color background = Colors.white.withValues(alpha: 0.95);
    Color border = BioColors.bark.withValues(alpha: 0.45);
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
        background = Colors.white.withValues(alpha: 0.65);
      }
    } else if (isSelected) {
      background = BioColors.paleLeaf;
      border = BioColors.forest;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: locked ? null : () => _selectAnswer(optionIndex),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: border, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: locked && (isCorrect || isSelected)
                        ? Colors.white
                        : BioColors.forest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    String.fromCharCode(65 + optionIndex),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: locked && (isCorrect || isSelected)
                          ? (isCorrect ? BioColors.correct : BioColors.danger)
                          : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question.options[optionIndex],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: text,
                      height: 1.25,
                    ),
                  ),
                ),
                if (locked && isCorrect)
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _result() {
    final total = kStation4Checkpoint.length;
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
        decoration: BoxDecoration(
          color: BioColors.parchment.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BioColors.forest.withValues(alpha: 0.45)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: BioColors.sun, size: 48),
            const SizedBox(height: 6),
            const Text(
              'Trail Checkpoint Complete',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: BioColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$_score / $total',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: BioColors.forest,
              ),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Claim My Badge',
              icon: Icons.check,
              color: BioColors.forest,
              fontSize: 15,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              onTap: _claimBadge,
            ),
          ],
        ),
      ),
    );
  }
}
