import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station1_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';

class Station1TakeawayScreen extends StatefulWidget {
  const Station1TakeawayScreen({super.key});

  @override
  State<Station1TakeawayScreen> createState() => _Station1TakeawayScreenState();
}

class _Station1TakeawayScreenState extends State<Station1TakeawayScreen> {
  final _controller = TextEditingController();
  int? _score;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _sentenceCount(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;

    final byPunctuation = trimmed
        .split(RegExp(r'[.!?]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .length;

    if (byPunctuation >= 2) return byPunctuation;

    final byLine = trimmed
        .split(RegExp(r'\n+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .length;

    return byPunctuation > byLine ? byPunctuation : byLine;
  }

  Future<void> _showAnswerAlert(String title, String message) {
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
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, height: 1.4),
        ),
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

  /// Heuristic rubric scorer (1-5) using keyword coverage + length.
  int _scoreAnswer(String text) {
    final lower = text.toLowerCase();
    final words = lower.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final matched = kStation1TakeawayKeywords
        .where((k) => lower.contains(k))
        .length;
    int s;
    if (matched >= 4) {
      s = 5;
    } else if (matched == 3) {
      s = 4;
    } else if (matched == 2) {
      s = 3;
    } else if (matched == 1) {
      s = 2;
    } else {
      s = 1;
    }
    if (words < 8 && s > 2) s = 2;
    return s;
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      await _showAnswerAlert(
        'No answer yet',
        'Please type your answer before submitting.',
      );
      return;
    }
    if (_sentenceCount(text) < 2) {
      await _showAnswerAlert(
        'More detail needed',
        'Explain your answer in at least 2 sentences before submitting.',
      );
      return;
    }

    final s = _scoreAnswer(text);
    setState(() => _score = s);
    await context
        .read<ProgressService>()
        .recordAssessment('station1_takeaway', s, 5);
  }

  @override
  Widget build(BuildContext context) {
    return BioScaffold(
      title: 'Takeaway Question',
      titleFontSize: 28,
      backgroundAsset: kStation1TakeawayBackgroundAsset,
      backgroundLabel: 'Takeaway',
      fullBleedBackground: true,
      scrimOpacity: 0.38,
      backButtonSize: 72,
      onBack: () => context.go(stationHubRoute('station1')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_score == null) ...[
            _promptCard(),
            const SizedBox(height: 12),
          ],
          Expanded(
            child: _score == null ? _input() : _feedback(context),
          ),
        ],
      ),
    );
  }

  Widget _promptCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BioColors.parchment,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            kStation1TakeawayPrompt,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.35,
              color: BioColors.ink,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: BioColors.paleLeaf,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: BioColors.forest.withValues(alpha: 0.25)),
            ),
            child: const Row(
              children: [
                Icon(Icons.edit_note, color: BioColors.forest, size: 28),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    kStation1TakeawayInstruction,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: BioColors.forest,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _input() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BioColors.bark, width: 2),
            ),
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(fontSize: 24, height: 1.4),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write 2-3 sentences here...',
                hintStyle: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: PrimaryButton(
            label: 'Submit Answer',
            icon: Icons.send,
            color: BioColors.sun,
            fontSize: 24,
            onTap: _submit,
          ),
        ),
      ],
    );
  }

  Widget _feedback(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BioColors.parchment,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: PrimaryButton(
          label: 'Proceed Outside',
          icon: Icons.exit_to_app,
          fontSize: 40,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          onTap: () async {
            final progress = context.read<ProgressService>();
            final router = GoRouter.of(context);
            await progress.markTakeawayComplete('station1');
            if (!context.mounted) return;
            router.go(stationHubRoute('station1'));
          },
        ),
      ),
    );
  }
}
