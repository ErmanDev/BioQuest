import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/station4_data.dart';

/// Activity 2 guidelines table for interpreting laboratory reactions.
class InterpretResultsTable extends StatelessWidget {
  final double fontSize;

  const InterpretResultsTable({super.key, this.fontSize = 14});

  static const _headerBlue = Color(0xFF1B4F72);
  static const _stripeBlue = Color(0xFFE8F0F8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: const BoxDecoration(
            color: _headerBlue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Text(
            'GENERAL GUIDELINES FOR INTERPRETING RESULTS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize + 1,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          columnWidths: const {
            0: FlexColumnWidth(0.55),
            1: FlexColumnWidth(1.45),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: _headerBlue),
              children: [
                _headerCell('Symbol'),
                _headerCell('Laboratory Observation'),
              ],
            ),
            for (var i = 0; i < kStation4InterpretationGuidelines.length; i++)
              TableRow(
                decoration: BoxDecoration(
                  color: i.isEven ? Colors.white : _stripeBlue,
                ),
                children: [
                  _symbolCell(kStation4InterpretationGuidelines[i].symbol),
                  _bodyCell(kStation4InterpretationGuidelines[i].observation),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _headerCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _symbolCell(String symbol) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        symbol,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize + 2,
          fontWeight: FontWeight.w900,
          color: BioColors.ink,
        ),
      ),
    );
  }

  Widget _bodyCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.35,
          color: BioColors.ink,
        ),
      ),
    );
  }
}
