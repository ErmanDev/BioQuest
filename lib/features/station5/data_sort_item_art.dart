import 'package:flutter/material.dart';

/// Colorful mini-illustrations for each sortable data item.
class DataSortItemArt extends StatelessWidget {
  final int index;

  const DataSortItemArt({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: ClipRect(
        child: Center(
          child: switch (index) {
            0 => _petriWithRuler(),
            1 => _replicates(),
            2 => _bacteria(),
            3 => _mossExtract(),
            4 => _positiveControl(),
            5 => _calculator(),
            6 => _colonyShape(),
            7 => _agarColor(),
            8 => _researcherBadge(),
            _ => _labDoor(),
          },
        ),
      ),
    );
  }

  Widget _petriWithRuler() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _petriDish(innerColor: const Color(0xFFFFE082), ring: true),
        const SizedBox(width: 2),
        Container(
          width: 8,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFFFCA28),
            border: Border.all(color: const Color(0xFF5D4037)),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (_) => Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                color: const Color(0xFF5D4037),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _replicates() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 2),
            child: _petriDish(innerColor: const Color(0xFFE1BEE7), size: 14),
          ),
      ],
    );
  }

  Widget _bacteria() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            width: 22 - i * 2.0,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFF7B1FA2),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }

  Widget _mossExtract() {
    return Container(
      width: 16,
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFF81C784),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        border: Border.all(color: const Color(0xFF2E7D32), width: 1.5),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 12,
          height: 6,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFBDBDBD),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _positiveControl() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _petriDish(innerColor: const Color(0xFFC8E6C9), size: 34),
        const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 18),
      ],
    );
  }

  Widget _calculator() {
    return Container(
      width: 30,
      height: 34,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF90CAF9),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF1565C0)),
      ),
      child: Column(
        children: [
          Container(height: 8, color: const Color(0xFFBBDEFB)),
          const SizedBox(height: 2),
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              children: List.generate(
                6,
                (_) => Container(color: const Color(0xFF1565C0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colonyShape() {
    return _petriDish(
      innerColor: const Color(0xFFFFF9C4),
      size: 34,
      spots: const [Offset(-6, -4), Offset(4, 2), Offset(-2, 6), Offset(7, -5)],
    );
  }

  Widget _agarColor() {
    return _petriDish(innerColor: const Color(0xFFF48FB1), size: 34);
  }

  Widget _researcherBadge() {
    return Container(
      width: 28,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF59D),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF5D4037)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: Color(0xFF8D6E63),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 4),
          Container(width: 18, height: 3, color: const Color(0xFF5D4037)),
        ],
      ),
    );
  }

  Widget _labDoor() {
    return Container(
      width: 26,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF42A5F5),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFF0D47A1), width: 2),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(right: 4),
          decoration: const BoxDecoration(
            color: Color(0xFFFFCA28),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _petriDish({
    required Color innerColor,
    double size = 30,
    bool ring = false,
    List<Offset> spots = const [],
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: innerColor,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF455A64), width: 2),
            ),
          ),
          if (ring)
            Container(
              width: size * 0.55,
              height: size * 0.55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2E7D32), width: 2),
              ),
            ),
          for (final spot in spots)
            Transform.translate(
              offset: spot,
              child: Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Color(0xFF6D4C41),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
