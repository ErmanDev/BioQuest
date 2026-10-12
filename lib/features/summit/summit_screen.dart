import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/references_panel.dart';
import '../../data/summit_data.dart';
import '../../models/mc_question.dart';
import '../../services/auth_service.dart';
import '../../services/progress_service.dart';

/// Discovery Summit — summative test on a full-screen background; certificate
/// shown after completion.
class SummitScreen extends StatefulWidget {
  const SummitScreen({super.key});

  @override
  State<SummitScreen> createState() => _SummitScreenState();
}

class _SummitScreenState extends State<SummitScreen> {
  static const _contentLeft = 0.10;
  static const _contentRight = 0.90;
  static const _contentTop = 0.24;
  static const _contentBottom = 0.94;

  int _page = 0;
  bool _showCertificate = false;
  late final List<int?> _answers = List<int?>.filled(kSummative.length, null);

  int get _pageCount => (kSummative.length / 2).ceil();
  int get _firstIndex => _page * 2;
  bool get _isLastPage => _page >= _pageCount - 1;
  bool get _showsSharedTable => _firstIndex >= 16;

  bool get _pageComplete {
    for (
      var i = _firstIndex;
      i < _firstIndex + 2 && i < kSummative.length;
      i++
    ) {
      if (_answers[i] == null) return false;
    }
    return true;
  }

  int get _answeredCount => _answers.where((answer) => answer != null).length;

  int _score() {
    var score = 0;
    for (var i = 0; i < kSummative.length; i++) {
      if (_answers[i] == kSummative[i].correctIndex) score++;
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
      _finish();
      return;
    }
    setState(() => _page++);
  }

  Future<void> _finish() async {
    final score = _score();
    final total = kSummative.length;
    final progress = context.read<ProgressService>();
    await progress.recordAssessment('summative', score, total);
    await progress.completeStation('summit', score);
    if (!mounted) return;
    setState(() => _showCertificate = true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: Opacity(
            opacity: _showCertificate ? 0.42 : 1,
            child: GameImage(
              asset: kSummitSummativeBackgroundAsset,
              label: 'Discovery Summit',
              fit: BoxFit.cover,
              color: BioColors.forest,
              icon: Icons.landscape,
              cacheWidth: 1280,
            ),
          ),
        ),
        if (_showCertificate)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.32),
                  ],
                ),
              ),
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
                  child: _showCertificate
                      ? _certificateView(context)
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final w = constraints.maxWidth;
                            final h = constraints.maxHeight;
                            return Stack(
                              clipBehavior: Clip.hardEdge,
                              children: [
                                Positioned(
                                  left: w * _contentLeft,
                                  top: h * _contentTop,
                                  width: w * (_contentRight - _contentLeft),
                                  height: h * (_contentBottom - _contentTop),
                                  child: _quizView(),
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
            onTap: () => context.go('/map'),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back, color: BioColors.forest, size: 26),
            ),
          ),
        ),
        if (!_showCertificate) ...[
          const Spacer(),
          Text(
            'Answered: $_answeredCount / ${kSummative.length}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }

  Widget _quizView() {
    final secondIndex = _firstIndex + 1;
    final hasSecond = secondIndex < kSummative.length;
    final compact = _showsSharedTable;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _titleBanner(),
        const SizedBox(height: 6),
        _directionsBar(compact: compact),
        SizedBox(height: compact ? 4 : 8),
        Expanded(
          child: Column(
            children: [
              if (_showsSharedTable) ...[
                _sharedTablePanel(),
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
            label: _isLastPage ? 'Submit Test' : 'Next',
            icon: _isLastPage ? Icons.check : Icons.arrow_forward,
            color: BioColors.deepSky,
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

  Widget _titleBanner() {
    return const Column(
      children: [
        Text(
          'SUMMATIVE TEST',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: BioColors.forest,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Discovery Summit',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: BioColors.ink,
          ),
        ),
      ],
    );
  }

  Widget _directionsBar({bool compact = false}) {
    const cream = Color(0xFFF7F1E4);
    final iconSize = compact ? 34.0 : 42.0;

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
              ),
            ),
            child: Icon(
              Icons.quiz_outlined,
              color: BioColors.forest,
              size: compact ? 18 : 22,
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
                    horizontal: compact ? 10 : 12,
                    vertical: compact ? 7 : 9,
                  ),
                  decoration: const BoxDecoration(
                    color: BioColors.deepSky,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    'DIRECTIONS:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 12 : 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: compact ? 6 : 8,
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
                      kSummitSummativeDirections,
                      style: TextStyle(
                        fontSize: compact ? 12 : 13.5,
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

  Widget _sharedTablePanel() {
    final table = kSummativeMossShootTable;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E4).withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            table.intro.replaceAll('\n\n', ' '),
            style: const TextStyle(
              fontSize: 11,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: BioColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          _transposedDataTable(table, fontSize: 11),
        ],
      ),
    );
  }

  /// Shows the table sideways (one row per column of the source) so the
  /// 4-week data fits the short space above the question cards.
  Widget _transposedDataTable(
    McTableStimulus table, {
    required double fontSize,
  }) {
    final cellPadding = EdgeInsets.symmetric(
      horizontal: 6,
      vertical: fontSize * 0.15,
    );
    return Table(
      border: TableBorder.all(color: BioColors.bark.withValues(alpha: 0.45)),
      columnWidths: const {0: FlexColumnWidth(1.4)},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (var col = 0; col < table.headers.length; col++)
          TableRow(
            decoration: col == 0
                ? BoxDecoration(color: Colors.grey.shade300)
                : null,
            children: [
              Padding(
                padding: cellPadding,
                child: Text(
                  table.headers[col],
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              for (final row in table.rows)
                Padding(
                  padding: cellPadding,
                  child: Text(
                    row[col],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: col == 0 ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _questionCard(int questionIndex, {bool compact = false}) {
    final question = kSummative[questionIndex];
    final selected = _answers[questionIndex];
    final answered = selected != null;
    final promptSize = compact ? 13.5 : 15.5;
    final optionSize = compact ? 12.5 : 14.5;
    final badgeSize = compact ? 30.0 : 36.0;
    final cardPadding = compact ? 7.0 : 10.0;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E4).withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _questionBadge(questionIndex + 1, size: badgeSize),
          SizedBox(width: compact ? 6 : 8),
          Expanded(
            flex: 11,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                question.prompt,
                style: TextStyle(
                  fontSize: promptSize,
                  fontWeight: FontWeight.w800,
                  height: 1.22,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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

  Widget _questionBadge(int number, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: BioColors.deepSky,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.5,
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
    required double fontSize,
    bool compact = false,
  }) {
    final isSelected = selectedIndex == optionIndex;
    final letter = String.fromCharCode(65 + optionIndex);
    Color textColor = BioColors.ink;
    Color letterColor = BioColors.deepSky;
    Color? fill;

    if (locked) {
      if (isSelected) {
        fill = BioColors.paleLeaf.withValues(alpha: 0.8);
      }
    } else if (isSelected) {
      fill = BioColors.paleLeaf.withValues(alpha: 0.65);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 1 : 2),
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
              vertical: compact ? 2 : 3,
            ),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: fontSize,
                  height: 1.18,
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

  void _showReferences(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ReferencesPanel(
          onClose: () => Navigator.of(dialogContext).pop(),
        ),
      ),
    );
  }

  Widget _certificateView(BuildContext context) {
    final user = context.read<AuthService>().currentUser;
    final name = user?.displayName ?? 'Young Researcher';

    return LayoutBuilder(
      builder: (context, constraints) {
        const certAspect = 1.5;
        var certW = constraints.maxWidth;
        var certH = certW / certAspect;
        if (certH > constraints.maxHeight - 64) {
          certH = constraints.maxHeight - 64;
          certW = certH * certAspect;
        }

        final nameFontSize = certH * 0.115;

        return Column(
          children: [
            Expanded(
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.45),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: certW,
                      height: certH,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GameImage(
                            asset: kSummitCertificateAsset,
                            label: 'Certificate of Achievement',
                            fit: BoxFit.fill,
                            color: BioColors.parchment,
                            icon: Icons.workspace_premium,
                            cacheWidth: 1536,
                          ),
                          Positioned(
                            left: certW * 0.14,
                            right: certW * 0.14,
                            top: certH * 0.328,
                            height: certH * 0.105,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: kSummitCertificateNameFont,
                                      fontSize: nameFontSize,
                                      height: 0.95,
                                      color: const Color(0xFF1A3D2F),
                                      letterSpacing: 0.6,
                                      shadows: const [
                                        Shadow(
                                          color: Color(0x40000000),
                                          offset: Offset(0, 1.5),
                                          blurRadius: 2,
                                        ),
                                        Shadow(
                                          color: Color(0x33C9A227),
                                          offset: Offset(0, 0),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(
                  label: 'References',
                  icon: Icons.menu_book_rounded,
                  color: BioColors.bark,
                  onTap: () => _showReferences(context),
                ),
                const SizedBox(width: 14),
                PrimaryButton(
                  label: 'Back to Expedition Map',
                  icon: Icons.map,
                  onTap: () => context.go('/map'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8,
      child: CustomPaint(painter: _DashedLinePainter()),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
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
