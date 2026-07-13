import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/game_image.dart';
import '../../data/station4_data.dart';

/// Activity 1: tap a form label, then tap the matching question slot.
class GraphFormMatchActivity extends StatefulWidget {
  final VoidCallback onAllCorrect;

  const GraphFormMatchActivity({
    super.key,
    required this.onAllCorrect,
  });

  @override
  State<GraphFormMatchActivity> createState() => _GraphFormMatchActivityState();
}

class _GraphFormMatchActivityState extends State<GraphFormMatchActivity>
    with SingleTickerProviderStateMixin {
  String? _selectedToken;
  final Set<String> _usedTokens = {};
  final Set<int> _solvedQuestions = {};
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  int? _shakingQuestion;

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  List<String> get _availableTokens => kStation4GraphTokens
      .where((token) => !_usedTokens.contains(token))
      .toList(growable: false);

  void _selectToken(String token) {
    if (_usedTokens.contains(token)) return;
    setState(() {
      _selectedToken = _selectedToken == token ? null : token;
    });
  }

  void _tapQuestion(int index) {
    if (_solvedQuestions.contains(index)) return;

    final token = _selectedToken;
    if (token == null) return;

    final correct = kStation4GraphMatch[index].answer == token;
    if (correct) {
      setState(() {
        _solvedQuestions.add(index);
        _usedTokens.add(token);
        _selectedToken = null;
        _shakingQuestion = null;
      });
      if (_solvedQuestions.length == kStation4GraphMatch.length) {
        widget.onAllCorrect();
      }
    } else {
      setState(() => _shakingQuestion = index);
      _shake.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _shakingQuestion = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _headerCard(),
        const SizedBox(height: 8),
        _choiceTray(),
        const SizedBox(height: 8),
        Expanded(child: _questionsList()),
      ],
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            kStation4GraphMatchTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            kStation4GraphMatchInstruction,
            style: TextStyle(
              fontSize: 14,
              height: 1.35,
              color: BioColors.ink.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _choiceTray() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.25)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          for (final token in _availableTokens) _choiceChip(token),
        ],
      ),
    );
  }

  Widget _choiceChip(String token) {
    final selected = _selectedToken == token;
    return Material(
      color: selected
          ? BioColors.forest.withValues(alpha: 0.15)
          : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _selectToken(token),
        child: Container(
          width: 118,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? BioColors.forest : BioColors.bark,
              width: selected ? 2.5 : 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _formImage(token, size: 44),
              const SizedBox(height: 4),
              Text(
                token,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? BioColors.forest : BioColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _questionsList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 6, 10),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Scrollbar(
        child: ListView.separated(
          padding: const EdgeInsets.only(right: 6),
          itemCount: kStation4GraphMatch.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _questionCard(index),
        ),
      ),
    );
  }

  Widget _questionCard(int index) {
    final row = kStation4GraphMatch[index];
    final solved = _solvedQuestions.contains(index);
    final shaking = _shakingQuestion == index;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = shaking && _shake.isAnimating
            ? math.sin(_shake.value * math.pi * 4) * 10 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: solved
              ? BioColors.correct.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: solved ? BioColors.correct : BioColors.bark.withValues(alpha: 0.35),
            width: solved ? 2 : 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: BioColors.forest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                row.description,
                style: const TextStyle(fontSize: 14, height: 1.35),
              ),
            ),
            const SizedBox(width: 8),
            _answerSlot(index, solved ? row.answer : null),
          ],
        ),
      ),
    );
  }

  Widget _answerSlot(int index, String? label) {
    final solved = label != null;
    final highlighted = _selectedToken != null && !solved;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: solved ? null : () => _tapQuestion(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 118,
          height: solved ? 60 : 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: solved
                ? BioColors.correct.withValues(alpha: 0.85)
                : highlighted
                    ? BioColors.leaf.withValues(alpha: 0.35)
                    : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: solved
                  ? BioColors.correct
                  : highlighted
                      ? BioColors.forest
                      : BioColors.bark,
              width: solved ? 2.5 : 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: solved
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _formImage(label, size: 26),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  label ?? 'Tap here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: solved
                        ? Colors.white
                        : BioColors.ink.withValues(alpha: 0.7),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _formImage(String token, {required double size}) {
    final asset = kStation4GraphFormAssets[token];
    if (asset == null) {
      return Icon(Icons.insert_chart, size: size, color: BioColors.forest);
    }
    return SizedBox(
      width: size,
      height: size,
      child: GameImage(
        asset: asset,
        label: token,
        fit: BoxFit.contain,
        color: BioColors.moss,
        icon: Icons.insert_chart,
        cacheWidth: (size * 2).round(),
      ),
    );
  }
}
