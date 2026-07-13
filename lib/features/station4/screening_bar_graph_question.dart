import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/text_format.dart';
import '../../data/station4_data.dart';

/// Question 1 — tap a value (0–3), then tap a bar slot to set its height.
class ScreeningBarGraphQuestion extends StatefulWidget {
  final VoidCallback onComplete;

  const ScreeningBarGraphQuestion({
    super.key,
    required this.onComplete,
  });

  @override
  State<ScreeningBarGraphQuestion> createState() =>
      _ScreeningBarGraphQuestionState();
}

class _ScreeningBarGraphQuestionState extends State<ScreeningBarGraphQuestion>
    with SingleTickerProviderStateMixin {
  static const _pyrrhColor = Color(0xFF1565C0);
  static const _ectroColor = Color(0xFFFF9800);

  int? _selectedValue;
  final List<int?> _pyrrhValues =
      List<int?>.filled(kStation4ScreeningTests.length, null);
  final List<int?> _ectroValues =
      List<int?>.filled(kStation4ScreeningTests.length, null);
  int? _shakingSlot;

  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  bool get _allSet =>
      !_pyrrhValues.contains(null) && !_ectroValues.contains(null);

  bool get _allCorrect {
    for (var i = 0; i < kStation4ScreeningTests.length; i++) {
      if (_pyrrhValues[i] != station4ExpectedPyrrhobryumBarValue(i)) {
        return false;
      }
      if (_ectroValues[i] != station4ExpectedEctropotheciumBarValue(i)) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _selectValue(int value) {
    setState(() {
      _selectedValue = _selectedValue == value ? null : value;
    });
  }

  void _tapBar(int testIndex, {required bool pyrrhobryum}) {
    final value = _selectedValue;
    if (value == null) return;

    final expected = pyrrhobryum
        ? station4ExpectedPyrrhobryumBarValue(testIndex)
        : station4ExpectedEctropotheciumBarValue(testIndex);

    if (value != expected) {
      setState(() => _shakingSlot = testIndex * 2 + (pyrrhobryum ? 0 : 1));
      _shake.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _shakingSlot = null);
      });
      return;
    }

    setState(() {
      if (pyrrhobryum) {
        _pyrrhValues[testIndex] = value;
      } else {
        _ectroValues[testIndex] = value;
      }
      _selectedValue = null;
      _shakingSlot = null;
    });

    if (_allSet && _allCorrect) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'QUESTION 1',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            readingTextSpan(
              kStation4BarGraphQuestionPrompt,
              fontSize: 15,
              color: BioColors.ink,
            ),
            style: const TextStyle(height: 1.4, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _chart(),
          const SizedBox(height: 10),
          _legend(),
          const SizedBox(height: 10),
          Text(
            'Tap a value, then tap each bar to set its height.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: BioColors.ink.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          _valueTray(),
          if (_allSet && _allCorrect)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Bar graph complete!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: BioColors.correct,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _yAxis(),
          const SizedBox(width: 6),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < kStation4ScreeningTests.length; i++)
                  Expanded(
                    child: _barGroup(i),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _yAxis() {
    return SizedBox(
      width: 18,
      child: Column(
        children: [
          for (var v = 3; v >= 0; v--)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$v',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _barGroup(int testIndex) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final chartH = constraints.maxHeight;
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  for (var v = 0; v <= 3; v++)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: chartH * (v / 3),
                      child: Divider(
                        height: 1,
                        color: BioColors.bark.withValues(alpha: 0.12),
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _barSlot(
                          testIndex: testIndex,
                          pyrrhobryum: true,
                          value: _pyrrhValues[testIndex],
                          color: _pyrrhColor,
                          maxHeight: chartH,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: _barSlot(
                          testIndex: testIndex,
                          pyrrhobryum: false,
                          value: _ectroValues[testIndex],
                          color: _ectroColor,
                          maxHeight: chartH,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          station4CompoundLabel(kStation4ScreeningTests[testIndex].compound),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _barSlot({
    required int testIndex,
    required bool pyrrhobryum,
    required int? value,
    required Color color,
    required double maxHeight,
  }) {
    final slotKey = testIndex * 2 + (pyrrhobryum ? 0 : 1);
    final shaking = _shakingSlot == slotKey;
    final barH = value == null ? 0.0 : maxHeight * (value / 3);
    final highlighted = _selectedValue != null && value == null;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = shaking && _shake.isAnimating
            ? math.sin(_shake.value * math.pi * 4) * 6 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _tapBar(testIndex, pyrrhobryum: pyrrhobryum),
          child: SizedBox(
            height: maxHeight,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (value == null)
                  Container(
                    width: double.infinity,
                    height: maxHeight,
                    decoration: BoxDecoration(
                      color: highlighted
                          ? BioColors.leaf.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: highlighted
                            ? BioColors.forest
                            : BioColors.bark.withValues(alpha: 0.2),
                        width: highlighted ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: value == null && highlighted
                        ? null
                        : Text(
                            '?',
                            style: TextStyle(
                              fontSize: 12,
                              color: BioColors.ink.withValues(alpha: 0.35),
                            ),
                          ),
                  ),
                if (value != null && barH > 0)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: barH,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ),
                if (value != null && value == 0)
                  Container(
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _legend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendDot(_pyrrhColor, 'Genus Pyrrhobryum'),
        const SizedBox(width: 16),
        _legendDot(_ectroColor, 'Genus Ectropothecium'),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _valueTray() {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: [
        for (final row in kStation4BarGraphValueScale)
          _valueChip(row.value, row.label),
      ],
    );
  }

  Widget _valueChip(int value, String label) {
    final selected = _selectedValue == value;
    return Material(
      color: selected
          ? BioColors.forest.withValues(alpha: 0.15)
          : BioColors.bark,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _selectValue(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? BioColors.forest : BioColors.bark,
              width: selected ? 2.5 : 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? BioColors.forest : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
