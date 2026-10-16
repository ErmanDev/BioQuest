import 'package:flutter/material.dart';

/// Enlarges small text on station screens. Small sizes grow the most and
/// sizes at or above [_keepFrom] are left alone, so captions and option text
/// become readable without blowing up titles and buttons.
class _BoostSmallText extends TextScaler {
  const _BoostSmallText(this.base);

  /// The device's own text scaling, applied after the boost.
  final TextScaler base;

  static const double _keepFrom = 34;
  static const double _strength = 0.25;

  @override
  double scale(double fontSize) {
    final boosted = fontSize >= _keepFrom
        ? fontSize
        : fontSize + (_keepFrom - fontSize) * _strength;
    return base.scale(boosted);
  }

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => base.textScaleFactor;

  @override
  bool operator ==(Object other) =>
      other is _BoostSmallText && other.base == base;

  @override
  int get hashCode => Object.hash(_BoostSmallText, base);
}

/// Applies [_BoostSmallText] to a station page (see the router).
class StationTextScale extends StatelessWidget {
  const StationTextScale({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(textScaler: _BoostSmallText(media.textScaler)),
      child: child,
    );
  }
}
