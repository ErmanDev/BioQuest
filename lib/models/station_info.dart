import 'package:flutter/material.dart';

/// Static definition of a station (title, badge, theme color, order).
class StationInfo {
  final String key; // e.g. "station1"
  final int order; // 1..5
  final String title;
  final String badgeName;
  final Color color;
  final bool implemented; // true once the full station is built
  /// Optional title-card image shown before the station intro.
  final String? splashAsset;
  /// Circular map marker logo for this station.
  final String logoAsset;

  const StationInfo({
    required this.key,
    required this.order,
    required this.title,
    required this.badgeName,
    required this.color,
    this.implemented = false,
    this.splashAsset,
    required this.logoAsset,
  });
}
