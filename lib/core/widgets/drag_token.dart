import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// A draggable labeled token for drag-and-drop activities.
class DragToken<T extends Object> extends StatelessWidget {
  final T value;
  final String label;
  final Color color;
  final double width;
  final double height;

  const DragToken({
    super.key,
    required this.value,
    required this.label,
    this.color = BioColors.moss,
    this.width = 150,
    this.height = 60,
  });

  Widget _chip({double opacity = 1}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<T>(
      data: value,
      feedback: Material(color: Colors.transparent, child: _chip()),
      childWhenDragging: _chip(opacity: 0.3),
      child: _chip(),
    );
  }
}
