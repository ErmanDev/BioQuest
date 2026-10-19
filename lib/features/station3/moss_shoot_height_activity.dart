import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station3_data.dart';

/// Mission 3: place moss replicates, measure with the ruler, record data.
class MossShootHeightActivity extends StatefulWidget {
  final VoidCallback onCompleted;
  final VoidCallback? onNext;

  const MossShootHeightActivity({
    super.key,
    required this.onCompleted,
    this.onNext,
  });

  @override
  State<MossShootHeightActivity> createState() =>
      _MossShootHeightActivityState();
}

class _MossShootHeightActivityState extends State<MossShootHeightActivity>
    with SingleTickerProviderStateMixin {
  static const _rulerMaxCm = 7.0;

  final List<bool> _placed =
      List<bool>.filled(kStation3MossReplicates.length, false);
  final List<bool> _measured =
      List<bool>.filled(kStation3MossReplicates.length, false);
  final List<TextEditingController> _afterCtrls = [
    for (final _ in kStation3MossReplicates) TextEditingController(),
  ];
  final List<bool> _recorded =
      List<bool>.filled(kStation3MossReplicates.length, false);

  int? _selectedReplicate;
  String? _selectedInstrumentId;
  int? _activeRulerSlot;
  double _cmScale = 14;
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  int? _shakingSlot;
  String? _wrongInstrumentId;

  bool get _allRecorded => _recorded.every((r) => r);

  @override
  void dispose() {
    _shake.dispose();
    for (final c in _afterCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _selectReplicate(int index) {
    if (_placed[index]) return;
    setState(() {
      _selectedReplicate = _selectedReplicate == index ? null : index;
      _selectedInstrumentId = null;
    });
  }

  void _selectInstrument(String id) {
    setState(() {
      _selectedInstrumentId = _selectedInstrumentId == id ? null : id;
      _selectedReplicate = null;
      _wrongInstrumentId = null;
    });
  }

  void _tapSlot(int slotIndex) {
    if (_selectedReplicate != null) {
      if (_selectedReplicate == slotIndex && !_placed[slotIndex]) {
        setState(() {
          _placed[slotIndex] = true;
          _selectedReplicate = null;
        });
      } else if (!_placed[slotIndex]) {
        _triggerShake(slotIndex);
      }
      return;
    }

    if (_selectedInstrumentId != null && _placed[slotIndex]) {
      _tryMeasure(slotIndex);
    }
  }

  void _tryMeasure(int slotIndex) {
    final instrument = kStation3Mission3Instruments
        .firstWhere((i) => i.id == _selectedInstrumentId);
    if (!instrument.isCorrect) {
      setState(() => _wrongInstrumentId = instrument.id);
      _triggerShake(slotIndex);
      return;
    }

    setState(() {
      _measured[slotIndex] = true;
      _activeRulerSlot = slotIndex;
      _selectedInstrumentId = null;
      _wrongInstrumentId = null;
    });
  }

  void _triggerShake(int slotIndex) {
    setState(() => _shakingSlot = slotIndex);
    _shake.forward(from: 0).whenComplete(() {
      if (mounted) setState(() => _shakingSlot = null);
    });
  }

  void _submitMeasurement(int index) {
    if (!_measured[index]) return;

    final entered = double.tryParse(_afterCtrls[index].text.trim());
    final expected = kStation3MossReplicates[index].afterHarvestHeight;
    final ok = entered != null && (entered - expected).abs() < 0.001;

    if (!ok) {
      HapticFeedback.lightImpact();
      setState(() => _recorded[index] = false);
      _triggerShake(index);
      return;
    }

    setState(() => _recorded[index] = true);
    if (_allRecorded) widget.onCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _cmScale = ((constraints.maxHeight * 0.38) / _rulerMaxCm).clamp(12.0, 18.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 24, child: _leftPanel()),
                  const SizedBox(width: 10),
                  Expanded(flex: 38, child: _centerPanel()),
                  const SizedBox(width: 10),
                  Expanded(flex: 38, child: _dataTable()),
                ],
              ),
            ),
            if (_allRecorded) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: PrimaryButton(
                  label: 'See Result',
                  color: BioColors.forest,
                  fontSize: 16,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  onTap: widget.onNext,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _leftPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BioColors.bark.withValues(alpha: 0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'INSTRUCTIONS',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: BioColors.forest,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '1. Tap each moss replicate, then tap its matching slot below.',
                style: TextStyle(fontSize: 15, height: 1.35, color: BioColors.ink),
              ),
              SizedBox(height: 4),
              Text(
                '2. Tap the ruler, then tap each moss to measure its shoot height.',
                style: TextStyle(fontSize: 15, height: 1.35, color: BioColors.ink),
              ),
              SizedBox(height: 4),
              Text(
                '3. Record the height in centimeters (cm) in the data table.',
                style: TextStyle(fontSize: 15, height: 1.35, color: BioColors.ink),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'MOSS REPLICATES',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < kStation3MossReplicates.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: _replicateBankTile(i),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _replicateBankTile(int index) {
    final replicate = kStation3MossReplicates[index];
    final placed = _placed[index];
    final selected = _selectedReplicate == index;

    return Material(
      color: placed
          ? BioColors.correct.withValues(alpha: 0.15)
          : selected
              ? BioColors.paleLeaf
              : Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: placed ? null : () => _selectReplicate(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: placed
                  ? BioColors.correct
                  : selected
                      ? BioColors.forest
                      : BioColors.bark.withValues(alpha: 0.35),
              width: selected ? 2.5 : 1.5,
            ),
          ),
          child: Row(
            children: [
              Text(
                replicate.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: BioColors.forest,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _mossImage(replicate, compact: true),
              ),
              if (placed)
                const Icon(Icons.check_circle, color: BioColors.correct, size: 22)
              else
                Icon(
                  selected ? Icons.check_circle_outline : Icons.touch_app,
                  size: 22,
                  color: selected ? BioColors.forest : BioColors.bark,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _centerPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'AVAILABLE INSTRUMENT',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 122,
          child: Center(
            child: SizedBox(
              width: 260,
              child: _instrumentTile(kStation3Mission3Instruments.first),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'TAP THE REPLICATES HERE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < kStation3MossReplicates.length; i++) ...[
                Expanded(child: _workSlot(i)),
                if (i < kStation3MossReplicates.length - 1)
                  const SizedBox(width: 6),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _instrumentTile(Station3Mission3Instrument instrument) {
    final selected = _selectedInstrumentId == instrument.id;
    final wrong = _wrongInstrumentId == instrument.id;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = wrong && _shake.isAnimating
            ? math.sin(_shake.value * math.pi * 4) * 5 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Material(
        color: wrong
            ? BioColors.danger.withValues(alpha: 0.12)
            : selected
                ? BioColors.paleLeaf
                : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _selectInstrument(instrument.id),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: wrong
                    ? BioColors.danger
                    : selected
                        ? BioColors.forest
                        : BioColors.bark.withValues(alpha: 0.35),
                width: selected ? 2.5 : 1.5,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: instrument.imageAsset != null
                      ? GameImage(
                          asset: instrument.imageAsset!,
                          label: instrument.label,
                          fit: BoxFit.contain,
                          color: BioColors.moss,
                          icon: Icons.science,
                          cacheWidth: 140,
                        )
                      : Icon(Icons.square_foot, color: BioColors.forest, size: 36),
                ),
                Text(
                  instrument.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: BioColors.ink,
                  ),
                ),
                Text(
                  instrument.hint,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.15,
                    color: BioColors.ink.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _workSlot(int slotIndex) {
    final replicate = kStation3MossReplicates[slotIndex];
    final placed = _placed[slotIndex];
    final measured = _measured[slotIndex];
    final showRuler = measured && _activeRulerSlot == slotIndex;
    final canPlace = _selectedReplicate == slotIndex;
    final canMeasure = _selectedInstrumentId != null && placed;
    final shaking = _shakingSlot == slotIndex;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = shaking && _shake.isAnimating
            ? math.sin(_shake.value * math.pi * 4) * 6 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _tapSlot(slotIndex),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: canPlace || canMeasure
                  ? BioColors.paleLeaf.withValues(alpha: 0.45)
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: placed
                    ? BioColors.correct
                    : canPlace
                        ? BioColors.forest
                        : BioColors.bark.withValues(alpha: 0.45),
                width: placed ? 2.5 : 1.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  replicate.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: BioColors.forest,
                  ),
                ),
                Expanded(
                  child: placed
                      ? _measurementArea(
                          replicate: replicate,
                          showRuler: showRuler,
                        )
                      : Center(
                          child: Text(
                            'Tap here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: BioColors.ink.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                ),
                if (measured)
                  Text(
                    '${replicate.afterHarvestHeight} cm',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: BioColors.correct,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _measurementArea({
    required Station3MossReplicate replicate,
    required bool showRuler,
  }) {
    final rulerH = _rulerMaxCm * _cmScale;
    final mossH = replicate.afterHarvestHeight * _cmScale;

    return SizedBox(
      height: rulerH,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showRuler) ...[
                _rulerWidget(replicate.afterHarvestHeight, drawMark: false),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: mossH,
                    child: _mossImage(replicate),
                  ),
                ),
              ),
            ],
          ),
          if (showRuler)
            Positioned(
              left: 0,
              right: 0,
              bottom: mossH - 1,
              child: Container(
                height: 2,
                color: BioColors.danger,
              ),
            ),
        ],
      ),
    );
  }

  Widget _mossImage(Station3MossReplicate replicate, {bool compact = false}) {
    final visualCm = replicate.afterHarvestHeight;
    final height = compact
        ? (visualCm / kStation3MossReferenceHeightCm) * 44.0
        : visualCm * _cmScale;

    return SizedBox(
      height: height,
      child: GameImage(
        asset: kStation3MossBaseAsset,
        label: replicate.label,
        fit: BoxFit.contain,
        color: BioColors.moss,
        icon: Icons.grass,
        cacheWidth: compact ? 120 : 180,
      ),
    );
  }

  Widget _rulerWidget(double heightCm, {bool drawMark = true}) {
    final rulerH = _rulerMaxCm * _cmScale;
    return SizedBox(
      width: 28,
      height: rulerH,
      child: CustomPaint(
        painter: _RulerPainter(
          maxCm: _rulerMaxCm,
          markCm: heightCm,
          cmScale: _cmScale,
          drawMark: drawMark,
        ),
      ),
    );
  }

  Widget _dataTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const headerH = 44.0;
        final rowH =
            ((constraints.maxHeight - headerH - 28) / 5).clamp(36.0, 56.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'DATA TABLE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: BioColors.forest,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Table(
                border: TableBorder.all(
                  color: BioColors.forest.withValues(alpha: 0.5),
                  width: 1.5,
                ),
                columnWidths: const {
                  0: FlexColumnWidth(0.75),
                  1: FlexColumnWidth(1.15),
                  2: FlexColumnWidth(1.25),
                  3: FlexColumnWidth(1.0),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: BioColors.forest.withValues(alpha: 0.88),
                    ),
                    children: [
                      _tableHeader('Rep.', headerH),
                      _tableHeader('Before\nPlanting', headerH),
                      _tableHeader('After\nHarvest', headerH),
                      _tableHeader('Height\nDiff.', headerH),
                    ],
                  ),
                  for (var i = 0; i < kStation3MossReplicates.length; i++)
                    _tableRow(i, rowH),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _tableHeader(String text, double height) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.15,
          ),
        ),
      ),
    );
  }

  TableRow _tableRow(int index, double rowH) {
    final replicate = kStation3MossReplicates[index];
    final recorded = _recorded[index];
    final canEnter = _measured[index];
    final diff = recorded ? replicate.heightDifference : null;

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven
            ? Colors.white.withValues(alpha: 0.96)
            : BioColors.paleLeaf.withValues(alpha: 0.35),
      ),
      children: [
        _tableCell(
          height: rowH,
          child: Text(
            replicate.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: BioColors.forest,
            ),
          ),
        ),
        _tableCell(
          height: rowH,
          child: Text(
            '${replicate.initialHeight} cm',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: BioColors.ink),
          ),
        ),
        _tableCell(
          height: rowH,
          child: TextField(
            controller: _afterCtrls[index],
            enabled: canEnter,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              hintText: canEnter ? 'cm' : '—',
              hintStyle: TextStyle(
                fontSize: 14,
                color: BioColors.ink.withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: recorded
                  ? BioColors.correct.withValues(alpha: 0.15)
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: recorded ? BioColors.correct : BioColors.bark,
                  width: 1.5,
                ),
              ),
              suffixIcon: recorded
                  ? const Icon(Icons.check, size: 18, color: BioColors.correct)
                  : IconButton(
                      icon: const Icon(Icons.check, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed:
                          canEnter ? () => _submitMeasurement(index) : null,
                    ),
            ),
            onSubmitted: canEnter ? (_) => _submitMeasurement(index) : null,
          ),
        ),
        _tableCell(
          height: rowH,
          child: Text(
            diff != null ? '${diff.toStringAsFixed(1)} cm' : '—',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: recorded ? FontWeight.w700 : FontWeight.w500,
              color: recorded ? BioColors.correct : BioColors.ink,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tableCell({required double height, required Widget child}) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Center(child: child),
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  final double maxCm;
  final double markCm;
  final double cmScale;
  final bool drawMark;

  _RulerPainter({
    required this.maxCm,
    required this.markCm,
    required this.cmScale,
    this.drawMark = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BioColors.bark
      ..strokeWidth = 1.2;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFFFF3D6),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = BioColors.bark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    for (var cm = 0; cm <= maxCm; cm++) {
      final y = size.height - cm * cmScale;
      canvas.drawLine(Offset(0, y), Offset(size.width * 0.55, y), paint);
      final tp = TextPainter(
        text: TextSpan(
          text: '$cm',
          style: const TextStyle(fontSize: 9, color: BioColors.ink),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(size.width * 0.58, y - tp.height / 2));
    }

    final markY = size.height - markCm * cmScale;
    if (drawMark) {
      final markPaint = Paint()
        ..color = BioColors.danger
        ..strokeWidth = 2;
      canvas.drawLine(Offset(0, markY), Offset(size.width, markY), markPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RulerPainter oldDelegate) =>
      oldDelegate.markCm != markCm ||
      oldDelegate.cmScale != cmScale ||
      oldDelegate.drawMark != drawMark;
}
