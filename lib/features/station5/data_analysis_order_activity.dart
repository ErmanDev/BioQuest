import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/text_format.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station5_data.dart';

/// Activity 1 — tap a step, then tap the numbered slot where it belongs.
class DataAnalysisOrderActivity extends StatefulWidget {
  final VoidCallback onCompleted;
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

class _DataAnalysisOrderActivityState extends State<DataAnalysisOrderActivity>
    with SingleTickerProviderStateMixin {
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
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  int? _shakingSlot;
  int? _wrongStep;

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

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _selectStep(int stepIndex) {
    setState(() {
      _selectedStep = _selectedStep == stepIndex ? null : stepIndex;
      _wrongStep = null;
    });
  }

  void _tapSlot(int slotIndex) {
    if (_slots[slotIndex] != null) return;

    final stepIndex = _selectedStep;
    if (stepIndex == null) return;

    if (stepIndex == slotIndex) {
      setState(() {
        _slots[slotIndex] = stepIndex;
        _bank.remove(stepIndex);
        _selectedStep = null;
        _wrongStep = null;
      });
      if (_allFilled) widget.onCompleted();
    } else {
      setState(() {
        _shakingSlot = slotIndex;
        _wrongStep = stepIndex;
      });
      _shake.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _shakingSlot = null);
      });
    }
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
        const Text(
          'RUMBLE! DRAG THESE STEPS',
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
          child: _bank.length == 0
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
    final wrong = _wrongStep == stepIndex;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = wrong && _shake.isAnimating
            ? math.sin(_shake.value * math.pi * 4) * 8 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Material(
        color: wrong
            ? BioColors.danger.withValues(alpha: 0.12)
            : selected
                ? BioColors.paleLeaf.withValues(alpha: 0.9)
                : Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _selectStep(stepIndex),
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: wrong
                    ? BioColors.danger
                    : selected
                        ? BioColors.forest
                        : style.color.withValues(alpha: 0.55),
                width: selected || wrong ? 2 : 1.5,
              ),
            ),
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
    final shaking = _shakingSlot == slotIndex;
    final canPlace = _selectedStep != null && placed == null;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = shaking && _shake.isAnimating
            ? math.sin(_shake.value * math.pi * 4) * 8 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Material(
        color: placed != null
            ? BioColors.correct.withValues(alpha: 0.12)
            : canPlace
                ? BioColors.paleLeaf.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: placed != null ? null : () => _tapSlot(slotIndex),
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: placed != null
                    ? BioColors.correct
                    : canPlace
                        ? BioColors.forest
                        : BioColors.bark.withValues(alpha: 0.4),
                width: canPlace || placed != null ? 2 : 1.5,
                style: placed == null && !canPlace
                    ? BorderStyle.solid
                    : BorderStyle.solid,
              ),
            ),
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
              border: Border.all(color: BioColors.forest.withValues(alpha: 0.3)),
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
        if (_allFilled && widget.onNext != null) ...[
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
