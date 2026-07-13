import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/station3_data.dart';

/// Data table for Station 3 Trail Checkpoint with student height-difference inputs.
class Station3CheckpointDataTable extends StatelessWidget {
  final List<TextEditingController> heightControllers;
  final double fontSize;
  final VoidCallback? onHeightChanged;
  final bool compact;
  final double? compactMaxWidth;

  const Station3CheckpointDataTable({
    super.key,
    required this.heightControllers,
    this.fontSize = 10,
    this.onHeightChanged,
    this.compact = false,
    this.compactMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final tableWidth = compact ? (compactMaxWidth ?? 520) : null;
    final table = Table(
      border: TableBorder.all(color: BioColors.bark.withValues(alpha: 0.55)),
      columnWidths: compact
          ? const {
              0: FlexColumnWidth(0.85),
              1: FlexColumnWidth(1.25),
              2: FlexColumnWidth(1.25),
              3: FlexColumnWidth(1.1),
            }
          : const {
              0: FlexColumnWidth(0.9),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.3),
            },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade300),
          children: [
            for (final header in _headers)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 6 : 4,
                  vertical: compact ? 6 : 6,
                ),
                child: Text(
                  header,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: compact ? fontSize : fontSize - 0.5,
                    fontWeight: FontWeight.w800,
                    color: BioColors.ink,
                    height: 1.1,
                  ),
                ),
              ),
          ],
        ),
        for (var i = 0; i < kStation3CheckpointTableRows.length; i++)
          _dataRow(i),
      ],
    );

    return Column(
      crossAxisAlignment:
          compact ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (kStation3CheckpointTable.intro.isNotEmpty) ...[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: tableWidth ?? double.infinity,
            ),
            child: Text(
              kStation3CheckpointTable.intro,
              textAlign: compact ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontSize: compact ? fontSize + 0.5 : fontSize + 1,
                height: 1.3,
                color: BioColors.ink,
              ),
            ),
          ),
          SizedBox(height: compact ? 8 : 8),
        ],
        if (tableWidth != null)
          SizedBox(width: tableWidth, child: table)
        else
          table,
      ],
    );
  }

  List<String> get _headers => compact && (compactMaxWidth ?? 520) >= 460
      ? kStation3CheckpointTable.headers
      : compact
          ? const ['REP.', 'BEFORE', 'AFTER', 'DIFF.']
          : kStation3CheckpointTable.headers;

  TableRow _dataRow(int index) {
    final row = kStation3CheckpointTableRows[index];
    final controller = heightControllers[index];
    final isCorrect = _isCorrectDifference(index, controller.text);
    final cellPad = compact
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 5)
        : const EdgeInsets.symmetric(horizontal: 4, vertical: 5);

    return TableRow(
      children: [
        for (final cell in row)
          Padding(
            padding: cellPad,
            child: Text(
              cell,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                height: 1.15,
                color: BioColors.ink,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 4 : 3,
            vertical: compact ? 4 : 4,
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: BioColors.ink,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4,
                vertical: compact ? 6 : 6,
              ),
              hintText: 'cm',
              hintStyle: TextStyle(
                fontSize: fontSize - 1,
                color: BioColors.ink.withValues(alpha: 0.35),
              ),
              filled: true,
              fillColor: isCorrect
                  ? BioColors.correct.withValues(alpha: 0.12)
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: isCorrect ? BioColors.correct : BioColors.bark,
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: isCorrect
                      ? BioColors.correct
                      : BioColors.bark.withValues(alpha: 0.55),
                  width: 1.2,
                ),
              ),
            ),
            onChanged: (_) => onHeightChanged?.call(),
          ),
        ),
      ],
    );
  }

  static double? parseHeightCm(String raw) {
    final cleaned = raw.trim().toLowerCase().replaceAll('cm', '').trim();
    return double.tryParse(cleaned);
  }

  static bool _isCorrectDifference(int rowIndex, String raw) {
    final parsed = parseHeightCm(raw);
    if (parsed == null) return false;
    final expected = kStation3CheckpointHeightDifferences[rowIndex];
    return (parsed - expected).abs() < 0.05;
  }
}
