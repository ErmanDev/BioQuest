import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/station4_data.dart';

/// Example data table for five-moss phytochemical screening.
class MossScreeningDataTable extends StatelessWidget {
  final double fontSize;

  const MossScreeningDataTable({super.key, this.fontSize = 10.5});

  static const _headerGrey = Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      columnWidths: const {
        0: FlexColumnWidth(1.1),
        1: FlexColumnWidth(1.2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(color: _headerGrey),
          children: [
            _cell('Moss Species', bold: true, center: true),
            _cell('Number of Detected Phytochemicals', bold: true, center: true),
          ],
        ),
        for (var i = 0; i < kStation4MossScreeningRows.length; i++)
          TableRow(
            decoration: BoxDecoration(
              color: i.isEven ? Colors.white : const Color(0xFFF5F5F5),
            ),
            children: [
              _cell(kStation4MossScreeningRows[i].species, center: true),
              _cell('${kStation4MossScreeningRows[i].count}', center: true),
            ],
          ),
      ],
    );
  }

  Widget _cell(String text, {bool bold = false, bool center = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Text(
        text,
        textAlign: center ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
          color: BioColors.ink,
          height: 1.2,
        ),
      ),
    );
  }
}

/// Bar graph visualizing [kStation4MossScreeningRows].
class MossScreeningBarChart extends StatelessWidget {
  final double width;
  final double fontSize;

  const MossScreeningBarChart({
    super.key,
    required this.width,
    this.fontSize = 9.5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'PHYTOCHEMICAL SCREENING OF 5 MOSS SPECIES',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize + 0.5,
            fontWeight: FontWeight.w900,
            color: BioColors.ink,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: width,
          height: 150,
          child: CustomPaint(
            painter: _MossScreeningBarChartPainter(fontSize: fontSize),
            size: Size(width, 150),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              color: BioColors.deepSky,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'NUMBER OF DETECTED PHYTOCHEMICALS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize - 0.5,
                  fontWeight: FontWeight.w700,
                  color: BioColors.ink,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MossScreeningBarChartPainter extends CustomPainter {
  final double fontSize;

  const _MossScreeningBarChartPainter({required this.fontSize});

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 22.0;
    const bottomPad = 34.0;
    const topPad = 8.0;
    const rightPad = 8.0;

    final chartLeft = leftPad;
    final chartBottom = size.height - bottomPad;
    final chartTop = topPad;
    final chartRight = size.width - rightPad;
    final chartW = chartRight - chartLeft;
    final chartH = chartBottom - chartTop;

    final axisPaint = Paint()
      ..color = BioColors.ink
      ..strokeWidth = 1.2;

    canvas.drawLine(
      Offset(chartLeft, chartTop),
      Offset(chartLeft, chartBottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartRight, chartBottom),
      axisPaint,
    );

    final rows = kStation4MossScreeningRows;
    final maxY = kStation4MossScreeningChartMax.toDouble();
    final barCount = rows.length;
    final groupW = chartW / barCount;
    final barW = groupW * 0.55;

    for (var tick = 0; tick <= maxY; tick += 2) {
      final y = chartBottom - (tick / maxY) * chartH;
      canvas.drawLine(
        Offset(chartLeft - 3, y),
        Offset(chartLeft, y),
        axisPaint..strokeWidth = 1,
      );
      _drawText(
        canvas,
        tick.toInt().toString(),
        Offset(2, y - fontSize * 0.55),
        fontSize - 1,
        FontWeight.w600,
      );
    }

    final barPaint = Paint()..color = BioColors.deepSky;

    for (var i = 0; i < rows.length; i++) {
      final value = rows[i].count.toDouble();
      final barH = (value / maxY) * chartH;
      final centerX = chartLeft + groupW * i + groupW / 2;
      final rect = Rect.fromLTWH(
        centerX - barW / 2,
        chartBottom - barH,
        barW,
        barH,
      );
      canvas.drawRect(rect, barPaint);

      final label = rows[i].species.replaceFirst('Moss ', 'MOSS ');
      _drawText(
        canvas,
        label,
        Offset(centerX, chartBottom + 4),
        fontSize - 1,
        FontWeight.w700,
        center: true,
        maxWidth: groupW,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    double size,
    FontWeight weight, {
    bool center = false,
    double maxWidth = 40,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          fontWeight: weight,
          color: BioColors.ink,
        ),
      ),
      textAlign: center ? TextAlign.center : TextAlign.left,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    painter.paint(
      canvas,
      center
          ? Offset(offset.dx - painter.width / 2, offset.dy)
          : offset,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
