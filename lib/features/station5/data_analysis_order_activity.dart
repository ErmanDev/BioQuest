import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/text_format.dart';
import '../../core/widgets/fit_text.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station5_data.dart';

/// Activity 1 — tap a step, then tap a numbered slot. Any arrangement is
/// accepted; "Check Answers" scores each slot and reveals the correct order.
class DataAnalysisOrderActivity extends StatefulWidget {
  /// Called once on check with the number of steps in the correct slot.
  final ValueChanged<int> onCompleted;
  final VoidCallback? onNext;

  const DataAnalysisOrderActivity({
    super.key,
    required this.onCompleted,
    this.onNext,
  });

  @override
  State<DataAnalysisOrderActivity> createState() =>
      _DataAnalysisOrderActivityState();
}

class _DataAnalysisOrderActivityState extends State<DataAnalysisOrderActivity> {
  static const _stepStyles = <({IconData icon, Color color})>[
    (icon: Icons.search, color: Color(0xFF1565C0)),
    (icon: Icons.lightbulb_outline, color: Color(0xFF00838F)),
    (icon: Icons.table_chart_outlined, color: Color(0xFF2E7D32)),
    (icon: Icons.functions, color: Color(0xFF283593)),
    (icon: Icons.compare_arrows, color: Color(0xFFE65100)),
    (icon: Icons.gavel, color: Color(0xFF6A1B9A)),
  ];

  late List<int> _bank;
  final List<int?> _slots = List<int?>.filled(kStation5Steps.length, null);
  int? _selectedStep;
  bool _checked = false;

  bool get _allFilled =>
      _slots.every((slot) => slot != null) &&
      _slots.length == kStation5Steps.length;

  @override
  void initState() {
    super.initState();
    _resetBank();
  }

  void _resetBank() {
    _bank = List<int>.generate(kStation5Steps.length, (i) => i)
      ..shuffle(math.Random(17));
  }

  int get _correctCount {
    var count = 0;
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] == i) count++;
    }
    return count;
  }

  void _selectStep(int stepIndex) {
    setState(() {
      _selectedStep = _selectedStep == stepIndex ? null : stepIndex;
    });
  }

  void _tapSlot(int slotIndex) {
    if (_checked) return;
    final placed = _slots[slotIndex];
    if (placed != null) {
      // Tapping a filled slot sends its step back to the list.
      setState(() {
        _slots[slotIndex] = null;
        _bank.add(placed);
      });
      return;
    }

    final stepIndex = _selectedStep;
    if (stepIndex == null) return;
    setState(() {
      _slots[slotIndex] = stepIndex;
      _bank.remove(stepIndex);
      _selectedStep = null;
    });
  }

  void _check() {
    if (!_allFilled || _checked) return;
    setState(() => _checked = true);
    widget.onCompleted(_correctCount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 6),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _bankColumn()),
              const SizedBox(width: 12),
              Expanded(child: _slotsColumn()),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _footer(),
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: BioColors.forest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            kStation5Activity1Title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          readingTextSpan(
            kStation5Activity1Instruction,
            fontSize: 13.5,
            color: BioColors.ink,
          ),
          style: const TextStyle(height: 1.35),
        ),
      ],
    );
  }

  Widget _bankColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _checked ? 'CORRECT ARRANGEMENT' : 'RUMBLE! DRAG THESE STEPS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: _checked
              ? _correctOrder()
              : _bank.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    for (var i = 0; i < _bank.length; i++) ...[
                      Expanded(child: _bankStep(_bank[i])),
                      if (i < _bank.length - 1) const SizedBox(height: 5),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _bankStep(int stepIndex) {
    final label = kStation5Steps[stepIndex];
    final style = _stepStyles[stepIndex];
    final selected = _selectedStep == stepIndex;

    return Material(
      color: selected
          ? BioColors.paleLeaf.withValues(alpha: 0.9)
          : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _selectStep(stepIndex),
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? BioColors.forest
                  : style.color.withValues(alpha: 0.55),
              width: selected ? 2 : 1.5,
            ),
          ),
          child: FitText(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: style.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(style.icon, size: 20, color: style.color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      color: BioColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Read-only list of the steps in their correct order, shown after checking.
  Widget _correctOrder() {
    return Column(
      children: [
        for (var i = 0; i < kStation5Steps.length; i++) ...[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: BioColors.correct.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: BioColors.correct, width: 1.5),
              ),
              child: FitText(
                child: Row(
                  children: [
                    Text(
                      '${i + 1}.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: BioColors.forest,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _stepStyles[i].icon,
                      size: 18,
                      color: _stepStyles[i].color,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        kStation5Steps[i],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: BioColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (i < kStation5Steps.length - 1) const SizedBox(height: 5),
        ],
      ],
    );
  }

  Widget _slotsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'ARRANGE THE STEPS IN THE CORRECT ORDER',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            letterSpacing: 0.15,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < kStation5Steps.length; i++) ...[
                Expanded(child: _slot(i)),
                if (i < kStation5Steps.length - 1)
                  const Icon(
                    Icons.arrow_downward,
                    color: BioColors.moss,
                    size: 12,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _slot(int slotIndex) {
    final placed = _slots[slotIndex];
    final label = placed != null ? kStation5Steps[placed] : null;
    final style = placed != null ? _stepStyles[placed] : null;
    final canPlace = !_checked && _selectedStep != null && placed == null;
    final isRight = placed == slotIndex;
    final Color filledColor = _checked
        ? (isRight ? BioColors.correct : BioColors.danger)
        : BioColors.forest;

    return Material(
      color: placed != null
          ? filledColor.withValues(alpha: 0.12)
          : canPlace
          ? BioColors.paleLeaf.withValues(alpha: 0.35)
          : Colors.white.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _checked ? null : () => _tapSlot(slotIndex),
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: placed != null
                  ? filledColor
                  : canPlace
                  ? BioColors.forest
                  : BioColors.bark.withValues(alpha: 0.4),
              width: canPlace || placed != null ? 2 : 1.5,
            ),
          ),
          child: FitText(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: BioColors.forest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${slotIndex + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: label == null
                      ? Text(
                          'Drop a step here.',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontStyle: FontStyle.italic,
                            color: BioColors.ink.withValues(alpha: 0.55),
                          ),
                        )
                      : Row(
                          children: [
                            if (style != null) ...[
                              Icon(style.icon, size: 16, color: style.color),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                  color: BioColors.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                if (_checked)
                  Icon(
                    isRight ? Icons.check_circle : Icons.cancel,
                    color: filledColor,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: BioColors.forest.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb, color: BioColors.sun, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'TIP! $kStation5Activity1Tip',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: BioColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_allFilled && !_checked) ...[
          const SizedBox(width: 8),
          PrimaryButton(
            label: 'Check Answers',
            icon: Icons.fact_check,
            color: BioColors.sun,
            fontSize: 13,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: _check,
          ),
        ],
        if (_checked) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: BioColors.forest),
            ),
            child: Text(
              'Score: $_correctCount / ${kStation5Steps.length}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: BioColors.forest,
              ),
            ),
          ),
        ],
        if (_checked && widget.onNext != null) ...[
          const SizedBox(width: 8),
          PrimaryButton(
            label: 'Next Activity',
            icon: Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: 13,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: widget.onNext,
          ),
        ],
      ],
    );
  }
}
