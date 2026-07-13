import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station3_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';

class Station3TakeawayScreen extends StatefulWidget {
  const Station3TakeawayScreen({super.key});

  @override
  State<Station3TakeawayScreen> createState() => _Station3TakeawayScreenState();
}

class _Station3TakeawayScreenState extends State<Station3TakeawayScreen> {
  static const _contentLeft = 0.28;
  static const _contentRight = 0.70;
  static const _contentTop = 0.30;
  static const _contentBottom = 0.84;
  static const _innerPadding = 12.0;

  final _controller = TextEditingController();

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

  Future<void> _showAlert(String title, String message) {
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

  int _scoreAnswer(String text) {
    final lower = text.toLowerCase();
    final words = lower.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final matched =
        kStation3TakeawayKeywords.where((k) => lower.contains(k)).length;
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
      await _showAlert(
        'No answer yet',
        'Please type your answer before submitting.',
      );
      return;
    }

    final sentences = _sentenceCount(text);
    if (sentences < 2) {
      await _showAlert(
        'More detail needed',
        'Explain your answer in at least 2 sentences before submitting.',
      );
      return;
    }
    if (sentences > 3) {
      await _showAlert(
        'Too many sentences',
        'Please limit your answer to a maximum of 3 sentences only.',
      );
      return;
    }

    final s = _scoreAnswer(text);
    final progress = context.read<ProgressService>();
    final router = GoRouter.of(context);
    await progress.recordAssessment('station3_takeaway', s, 5);
    await progress.markTakeawayComplete('station3');
    if (!context.mounted) return;
    router.go(stationHubRoute('station3'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: kStation3TakeawayBackgroundAsset,
            label: 'Takeaway',
            fit: BoxFit.cover,
            color: BioColors.forest,
            icon: Icons.landscape,
            cacheWidth: 1280,
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Column(
              children: [
                _topBar(context),
                const SizedBox(height: 8),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      final left = w * _contentLeft;
                      final width = w * (_contentRight - _contentLeft);
                      final top = h * _contentTop;
                      final height = h * _contentBottom - top;

                      return Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Positioned(
                            left: left,
                            top: top,
                            width: width,
                            height: height,
                            child: ClipRect(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: _innerPadding,
                                ),
                                child: _form(),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
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
            onTap: () => context.go(stationHubRoute('station3')),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back, color: BioColors.forest, size: 26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          kStation3TakeawayPrompt,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            height: 1.32,
            color: BioColors.forest,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          kStation3TakeawayInstruction,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: BioColors.ink.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: BioColors.forest,
                width: 2,
              ),
            ),
            child: CustomPaint(
              painter: const _LinedPaperPainter(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 36),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(fontSize: 17, height: 1.55),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write 2–3 sentences here...',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.science,
                  size: 16,
                  color: BioColors.forest.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 4),
                Text(
                  kStation3TakeawayMaxSentencesNote,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: BioColors.forest.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
            if (_controller.text.trim().isNotEmpty)
              Text(
                '${_sentenceCount(_controller.text)} / 3 sentences',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _sentenceCount(_controller.text) > 3
                      ? BioColors.danger
                      : BioColors.forest,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: PrimaryButton(
            label: 'Submit Answer',
            color: BioColors.forest,
            fontSize: 18,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            onTap: _submit,
          ),
        ),
      ],
    );
  }
}

class _LinedPaperPainter extends CustomPainter {
  const _LinedPaperPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BioColors.forest.withValues(alpha: 0.18)
      ..strokeWidth = 1;

    const lineGap = 28.0;
    for (var y = lineGap; y < size.height; y += lineGap) {
      canvas.drawLine(Offset(12, y), Offset(size.width - 12, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
