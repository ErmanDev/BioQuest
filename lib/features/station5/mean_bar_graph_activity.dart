import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station5_data.dart';

/// Activity 4 — compute means from replicate data and drag bars onto the graph.
class MeanBarGraphActivity extends StatefulWidget {
  final void Function(int score) onCompleted;
  final VoidCallback? onNext;

  const MeanBarGraphActivity({
    super.key,
    required this.onCompleted,
    this.onNext,
  });

  @override
  State<MeanBarGraphActivity> createState() => _MeanBarGraphActivityState();
}

class _MeanBarGraphActivityState extends State<MeanBarGraphActivity>
    with SingleTickerProviderStateMixin {
  static const _bar50Color = Color(0xFF1565C0);
  static const _bar100Color = Color(0xFF2E7D32);

  final _sum100Ctrl = TextEditingController();
  final _mean100Ctrl = TextEditingController();
  final _sum50Ctrl = TextEditingController();
  final _mean50Ctrl = TextEditingController();

  /// Bar id in tray: 0 = 50% (blue), 1 = 100% (green). Null = placed on graph.
  final List<int?> _tray = [0, 1];
  final List<int?> _slots = [null, null]; // index 0 = 50%, 1 = 100%
  int? _selectedBar;
  int? _shakingSlot;
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  @override
  void dispose() {
    _sum100Ctrl.dispose();
    _mean100Ctrl.dispose();
    _sum50Ctrl.dispose();
    _mean50Ctrl.dispose();
    _shake.dispose();
    super.dispose();
  }

  void _selectBar(int barId) {
    setState(() => _selectedBar = _selectedBar == barId ? null : barId);
  }

  void _placeBar(int slotIndex, int barId) {
    if (barId != slotIndex) {
      setState(() => _shakingSlot = slotIndex);
      _shake.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _shakingSlot = null);
      });
      return;
    }
    setState(() {
      _slots[slotIndex] = barId;
      _tray.remove(barId);
      _selectedBar = null;
    });
  }

  void _tapSlot(int slotIndex) {
    final barId = _selectedBar;
    if (barId == null || _slots[slotIndex] != null) return;
    _placeBar(slotIndex, barId);
  }

  void _finish() {
    final score = scoreStation5MeanBarActivity(
      mean100: _mean100Ctrl.text,
      mean50: _mean50Ctrl.text,
      barOn50Slot: _slots[0],
      barOn100Slot: _slots[1],
    );
    widget.onCompleted(score);
    widget.onNext?.call();
  }

  double _barHeight(double mean, double maxHeight) {
    final value = mean.clamp(0, kStation5MeanBarGraphMax);
    return maxHeight * (value / kStation5MeanBarGraphMax);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 4),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _supposeBox(),
                  const SizedBox(height: 6),
                  _dataTable(),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 188,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 5, child: _meanSection()),
                        const SizedBox(width: 8),
                        Expanded(flex: 6, child: _graphSection()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _draggableTray(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: PrimaryButton(
            label: 'Next Activity',
            icon: Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: 13,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: _finish,
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          kStation5MeanBarTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: BioColors.deepSky,
          ),
        ),
        Text(
          kStation5MeanBarSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _supposeBox() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BioColors.deepSky.withValues(alpha: 0.4)),
      ),
      child: Text(
        'SUPPOSE… $kStation5MeanBarSuppose',
        style: const TextStyle(fontSize: 11.5, height: 1.35, color: BioColors.ink),
      ),
    );
  }

  Widget _dataTable() {
    return Table(
      border: TableBorder.all(color: BioColors.deepSky, width: 1.5),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: BioColors.deepSky),
          children: [
            _tableHead('Replicate'),
            _tableHead('100% (mm)'),
            _tableHead('50% (mm)'),
          ],
        ),
        for (var i = 0; i < kStation5MeanBarReplicateCount; i++)
          TableRow(
            children: [
              _tableCell('${i + 1}', bold: true),
              _tableCell('${kStation5MeanBar100Values[i]}'),
              _tableCell('${kStation5MeanBar50Values[i]}'),
            ],
          ),
      ],
    );
  }

  Widget _tableHead(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      );

  Widget _tableCell(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: BioColors.ink,
          ),
        ),
      );

  Widget _meanSection() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '1. COMPUTE THE MEAN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _meanBox(
                    title: 'First Concentration (100%)',
                    sumCtrl: _sum100Ctrl,
                    meanCtrl: _mean100Ctrl,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _meanBox(
                    title: 'Second Concentration (50%)',
                    sumCtrl: _sum50Ctrl,
                    meanCtrl: _mean50Ctrl,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _meanBox({
    required String title,
    required TextEditingController sumCtrl,
    required TextEditingController meanCtrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 4),
          _meanLine('Σx =', sumCtrl),
          const Text(
            'n = 5',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          _meanLine('MEAN =', meanCtrl, suffix: 'mm'),
        ],
      ),
    );
  }

  Widget _meanLine(
    String label,
    TextEditingController controller, {
    String suffix = '',
  }) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        const SizedBox(width: 4),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              border: const UnderlineInputBorder(),
              suffixText: suffix.isEmpty ? null : suffix,
              suffixStyle: const TextStyle(fontSize: 9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _graphSection() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BioColors.deepSky.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '2. DRAW YOUR BAR GRAPH',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: BioColors.deepSky,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'TITLE:',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
          ),
          Container(
            height: 1.5,
            margin: const EdgeInsets.only(top: 2, bottom: 6),
            color: BioColors.ink.withValues(alpha: 0.35),
          ),
          Expanded(child: _chart()),
        ],
      ),
    );
  }

  Widget _chart() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const leftPad = 28.0;
        const bottomPad = 22.0;
        final chartH = constraints.maxHeight - bottomPad;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: leftPad,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var v = 30; v >= 0; v -= 5)
                    Text(
                      '$v',
                      style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _GridPainter(maxY: kStation5MeanBarGraphMax),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: _graphSlot(0, chartH, _bar50Color)),
                            Expanded(child: _graphSlot(1, chartH, _bar100Color)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          '50%',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '100%',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'CONCENTRATION',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _graphSlot(int slotIndex, double chartH, Color color) {
    final placed = _slots[slotIndex];
    final mean = slotIndex == 0
        ? double.tryParse(_mean50Ctrl.text.trim())
        : double.tryParse(_mean100Ctrl.text.trim());
    final displayMean = mean ??
        (slotIndex == 0 ? kStation5MeanBar50Mean : kStation5MeanBar100Mean);
    final barH = _barHeight(displayMean, chartH - 8);
    final shaking = _shakingSlot == slotIndex;

    return DragTarget<int>(
      onWillAcceptWithDetails: (d) => _slots[slotIndex] == null,
      onAcceptWithDetails: (d) => _placeBar(slotIndex, d.data),
      builder: (context, candidate, rejected) {
        return AnimatedBuilder(
          animation: _shake,
          builder: (context, child) {
            final dx = shaking && _shake.isAnimating
                ? math.sin(_shake.value * math.pi * 4) * 6 * (1 - _shake.value)
                : 0.0;
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
          child: InkWell(
            onTap: () => _tapSlot(slotIndex),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                border: Border.all(
                  color: candidate.isNotEmpty || _selectedBar != null
                      ? color
                      : BioColors.bark.withValues(alpha: 0.25),
                  width: candidate.isNotEmpty ? 2 : 1,
                ),
              ),
              child: placed != null
                  ? Container(
                      width: 36,
                      height: barH,
                      color: placed == 0 ? _bar50Color : _bar100Color,
                    )
                  : SizedBox(
                      height: chartH,
                      child: Center(
                        child: Text(
                          'Drop here',
                          style: TextStyle(
                            fontSize: 8,
                            color: BioColors.ink.withValues(alpha: 0.45),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _draggableTray() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF9A825)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'DRAGGABLE ITEMS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: BioColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Drag each bar onto the graph to represent your mean values.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 9.5, height: 1.25),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final barId in _tray)
                if (barId != null) ...[
                  _draggableBar(barId),
                  const SizedBox(width: 16),
                ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _draggableBar(int barId) {
    final color = barId == 0 ? _bar50Color : _bar100Color;
    final label = barId == 0 ? '50%' : '100%';
    final height = barId == 0 ? 48.0 : 82.0;
    final selected = _selectedBar == barId;

    return LongPressDraggable<int>(
      data: barId,
      feedback: Material(
        color: Colors.transparent,
        child: _barPreview(color, height, label),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: _barPreview(color, height, label),
      ),
      child: GestureDetector(
        onTap: () => _selectBar(barId),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.55),
                      blurRadius: 0,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: _barPreview(color, height, label),
        ),
      ),
    );
  }

  Widget _barPreview(Color color, double height, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final double maxY;

  _GridPainter({required this.maxY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BioColors.bark.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    for (var i = 0; i <= 6; i++) {
      final y = size.height * (1 - i / 6);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
