import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station3_data.dart';
import '../../data/stations.dart';
import '../../models/mc_question.dart';
import '../../services/progress_service.dart';
import 'station3_checkpoint_table.dart';

class Station3CheckpointScreen extends StatefulWidget {
  const Station3CheckpointScreen({super.key});

  @override
  State<Station3CheckpointScreen> createState() =>
      _Station3CheckpointScreenState();
}

class _Station3CheckpointScreenState extends State<Station3CheckpointScreen> {
  static const _contentLeft = 0.025;
  static const _contentRight = 0.945;
  static const _contentTop = 0.215;
  static const _contentBottom = 0.875;
  static const _compactPanelMaxWidth = 840.0;
  static const _tableMaxWidth = 620.0;

  int _page = 0;
  late final List<int?> _answers =
      List<int?>.filled(kStation3Checkpoint.length, null);
  late final List<TextEditingController> _heightDiffControllers = [
    for (var _ in kStation3CheckpointTableRows) TextEditingController(),
  ];

  @override
  void dispose() {
    for (final controller in _heightDiffControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  int get _pageCount => (kStation3Checkpoint.length / 2).ceil();

  int get _firstIndex => _page * 2;

  /// Questions 7–8 share one data table above both cards.
  bool get _isSharedTablePage => _firstIndex == 6;

  bool get _pageComplete {
    for (var i = _firstIndex;
        i < _firstIndex + 2 && i < kStation3Checkpoint.length;
        i++) {
      if (_answers[i] == null) return false;
    }
    return true;
  }

  int get _answeredCount => _answers.where((a) => a != null).length;

  int _score() {
    var score = 0;
    for (var i = 0; i < kStation3Checkpoint.length; i++) {
      if (_answers[i] == kStation3Checkpoint[i].correctIndex) score++;
    }
    return score;
  }

  void _selectAnswer(int questionIndex, int optionIndex) {
    if (_answers[questionIndex] != null) return;
    setState(() => _answers[questionIndex] = optionIndex);
  }

  Future<void> _next() async {
    if (!_pageComplete) return;

    if (_page < _pageCount - 1) {
      setState(() => _page++);
      return;
    }

    final progress = context.read<ProgressService>();
    final router = GoRouter.of(context);
    final score = _score();
    final total = kStation3Checkpoint.length;
    await progress.recordAssessment('station3_checkpoint', score, total);
    await progress.completeStation('station3', score);
    if (!mounted) return;
    router.go('/station3/badge');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: kStation3TrailCheckpointBackgroundAsset,
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
                const SizedBox(height: 6),
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
            onTap: () => context.go(stationHubRoute('station3')),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back, color: BioColors.forest, size: 26),
            ),
          ),
        ),
        const Spacer(),
        Text(
          'Answered: $_answeredCount / ${kStation3Checkpoint.length}',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _isSharedTablePage
            ? _compactPanel(_instructionsBar())
            : _instructionsBar(),
        const SizedBox(height: 8),
        Expanded(
          child: _isSharedTablePage
              ? _sharedTablePageLayout()
              : _dualQuestionLayout(),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.center,
          child: PrimaryButton(
            label: _page == _pageCount - 1 ? 'Claim My Badge' : 'Next',
            icon: Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: 16,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            onTap: _pageComplete ? _next : null,
          ),
        ),
      ],
    );
  }

  Widget _dualQuestionLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: _questionCard(_firstIndex)),
        const SizedBox(width: 8),
        Expanded(
          child: _firstIndex + 1 < kStation3Checkpoint.length
              ? _questionCard(_firstIndex + 1)
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: 6),
        _pageNav(),
      ],
    );
  }

  Widget _sharedTablePageLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _compactPanel(_sharedTablePanel()),
              const SizedBox(height: 8),
              _compactPanel(_questionCard(6, shrinkWrap: true)),
              const SizedBox(height: 8),
              _compactPanel(_questionCard(7, shrinkWrap: true)),
            ],
          ),
        ),
        const SizedBox(width: 6),
        _pageNav(),
      ],
    );
  }

  Widget _compactPanel(Widget child) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _compactPanelMaxWidth),
        child: child,
      ),
    );
  }

  Widget _sharedTablePanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: BioColors.parchment.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BioColors.forest.withValues(alpha: 0.4)),
        ),
        child: Station3CheckpointDataTable(
          heightControllers: _heightDiffControllers,
          fontSize: 11,
          compact: true,
          compactMaxWidth: _tableMaxWidth,
          onHeightChanged: () => setState(() {}),
        ),
    );
  }

  Widget _instructionsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.45)),
      ),
      child: const Row(
        children: [
          Icon(Icons.assignment, color: BioColors.forest, size: 20),
          SizedBox(width: 8),
          Text(
            'INSTRUCTIONS:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: BioColors.forest,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              kStation3CheckpointInstructions,
              style: TextStyle(fontSize: 14.5, height: 1.3, color: BioColors.ink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageNav() {
    return SizedBox(
      width: 28,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                color: BioColors.paleLeaf,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  heightFactor: (_page + 1) / _pageCount,
                  child: Container(
                    decoration: BoxDecoration(
                      color: BioColors.forest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Material(
            color: _page < _pageCount - 1 && _pageComplete
                ? BioColors.forest
                : BioColors.bark.withValues(alpha: 0.35),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _page < _pageCount - 1 && _pageComplete ? _next : null,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.chevron_right, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionCard(int questionIndex, {bool shrinkWrap = false}) {
    if (questionIndex >= kStation3Checkpoint.length) {
      return const SizedBox.shrink();
    }

    final question = kStation3Checkpoint[questionIndex];
    final selected = _answers[questionIndex];
    final answered = selected != null;
    final instrumentAsset = _instrumentAssetFor(question);

    final promptAndOptions = [
      if (_stimulusForCard(question) != null) ...[
        _stimulusForCard(question)!,
        const SizedBox(height: 6),
      ],
      Text(
        question.prompt,
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w800,
          height: 1.25,
          color: BioColors.ink,
        ),
      ),
      const SizedBox(height: 6),
      for (var i = 0; i < question.options.length; i++)
        _optionTile(
          questionIndex: questionIndex,
          question: question,
          optionIndex: i,
          displayIndex: i,
          selectedIndex: selected,
          locked: answered,
          compact: shrinkWrap,
        ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment:
            shrinkWrap ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
        mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _questionBadge(questionIndex + 1),
              const Spacer(),
              if (instrumentAsset != null)
                SizedBox(
                  width: 42,
                  height: 42,
                  child: GameImage(
                    asset: instrumentAsset,
                    label: 'instrument',
                    fit: BoxFit.contain,
                    color: BioColors.moss,
                    icon: Icons.science,
                    cacheWidth: 100,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (shrinkWrap)
            ...promptAndOptions
          else
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: promptAndOptions,
              ),
            ),
        ],
      ),
    );
  }

  Widget _questionBadge(int number) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: BioColors.forest,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget? _stimulusForCard(McQuestion question) {
    if (question.tableStimulus == kStation3CheckpointTable) {
      return null;
    }
    if (question.stimulus == null) return null;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.35)),
      ),
      child: Text(
        question.stimulus!,
        style: const TextStyle(fontSize: 13, height: 1.3),
      ),
    );
  }

  Widget _optionTile({
    required int questionIndex,
    required McQuestion question,
    required int optionIndex,
    required int displayIndex,
    required int? selectedIndex,
    required bool locked,
    bool compact = false,
  }) {
    final isSelected = selectedIndex == optionIndex;
    final isCorrect = optionIndex == question.correctIndex;

    Color background = Colors.white;
    Color border = BioColors.bark.withValues(alpha: 0.4);
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
        background = Colors.white.withValues(alpha: 0.6);
      }
    } else if (isSelected) {
      background = BioColors.paleLeaf;
      border = BioColors.forest;
    }

    final tile = Material(
      color: background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: locked
            ? null
            : () => _selectAnswer(questionIndex, optionIndex),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 8,
            vertical: compact ? 3 : 4,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border, width: 1.5),
          ),
          child: Row(
            mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Container(
                width: compact ? 24 : 26,
                height: compact ? 24 : 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: locked && (isCorrect || isSelected)
                      ? Colors.white
                      : BioColors.forest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  String.fromCharCode(65 + displayIndex),
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: locked && (isCorrect || isSelected)
                        ? (isCorrect ? BioColors.correct : BioColors.danger)
                        : Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (compact)
                Text(
                  question.options[optionIndex],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: text,
                    height: 1.2,
                  ),
                )
              else
                Expanded(
                  child: Text(
                    question.options[optionIndex],
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: text,
                      height: 1.2,
                    ),
                  ),
                ),
              if (locked && isCorrect)
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: compact
          ? Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(child: tile),
            )
          : tile,
    );
  }

  String? _instrumentAssetFor(McQuestion question) {
    final answer = question.options[question.correctIndex].toLowerCase();
    if (answer.contains('ruler')) {
      return 'assets/images/station3/research_instruments/ruler.png';
    }
    if (answer.contains('balance') || answer.contains('weighing')) {
      return 'assets/images/station3/research_instruments/digital_weighing_scale.png';
    }
    if (answer.contains('microscope')) {
      return 'assets/images/station3/research_instruments/microscope.png';
    }
    if (answer.contains('camera')) {
      return 'assets/images/station3/research_instruments/camera.png';
    }
    if (answer.contains('thermometer')) {
      return 'assets/images/station3/research_instruments/thermometer.png';
    }
    if (answer.contains('hygrometer')) {
      return 'assets/images/station3/research_instruments/hygrometer.png';
    }
    if (answer.contains('stopwatch') || answer.contains('timer')) {
      return 'assets/images/station3/research_instruments/stopwatch.png';
    }
    return null;
  }
}
