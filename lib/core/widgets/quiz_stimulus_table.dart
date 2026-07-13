import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/mc_question.dart';

/// Renders optional intro text and a bordered data table for quiz stimuli.
class QuizStimulusTable extends StatelessWidget {
  final McTableStimulus table;
  final double fontSize;
  final TextAlign bodyTextAlign;

  const QuizStimulusTable({
    super.key,
    required this.table,
    this.fontSize = 15,
    this.bodyTextAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (table.intro.isNotEmpty) ...[
          Text(
            table.intro,
            style: TextStyle(
              fontSize: fontSize + 1,
              height: 1.45,
              color: BioColors.ink,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Table(
          border: TableBorder.all(color: BioColors.bark.withValues(alpha: 0.55)),
          columnWidths: {
            for (var i = 0; i < table.headers.length; i++)
              i: const FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              children: [
                for (final header in table.headers)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Text(
                      header,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                        color: BioColors.ink,
                      ),
                    ),
                  ),
              ],
            ),
            for (final row in table.rows)
              TableRow(
                children: [
                  for (final cell in row)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      child: Text(
                        cell,
                        textAlign: bodyTextAlign,
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 1.3,
                          color: BioColors.ink,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
