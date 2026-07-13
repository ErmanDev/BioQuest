import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Large, tappable button suited for kids on touch screens.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color color;
  final double fontSize;
  final EdgeInsets padding;
  final bool expand;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color = BioColors.forest,
    this.fontSize = 22,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return SizedBox(
      width: expand ? double.infinity : null,
      child: Material(
        color: enabled ? color : Colors.grey,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: fontSize + 4),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
