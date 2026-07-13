import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station4_data.dart';

/// Activity 2 main task: observe reactions on the left, fill the results
/// table on the right via tap-to-match (-, +, ++, +++).
class PhytochemicalScreeningActivity extends StatefulWidget {
  final VoidCallback onComplete;

  const PhytochemicalScreeningActivity({
    super.key,
    required this.onComplete,
  });

  @override
  State<PhytochemicalScreeningActivity> createState() =>
      _PhytochemicalScreeningActivityState();
}

class _PhytochemicalScreeningActivityState
    extends State<PhytochemicalScreeningActivity>
    with SingleTickerProviderStateMixin {
  int _currentTest = 0;
  String? _selectedToken;
  final Map<int, String> _answers = {};
  int? _shakingCell;

  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  static const _mossLabels = ['Genus Pyrrhobryum', 'Genus Ectropothecium'];

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  int _cellKey(int testIndex, int mossIndex) => testIndex * 2 + mossIndex;

  String _correctAnswer(int testIndex, int mossIndex) {
    final test = kStation4ScreeningTests[testIndex];
    return mossIndex == 0 ? test.pyrrhobryumAnswer : test.ectropotheciumAnswer;
  }

  bool get _currentRowComplete {
    final pyrrh = _answers[_cellKey(_currentTest, 0)];
    final ectro = _answers[_cellKey(_currentTest, 1)];
    return pyrrh == kStation4ScreeningTests[_currentTest].pyrrhobryumAnswer &&
        ectro == kStation4ScreeningTests[_currentTest].ectropotheciumAnswer;
  }

  bool get _allComplete {
    if (_answers.length != kStation4ScreeningTests.length * 2) return false;
    for (var t = 0; t < kStation4ScreeningTests.length; t++) {
      if (_answers[_cellKey(t, 0)] != _correctAnswer(t, 0)) return false;
      if (_answers[_cellKey(t, 1)] != _correctAnswer(t, 1)) return false;
    }
    return true;
  }

  void _selectToken(String token) {
    setState(() {
      _selectedToken = _selectedToken == token ? null : token;
    });
  }

  void _tapCell(int testIndex, int mossIndex) {
    if (testIndex != _currentTest) return;
    final key = _cellKey(testIndex, mossIndex);
    if (_answers.containsKey(key)) return;

    final token = _selectedToken;
    if (token == null) return;

    if (token == _correctAnswer(testIndex, mossIndex)) {
      setState(() {
        _answers[key] = token;
        _selectedToken = null;
        _shakingCell = null;
      });
      if (_allComplete) widget.onComplete();
    } else {
      setState(() => _shakingCell = key);
      _shake.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _shakingCell = null);
      });
    }
  }

  void _nextTest() {
    if (!_currentRowComplete) return;
    if (_currentTest >= kStation4ScreeningTests.length - 1) return;
    setState(() {
      _currentTest++;
      _selectedToken = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _headerBanner(),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _testPanel()),
              const SizedBox(width: 10),
              Expanded(child: _resultsPanel()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            BioColors.forest,
            BioColors.forest.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Text(
            'ACTIVITY 2: PHYTOCHEMICAL SCREENING LABORATORY',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'MAIN ACTIVITY: IDENTIFY THE RESULTS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ],
      ),
    );
  }

  Widget _testPanel() {
    final test = kStation4ScreeningTests[_currentTest];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.25)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _mossSamplesRow(compact: true),
            const SizedBox(height: 10),
            Text(
              test.compound.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: BioColors.forest,
              ),
            ),
            Text(
              '(${test.testName})',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: BioColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              test.observation,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 12),
            _observedResultsRow(test),
            const SizedBox(height: 12),
            _legendCard(),
          ],
        ),
      ),
    );
  }

  Widget _observedResultsRow(
    ({String compound, String testName, String observation, String pyrrhobryumAnswer, String ectropotheciumAnswer}) test,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'Observe the result',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _mossResultColumn(
                  label: 'Pyrrhobryum',
                  asset: station4ReactionAsset(
                    _currentTest,
                    test.pyrrhobryumAnswer,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 90,
                color: BioColors.bark.withValues(alpha: 0.2),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: _mossResultColumn(
                  label: 'Ectropothecium',
                  asset: station4ReactionAsset(
                    _currentTest,
                    test.ectropotheciumAnswer,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mossResultColumn({required String label, required String asset}) {
    return Column(
      children: [
        SizedBox(
          width: 52,
          height: 82,
          child: GameImage(
            asset: asset,
            label: '',
            fit: BoxFit.contain,
            color: BioColors.bark,
            icon: Icons.science,
            cacheWidth: 180,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _legendCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.search, size: 18, color: BioColors.forest),
              SizedBox(width: 6),
              Text(
                'Reaction Guide',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: BioColors.forest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          for (final row in kStation4InterpretationGuidelines)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                '${row.symbol} — ${row.observation}',
                style: const TextStyle(fontSize: 12, height: 1.3),
              ),
            ),
        ],
      ),
    );
  }

  Widget _resultsPanel() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _mossSamplesRow(),
          const SizedBox(height: 8),
          const Text(
            'Analyze the reaction in each moss sample. Identify the level '
            'present by tapping your answer in the table below.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, height: 1.35),
          ),
          const SizedBox(height: 8),
          Expanded(child: _resultsTable()),
          const SizedBox(height: 8),
          _tokenTray(),
          const SizedBox(height: 8),
          if (_currentTest < kStation4ScreeningTests.length - 1)
            Center(
              child: PrimaryButton(
                label: 'Next Test',
                icon: Icons.arrow_forward,
                color: BioColors.forest,
                fontSize: 16,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                onTap: _currentRowComplete ? _nextTest : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _mossSamplesRow({bool compact = false}) {
    const assets = [
      kStation4MossPyrrhobryumAsset,
      kStation4MossEctropotheciumAsset,
    ];
    final imageHeight = compact ? 64.0 : 78.0;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          if (!compact)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                'TWO MOSS SAMPLES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: BioColors.forest,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          Row(
            children: [
              for (var i = 0; i < 2; i++) ...[
                if (i > 0)
                  Container(
                    width: 1,
                    height: imageHeight + 18,
                    color: BioColors.bark.withValues(alpha: 0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: imageHeight,
                        child: GameImage(
                          asset: assets[i],
                          label: '',
                          fit: BoxFit.contain,
                          color: BioColors.moss,
                          icon: Icons.grass,
                          cacheWidth: 220,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _mossLabels[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: compact ? 10 : 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          _tableHeaderRow(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: kStation4ScreeningTests.length,
              separatorBuilder: (_, index) => Divider(
                height: 1,
                color: BioColors.bark.withValues(alpha: 0.2),
              ),
              itemBuilder: (context, testIndex) =>
                  _tableDataRow(testIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: BioColors.forest.withValues(alpha: 0.12),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Compound Tests',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: BioColors.forest,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Pyrrhobryum',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: BioColors.forest,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Ectropothecium',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: BioColors.forest,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableDataRow(int testIndex) {
    final test = kStation4ScreeningTests[testIndex];
    final active = testIndex == _currentTest;
    final complete = _answers.containsKey(_cellKey(testIndex, 0)) &&
        _answers.containsKey(_cellKey(testIndex, 1));

    return Container(
      color: active
          ? BioColors.leaf.withValues(alpha: 0.12)
          : complete
              ? BioColors.correct.withValues(alpha: 0.08)
              : null,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              test.compound,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.bold : FontWeight.w600,
                color: BioColors.ink,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(child: _answerCell(testIndex, 0)),
          ),
          Expanded(
            flex: 2,
            child: Center(child: _answerCell(testIndex, 1)),
          ),
        ],
      ),
    );
  }

  Widget _answerCell(int testIndex, int mossIndex) {
    final key = _cellKey(testIndex, mossIndex);
    final value = _answers[key];
    final active = testIndex == _currentTest;
    final shaking = _shakingCell == key;
    final highlighted = active && _selectedToken != null && value == null;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = shaking && _shake.isAnimating
            ? math.sin(_shake.value * math.pi * 4) * 8 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: active && value == null ? () => _tapCell(testIndex, mossIndex) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 46,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: value != null
                  ? BioColors.correct.withValues(alpha: 0.85)
                  : highlighted
                      ? BioColors.leaf.withValues(alpha: 0.4)
                      : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: value != null
                    ? BioColors.correct
                    : active
                        ? BioColors.forest
                        : BioColors.bark.withValues(alpha: 0.4),
                width: value != null ? 2 : 1.5,
              ),
            ),
            child: Text(
              value ?? (active ? '?' : ''),
              style: TextStyle(
                fontSize: value != null ? 16 : 14,
                fontWeight: FontWeight.bold,
                color: value != null
                    ? Colors.white
                    : BioColors.ink.withValues(alpha: 0.55),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tokenTray() {
    return Column(
      children: [
        Text(
          kStation4ScreeningInstruction,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            height: 1.3,
            color: BioColors.ink.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            for (final token in kStation4RatingTokens) _tokenChip(token),
          ],
        ),
      ],
    );
  }

  Widget _tokenChip(String token) {
    final selected = _selectedToken == token;
    return Material(
      color: selected
          ? BioColors.forest.withValues(alpha: 0.15)
          : BioColors.bark,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _selectToken(token),
        child: Container(
          width: 52,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? BioColors.forest : BioColors.bark,
              width: selected ? 2.5 : 1.5,
            ),
          ),
          child: Text(
            token,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: selected ? BioColors.forest : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
