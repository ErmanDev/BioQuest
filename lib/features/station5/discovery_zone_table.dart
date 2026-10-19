import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Zone-of-inhibition replicate table for the Discovery Stop walkthrough.
class DiscoveryZoneTable extends StatelessWidget {
  final List<String> headers;
  final List<({String treatment, List<String> values, String? mean})> rows;
  final double fontSize;
  final bool boldTreatmentLabels;

  const DiscoveryZoneTable({
    super.key,
    required this.headers,
    required this.rows,
    this.fontSize = 10.5,
    this.boldTreatmentLabels = true,
  });

  static const _headerColor = Color(0xFF4A4A4A);
  static const _stripe = Color(0xFFF3F3F3);
  static const _meanRed = Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        for (var i = 0; i < headers.length; i++)
          i: i == 0 ? const FlexColumnWidth(1.15) : const FlexColumnWidth(0.9),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: _headerColor),
          children: [for (final header in headers) _headerCell(header)],
        ),
        for (var i = 0; i < rows.length; i++)
          TableRow(
            decoration: BoxDecoration(color: i.isEven ? Colors.white : _stripe),
            children: [
              _bodyCell(rows[i].treatment, bold: boldTreatmentLabels),
              for (final value in rows[i].values) _bodyCell(value),
              if (headers.length == rows[i].values.length + 2)
                _bodyCell(rows[i].mean ?? '', bold: true, color: _meanRed),
            ],
          ),
      ],
    );
  }

  Widget _headerCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _bodyCell(String label, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          color: color ?? BioColors.ink,
          height: 1.2,
        ),
      ),
    );
  }
}
