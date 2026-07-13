import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station5_data.dart';
import '../../data/stations.dart';
import '../../models/mc_question.dart';
import '../../services/progress_service.dart';

class Station5CheckpointScreen extends StatefulWidget {
  const Station5CheckpointScreen({super.key});

  @override
  State<Station5CheckpointScreen> createState() =>
      _Station5CheckpointScreenState();
}

class _Station5CheckpointScreenState extends State<Station5CheckpointScreen> {
  // Header/subtitle are baked into the background; overlay starts below them.
  static const _contentLeft = 0.12;
  static const _contentRight = 0.88;
  static const _contentTop = 0.27;
  static const _contentBottom = 0.94;

  int _page = 0;
  late final List<int?> _answers =
      List<int?>.filled(kStation5Checkpoint.length, null);

  int get _pageCount => (kStation5Checkpoint.length / 2).ceil();
  int get _firstIndex => _page * 2;
  bool get _isLastPage => _page >= _pageCount - 1;

  bool get _pageComplete {
    for (var i = _firstIndex;
        i < _firstIndex + 2 && i < kStation5Checkpoint.length;
        i++) {
      if (_answers[i] == null) return false;
    }
    return true;
  }

  int get _answeredCount => _answers.where((answer) => answer != null).length;

  /// Pages 4–5 include questions 8–10 (indices 7–9).
  bool get _showsSharedTable => _firstIndex >= 6;

  int _score() {
    var score = 0;
    for (var i = 0; i < kStation5Checkpoint.length; i++) {
      if (_answers[i] == kStation5Checkpoint[i].correctIndex) score++;
    }
    return score;
  }

  void _selectAnswer(int questionIndex, int optionIndex) {
    if (_answers[questionIndex] != null) return;
    setState(() => _answers[questionIndex] = optionIndex);
  }

  void _next() {
    if (!_pageComplete) return;
    if (_isLastPage) {
      _claimBadge();
      return;
    }
    setState(() => _page++);
  }

  Future<void> _claimBadge() async {
    final progress = context.read<ProgressService>();
    final router = GoRouter.of(context);
    final score = _score();
    final total = kStation5Checkpoint.length;
    await progress.recordAssessment('station5_checkpoint', score, total);
    await progress.completeStation('station5', score);
    if (!mounted) return;
    router.go('/station5/badge');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: kStation5TrailCheckpointBackgroundAsset,
            label: 'Trail Checkpoint',
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
                const SizedBox(height: 4),
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
                            child: _activity(),
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
            onTap: () => context.go(stationHubRoute('station5')),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back, color: BioColors.forest, size: 26),
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Answered: $_answeredCount / ${kStation5Checkpoint.length}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _activity() {
    final secondIndex = _firstIndex + 1;
    final hasSecond = secondIndex < kStation5Checkpoint.length;
    final compact = _showsSharedTable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _directionsBar(compact: compact),
        SizedBox(height: compact ? 4 : 8),
        Expanded(
          child: Column(
            children: [
              if (_showsSharedTable) ...[
                Flexible(
                  flex: 2,
                  child: _sharedTablePanel(compact: true),
                ),
                const SizedBox(height: 6),
              ],
              Expanded(
                flex: compact ? 3 : 1,
                child: _questionCard(_firstIndex, compact: compact),
              ),
              SizedBox(height: compact ? 6 : 10),
              Expanded(
                flex: compact ? 3 : 1,
                child: hasSecond
                    ? _questionCard(secondIndex, compact: compact)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        SizedBox(height: compact ? 4 : 8),
        Align(
          alignment: Alignment.center,
          child: PrimaryButton(
            label: _isLastPage ? 'Claim My Badge' : 'Next',
            icon: _isLastPage ? Icons.emoji_events : Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: compact ? 15 : 16,
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: compact ? 9 : 11,
            ),
            onTap: _pageComplete ? _next : null,
          ),
        ),
      ],
    );
  }

  Widget _directionsBar({bool compact = false}) {
    const cream = Color(0xFFF7F1E4);
    final iconSize = compact ? 34.0 : 46.0;
    final labelSize = compact ? 12.0 : 14.0;
    final bodySize = compact ? 12.0 : 14.0;
    final barPaddingV = compact ? 7.0 : 10.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: cream,
              shape: BoxShape.circle,
              border: Border.all(
                color: BioColors.forest.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: BioColors.forest,
              size: compact ? 18 : 24,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 10 : 14,
                    vertical: barPaddingV,
                  ),
                  decoration: const BoxDecoration(
                    color: BioColors.forest,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    'DIRECTIONS:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: labelSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(
                      10,
                      compact ? 6 : 8,
                      10,
                      compact ? 6 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: cream.withValues(alpha: 0.98),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(
                        color: BioColors.forest.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      kStation5CheckpointDirections,
                      style: TextStyle(
                        fontSize: bodySize,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: BioColors.ink,
                      ),
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

  Widget _sharedTablePanel({bool compact = false}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, compact ? 5 : 8, 8, compact ? 5 : 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E4).withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$kStation5CheckpointTableNote ${kStation5CheckpointTable.intro}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 10.5 : 12.5,
              height: 1.2,
              fontWeight: FontWeight.w700,
              color: BioColors.ink.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: compact ? 4 : 6),
          Expanded(
            child: _compactDataTable(fontSize: compact ? 9.5 : 11.5),
          ),
        ],
      ),
    );
  }

  Widget _compactDataTable({required double fontSize}) {
    final table = kStation5CheckpointTable;
    final cellPadding = EdgeInsets.symmetric(
      horizontal: compactCellPadding(fontSize),
      vertical: fontSize * 0.35,
    );

    return Table(
      border: TableBorder.all(color: BioColors.bark.withValues(alpha: 0.45)),
      columnWidths: {
        for (var i = 0; i < table.headers.length; i++)
          i: FlexColumnWidth(i == 0 ? 1.4 : 1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade300),
          children: [
            for (final header in table.headers)
              Padding(
                padding: cellPadding,
                child: Text(
                  header,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: BioColors.ink,
                  ),
                ),
              ),
          ],
        ),
        for (final row in table.rows)
          TableRow(
            children: [
              for (final cell in row)
                Padding(
                  padding: cellPadding,
                  child: Text(
                    cell,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      height: 1.15,
                      color: BioColors.ink,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  double compactCellPadding(double fontSize) => fontSize < 10 ? 3 : 6;

  Widget _questionCard(int questionIndex, {bool compact = false}) {
    final question = kStation5Checkpoint[questionIndex];
    final selected = _answers[questionIndex];
    final answered = selected != null;

    final promptSize = compact ? 14.0 : 16.5;
    final optionSize = compact ? 13.0 : 15.5;
    final badgeSize = compact ? 32.0 : 38.0;
    final cardPadding = compact ? 8.0 : 12.0;

    return Container(
      padding: EdgeInsets.fromLTRB(cardPadding, cardPadding, cardPadding, cardPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E4).withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _questionBadge(questionIndex + 1, size: badgeSize),
          SizedBox(width: compact ? 8 : 10),
          Expanded(
            flex: 11,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                question.prompt,
                style: TextStyle(
                  fontSize: promptSize,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  color: BioColors.forest,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          const _DashedDivider(),
          const SizedBox(width: 6),
          Expanded(
            flex: 11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < question.options.length; i++)
                  _optionLine(
                    questionIndex: questionIndex,
                    question: question,
                    optionIndex: i,
                    selectedIndex: selected,
                    locked: answered,
                    fontSize: optionSize,
                    compact: compact,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionBadge(int number, {double size = 38}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: BioColors.forest,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.52,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _optionLine({
    required int questionIndex,
    required McQuestion question,
    required int optionIndex,
    required int? selectedIndex,
    required bool locked,
    double fontSize = 15.5,
    bool compact = false,
  }) {
    final isSelected = selectedIndex == optionIndex;
    final isCorrect = optionIndex == question.correctIndex;
    final letter = String.fromCharCode(65 + optionIndex);

    Color textColor = BioColors.ink;
    Color letterColor = BioColors.forest;
    Color? fill;

    if (locked) {
      if (isCorrect) {
        textColor = BioColors.correct;
        letterColor = BioColors.correct;
        fill = BioColors.correct.withValues(alpha: 0.12);
      } else if (isSelected) {
        textColor = BioColors.danger;
        letterColor = BioColors.danger;
        fill = BioColors.danger.withValues(alpha: 0.1);
      } else {
        textColor = BioColors.ink.withValues(alpha: 0.55);
        letterColor = BioColors.ink.withValues(alpha: 0.55);
      }
    } else if (isSelected) {
      fill = BioColors.paleLeaf.withValues(alpha: 0.65);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 1.5 : 3),
      child: Material(
        color: fill ?? Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: locked
              ? null
              : () => _selectAnswer(questionIndex, optionIndex),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 2,
              vertical: compact ? 2 : 4,
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: fontSize,
                  height: 1.2,
                  color: textColor,
                ),
                children: [
                  TextSpan(
                    text: '$letter. ',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: letterColor,
                    ),
                  ),
                  TextSpan(
                    text: question.options[optionIndex],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 10,
      child: CustomPaint(
        painter: _DashedLinePainter(),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BioColors.forest.withValues(alpha: 0.45)
      ..strokeWidth = 1.2;

    const dash = 5.0;
    const gap = 4.0;
    var y = 0.0;
    final x = size.width / 2;
    while (y < size.height) {
      final end = (y + dash).clamp(0.0, size.height);
      canvas.drawLine(Offset(x, y), Offset(x, end), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
