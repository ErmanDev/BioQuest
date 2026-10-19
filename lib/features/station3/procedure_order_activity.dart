import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station3_data.dart';

/// Part I tap-to-place: select a step, then tap the correct numbered slot.
class ProcedureOrderActivity extends StatefulWidget {
  final VoidCallback onCompleted;
  final VoidCallback? onNext;

  const ProcedureOrderActivity({
    super.key,
    required this.onCompleted,
    this.onNext,
  });

  @override
  State<ProcedureOrderActivity> createState() => _ProcedureOrderActivityState();
}

class _ProcedureOrderActivityState extends State<ProcedureOrderActivity>
    with SingleTickerProviderStateMixin {
  late List<int> _bank;
  final List<int?> _slots =
      List<int?>.filled(kStation3ProcedureSteps.length, null);
  int? _selectedStep;
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  int? _shakingSlot;
  int? _wrongStep;

  bool get _allFilled =>
      _slots.every((slot) => slot != null) &&
      _slots.length == kStation3ProcedureSteps.length;

  @override
  void initState() {
    super.initState();
    _resetBank();
  }

  void _resetBank() {
    _bank = List<int>.generate(kStation3ProcedureSteps.length, (i) => i)
      ..shuffle(math.Random(11));
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
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _bankColumn()),
              const SizedBox(width: 10),
              Expanded(child: _slotsColumn()),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _footer(),
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.eco, color: BioColors.moss, size: 18),
            SizedBox(width: 6),
            Text(
              'PART I: ORGANIZE THE DATA COLLECTION PROCEDURE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: BioColors.forest,
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.eco, color: BioColors.moss, size: 18),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.lightbulb_outline, color: BioColors.sun, size: 18),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Tap a research step, then tap the numbered slot where it '
                'belongs to build the correct data collection procedure.',
                style: TextStyle(fontSize: 16.5, height: 1.3, color: BioColors.ink),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bankColumn() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _bank.length; i++) ...[
            _bankStep(_bank[i]),
            if (i < _bank.length - 1) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }

  Widget _bankStep(int stepIndex) {
    final step = kStation3ProcedureSteps[stepIndex];
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
                ? BioColors.paleLeaf.withValues(alpha: 0.85)
                : Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _selectStep(stepIndex),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: wrong
                    ? BioColors.danger
                    : selected
                        ? BioColors.forest
                        : BioColors.bark.withValues(alpha: 0.45),
                width: selected || wrong ? 2 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: BioColors.paleLeaf.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(step.icon, size: 18, color: BioColors.forest),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step.label,
                    style: const TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: BioColors.ink,
                    ),
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle : Icons.touch_app,
                  size: 18,
                  color: selected
                      ? BioColors.forest
                      : BioColors.bark.withValues(alpha: 0.45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _slotsColumn() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var i = 0; i < kStation3ProcedureSteps.length; i++) ...[
            _slot(i),
            if (i < kStation3ProcedureSteps.length - 1)
              const Icon(Icons.arrow_downward, color: BioColors.moss, size: 13),
          ],
        ],
      ),
    );
  }

  Widget _slot(int slotIndex) {
    final placed = _slots[slotIndex];
    final step = placed != null ? kStation3ProcedureSteps[placed] : null;
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
            ? BioColors.correct.withValues(alpha: 0.88)
            : canPlace
                ? BioColors.paleLeaf.withValues(alpha: 0.75)
                : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: placed == null ? () => _tapSlot(slotIndex) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: placed != null
                    ? BioColors.correct
                    : canPlace
                        ? BioColors.forest
                        : BioColors.bark.withValues(alpha: 0.4),
                width: placed != null ? 2.5 : 1.5,
              ),
              boxShadow: placed != null
                  ? [
                      BoxShadow(
                        color: BioColors.correct.withValues(alpha: 0.35),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: placed != null ? Colors.white : BioColors.forest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${slotIndex + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: placed != null ? BioColors.correct : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (step != null) ...[
                  Icon(step.icon, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    step?.label ?? 'Tap step here',
                    style: TextStyle(
                      fontSize: 18.5,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: placed != null
                          ? Colors.white
                          : BioColors.ink.withValues(alpha: 0.65),
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

  Widget _footer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: BioColors.sun.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: BioColors.sun.withValues(alpha: 0.45)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb, color: BioColors.sun, size: 18),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'TIP: Follow the correct order to collect accurate and '
                    'reliable data!',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: BioColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (_allFilled)
          PrimaryButton(
            label: 'PART II NEXT ACTIVITY',
            icon: Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: 15,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: widget.onNext,
          ),
      ],
    );
  }
}
