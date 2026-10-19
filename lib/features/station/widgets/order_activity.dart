import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../app/theme.dart';

/// Tap-in-correct-order activity. Shows the steps shuffled; the learner taps
/// the step they think comes next. Correct taps lock into the ordered column
/// (green); wrong taps shake and are rejected. Robust on low-end devices (no
/// drag math). Calls [onCompleted] once every step is placed in order.
class OrderActivity extends StatefulWidget {
  /// Steps in their CORRECT order.
  final List<String> correctOrder;
  final VoidCallback onCompleted;

  const OrderActivity({
    super.key,
    required this.correctOrder,
    required this.onCompleted,
  });

  @override
  State<OrderActivity> createState() => _OrderActivityState();
}

class _OrderActivityState extends State<OrderActivity>
    with SingleTickerProviderStateMixin {
  late final List<String> _shuffled;
  final List<String> _placed = [];
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  String? _wrongLabel;

  @override
  void initState() {
    super.initState();
    _shuffled = List<String>.from(widget.correctOrder);
    _shuffled.shuffle(math.Random(7));
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _tap(String step) {
    final nextIndex = _placed.length;
    if (step == widget.correctOrder[nextIndex]) {
      setState(() => _placed.add(step));
      if (_placed.length == widget.correctOrder.length) {
        widget.onCompleted();
      }
    } else {
      setState(() => _wrongLabel = step);
      _shake.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _bank()),
        const SizedBox(width: 16),
        Expanded(child: _order()),
      ],
    );
  }

  Widget _bank() {
    final remaining = _shuffled
        .where((s) => !_placed.contains(s))
        .toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Tap the steps in the correct order',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [for (final step in remaining) _bankChip(step)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bankChip(String step) {
    final isWrong = _wrongLabel == step;
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = (isWrong && _shake.isAnimating)
            ? math.sin(_shake.value * math.pi * 4) * 8 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: isWrong ? BioColors.danger : Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _tap(step),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BioColors.bark, width: 2),
              ),
              child: Text(
                step,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isWrong ? Colors.white : BioColors.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _order() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Correct sequence',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < widget.correctOrder.length; i++) _slot(i),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _slot(int i) {
    final filled = i < _placed.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: filled
              ? BioColors.correct.withValues(alpha: 0.85)
              : Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: filled ? BioColors.correct : BioColors.bark,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: filled ? Colors.white : BioColors.paleLeaf,
              child: Text(
                '${i + 1}',
                style: const TextStyle(
                  color: BioColors.forest,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                filled ? _placed[i] : '. . .',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: filled ? Colors.white : BioColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
