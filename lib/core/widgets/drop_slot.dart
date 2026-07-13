import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// A drop target that validates the dropped token.
/// - Correct drop: glows green and keeps the accepted label.
/// - Wrong drop: shakes and is rejected (not accepted into the box).
class DropSlot<T extends Object> extends StatefulWidget {
  final String hint;
  final bool Function(T value) isCorrect;
  final String Function(T value) labelOf;
  final void Function(T value)? onCorrect;
  final double width;
  final double height;

  const DropSlot({
    super.key,
    required this.hint,
    required this.isCorrect,
    required this.labelOf,
    this.onCorrect,
    this.width = 170,
    this.height = 70,
  });

  @override
  State<DropSlot<T>> createState() => _DropSlotState<T>();
}

class _DropSlotState<T extends Object> extends State<DropSlot<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  String? _acceptedLabel;
  bool _solved = false;

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _onAccept(T value) {
    if (widget.isCorrect(value)) {
      setState(() {
        _acceptedLabel = widget.labelOf(value);
        _solved = true;
      });
      widget.onCorrect?.call(value);
    } else {
      _shake.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      onWillAcceptWithDetails: (_) => !_solved,
      onAcceptWithDetails: (d) => _onAccept(d.data),
      builder: (context, candidate, rejected) {
        final hovering = candidate.isNotEmpty;
        return AnimatedBuilder(
          animation: _shake,
          builder: (context, child) {
            final dx = _shake.isAnimating
                ? math.sin(_shake.value * math.pi * 4) *
                    10 *
                    (1 - _shake.value)
                : 0.0;
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _solved
                  ? BioColors.correct.withValues(alpha: 0.85)
                  : hovering
                      ? BioColors.leaf.withValues(alpha: 0.5)
                      : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _solved ? BioColors.correct : BioColors.bark,
                width: _solved ? 3 : 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                _acceptedLabel ?? widget.hint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _solved ? Colors.white : BioColors.ink,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
