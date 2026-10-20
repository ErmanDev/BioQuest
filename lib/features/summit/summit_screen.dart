import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/fit_text.dart';
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
  static const _contentLeft = 0.05;
  static const _contentRight = 0.95;
  static const _contentTop = 0.13;
  static const _contentBottom = 0.94;

  int _page = 0;
  bool _showCertificate = false;
  late final List<int?> _answers = List<int?>.filled(kSummative.length, null);

  /// One question per page.
  int get _pageCount => kSummative.length;
  bool get _isLastPage => _page >= _pageCount - 1;

  /// Questions 17–20 refer to the shared data table.
  bool get _showsSharedTable => _page >= 16;

  bool get _pageComplete => _answers[_page] != null;

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
    final compact = _showsSharedTable;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // The background art already shows the "SUMMATIVE TEST" title.
        _directionsBar(compact: compact),
        const SizedBox(height: 8),
        if (_showsSharedTable) ...[
          _sharedTablePanel(),
          const SizedBox(height: 8),
        ],
        Expanded(child: _singleQuestion(_page, compact: compact)),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: PrimaryButton(
            label: _isLastPage ? 'Submit Test' : 'Next',
            icon: _isLastPage ? Icons.check : Icons.arrow_forward,
            color: BioColors.deepSky,
            fontSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 11),
            onTap: _pageComplete ? _next : null,
          ),
        ),
      ],
    );
  }

  /// One question: the prompt on top, then four large tappable answers.
  Widget _singleQuestion(int index, {required bool compact}) {
    final question = kSummative[index];
    final selected = _answers[index];
    final promptSize = compact ? 22.0 : 27.0;
    final optionSize = compact ? 20.0 : 24.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
      // Shrinks slightly only if a long question would not fit.
      child: FitText(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _questionBadge(index + 1, size: compact ? 40 : 48),
                const SizedBox(width: 12),
                Expanded(
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
              ],
            ),
            SizedBox(height: compact ? 8 : 14),
            for (var i = 0; i < question.options.length; i++)
              _bigOption(
                questionIndex: index,
                question: question,
                optionIndex: i,
                selectedIndex: selected,
                fontSize: optionSize,
                compact: compact,
              ),
          ],
        ),
      ),
    );
  }

  Widget _bigOption({
    required int questionIndex,
    required McQuestion question,
    required int optionIndex,
    required int? selectedIndex,
    required double fontSize,
    required bool compact,
  }) {
    final isSelected = selectedIndex == optionIndex;
    final locked = selectedIndex != null;
    final letter = String.fromCharCode(65 + optionIndex);

    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 6 : 10),
      child: Material(
        color: isSelected ? BioColors.paleLeaf : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: locked
              ? null
              : () => _selectAnswer(questionIndex, optionIndex),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: compact ? 7 : 11,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? BioColors.forest
                    : BioColors.bark.withValues(alpha: 0.35),
                width: isSelected ? 2.5 : 1.5,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: fontSize * 0.75,
                  backgroundColor: isSelected
                      ? BioColors.forest
                      : BioColors.deepSky,
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: fontSize * 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    question.options[optionIndex],
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: BioColors.ink,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: BioColors.forest,
                    size: fontSize + 4,
                  ),
              ],
            ),
          ),
        ),
      ),
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
                      fontSize: compact ? 16 : 18,
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
                        fontSize: compact ? 16 : 19,
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
              fontSize: 15.5,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: BioColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          _transposedDataTable(table, fontSize: 17),
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
