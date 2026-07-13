import 'package:flutter/material.dart';

/// BioQuest palette - earthy, nature/adventure themed.
class BioColors {
  static const Color forest = Color(0xFF1B5E20);
  static const Color moss = Color(0xFF4CAF50);
  static const Color leaf = Color(0xFF81C784);
  static const Color paleLeaf = Color(0xFFC8E6C9);
  static const Color bark = Color(0xFF5D4037);
  static const Color sand = Color(0xFFF1E9D2);
  static const Color sky = Color(0xFF64B5F6);
  static const Color deepSky = Color(0xFF1565C0);
  static const Color sun = Color(0xFFFFB300);
  static const Color danger = Color(0xFFE53935);
  static const Color correct = Color(0xFF43A047);
  static const Color ink = Color(0xFF263238);
  static const Color parchment = Color(0xFFFFF8E1);
}

class BioTheme {
  static ThemeData build() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: BioColors.forest,
        primary: BioColors.forest,
        secondary: BioColors.sun,
      ),
      scaffoldBackgroundColor: BioColors.sand,
      fontFamily: 'Roboto',
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: BioColors.ink,
        displayColor: BioColors.ink,
      ),
    );
  }
}
