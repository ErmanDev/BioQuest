import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/station4_data.dart';

/// Discovery Stop table of common moss phytochemicals and their functions.
class PhytochemicalTable extends StatelessWidget {
  final double fontSize;

  const PhytochemicalTable({super.key, this.fontSize = 12});

  static const _headerBlue = Color(0xFF1B4F72);
  static const _stripeBlue = Color(0xFFE8F0F8);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey.shade400,
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(0.88),
        1: FlexColumnWidth(1.35),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(color: _headerBlue),
          children: [
            _headerCell('Phytochemical'),
            _headerCell('Function'),
          ],
        ),
        for (var i = 0; i < kStation4PhytochemicalRows.length; i++)
          TableRow(
            decoration: BoxDecoration(
              color: i.isEven ? Colors.white : _stripeBlue,
            ),
            children: [
              _nameCell(kStation4PhytochemicalRows[i].name),
              _functionCell(kStation4PhytochemicalRows[i].function),
            ],
          ),
      ],
    );
  }

  Widget _headerCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _nameCell(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Text(
        name,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: BioColors.ink,
          height: 1.25,
        ),
      ),
    );
  }

  Widget _functionCell(String function) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        function,
        softWrap: true,
        style: TextStyle(
          fontSize: fontSize,
          color: BioColors.ink,
          height: 1.25,
        ),
      ),
    );
  }
}
